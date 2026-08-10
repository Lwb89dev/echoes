import 'package:flutter/material.dart';

/// App-wide [ScaffoldMessenger] handle, wired into [MaterialApp] at startup.
///
/// Exists for results that outlive the screen that asked for them: syncing a
/// note keeps running after the user leaves the editor (the work belongs to
/// the notes provider, not to the widget), so the "synced" — or "couldn't
/// sync" — message has nowhere screen-local left to appear. Posting it here
/// shows it on whatever screen the user is actually looking at.
///
/// Only for that case. Anything a screen can report while it is still on
/// screen should use its own `ScaffoldMessenger.of(context)`, so the message
/// disappears together with the screen that owns it.
final GlobalKey<ScaffoldMessengerState> appMessengerKey = GlobalKey<ScaffoldMessengerState>();

/// Shows [message] as a dismissible snackbar, from anywhere — including code
/// with no [BuildContext] left to speak of. A no-op before the app is mounted
/// (nothing to show it on yet) rather than an error.
void showAppSnackBar(String message) {
  final messenger = appMessengerKey.currentState;
  if (messenger == null) return;
  // One at a time: a queued backlog of stale sync results is noise, not news.
  messenger
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        // Swipe-to-dismiss is on by default; the explicit action gives the
        // same escape hatch to anyone who doesn't think to swipe.
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
}
