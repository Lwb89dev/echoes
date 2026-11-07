# Echoes on Linux AArch64 / Omarchy Mobile

This branch ports the existing Flutter application. It does not implement the Rust D-Bus service described in `docs/linux-architecture.md`. That document is an unimplemented plan. The application that ships is the Flutter GTK client already used for the Debian package and the Flatpak.

Base revision: `4ab950757252b929ed78203bd466fc7783416047` (`v1.1.2`, version `1.1.2+2017`). The version and the Android `versionCode` are unchanged. Branch: `feat/omamobile-linux-arm64`.

Local toolchain for the checks below: Flutter 3.44.3, Dart 3.12.2. The new workflow pins that Flutter version. `.github/workflows/build-linux.yml` is unchanged and still follows the `stable` channel when a `v*` tag is pushed.

## Architecture

One Flutter codebase. Android behavior stays. Linux keeps the GTK runner in `linux/` (`BINARY` `echoes`, application id `com.echoes.echoes`, RPATH `$ORIGIN/lib`). The window size in the runner is unchanged.

Login goes through `NostrSigner`:

| Login | Where the identity key lives | Platforms |
| --- | --- | --- |
| Amber, NIP-55 | Amber, via `amberflutter` | Android only. The button is hidden elsewhere. |
| NIP-46 `nostrconnect://` or `bunker://` | The remote signer | Android and Linux. |
| Explicit nsec import | Secret storage (Android keystore, Linux Secret Service) | Every platform, as a collapsed option. |

A NIP-46 session uses a second keypair, generated for that connection. It is not the user's Nostr identity. The `nostrconnect://` URI carries the client public key, the user's relays (or the app defaults), a 32-byte random secret, and the permissions Echoes asks for: `sign_event` for kinds 30078, 5, 27235 and 24242, plus `nip44_encrypt` and `nip44_decrypt`. The QR is shown on a white background. The URI is not printed as text. Copy puts it on the clipboard.

The client accepts a kind-24133 response only when the decrypted `result` matches that secret (equal length, constant-time compare) and the event signature checks out. The author of that event becomes the remote signer key. The account public key then comes from `get_public_key`, which may differ from the transport key. An error that includes the secret is a real rejection. An error without the secret is ignored. The user can cancel the wait. After success the in-memory session drops the secret, and only that sanitized session is eligible for storage. Logout asks the signer to drop the session and always deletes the local transport key.

`bunker://` remains available on every platform, including Linux.

## Offline notes and the signer

Hive stores each note as JSON, or as AES-256-GCM ciphertext when the user has set a local password. That password is not stored. Opening the local box does not call `NostrSigner`.

Publishing, deleting on relays, and NIP-44 on relay payloads do call the signer. For a bunker or Amber login the identity private key is not on the device. If the signer is offline those network operations fail. Notes already in Hive stay readable. Echoes does not cache the identity private key to bridge that gap, and it does not write decrypted note bodies to a second store.

The NIP-46 transport key cannot decrypt a kind 30078 note. Note ciphertext is encrypted to the account key. Kind 30078 events keep the current shape: JSON note, NIP-44 to self, then a signed kind 30078 with the `d` tag. Android Amber and a local nsec still produce that shape. The Linux path asks the remote signer to encrypt and sign the same bytes.

## What was verified on this machine

Host: x86_64 Pop!_OS. Not an Omarchy phone.

- `flutter analyze --no-fatal-infos` reports four `prefer_initializing_formals` infos and no warnings.
- `flutter test` passed, including `test/nip46_connect_test.dart`.
- That test speaks NIP-46 to a second process-local signer over a loopback WebSocket relay. It is not a mock of `Nip46Client`. It covers a `nostrconnect://` URI, a wrong secret, `get_public_key`, `switch_relays`, `nip44_encrypt` / `nip44_decrypt` of a kind-30078-shaped payload, `sign_event` of kind 30078, a persisted session with no association secret, reconnect from that session, `logout`, and a rejected request afterwards.
- A phone signer (Amber acting as a bunker, nsec.app, or another NIP-46 app) was not used.
- `flutter build linux --release` produced `build/linux/x64/release/bundle/echoes`. `file` reports `ELF 64-bit LSB pie executable, x86-64, ... for GNU/Linux`. `readelf -h` reports machine Advanced Micro Devices X86-64. Every ELF in the bundle is x86-64. `scripts/verify-linux-bundle-arch.sh` passed for `x86_64`.
- `scripts/build-linux-aarch64.sh` exits 1 on this host and does not rename the x86_64 binary.
- `gdbus` reports that `org.freedesktop.secrets` owns a name on this session bus. No credential was written. A missing Secret Service still refuses the write. There is no SharedPreferences or file fallback.

