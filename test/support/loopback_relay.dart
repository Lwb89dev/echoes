import 'dart:convert';
import 'dart:io';

/// A tiny NIP-01 relay on 127.0.0.1. Enough for a NIP-46 handshake: it
/// accepts EVENT, answers OK, and fans REQ matches out to current sockets.
/// Stored events are replayed to a new subscription so a signer and a
/// client can connect in either order.
class LoopbackRelay {
  LoopbackRelay._(this._server);

  final HttpServer _server;
  final _sockets = <WebSocket, Map<String, Map<String, dynamic>>>{};
  final _events = <Map<String, dynamic>>[];

  static Future<LoopbackRelay> start() async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final relay = LoopbackRelay._(server);
    server.listen(relay._onRequest);
    return relay;
  }

  String get url => 'ws://127.0.0.1:${_server.port}';

  Future<void> close() async {
    for (final socket in _sockets.keys.toList()) {
      await socket.close();
    }
    await _server.close(force: true);
  }

  Future<void> _onRequest(HttpRequest request) async {
    if (!WebSocketTransformer.isUpgradeRequest(request)) {
      request.response.statusCode = HttpStatus.upgradeRequired;
      await request.response.close();
      return;
    }
    final socket = await WebSocketTransformer.upgrade(request);
    _sockets[socket] = {};
    socket.listen((data) => _onFrame(socket, data), onDone: () => _sockets.remove(socket));
  }

  void _onFrame(WebSocket socket, Object? data) {
    final text = _asText(data);
    if (text == null) return;
    final decoded = jsonDecode(text);
    if (decoded is! List || decoded.isEmpty) return;
    final type = decoded.first;
    if (type == 'EVENT' && decoded.length >= 2 && decoded[1] is Map) {
      final event = Map<String, dynamic>.from(decoded[1] as Map);
      _events.add(event);
      _broadcast(event);
      socket.add(jsonEncode(['OK', event['id'], true, '']));
      return;
    }
    if (type == 'REQ' && decoded.length >= 3 && decoded[1] is String) {
      final subId = decoded[1] as String;
      final filters = <Map<String, dynamic>>[];
      for (var i = 2; i < decoded.length; i++) {
        final filter = decoded[i];
        if (filter is Map) filters.add(Map<String, dynamic>.from(filter));
      }
      _sockets[socket]![subId] = {'filters': filters};
      for (final event in _events) {
        if (_matchesAny(filters, event)) {
          socket.add(jsonEncode(['EVENT', subId, event]));
        }
      }
      socket.add(jsonEncode(['EOSE', subId]));
      return;
    }
    if (type == 'CLOSE' && decoded.length >= 2) {
      _sockets[socket]?.remove(decoded[1]);
    }
  }

  void _broadcast(Map<String, dynamic> event) {
    for (final entry in _sockets.entries) {
      for (final sub in entry.value.entries) {
        final filters = sub.value['filters'];
        if (filters is! List) continue;
        final typed = [for (final filter in filters) Map<String, dynamic>.from(filter as Map)];
        if (_matchesAny(typed, event)) {
          entry.key.add(jsonEncode(['EVENT', sub.key, event]));
        }
      }
    }
  }

  bool _matchesAny(List<Map<String, dynamic>> filters, Map<String, dynamic> event) {
    if (filters.isEmpty) return true;
    for (final filter in filters) {
      if (_matches(filter, event)) return true;
    }
    return false;
  }

  bool _matches(Map<String, dynamic> filter, Map<String, dynamic> event) {
    final kinds = filter['kinds'];
    if (kinds is List && !kinds.contains(event['kind'])) return false;
    final authors = filter['authors'];
    if (authors is List && !authors.contains(event['pubkey'])) return false;
    final since = filter['since'];
    final createdAt = event['created_at'];
    if (since is int && createdAt is int && createdAt < since) return false;
    final tagged = filter['#p'];
    if (tagged is! List) return true;
    final tags = event['tags'];
    if (tags is! List) return false;
    for (final tag in tags) {
      if (tag is List && tag.length >= 2 && tag[0] == 'p' && tagged.contains(tag[1])) {
        return true;
      }
    }
    return false;
  }

  String? _asText(Object? data) {
    if (data is String) return data;
    if (data is List<int>) return utf8.decode(data);
    return null;
  }
}
