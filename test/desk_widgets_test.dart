import 'package:echoes/l10n/app_localizations.dart';
import 'package:echoes/models/attachment.dart';
import 'package:echoes/models/note.dart';
import 'package:echoes/utils/responsive.dart';
import 'package:echoes/widgets/diary_timeline.dart';
import 'package:echoes/widgets/note_card.dart';
import 'package:echoes/widgets/quick_capture_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Note _note() {
  return Note(
    id: 'n1',
    title: 'Project Kitchen',
    body: 'A thought about the desk.',
    isChecklist: true,
    items: const [
      ChecklistItem(text: 'Sage'),
      ChecklistItem(text: 'Paper', done: true),
    ],
    attachments: const [
      Attachment(
        id: 'voice',
        type: AttachmentType.audio,
        mimeType: 'audio/mp4',
        durationSeconds: 37,
      ),
    ],
    createdAt: DateTime(2026, 9, 28, 9),
    updatedAt: DateTime(2026, 9, 28, 9),
    isDiaryEntry: true,
    entryDate: DateTime(2026, 9, 28),
  );
}

Widget _app(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('a note card lays out checklist and voice without throwing', (tester) async {
    await tester.pumpWidget(
      _app(
        NoteCard(
          note: _note(),
          selected: false,
          selectionMode: false,
          pinned: true,
          archived: false,
          onTap: () {},
          onLongPress: () {},
          onTogglePin: () {},
          onToggleArchive: () {},
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('Project Kitchen'), findsOneWidget);
    expect(find.text('Sage'), findsOneWidget);
    expect(find.text('Paper'), findsNothing);
    expect(find.text('0:37'), findsOneWidget);

    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      _app(
        NoteCard(
          note: _note(),
          selected: false,
          selectionMode: false,
          pinned: true,
          archived: false,
          onTap: () {},
          onLongPress: () {},
          onTogglePin: () {},
          onToggleArchive: () {},
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('the capture fan opens on a narrow phone width', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(floatingActionButton: QuickCaptureFab()),
        ),
      ),
    );
    await tester.tap(find.byType(FloatingActionButton).last);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Checklist'), findsOneWidget);
    expect(find.text('Photo'), findsOneWidget);
  });

  testWidgets('the diary timeline lays out inside a max-width column', (tester) async {
    await tester.pumpWidget(
      _app(
        MaxWidthCenter(
          child: DiaryTimeline(
            notes: [_note()],
            selectedIds: const {},
            selectionMode: false,
            pinnedIds: const {},
            archivedIds: const {},
            onOpen: (_) {},
            onLongPress: (_) {},
            onTogglePin: (_) {},
            onToggleArchive: (_) {},
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('28'), findsOneWidget);
    expect(find.text('Project Kitchen'), findsOneWidget);
  });
}
