# Echoes Linux desktop architecture

Status: Phase 0–1 (audit + architecture) complete; implementation phased below.
Audience: contributors working on the Linux desktop integration.

Sibling project: **Astraea** solved the same problem for calendars. Its
`docs/linux-architecture.md` is the reference; this document deliberately
mirrors it and calls out only where Echoes must differ. Where nothing is
said, Astraea's decision applies unchanged.

## Components

```
┌────────────────────┐ ┌──────────────────┐ ┌───────────────┐ ┌──────────────┐
│  Echoes Desktop    │ │ GNOME Shell      │ │ COSMIC applet │ │ Quick Capture│
│  (Flutter, GTK)    │ │ extension (GJS)  │ │ (Rust,        │ │ (Rust, GTK4) │
│  full notes UI     │ │ top-bar popup:   │ │  libcosmic)   │ │ Spotlight-   │
│  editor, tags,     │ │ search + pinned  │ │ same popup    │ │ like, global │
│  trash, markdown   │ │ + recent + new   │ │               │ │ shortcut     │
└─────────┬──────────┘ └────────┬─────────┘ └──────┬────────┘ └──────┬───────┘
          │      D-Bus (session bus)                │                 │
          └───────────────┬──────────────────────────┴────────────────┘
                          ▼
        ┌────────────────────────────────────────────┐
        │ Echoes Service (Rust daemon)               │
        │  bus name  com.lwb89dev.Echoes.Service     │
        │  path      /com/lwb89dev/Echoes            │
        │  ifaces    com.lwb89dev.Echoes.Notes1      │
        │            com.lwb89dev.NostrAccount1      │
        │                                            │
        │  SQLite + FTS5 (XDG data dir)              │
        │  sync queue + relay pool (nostr-sdk)       │
        │  browser-auth bridge (127.0.0.1)           │
        │  signer abstraction · desktop notifications│
        └───────┬────────────────────┬───────────────┘
                │                    │
        Secret Service          Nostr relays (wss)
        (keyring)               kind 30078 + kind 5
```

Responsibilities match Astraea's: the service is the **single owner** of the
Linux-side database, relay connections, sync queue, auth sessions and
notifications. Shell frontends are thin — they never touch relays, keys or
the database, and must never spawn Flutter just to display notes.

## Phase 0 — Repository audit (2026-07-20)

- Single Flutter package `echoes` `0.4.2+6`, Dart SDK `^3.12.2`. Android is
  the shipping target; a **`linux/` runner already exists** (desktop support
  landed in v0.3.0, incl. a Flatpak manifest under `flatpak/`).
- State: Riverpod (`AsyncNotifier`). Nostr: `dart_nostr` 10. Persistence:
  **Hive** box `echoes_notes`, SharedPreferences for settings/bookmarks,
  `flutter_secure_storage` for the private key.
- Wire format: kind **30078**, `d` tag = `note.id`, content =
  `Note.toJson()` **NIP-44 self-encrypted** to the author's own pubkey.
  Deletion = NIP-09 kind 5 with both `e` and `a` (coordinate) tags.
  Merge: last-write-wins on `updatedAt`.
- **Sharing exists and is substantial** (v0.4.0): per-recipient NIP-44
  copies under deterministic `d` tags, edit proposals back to the owner,
  "leave" control events, permanent abandon tombstones, and authorization
  rules keyed on the *signed* event author. See `lib/utils/note_sharing.dart`.
- Attachments: AES-256-GCM client-side, Blossom/NIP-96 hosts, hash-checked.
- Identity: local key or Amber (NIP-55, Android only). **No browser/NIP-07
  path exists yet** — that is new work, shared with Astraea's design.
- Note model today: `id, title, body, items[] (checklist), attachments[],
  createdAt, updatedAt, synced, nostrEventId, isDiaryEntry, entryDate,
  color, ownerPubkey, sharedWith[]`.
  **Absent: `pinned`, `archived`, `trashed`, `tags`** — required by the
  desktop brief (see ADR-E-006).
