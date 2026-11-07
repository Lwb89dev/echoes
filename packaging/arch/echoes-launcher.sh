#!/bin/sh
# The Flutter bundle resolves lib/ and data/ next to the real binary
# ($ORIGIN/lib). This wrapper does not depend on the current directory.
exec /usr/lib/echoes/echoes "$@"
