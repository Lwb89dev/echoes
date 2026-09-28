import 'package:echoes/models/note.dart';
import 'package:echoes/utils/note_links.dart';
import 'package:flutter_test/flutter_test.dart';

Note _note({required String id, String title = '', String body = ''}) {
  return Note(
    id: id,
    title: title,
    body: body,
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );
}

void main() {
  test('a title link resolves when exactly one note has that title', () {
    final notes = [
      _note(id: 'kitchen', title: 'Project Kitchen'),
      _note(id: 'ideas', title: 'Ideas', body: 'See [[Project Kitchen]]'),
    ];
    final index = NoteLinkIndex.from(notes);
    expect(index.outgoing(notes[1]).map((note) => note.id), ['kitchen']);
    expect(index.incoming('kitchen').map((note) => note.id), ['ideas']);
  });

  test('an id link survives a rename, and the preview shows the new title', () {
    final notes = [
      _note(id: 'kitchen', title: 'Pantry'),
      _note(id: 'ideas', title: 'Ideas', body: 'See [[Project Kitchen|kitchen]] tomorrow'),
    ];
    final index = NoteLinkIndex.from(notes);
    expect(index.outgoing(notes[1]).single.id, 'kitchen');
    final rendered = wikilinksToMarkdown(notes[1].body, index);
    expect(rendered, contains('[Pantry](echoes:kitchen)'));
    expect(rendered, isNot(contains('Project Kitchen')));
  });

  test('a repeated title does not guess, unless the link carries an id', () {
    final notes = [
      _note(id: 'a', title: 'List'),
      _note(id: 'b', title: 'List'),
      _note(id: 'c', title: 'Notes', body: '[[List]] and [[List|b]]'),
    ];
    final index = NoteLinkIndex.from(notes);
    expect(index.outgoing(notes[2]).map((note) => note.id), ['b']);
  });

  test('a note does not echo itself', () {
    final notes = [_note(id: 'a', title: 'A', body: '[[A|a]]')];
    final index = NoteLinkIndex.from(notes);
    expect(index.outgoing(notes.single), isEmpty);
    expect(index.incoming('a'), isEmpty);
  });

  test('markdown echoes: links are read the same way', () {
    final notes = [
      _note(id: 'budget', title: 'Budget'),
      _note(id: 'ideas', title: 'Ideas', body: 'Costs live in [Budget](echoes:budget).'),
    ];
    final index = NoteLinkIndex.from(notes);
    expect(index.incoming('budget').single.id, 'ideas');
  });

  test('card excerpts drop attachment tokens and wikilink brackets', () {
    const body = 'Milk\n![](attachment://abc "medium")\nSee [[Project Kitchen|kitchen]]';
    expect(plainNoteExcerpt(body), 'Milk\nSee Project Kitchen');
  });
}
