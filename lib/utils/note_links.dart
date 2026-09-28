import '../models/note.dart';

/// A reference from one note's body to another.
///
/// Two spellings are recognized, both of which stay inside the note body
/// (the encrypted payload already syncs that string — no new field, so an
/// older client that re-saves the note cannot strip the relationship):
///
/// * `[[Project Kitchen]]` — resolved by a unique title match.
/// * `[[Project Kitchen|note-id]]` — resolved by the stable id, so a later
///   rename of the target still points at the same note. The label is only
///   what was written; the UI shows the target's current title.
///
/// A normal markdown link `[Project Kitchen](echoes:note-id)` is accepted
/// too, for anything that round-trips through a markdown editor.
class NoteAnchor {
  const NoteAnchor({required this.label, this.noteId});

  final String label;
  final String? noteId;
}

final RegExp _wikiLink = RegExp(r'\[\[([^\[\]\n]+?)\]\]');
final RegExp _echoMarkdownLink = RegExp(r'(?<!!)\[([^\[\]\n]+)\]\(echoes:([^)\s]+)\)');

NoteAnchor _anchorFromInner(String inner) {
  final parts = inner.split('|');
  final label = parts.first.trim();
  final id = parts.length > 1 ? parts[1].trim() : '';
  return NoteAnchor(label: label, noteId: id.isEmpty ? null : id);
}

/// Every note reference written in [body], in order. Duplicates are kept;
/// callers that want a set de-duplicate after resolving.
List<NoteAnchor> parseNoteAnchors(String body) {
  final anchors = <NoteAnchor>[];
  for (final match in _wikiLink.allMatches(body)) {
    anchors.add(_anchorFromInner(match.group(1)!));
  }
  for (final match in _echoMarkdownLink.allMatches(body)) {
    anchors.add(NoteAnchor(label: match.group(1)!.trim(), noteId: match.group(2)!.trim()));
  }
  return anchors;
}

/// Body text with the markup a card should not show: attachment tokens,
/// wikilink brackets, and the lightest markdown markers.
String plainNoteExcerpt(String body) {
  final withoutTokens = body.replaceAll(RegExp(r'!\[[^\]]*\]\(attachment://[^)]*\)'), '');
  final withLabels = withoutTokens.replaceAllMapped(_wikiLink, (match) {
    return _anchorFromInner(match.group(1)!).label;
  });
  final links = withLabels.replaceAllMapped(RegExp(r'\[([^\[\]\n]+)\]\([^)]*\)'), (match) {
    return match.group(1)!;
  });
  final lines = <String>[];
  for (final rawLine in links.split('\n')) {
    var line = rawLine.trim();
    if (line.isEmpty) continue;
    line = line.replaceFirst(RegExp(r'^#{1,6}\s+'), '');
    line = line.replaceFirst(RegExp(r'^[-*]\s+'), '');
    line = line.replaceAll(RegExp(r'\*\*|__|~~|\+\+|`'), '');
    line = line.trim();
    if (line.isNotEmpty) lines.add(line);
    if (lines.length == 8) break;
  }
  return lines.join('\n');
}

/// Turns wikilinks into markdown links the preview renderer already
/// understands. When [index] can resolve a target, the visible label is
/// that note's current title, so a rename shows up without rewriting the
/// stored text (which would mark the note dirty and republish it).
String wikilinksToMarkdown(String input, NoteLinkIndex index) {
  return input.replaceAllMapped(_wikiLink, (match) {
    final anchor = _anchorFromInner(match.group(1)!);
    final id = index.resolve(anchor);
    final target = id == null ? null : index.byId[id];
    final label = _visibleLabel(target, anchor.label);
    final href = id != null ? 'echoes:$id' : 'echoes-title:${Uri.encodeComponent(anchor.label)}';
    return '[${_escapeLinkLabel(label)}]($href)';
  });
}

String _visibleLabel(Note? target, String fallback) {
  final title = target?.title.trim() ?? '';
  if (title.isNotEmpty) return title;
  if (fallback.trim().isNotEmpty) return fallback.trim();
  return '…';
}

String _escapeLinkLabel(String label) {
  return label.replaceAll('[', '').replaceAll(']', '').replaceAll('(', '').replaceAll(')', '');
}

/// In-memory index of note-to-note references. Built by scanning bodies.
/// No extra storage and no graph database: a few thousand personal notes
/// are a single pass.
class NoteLinkIndex {
  NoteLinkIndex._(this.byId, this._titleToIds, this._incoming);

  final Map<String, Note> byId;
  final Map<String, List<String>> _titleToIds;
  final Map<String, List<String>> _incoming;

  factory NoteLinkIndex.from(List<Note> notes) {
    final byId = {for (final note in notes) note.id: note};
    final titles = <String, List<String>>{};
    for (final note in notes) {
      final key = note.title.trim().toLowerCase();
      if (key.isEmpty) continue;
      titles.putIfAbsent(key, () => []).add(note.id);
    }
    final index = NoteLinkIndex._(byId, titles, {});
    for (final note in notes) {
      final seen = <String>{};
      for (final anchor in parseNoteAnchors(note.body)) {
        final target = index.resolve(anchor);
        if (target == null || target == note.id || !seen.add(target)) continue;
        index._incoming.putIfAbsent(target, () => []).add(note.id);
      }
    }
    return index;
  }

  static final empty = NoteLinkIndex._(const {}, const {}, const {});

  /// The note id [anchor] points at, or null when it names nothing unique.
  String? resolve(NoteAnchor anchor) {
    final id = anchor.noteId;
    if (id != null && byId.containsKey(id)) return id;
    final matches = _titleToIds[anchor.label.trim().toLowerCase()];
    if (matches != null && matches.length == 1) return matches.single;
    return null;
  }

  /// Href produced by [wikilinksToMarkdown], or an `echoes:` markdown link.
  String? idForHref(String href) {
    final uri = href.trim();
    if (uri.startsWith('echoes-title:')) {
      final label = Uri.decodeComponent(uri.substring('echoes-title:'.length));
      return resolve(NoteAnchor(label: label));
    }
    if (uri.startsWith('echoes:')) {
      final id = uri.substring('echoes:'.length);
      return byId.containsKey(id) ? id : null;
    }
    return null;
  }

  List<Note> outgoing(Note note) {
    final seen = <String>{};
    final notes = <Note>[];
    for (final anchor in parseNoteAnchors(note.body)) {
      final id = resolve(anchor);
      if (id == null || id == note.id || !seen.add(id)) continue;
      final target = byId[id];
      if (target != null) notes.add(target);
    }
    return notes;
  }

  List<Note> incoming(String noteId) {
    return [
      for (final sourceId in _incoming[noteId] ?? const <String>[])
        if (byId[sourceId] != null) byId[sourceId]!,
    ];
  }
}
