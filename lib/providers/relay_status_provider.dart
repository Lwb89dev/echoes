import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether a relay at [url] currently accepts a websocket connection — used
/// only to drive the online/offline dot next to each relay in Settings
/// (see `RelayListView`), completely separate from the app's real sync
/// connections (those go through `NostrService`/`dart_nostr`, and are never
/// opened or closed by this check).
///
/// `autoDispose` (the default for `.family`) means this re-checks fresh
/// every time the relay list is actually shown, instead of either pinging
/// continuously in the background or caching a possibly-stale result
/// forever — the relay list itself lives behind a collapsed `ExpansionTile`
/// in Settings, which by default doesn't even build (let alone watch) its
/// children until expanded, so opening Settings alone never triggers any
/// of these checks.
final relayStatusProvider = FutureProvider.autoDispose.family<bool, String>((ref, url) async {
  WebSocket? socket;
  try {
    socket = await WebSocket.connect(url).timeout(const Duration(seconds: 5));
    return true;
  } catch (_) {
    return false;
  } finally {
    unawaited(socket?.close());
  }
});
