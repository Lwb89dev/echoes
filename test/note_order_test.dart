import 'package:echoes/models/note.dart';
import 'package:echoes/providers/note_order_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Note note(String id, {int day = 1}) => Note(
    id: id,
    title: id,
    body: '',
    createdAt: DateTime(2026, 1, day),
    updatedAt: DateTime(2026, 1, day),
  );

  test('with no saved order, notes keep the order they came in', () {
    final notes = [note('a'), note('b'), note('c')];
    expect(applyNoteOrder(notes, const []).map((n) => n.id), ['a', 'b', 'c']);
  });

  test('arranged notes follow the saved order', () {
    final notes = [note('a'), note('b'), note('c')];
    expect(applyNoteOrder(notes, const ['c', 'a', 'b']).map((n) => n.id), ['c', 'a', 'b']);
  });

  test('notes with no saved position come first, keeping their own order', () {
    // 'new1'/'new2' were created after the last arrangement: they must not be
    // buried at the bottom of a long hand-sorted list.
    final notes = [note('new1'), note('b'), note('new2'), note('a')];
    expect(applyNoteOrder(notes, const ['a', 'b']).map((n) => n.id), ['new1', 'new2', 'a', 'b']);
  });

  test('a saved id for a note that no longer exists is simply ignored', () {
    final notes = [note('a'), note('b')];
    expect(applyNoteOrder(notes, const ['deleted', 'b', 'a']).map((n) => n.id), ['b', 'a']);
  });
}
