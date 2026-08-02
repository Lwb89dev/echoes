#!/usr/bin/env bash
# Builds a single .deb of the Echoes Flutter Linux desktop app for
# Debian-based distributions. One package, no split: the self-contained
# Flutter bundle (executable + bundled libraries + assets) is installed under
# /usr/lib/echoes, with a thin launcher on PATH, a desktop entry, icons and
# AppStream metadata.
#
# Usage: packaging/deb/build-deb.sh [--no-build]
#   --no-build   package the existing build/linux/x64/release/bundle as-is
#                (skip `flutter build linux --release`).
#
# Output: dist/echoes_<version>_amd64.deb
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$REPO_ROOT"

APP_ID="com.echoes.echoes"
BINARY="echoes"

# Version from pubspec (`version: X.Y.Z+build`) → Debian version X.Y.Z.
VERSION="$(grep -m1 '^version:' pubspec.yaml | sed -E 's/^version:[[:space:]]*([0-9]+\.[0-9]+\.[0-9]+).*/\1/')"
[ -n "$VERSION" ] || { echo "Could not read version from pubspec.yaml" >&2; exit 1; }

if [ "${1:-}" != "--no-build" ]; then
  echo "==> flutter build linux --release"
  flutter build linux --release
fi

BUNDLE="build/linux/x64/release/bundle"
[ -x "$BUNDLE/$BINARY" ] || { echo "Missing $BUNDLE/$BINARY — run without --no-build first." >&2; exit 1; }

STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

# --- payload ---------------------------------------------------------------
install -d "$STAGE/usr/lib/echoes"
cp -r "$BUNDLE/." "$STAGE/usr/lib/echoes/"

# Thin launcher on PATH. Exec the real binary at its real location so the
# Flutter runner resolves data/ and lib/ (rpath $ORIGIN/lib) next to it.
install -d "$STAGE/usr/bin"
cat > "$STAGE/usr/bin/echoes" <<'LAUNCH'
#!/bin/sh
exec /usr/lib/echoes/echoes "$@"
LAUNCH
chmod 755 "$STAGE/usr/bin/echoes"

# --- desktop entry ---------------------------------------------------------
install -d "$STAGE/usr/share/applications"
cat > "$STAGE/usr/share/applications/$APP_ID.desktop" <<DESKTOP
[Desktop Entry]
Type=Application
Name=Echoes
GenericName=Notes
Comment=Offline-first, end-to-end encrypted notes synced over Nostr
Exec=echoes %U
Icon=$APP_ID
Terminal=false
Categories=Office;
Keywords=notes;encrypted;nostr;diary;checklist;
StartupWMClass=$APP_ID
DESKTOP

# --- icons -----------------------------------------------------------------
for size in 128 256 512; do
  src="flatpak/org.echoes.echoes-$size.png"
  [ -f "$src" ] || continue
  dir="$STAGE/usr/share/icons/hicolor/${size}x${size}/apps"
  install -d "$dir"
  cp "$src" "$dir/$APP_ID.png"
done

# --- AppStream metadata ----------------------------------------------------
if [ -f flatpak/org.echoes.echoes.metainfo.xml ]; then
  install -d "$STAGE/usr/share/metainfo"
  cp flatpak/org.echoes.echoes.metainfo.xml "$STAGE/usr/share/metainfo/$APP_ID.metainfo.xml"
fi

# --- control ---------------------------------------------------------------
# Installed-Size in KiB, as dpkg expects.
INSTALLED_KB="$(du -ks "$STAGE/usr" | cut -f1)"
install -d "$STAGE/DEBIAN"
cat > "$STAGE/DEBIAN/control" <<CONTROL
Package: echoes
Version: $VERSION
Section: utils
Priority: optional
Architecture: amd64
Maintainer: Lwb89dev <noreply@echoes.app>
Installed-Size: $INSTALLED_KB
Depends: libgtk-3-0 | libgtk-3-0t64, libglib2.0-0 | libglib2.0-0t64, libsecret-1-0
Homepage: https://github.com/Lwb89dev/echoes
Description: Offline-first, end-to-end encrypted notes over Nostr
 Echoes is a note-taking app that keeps every note, checklist, diary entry
 and voice memo on your device first and syncs — encrypted end to end — over
 the Nostr protocol, on your terms. Note content is NIP-44 self-encrypted and
 attachments are AES-256-GCM encrypted client-side before upload, so relays
 and file hosts only ever see ciphertext.
CONTROL

# --- desktop-file validation (best effort) ---------------------------------
if command -v desktop-file-validate >/dev/null 2>&1; then
  desktop-file-validate "$STAGE/usr/share/applications/$APP_ID.desktop" || true
fi

# --- build -----------------------------------------------------------------
mkdir -p dist
OUT="dist/echoes_${VERSION}_amd64.deb"
# --root-owner-group: files owned by root:root without needing fakeroot/root.
dpkg-deb --build --root-owner-group "$STAGE" "$OUT"
echo "==> built $OUT"
dpkg-deb --info "$OUT" | sed 's/^/    /'
