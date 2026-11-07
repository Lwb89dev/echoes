#!/usr/bin/env bash
# Confirm every ELF in a Flutter Linux bundle is the expected architecture.
# Usage: scripts/verify-linux-bundle-arch.sh <bundle-dir> <aarch64|x86_64>
set -euo pipefail

BUNDLE="${1:?bundle directory}"
EXPECT="${2:?aarch64 or x86_64}"
case "$EXPECT" in
  aarch64) MACHINE="ARM aarch64" ;;
  x86_64) MACHINE="x86-64" ;;
  *) echo "expected aarch64 or x86_64, got $EXPECT" >&2; exit 2 ;;
esac

if [[ ! -x "$BUNDLE/echoes" ]]; then
  echo "missing executable: $BUNDLE/echoes" >&2
  exit 1
fi

fail=0
while IFS= read -r -d '' path; do
  desc="$(file -b "$path")"
  if [[ "$desc" != *"ELF"* ]]; then
    continue
  fi
  if [[ "$desc" != *"$MACHINE"* ]]; then
    echo "wrong architecture: $path" >&2
    echo "  $desc" >&2
    fail=1
  fi
done < <(find "$BUNDLE" -type f -print0)

if [[ "$fail" -ne 0 ]]; then
  exit 1
fi
echo "bundle ELF check passed ($EXPECT)"
