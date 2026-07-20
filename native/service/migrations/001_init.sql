-- Echoes service schema, version 1.
-- Times: *_ms columns are Unix milliseconds UTC.
-- Mirrors Astraea's conventions so the two services stay reviewable side by side.

CREATE TABLE accounts (
    id            TEXT PRIMARY KEY,
    pubkey        TEXT NOT NULL UNIQUE,
    npub          TEXT NOT NULL,
    label         TEXT NOT NULL DEFAULT '',
    signer        TEXT NOT NULL DEFAULT 'read_only',
    is_active     INTEGER NOT NULL DEFAULT 0,
    created_at_ms INTEGER NOT NULL,
    updated_at_ms INTEGER NOT NULL
);

CREATE TABLE notes (
    id               TEXT PRIMARY KEY,
    nostr_event_id   TEXT,
    owner_pubkey     TEXT,             -- NULL = I own it (matches the Dart model)
    title            TEXT NOT NULL DEFAULT '',
    body             TEXT NOT NULL DEFAULT '',
    -- Rendered plain text of body + checklist items, kept denormalized purely
    -- to feed FTS: the index must not have to understand markdown.
    plain_text       TEXT NOT NULL DEFAULT '',
    -- Space-joined tag names, denormalized for the same reason. FTS5 external
    -- content reads its columns straight off this table, so every indexed
    -- column has to exist here as a real column; the service rewrites this
    -- whenever note_tags changes for the row.
    tags_text        TEXT NOT NULL DEFAULT '',
    is_checklist     INTEGER NOT NULL DEFAULT 0,
    checklist_items  TEXT NOT NULL DEFAULT '[]',  -- JSON [{"text":..,"done":..}]
    attachments      TEXT NOT NULL DEFAULT '[]',  -- JSON, mirrors Attachment.toJson
    color            TEXT,                        -- NULL = default/no colour
    is_diary_entry   INTEGER NOT NULL DEFAULT 0,
    entry_date_ms    INTEGER,

    -- Desktop-first organisation fields. LOCAL-ONLY until the mobile wire
    -- contract carries them — see ADR-E-006. Never serialized into a
    -- published payload while `wire_carries_flags` is 0 in settings.
    pinned           INTEGER NOT NULL DEFAULT 0,
    archived         INTEGER NOT NULL DEFAULT 0,
    trashed          INTEGER NOT NULL DEFAULT 0,
    trashed_at_ms    INTEGER,

    -- 'owned'      → this daemon syncs it (self-encrypted, kind 30078)
    -- 'dart_owned' → shared by/with me; sync belongs to the mobile app until
    --                ADR-E-005 is lifted. Stored and searchable, never
    --                published from here.
    sync_scope       TEXT NOT NULL DEFAULT 'owned'
                     CHECK (sync_scope IN ('owned', 'dart_owned')),
    sync_state       TEXT NOT NULL DEFAULT 'local_only'
                     CHECK (sync_state IN ('local_only', 'pending_publish',
                                           'publishing', 'synced', 'failed')),
    encryption_state TEXT NOT NULL DEFAULT 'plaintext_local'
                     CHECK (encryption_state IN ('plaintext_local', 'encrypted_at_rest')),

    -- Unknown keys from a peer's payload, preserved verbatim so this service
    -- never erases a field a newer client added (the ADR-E-006 rule, applied
    -- to the Rust side from day one).
    extra_json       TEXT NOT NULL DEFAULT '{}',
    metadata_json    TEXT NOT NULL DEFAULT '{}',

    created_at_ms    INTEGER NOT NULL,
    updated_at_ms    INTEGER NOT NULL
);

CREATE INDEX idx_notes_updated   ON notes(updated_at_ms DESC);
CREATE INDEX idx_notes_pinned    ON notes(pinned, updated_at_ms DESC) WHERE trashed = 0;
CREATE INDEX idx_notes_active    ON notes(archived, trashed, updated_at_ms DESC);
CREATE INDEX idx_notes_syncstate ON notes(sync_state) WHERE sync_state != 'synced';

CREATE TABLE tags (
    id          TEXT PRIMARY KEY,
    name        TEXT NOT NULL,
    -- Case-insensitive uniqueness without depending on a collation that
    -- would also change ordering semantics elsewhere.
    name_folded TEXT NOT NULL UNIQUE,
    color       TEXT,
    created_at_ms INTEGER NOT NULL
);

