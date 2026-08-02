import 'package:echoes/utils/network_url.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('requireHttpsUri', () {
    test('accepts an absolute HTTPS URL', () {
      expect(requireHttpsUri('https://example.com/a?q=1').host, 'example.com');
    });

    test('rejects downgrade, credentials, relative and malformed URLs', () {
      for (final value in [
        'http://example.com',
        'https://user:pass@example.com',
        '/relative/path',
        'https:///missing-host',
      ]) {
        expect(() => requireHttpsUri(value), throwsFormatException);
      }
    });
  });

  group('requireWebSocketUri', () {
    test('accepts wss:// and ws:// (LAN relays), rejects credentials/bad URLs', () {
      expect(requireWebSocketUri('wss://relay.example').scheme, 'wss');
      // ws:// is allowed: self-hosted bunker on a trusted LAN/Tailscale.
      expect(requireWebSocketUri('ws://192.168.1.10:4869').scheme, 'ws');
      expect(() => requireWebSocketUri('wss://user@relay.example'), throwsFormatException);
      expect(() => requireWebSocketUri('https://relay.example'), throwsFormatException);
      expect(() => requireWebSocketUri('wss://relay.example#frag'), throwsFormatException);
    });
  });
}
