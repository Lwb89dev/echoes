import 'dart:convert';

import 'package:echoes/models/note.dart';
import 'package:flutter_test/flutter_test.dart';

/// Timestamps are what last-write-wins merges compare and what the
/// payload/envelope check in `NostrService` validates, so how they survive a
/// trip through a relay decides whether an edit made on one device ever wins
/// (or is even accepted) on another.
void main() {
  Note noteAt(DateTime updatedAt) => Note(
    id: 'n1',
    title: 't',
    body: 'b',
    createdAt: updatedAt,
    updatedAt: updatedAt,
  );

  test('serialized timestamps carry an explicit zone', () {
    final json = noteAt(DateTime(2026, 8, 2, 14, 30)).toJson();
    // Without a zone marker the same text means a different instant on a
    // device in another timezone — silently shifting updatedAt.
    expect(json['updatedAt'], endsWith('Z'));
    expect(json['createdAt'], endsWith('Z'));
  });

  test('round trip preserves the exact instant', () {
    final original = DateTime(2026, 8, 2, 14, 30, 15, 250);
    final decoded = Note.fromJson(
      jsonDecode(jsonEncode(noteAt(original).toJson())) as Map<String, dynamic>,
    );
    expect(decoded.updatedAt.isAtSameMomentAs(original), isTrue);
  });

  test('a UTC-marked payload is read as the same instant, not the same clock face', () {
    // What a device in another timezone receives: 12:30Z is 14:30 in Rome.
    final json = noteAt(DateTime(2026, 8, 2, 14, 30)).toJson();
    final decoded = Note.fromJson(json);
    expect(
      decoded.updatedAt.toUtc(),
      DateTime(2026, 8, 2, 14, 30).toUtc(),
    );
  });

  test('zone-less timestamps written by older versions still load', () {
    // Backward compatibility: notes already on relays have no zone marker.
    final legacy = {
      ...noteAt(DateTime(2026, 8, 2, 14, 30)).toJson(),
      'createdAt': '2026-08-02T14:30:00.000',
      'updatedAt': '2026-08-02T14:30:00.000',
    };
    final decoded = Note.fromJson(legacy);
    expect(decoded.updatedAt, DateTime(2026, 8, 2, 14, 30));
  });
}
