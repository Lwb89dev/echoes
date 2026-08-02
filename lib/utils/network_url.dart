/// Parses an absolute HTTPS URL at a network trust boundary.
///
/// Checking only `startsWith('https://')` is not enough: it accepts malformed
/// values and URLs containing user-info, which can make the visible host
/// misleading. Callers may safely pass the returned [Uri] to an HTTP client.
Uri requireHttpsUri(String value) {
  final uri = Uri.tryParse(value.trim());
  if (uri == null ||
      uri.scheme.toLowerCase() != 'https' ||
      uri.host.isEmpty ||
      uri.userInfo.isNotEmpty) {
    throw FormatException('A valid HTTPS URL is required.');
  }
  return uri;
}

/// Non-throwing counterpart used for optional/decorative network resources.
Uri? tryParseHttpsUri(String value) {
  try {
    return requireHttpsUri(value);
  } on FormatException {
    return null;
  }
}

/// Parses a WebSocket relay URL (`ws://` or `wss://`).
///
/// `wss://` is preferred, but `ws://` is deliberately allowed: Echoes supports
/// plain-WebSocket relays on trusted local networks (a self-hosted relay over
/// LAN or Tailscale), the same policy the note relays use — so a remote-signer
/// bunker reachable only over `ws://` on such a network still connects. The
/// robustness checks stay: a malformed URL, embedded user-info (which can make
/// the visible host misleading) or a fragment are all rejected, none of which
/// belong in a relay URL.
Uri requireWebSocketUri(String value) {
  final uri = Uri.tryParse(value.trim());
  final scheme = uri?.scheme.toLowerCase();
  if (uri == null ||
      (scheme != 'ws' && scheme != 'wss') ||
      uri.host.isEmpty ||
      uri.userInfo.isNotEmpty ||
      uri.fragment.isNotEmpty) {
    throw FormatException('A valid ws:// or wss:// relay URL is required.');
  }
  return uri;
}
