import 'package:echoes/screens/widgets/reorderable_note.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Drives a real drag gesture across the widget, because the bug this guards
/// against was invisible to everything else: the dragged card lifted, the
/// animation ran, and nothing happened on drop — the other cards were never
/// drop targets at all, so there was nowhere to land.
void main() {
  /// Three stacked cards; only [selectedIndex] can be picked up, mirroring
  /// the home screen where a long press selects before a drag can start.
  Widget harness({
    required int selectedIndex,
    required void Function(int from, int to) onMove,
    bool canReorder = true,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            for (var i = 0; i < 3; i++)
              ReorderableNote(
                index: i,
                canDrag: canReorder && i == selectedIndex,
                canReceive: canReorder,
                onMove: onMove,
                child: SizedBox(height: 100, width: 300, child: Text('card$i')),
              ),
          ],
        ),
      ),
    );
  }

  testWidgets('dropping the selected card onto another one reorders', (tester) async {
    final moves = <({int from, int to})>[];
    await tester.pumpWidget(
      harness(selectedIndex: 0, onMove: (from, to) => moves.add((from: from, to: to))),
    );

    // Pick card0 up and carry it over card2, then let go.
    final gesture = await tester.startGesture(tester.getCenter(find.text('card0')));
    await tester.pump(kLongPressTimeout);
    await gesture.moveTo(tester.getCenter(find.text('card2')));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(moves, [(from: 0, to: 2)]);
  });

  testWidgets('an unselected card is still a drop target', (tester) async {
    // The regression itself: with only the draggable card wired as a target,
    // this drop reported nothing at all.
    final moves = <({int from, int to})>[];
    await tester.pumpWidget(
      harness(selectedIndex: 1, onMove: (from, to) => moves.add((from: from, to: to))),
    );

    final gesture = await tester.startGesture(tester.getCenter(find.text('card1')));
    await tester.pump(kLongPressTimeout);
    await gesture.moveTo(tester.getCenter(find.text('card0')));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(moves, [(from: 1, to: 0)]);
  });

  testWidgets('a card is never dropped onto itself', (tester) async {
    final moves = <({int from, int to})>[];
    await tester.pumpWidget(
      harness(selectedIndex: 0, onMove: (from, to) => moves.add((from: from, to: to))),
    );

    final gesture = await tester.startGesture(tester.getCenter(find.text('card0')));
    await tester.pump(kLongPressTimeout);
    // Nudge, but stay on the same card.
    await gesture.moveBy(const Offset(0, 10));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(moves, isEmpty);
  });

  testWidgets('nothing is draggable while searching', (tester) async {
    final moves = <({int from, int to})>[];
    await tester.pumpWidget(
      harness(
        selectedIndex: 0,
        canReorder: false,
        onMove: (from, to) => moves.add((from: from, to: to)),
      ),
    );

    final gesture = await tester.startGesture(tester.getCenter(find.text('card0')));
    await tester.pump(kLongPressTimeout);
    await gesture.moveTo(tester.getCenter(find.text('card2')));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(moves, isEmpty);
  });
}
