# Linux desktop integration — progress checklist

Tracks the phased implementation. Update at the end of every phase.
Architecture and ADRs: `docs/linux-architecture.md`.

## Phase 0 — Repository audit ✅ (2026-07-20)

Findings and risks recorded in `docs/linux-architecture.md`. Headlines:
a `linux/` Flutter runner already exists (v0.3.0); storage is Hive, not
SQLite; **note sharing is already in production** and is far larger than
Astraea's wire surface; `pinned/archived/trashed/tags` do not exist yet in
the model or on the wire.

## Phase 1 — Architecture ✅ (2026-07-20)

- [x] `docs/linux-architecture.md` (components, storage, lifecycle, ADRs)
- [x] `native/dbus/com.lwb89dev.Echoes.Notes1.xml` (normative introspection)
- [x] `native/dbus/com.lwb89dev.NostrAccount1.xml` (byte-identical to
      Astraea's — shared identity contract, ADR-E-004)
- [x] `native/service/migrations/001_init.sql` — schema v1 with FTS5
      external-content index, verified against SQLite 3.45: triggers,
      bm25 ranking, `snippet()`, `integrity-check`, FK cascade
- [ ] `docs/dbus-api.md` — payload schemas per method (blocks phase 3)
- [ ] `docs/nostr-sync.md` — normative wire contract + shared fixtures
      (blocks ADR-E-005 being lifted)

## Phase 2 — Dart model prerequisites (mobile ships first)

Gated by ADR-E-006. Nothing on the desktop side depends on this *shipping*,
but the wire fields stay local-only until it does.

- [ ] `Note.fromJson`/`toJson` preserve unknown keys (`_extra` round-trip)
- [ ] Add `pinned`, `archived`, `trashed`, `tags` to the Dart model + wire
- [ ] Mobile UI for at least pin + tags (otherwise desktop-only fields feel
      broken when the user opens the same note on the phone)
- [ ] Wire-contract fixtures shared with the Rust crate

## Phase 3 — Minimal service (Rust)

- [ ] `native/service` crate: bus name `com.lwb89dev.Echoes.Service`,
      object `/com/lwb89dev/Echoes`, `Notes1` + `NostrAccount1` (account
      stubbed until phase 6)
- [ ] SQLite (XDG paths, WAL, versioned migrations, backup-before-migrate,
      corruption quarantine) — mirror Astraea's `db.rs`/`store.rs`
- [ ] Notes CRUD + pin/archive/trash/tags over D-Bus, `NotesChanged`
- [ ] FTS5 search with the ADR-E-008 ranking
- [ ] systemd user unit (hardened) + D-Bus activation (+ non-systemd
      fallback), idle-exit policy, graceful SIGTERM
- [ ] CLI: `status`, `search`, `doctor`, `db migrate`
- [ ] Unit tests: model, store, migrations, search ranking

## Phase 4 — Quick Capture (highest user-visible value)

- [ ] `native/quick-capture`: GTK4 binary, D-Bus client, opens < 100 ms
      (ADR-E-007)
- [ ] `QuickCapture()` on `Notes1` raises it; `seedText` pre-fill
- [ ] Global shortcut setup per desktop (GNOME/COSMIC/KDE),
      default `Super+Shift+N`

## Phase 5 — Flutter Linux client

- [ ] `lib/desktop/`: D-Bus client + Riverpod provider overrides (ADR-003)
- [ ] Desktop layout: sidebar (Pinned / Notes / Tags / Trash) + editor
- [ ] Markdown editor + preview, keyboard shortcuts
- [ ] `echoes://` deep links through the single-instance GTK runner
- [ ] Mock backend so the UI builds with no service running

## Phase 6 — Authentication

- [ ] `account/` module behind `SignerBackend` / `AccountStore` traits
- [ ] Browser login bridge (127.0.0.1, random port, state/nonce/expiry,
      single use) + `window.nostr` page
- [ ] Secret Service storage; no key material ever crosses D-Bus
- [ ] Signers: `BrowserNip07Signer`, `RemoteSigner` (NIP-46),
      `LocalDelegatedSigner`, `ReadOnlySigner`

## Phase 7 — Nostr sync in the service

- [ ] Self-encrypted owned notes (kind 30078, `d` = note id), sync queue
      with exponential backoff, `SyncStatusChanged`
- [ ] NIP-09 retraction on permanent delete
- [ ] Cross-implementation fixtures green in CI
- [ ] **Only then**: lift ADR-E-005 and move sharing into the service

## Phase 8 — Shell frontends

- [ ] GNOME Shell extension (GJS): search + pinned + recent + new/checklist
      /paste-clipboard + "Open Echoes". Lint + mock D-Bus tests + written
      manual test plan (dev machine runs COSMIC)
- [ ] COSMIC applet (Rust, libcosmic) against the same D-Bus API
- [ ] GNOME Search Provider (notes in the desktop search overlay)

## Phase 9 — Packaging

- [ ] deb, rpm, PKGBUILD, Flatpak, AppImage, tarball
- [ ] desktop entry, AppStream metainfo, systemd user unit, D-Bus
      activation, MIME + `echoes://` URI handler
- [ ] `scripts/build-*.sh`, `install-dev.sh`, `check-versions.sh`
- [ ] Nautilus "Send to Echoes" context menu

## Phase 10 — Optional integrations

- [ ] Clipboard watcher (opt-in, off by default)
- [ ] Drag & drop of files/text onto the desktop app
- [ ] Desktop notifications (synced, checklist completed, conflict resolved)