- License GPL-3.0-or-later. Namespace `com.lwb89dev.Echoes`, app id
  `com.echoes.echoes` on Android.
- Dev machine runs **COSMIC**, so the GNOME extension is validated by lint +
  mock D-Bus tests + a written manual test plan, not a local nested shell.

### Risks

1. **Duplicating the sharing protocol in Rust** is materially riskier than
   duplicating Astraea's calendar sync: a divergence leaks note contents to
   the wrong pubkey rather than dropping a field. Addressed by ADR-E-005.
2. **New note fields are erased by older clients** on their next
   last-write-wins publish. Addressed by ADR-E-006.
3. Flatpak sandbox vs. owning a session bus name — same trade-off Astraea
   documented; the service is not shipped inside the Flatpak sandbox.
4. Two independent sync engines (Dart on mobile, Rust on Linux) writing the
   same relays; both must honour the identical wire contract.

## Architecture decision records

Astraea's ADR-001…ADR-006 are adopted as-is: Rust service with the `nostr`
crate family; versioned JSON strings over D-Bus (`schemaVersion`, 1 MiB cap,
unknown fields ignored, breaking change ⇒ `Notes1` → `Notes2`); Flutter
Linux backend swapped at the Riverpod provider level with no forked UI;
identity behind `com.lwb89dev.NostrAccount1`; browser login + pluggable
`SignerBackend`. Echoes-specific additions follow.

### ADR-E-004 — The account interface is copied verbatim, not adapted

`native/dbus/com.lwb89dev.NostrAccount1.xml` is byte-identical to Astraea's.
Echoes' service exports it on its own bus name for now; extracting a shared
`lwb-nostr-account-service` later means moving the module to its own crate
and pointing both daemons at it, with **no interface change on either side**.
Any Echoes-specific auth need must go on `Notes1`, never on `NostrAccount1`.

### ADR-E-005 — The Rust service does not own note *sharing* (phase 1–4)

Astraea's ADR-001 accepts a second Nostr implementation because its wire
format is "deliberately tiny". Echoes' is not: sharing adds per-recipient
encryption, deterministic share/edit `d`-tags, control events, and
authorization rules where the failure mode is **disclosing a note to the
wrong person**. Reimplementing that in Rust concurrently with everything
else is the highest-risk thing in this project.

Therefore, until a shared fixture suite proves parity:

- The Rust service owns: local store, FTS5 search, and sync of
  **self-encrypted notes I own** (kind 30078, `d` = note id) — the small,
  well-understood subset that is exactly Astraea-shaped.
- Notes that are shared *by* me or *with* me are stored, indexed, searched
  and displayed on the desktop, but their share/edit/control events are not
  produced or consumed by the daemon. Such notes are marked
  `sync_scope = 'dart_owned'` in SQLite and shown read-only-for-sharing in
  the desktop UI, with an explicit "sharing syncs from mobile" affordance.
- Phase 7 lifts this once `docs/nostr-sync.md` fixtures (round-trip payloads
  + NIP-44 vectors, run by both `test/` and the Rust crate) pass in CI.

This is a deliberate, documented functional gap rather than an unmanaged
security risk. It is the single most important decision in this document.

### ADR-E-006 — New note fields ship on the wire from mobile *first*

`pinned`, `archived`, `trashed` and `tags` do not exist in the current
payload. If the desktop starts writing them, any Android client editing the
same note republishes without them and silently erases them (LWW) — the
problem Astraea hit with `calendarId` (its ADR-005).

Two changes, in this order:

1. **`Note.fromJson`/`toJson` round-trip unknown keys** (`_extra` map). This
   is small, belongs in the Dart model regardless, and permanently ends this
   class of bug for every future field, in both directions.
2. Only then add the four fields to the Dart model and the wire contract, so
   mobile understands them before desktop emits them.

Until step 1 ships to mobile, desktop keeps the four fields **local-only**
(SQLite columns, never serialized into the published payload). Search, pin
and archive work fully on the desktop; they just do not travel yet. This
keeps the Keep-like UX on day one without risking data loss.

