#!/bin/sh
# Thin launcher: the actual bundle keeps the exact layout `flutter build
# linux` produces (a binary next to lib/ and data/, found via the runner's
# baked-in $ORIGIN/lib rpath — see linux/CMakeLists.txt), so it's installed
# as a self-contained unit under /app/lib/echoes rather than spread across
# the usual /app/bin + /app/lib. This is what actually runs it from $PATH.
exec /app/lib/echoes/echoes "$@"
