import 'package:echoes/services/note_encryption_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('rejects malformed export crypto fields before key derivation', () async {
    final service = NoteEncryptionService();
    final malformed = {
      'salt': 'dG9vLXNob3J0',
      'nonce': 'dG9vLXNob3J0',
      'mac': 'dG9vLXNob3J0',
      'ciphertext': 'YQ==',
    };

    await expectLater(
      service.decryptExportWithPassword(malformed, 'password'),
      throwsFormatException,
    );
  });
}