### ADR-E-007 — Quick Capture is a native GTK4 binary, not Flutter

Quick Capture's whole value is being faster than the thought that triggered
it; a Flutter cold start (hundreds of ms plus engine init) fails that test,
and keeping the Flutter app resident just to serve a shortcut is a poor
trade for the memory. `echoes-quick-capture` is therefore a small GTK4
binary shipped with the service: a single entry, layered above other
windows, that calls `CreateNote` and exits. It works identically on GNOME,
KDE and COSMIC because it depends on nothing but the session bus, and it is
what `QuickCapture()` on `Notes1` raises.

Global shortcut binding is per-desktop and is set up by the packaging
scripts (GNOME/COSMIC custom keybinding, KDE `khotkeys`), defaulting to
`Super+Shift+N`.

### ADR-E-008 — Search ranking is FTS5 + explicit boosts, not fuzzy matching

`bm25()` over an FTS5 external-content table, boosted by: title match ≫ body
match, pinned notes lifted, recency as a tiebreaker, archived/trashed
excluded unless explicitly requested. Prefix queries (`term*`) are supported
because the shell popup searches on every keystroke. True fuzzy/trigram
matching is deferred — it costs index size and, with a personal-scale corpus
(thousands of notes, not millions), prefix + stemming already returns the
right note; revisit only if real usage shows misses.

## Storage (XDG)

| Purpose  | Path                                                     |
| -------- | -------------------------------------------------------- |
| Database | `$XDG_DATA_HOME/echoes/echoes.db` (fallback `~/.local/share/…`) |
| Config   | `$XDG_CONFIG_HOME/echoes/`                               |
| Cache    | `$XDG_CACHE_HOME/echoes/` (attachment plaintext cache)   |
| Logs     | `$XDG_STATE_HOME/echoes/logs/` (rotated, bounded)        |
| Runtime  | `$XDG_RUNTIME_DIR/echoes/`                               |

Secrets live exclusively in the freedesktop **Secret Service**. Never in
SQLite, config files or logs. Decrypted attachment plaintext lives only in
the cache dir with `0700`, and is purged on logout.

## Data flow: quick capture

1. User presses `Super+Shift+N`; `echoes-quick-capture` shows instantly
   (D-Bus activation starts the service in parallel if it was idle).
2. User types, presses Enter. The binary calls `CreateNote(draftJson)`.
3. Service writes to SQLite in a transaction (`sync_state = 'local_only'`),
   updates the FTS index in the same transaction, enqueues a `publish` row.
4. Service emits `NotesChanged`; the GNOME popup, COSMIC applet and any open
   Flutter window refresh. Quick-capture window closes immediately — it
   never waits for the network.
5. The sync worker signs and publishes; `sync_state` transitions
   `local_only → pending_publish → publishing → synced`, surfaced through
   `SyncStatusChanged`. Offline changes nothing: the queue drains later.

## Process lifecycle

As Astraea: D-Bus activation with `SystemdService=echoes.service`, idle exit
(default 30 min) when no clients are connected and the sync queue is empty,
graceful SIGTERM (flush queue with a bounded deadline, checkpoint WAL, close,
exit 0). Owning the well-known bus name is the singleton lock.

## Repository layout (delta)

```
lib/desktop/            D-Bus client + Linux provider overrides (Dart)
linux/                  Flutter Linux runner (exists since v0.3.0)
native/service/         echoes-service (Rust)
native/quick-capture/   echoes-quick-capture (Rust, GTK4)
native/cosmic-applet/   COSMIC applet (Rust)
native/dbus/            introspection XML (normative copies)
extensions/gnome/       GNOME Shell extension (GJS)
packaging/{deb,rpm,arch,flatpak,appimage,common}/
assets/{desktop,appstream}/
scripts/                build-*.sh, install-dev.sh, check-versions.sh
docs/                   this file + dbus-api, nostr-sync, authentication, …
```

Existing directories are untouched; the Android build stays green.

## Phasing

See `docs/linux-progress.md` for the live checklist.
