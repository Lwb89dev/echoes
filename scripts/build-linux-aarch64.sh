#!/usr/bin/env bash
# Native Linux AArch64 release bundle. This does not cross-compile: Flutter
# desktop builds the engine and the plugins for the host CPU. On an x86_64
# machine (the HP OMEN / Pop!_OS dev box) run it inside an AArch64 environment
# — an Arch Linux ARM machine, a qemu-user aarch64 chroot, or the
# ubuntu-24.04-arm GitHub runner — not by renaming an x86_64 binary.
#
# Usage, from the repository root, on Linux aarch64:
#   scripts/build-linux-aarch64.sh
#
# Outputs:
#   build/linux/arm64/release/bundle/
#   dist/echoes-linux-aarch64-<version>-<commit>.tar.gz
#   dist/echoes-linux-aarch64-<version>-<commit>.tar.gz.sha256
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

HOST="$(uname -m)"
if [[ "$HOST" != "aarch64" && "$HOST" != "arm64" ]]; then
  echo "This script builds a real AArch64 ELF and the host is $HOST." >&2
  echo "Flutter's Linux desktop target follows the host CPU. It will not" >&2
  echo "turn an x86_64 engine into an arm64 binary." >&2
  echo "Run this script on Linux aarch64, or in CI on ubuntu-24.04-arm." >&2
  exit 1
fi

if ! command -v flutter >/dev/null 2>&1; then
  echo "flutter is not on PATH. Install the Flutter SDK on this machine." >&2
  echo "This script does not download it." >&2
  exit 1
fi

flutter config --enable-linux-desktop
flutter pub get
flutter gen-l10n
flutter build linux --release

BUNDLE="build/linux/arm64/release/bundle"
if [[ ! -x "$BUNDLE/echoes" ]]; then
  # Some Flutter versions still use the x64 directory name even on arm.
  # Accept that only when the ELF itself is AArch64.
  if [[ -x build/linux/x64/release/bundle/echoes ]]; then
    BUNDLE="build/linux/x64/release/bundle"
  else
    echo "release bundle not found under build/linux" >&2
    exit 1
  fi
fi

scripts/verify-linux-bundle-arch.sh "$BUNDLE" aarch64

VERSION="$(grep -m1 '^version:' pubspec.yaml | sed -E 's/^version:[[:space:]]*([0-9]+\.[0-9]+\.[0-9]+).*/\1/')"
COMMIT="$(git rev-parse --short=12 HEAD)"
mkdir -p dist
BASE="echoes-linux-aarch64-${VERSION}-${COMMIT}.tar.gz"
tar -C "$BUNDLE" -czf "dist/${BASE}" .
# The checksum names the archive basename, so it still verifies after the
# file is copied next to packaging/arch/echoes-bin/.
(
  cd dist
  sha256sum "$BASE" | tee "${BASE}.sha256"
)
echo "built dist/${BASE}"
file "$BUNDLE/echoes"
