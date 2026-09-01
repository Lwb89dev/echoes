import 'package:markdown/markdown.dart' as md;

/// Underline for the note body's markdown, as `++text++`.
///
/// Standard Markdown has no native underline: it's a deliberate omission in
/// the spec, since `__text__` already means bold. Raw HTML (`<u>text</u>`)
/// isn't an alternative either — the renderer this app uses for previews
/// doesn't parse arbitrary HTML tags into styled elements, so it would show
/// the literal angle brackets. `++text++` is Echoes' own convention on top
/// of that gap: it renders correctly here (see `_MarkdownPreview` in
/// note_editor_attachments.dart, which registers this syntax and gives the
/// `u` tag it produces an underline `TextStyle`), but it is *not* portable —
/// a note viewed in another Nostr client shows the literal `++...++` marks,
/// same as this app would for anyone else's non-standard extension.
///
/// Modeled directly on `package:markdown`'s own `StrikethroughSyntax`
/// (paired `~~`) rather than a bespoke regex parser, so nesting (e.g. bold
/// inside an underlined span) is handled by the same delimiter-run machinery
/// as every other paired-delimiter syntax, not reimplemented here.
///
/// `+` shows up in ordinary text too (`i++`, `C++`), which looked at first
/// like it could misfire — but `requiresDelimiterRun`'s CommonMark flanking
/// rules already rule those out: a `++` immediately followed by another
/// word character (as in `i++`, `C++20`, `a+++b`) can never be a left-flanking
/// *opener*, only a closer with nothing to close, so it's left as plain
/// text. Confirmed directly against `package:markdown` — `"C++ ... this is
/// ++underlined++"` renders exactly the `<u>` around the real pair and
/// nothing around either `C++`.
class UnderlineSyntax extends md.DelimiterSyntax {
  UnderlineSyntax()
    : super(
        r'\+{2,}',
        requiresDelimiterRun: true,
        allowIntraWord: true,
        startCharacter: 0x2b, // '+'
        tags: [md.DelimiterTag('u', 2)],
      );
}
