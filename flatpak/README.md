# Packaging Echoes as a Flatpak

This packages the *already-built* Linux release bundle rather than compiling
Flutter/Dart inside the Flatpak sandbox — simpler and avoids needing network
access mid-build to fetch pub packages. Build the app first, then package it:

```bash
# 1. Build the Linux release bundle (from the repo root)
flutter build linux --release

# 2. Fetch the GTK3 base module Flathub apps share (one-time)
git clone --depth 1 https://github.com/flathub/shared-modules.git flatpak/shared-modules

# 3. Build and install locally
cd flatpak
flatpak-builder --user --install --force-clean build-dir org.echoes.echoes.json
```

Then run it with `flatpak run org.echoes.echoes`.

## Notes

- The manifest installs the bundle as a self-contained unit under
  `/app/lib/echoes` (binary + `lib/*.so` + `data/`) instead of spreading it
  across `/app/bin`/`/app/lib`, because the runner binary resolves its
  bundled libraries via a `$ORIGIN/lib`-relative rpath (see
  `linux/CMakeLists.txt`) — moving the binary away from its `lib/` sibling
  would break that. `echoes.sh` is the thin `/app/bin/echoes` wrapper that
  actually gets found on `$PATH`.
- Voice notes are unavailable on Linux (see
  `lib/utils/platform_support.dart`'s `supportsVoiceNotes` doc comment), so
  no PulseAudio/microphone permission is requested — the sandbox stays
  narrower than it would need to be if that feature were exposed here.
- `--talk-name=org.freedesktop.secrets` is for `flutter_secure_storage`'s
  libsecret-backed keyring on Linux (where the account's private key lives).
- Re-run step 1 and the `flatpak-builder` command any time the app changes;
  nothing here needs to change unless a new native dependency (a new
  plugin's `.so`, a new system library) is added.
