# Echoes

**Offline-first, end-to-end encrypted notes — synced privately over [Nostr](https://nostr.com), on your terms.**

Echoes is a Flutter notes app for Android and Linux/Windows desktop that treats the network as optional. Every note, checklist, image, and voice memo is saved locally first and stays fully usable with no connection at all. Nothing is ever published without an explicit opt-in: a note only starts syncing after you sync it once yourself — from then on, *that* note's updates ride the background sync (on launch, periodically, and on reconnect), while everything else stays local-only. Everything that leaves the device is encrypted before it goes: note content is NIP-44 self-encrypted, and image/voice attachments are AES-256-GCM encrypted client-side before upload, so relay operators and file hosts only ever see opaque ciphertext.

## Features

- **Offline-first** — notes are always readable/writable locally; nothing blocks on network or relay availability.
- **Private Nostr sync** — per-note or bulk, explicit opt-in. Content is NIP-44 self-encrypted and published as a parameterized-replaceable event (NIP-78/33), so edits update the same event in place instead of piling up duplicates.
- **Share notes with other Nostr users** — end-to-end encrypted, one NIP-44 copy per recipient (so revoking access actually cuts someone off). Recipients can edit; their changes sync back to the owner and merge. Add recipients by npub, hex, or a **NIP-05** identifier (`name@domain`), with contact autocomplete and an avatar-and-name confirmation before anything is shared.
- **Encrypted attachments** — images and voice notes are AES-256-GCM encrypted on-device, then uploaded to a [Blossom](https://github.com/hzrd149/blossom) or [NIP-96](https://github.com/nostr-protocol/nips/blob/master/96.md) file host. The host never sees the plaintext, filename, or media type in the clear.
- **Diary mode** — journal-style entries tagged with a date (defaults to today, freely backdated/postdated), shown as a day-grouped timeline separate from regular notes.
- **Optional at-rest encryption** — password-protect the local note database (PBKDF2 + AES-256-GCM); the password is never stored.
- **Flexible sign-in** — import a private key directly, delegate to [Amber](https://github.com/greenart7c3/Amber) (NIP-55 external signer, Android), or connect a **NIP-46 remote signer** ("bunker", every platform) so the private key stays in the signer and never reaches Echoes.
- **Bring your own infrastructure** — any relay (including a self-hosted one over `ws://` on a local network or [Tailscale](https://tailscale.com)) and any Blossom/NIP-96 host; built-in defaults were chosen specifically for not rejecting encrypted uploads. Adding a relay auto-republishes your already-synced notes to it.
- **Backup by relay, not by cloud** — export/import notes as a (optionally password-encrypted) JSON file, or republish everything to a newly added relay to backfill it.
- **Checklists, voice notes, inline images** — with a lightweight markdown formatting toolbar (bold/italic/heading/list/link) and a read-view/edit-view split, so opening a note shows a clean rendered view first.
- **Google-Keep-style post-it grid** (default) or single-column list, light/dark themes, and 27 languages (all 24 official EU languages plus Chinese, Japanese and Russian).

## How syncing works

1. Saving a note always writes to local storage first (Hive) — fast and reliable regardless of network state.
2. Publishing is explicit: the cloud button on a single note, a bulk "sync selected" action, or an automatic background cycle (on launch, periodically, and on reconnect) that only ever touches notes already opted into syncing.
3. Notes are Nostr kind `30078` events (NIP-78, parameterized-replaceable via a `d` tag), content NIP-44-encrypted to the author's own pubkey. Deleting a synced note publishes a NIP-09 retraction.
4. Any attachment still pending upload is encrypted and uploaded *before* the note is published, so a relay never receives a reference to a file that only exists on one device.
5. Pulling from relays merges by `updatedAt` — last write wins. Simple and predictable, with the honest trade-off that if the same note is edited on two devices while offline, the older of the two edits is discarded on merge (there is no conflict-keeping).

## Tech stack

- [Flutter](https://flutter.dev) + [Riverpod](https://riverpod.dev) for state management
- [`dart_nostr`](https://pub.dev/packages/dart_nostr) for relay transport and event signing, plus a from-scratch NIP-44 implementation (`lib/utils/nip44.dart`) against `pointycastle`
- [`amberflutter`](https://pub.dev/packages/amberflutter) for NIP-55 (Amber) delegated signing, and a from-scratch NIP-46 remote-signer client (`lib/services/nip46_client.dart`) for bunker sign-in
- [Hive](https://pub.dev/packages/hive) for local note storage, [`flutter_secure_storage`](https://pub.dev/packages/flutter_secure_storage) for the private key (and the bunker session)
- Blossom (BUD-01/02/11) and NIP-96 clients for encrypted attachment upload/download

## Getting started

Prerequisites: the [Flutter SDK](https://docs.flutter.dev/get-started/install) and a configured toolchain for your target (`flutter doctor`). Android and Linux desktop are the actively built targets; the codebase is standard Flutter, so other desktop targets build too.

```bash
flutter pub get
flutter gen-l10n   # generates lib/l10n/app_localizations*.dart from the .arb files
flutter run        # add -d linux to run the desktop build
```

### Packaging

- **Android**: `flutter build apk --release` produces per-ABI APKs under `build/app/outputs/flutter-apk/`. Release signing is read from `android/key.properties` (never committed).
- **Debian/Ubuntu**: `./packaging/deb/build-deb.sh` builds a single `.deb` of the Linux desktop app into `dist/`.
- **Flatpak**: a manifest for `org.echoes.echoes` lives under `flatpak/`.

### Development

```bash
flutter analyze    # static analysis
flutter test       # unit/widget tests
```

Localized strings live in `lib/l10n/*.arb` (`app_en.arb` is the template — every key must exist there; other locales fall back to English for anything untranslated). After editing an `.arb` file, run `flutter gen-l10n` to regenerate the Dart bindings.

### Project structure

```
lib/
  models/      Plain data classes (Note, Attachment, Relay, User, ...)
  services/    Nostr, local storage, sync orchestration, attachment upload/download
  providers/   Riverpod state (auth, notes, relays, settings)
  screens/     UI (home, note editor, settings, onboarding)
  utils/       NIP-44 crypto, formatting, app-wide constants
```

## License

Echoes is licensed under the [GNU General Public License v3.0](LICENSE) (GPL-3.0-or-later).
