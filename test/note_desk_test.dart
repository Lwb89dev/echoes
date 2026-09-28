import 'package:echoes/models/note.dart';
import 'package:echoes/providers/note_desk_provider.dart';
import 'package:flutter_test/flutter_test.dart';

Note _note(String id) {
  return Note(id: id, title: id, body: '', createdAt: DateTime(2026), updatedAt: DateTime(2026));
}

void main() {
  test('pinned notes keep their order and sit above the rest', () {
    final notes = [_note('c'), _note('a'), _note('b')];
    final arranged = pinFirst(notes, {'b', 'a'});
    expect(arranged.map((note) => note.id), ['a', 'b', 'c']);
  });

  test('the archive is hidden on the desk and shown in the archive', () {
    final note = _note('a');
    const desk = NoteDesk(archived: {'a'});
    expect(noteVisibleOnDesk(note, desk, searching: false), isFalse);
    expect(noteVisibleOnDesk(note, desk, searching: true), isTrue);
    const viewing = NoteDesk(archived: {'a'}, viewingArchive: true);
    expect(noteVisibleOnDesk(note, viewing, searching: false), isTrue);
  });
}