`readelf -d` on the x86_64 bundle, not a claim about an AArch64 install: the embedder needs GTK 3 (`libgtk-3.so.0` and the usual GLib/Cairo/Pango stack). `libflutter_secure_storage_linux_plugin.so` also needs `libsecret-1.so.0`. `librecord_linux_plugin.so` does not link PipeWire; `record_linux` looks up `parecord` or `ffmpeg` on `PATH` at runtime. Voice notes stay hidden on Linux because `audio_waveforms` has no desktop backend. Do not read these sonames as the AArch64 dependency closure. That bundle has not been built here.

## Plugin matrix

| Plugin | Linux x86_64 | Linux AArch64 | Note |
| --- | --- | --- | --- |
| `flutter_secure_storage` 10.3.1, Linux impl 3.0.1 | Build passed | Implemented, untested | Dynamic link to libsecret. No bundled arch-specific blob. Write is refused when the Secret Service name is missing. |
| `qr_flutter` 4.1.0 | Build passed | Implemented, untested | Pure Dart. Added for the Nostr Connect QR. |
| `record_linux` 1.3.1 | Build passed | Implemented, untested | Compiled into the bundle. The voice UI does not call it. |
| `audio_waveforms` 2.0.2 | Blocked | Blocked | Android/iOS only. `PlatformSupport.supportsVoiceNotes` is false on Linux. |
| `wakelock_plus` 1.5.2 | Implemented, untested | Implemented, untested | Linux backend talks to `org.freedesktop.portal.Inhibit`. Not exercised. |
| `amberflutter` 0.0.9 | Blocked | Blocked | Android NIP-55 only. Hidden in the login form on Linux. The user's nsec is never read out of Amber. |
| `file_picker`, `path_provider`, `shared_preferences`, `url_launcher_linux` | Build passed | Implemented, untested | Already part of the desktop app. |
| `jni` (pulled by Amber) | Build passed | Implemented, untested | C sources compiled by the Linux runner. Unused by the Linux login flow. |

## Packaging and CI

- Debian and Flatpak recipes are unchanged, including the Debian autostart entry.
- `packaging/arch/PKGBUILD` is a source build for `aarch64` and `x86_64`. It refuses to cross-compile and refuses to download Flutter.
- `packaging/arch/echoes-bin/PKGBUILD` installs a tarball you already have. Its checksum is the sibling `.sha256` file. The recipe does not contain a hash of an unpublished tarball.
- `.github/workflows/linux-aarch64.yml` runs analyze, test, an x86_64 release build, and a native build on `ubuntu-24.04-arm`. The AArch64 job uploads `echoes-linux-aarch64-<version>-<commit>.tar.gz` and the `.sha256` file as an Actions artifact. It does not publish a release. The Android release path is untouched because there is no Android workflow in this repository, and this file does not add one.

## Status

Allowed values are only the ones in this table.

| Item | Status |
| --- | --- |
| Shared Flutter tree on `feat/omamobile-linux-arm64` | Build passed |
| NIP-46 against the in-tree WebSocket signer (login, sign, NIP-44, reconnect, revoke) | Build passed |
| NIP-46 against a phone signer | Not started |
| Secret Service write on a desktop session | Implemented, untested |
| Linux x86_64 release bundle | Build passed |
| Linux AArch64 ELF bundle | Implemented, untested |
| Arch package installed with pacman | Not started |
| App launched on Omarchy Mobile | Not started |
| Wayland native client and virtual keyboard | Blocked |
| Voice notes on Linux | Blocked |
| Amber on Linux | Blocked |
| Identity private-key cache when the signer is offline | Blocked |

"Build passed" for the NIP-46 row means `flutter test` passed on this x86_64 host. It does not mean a person signed in with a phone. The AArch64 binary, the Arch package, and an Omarchy handset have not been run.

## Open problems

- Flutter desktop follows the host CPU. An AArch64 binary has to be produced on AArch64 (the GitHub `ubuntu-24.04-arm` runner, or an Arch Linux ARM machine). This Pop!_OS box cannot do it.
- Hyprland often shows the GTK embedder through XWayland. A native Wayland window and `text-input` / squeekboard were not tested. The default window stays 1280×720.
- The Secret Service probe on this machine saw the bus name. Storing a real session, unlocking a locked keyring, and restoring it after reboot were not done.
- `switch_relays` is accepted when the signer returns a JSON list of `ws://` or `wss://` URLs. A signer that returns `null` keeps the current relays. A live signer was not asked.
- The login screen scrolls when the window is short. It was not run on a phone-sized Hyprland output.
