import 'package:echoes/models/note.dart';
import 'package:flutter_test/flutter_test.dart';

/// The home-screen preview is what a shopping list gets read from in the
/// shop, so what it leaves out matters as much as what it shows.
void main() {
  Note checklist(List<ChecklistItem> items) => Note(
    id: 'n1',
    title: 'Shopping',
    body: '',
    isChecklist: true,
    items: items,
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );

  test('previews only items still to do', () {
    final note = checklist(const [
      ChecklistItem(text: 'Olive oil', done: true),
      ChecklistItem(text: 'Bread'),
      ChecklistItem(text: 'Coffee', done: true),
      ChecklistItem(text: 'Milk'),
    ]);
    // Showing already-ticked items here is how you buy something twice.
    expect(note.preview, 'Bread\nMilk');
  });

  test('an all-done checklist previews as empty', () {
    final note = checklist(const [
      ChecklistItem(text: 'Bread', done: true),
      ChecklistItem(text: 'Milk', done: true),
    ]);
    expect(note.preview, isEmpty);
  });

  test('a bulleted body keeps its line structure', () {
    // Flattened onto one line, a shopping list reads as an unusable smear.
    final note = Note(
      id: 'n3',
      title: 'List',
      body: '- milk\n- bread\n\n- coffee',
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );
    expect(note.preview, '- milk\n- bread\n- coffee');
  });

  test('a plain note still previews its body', () {
    final note = Note(
      id: 'n2',
      title: 'T',
      body: 'just some text',
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );
    expect(note.preview, 'just some text');
  });
}
