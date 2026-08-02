import 'dart:typed_data';

import 'package:echoes/services/file_cache_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('rejects traversal and non-hash cache keys before filesystem access', () {
    final cache = FileCacheService();

    expect(() => cache.get('../../private'), throwsArgumentError);
    expect(() => cache.put('a' * 64, Uint8List(0), extension: '/../secret'), throwsArgumentError);
  });
}