CREATE TABLE note_tags (
    note_id TEXT NOT NULL REFERENCES notes(id) ON DELETE CASCADE,
    tag_id  TEXT NOT NULL REFERENCES tags(id)  ON DELETE CASCADE,
    PRIMARY KEY (note_id, tag_id)
);
CREATE INDEX idx_note_tags_tag ON note_tags(tag_id);

-- Wiki-style links between notes ([[other note]]), resolved lazily: a link
-- may name a note that does not exist yet, so target_id is nullable.
CREATE TABLE note_links (
    source_id  TEXT NOT NULL REFERENCES notes(id) ON DELETE CASCADE,
    target_id  TEXT REFERENCES notes(id) ON DELETE SET NULL,
    raw_target TEXT NOT NULL,
    PRIMARY KEY (source_id, raw_target)
);
CREATE INDEX idx_note_links_target ON note_links(target_id);

CREATE TABLE sync_queue (
    id             INTEGER PRIMARY KEY AUTOINCREMENT,
    note_id        TEXT NOT NULL REFERENCES notes(id) ON DELETE CASCADE,
    operation      TEXT NOT NULL CHECK (operation IN ('publish', 'delete')),
    attempts       INTEGER NOT NULL DEFAULT 0,
    next_attempt_ms INTEGER NOT NULL,
    created_at_ms  INTEGER NOT NULL,
    UNIQUE (note_id, operation)
);
CREATE INDEX idx_sync_queue_due ON sync_queue(next_attempt_ms);

CREATE TABLE sync_failures (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    note_id       TEXT,
    operation     TEXT NOT NULL,
    error         TEXT NOT NULL,
    occurred_at_ms INTEGER NOT NULL
);
CREATE INDEX idx_sync_failures_time ON sync_failures(occurred_at_ms DESC);

CREATE TABLE settings (
    key        TEXT PRIMARY KEY,
    value      TEXT NOT NULL,
    updated_at_ms INTEGER NOT NULL
);

CREATE TABLE relays (
    url        TEXT PRIMARY KEY,
    read       INTEGER NOT NULL DEFAULT 1,
    write      INTEGER NOT NULL DEFAULT 1,
    enabled    INTEGER NOT NULL DEFAULT 1,
    added_at_ms INTEGER NOT NULL
);

-- ---------------------------------------------------------------------------
-- Full-text search (FTS5, external content).
--
-- `content='notes'` means the index stores no second copy of the note text:
-- it reads the indexed columns back off `notes` by rowid. That keeps the
-- database at roughly one copy of the text and leaves `notes` the single
-- source of truth — and, unlike a contentless index, it still supports
-- snippet()/highlight(), which the shell popup and search results need.
-- The price is that the index must be maintained by trigger, below.
-- ---------------------------------------------------------------------------
CREATE VIRTUAL TABLE notes_fts USING fts5(
    title,
    plain_text,
    tags_text,
    content='notes',
    content_rowid='rowid',
    tokenize="unicode61 remove_diacritics 2"
);

-- Triggers keep FTS in lockstep with `notes` inside the same transaction, so
-- a crash can never leave the index describing rows that no longer exist.
-- The 'delete' command must carry the OLD values: FTS5 uses them to locate
-- the index entries to remove, and passing the new ones corrupts the index.
CREATE TRIGGER notes_fts_insert AFTER INSERT ON notes BEGIN
    INSERT INTO notes_fts(rowid, title, plain_text, tags_text)
    VALUES (new.rowid, new.title, new.plain_text, new.tags_text);
END;

CREATE TRIGGER notes_fts_delete AFTER DELETE ON notes BEGIN
    INSERT INTO notes_fts(notes_fts, rowid, title, plain_text, tags_text)
    VALUES ('delete', old.rowid, old.title, old.plain_text, old.tags_text);
END;

CREATE TRIGGER notes_fts_update AFTER UPDATE OF title, plain_text, tags_text ON notes BEGIN
    INSERT INTO notes_fts(notes_fts, rowid, title, plain_text, tags_text)
    VALUES ('delete', old.rowid, old.title, old.plain_text, old.tags_text);
    INSERT INTO notes_fts(rowid, title, plain_text, tags_text)
    VALUES (new.rowid, new.title, new.plain_text, new.tags_text);
END;
