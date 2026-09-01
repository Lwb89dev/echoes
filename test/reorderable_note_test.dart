import 'package:echoes/screens/widgets/reorderable_note.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Moves [gesture] to [target] in several small steps rather than one big
/// jump. A real finger generates a stream of small pointer-move deltas; a
/// single huge synthetic jump doesn't reliably drive `Draggable`'s
/// `onDragUpdate` the same way (confirmed while writing the auto-scroll
/// tests below — the single-jump form left `onDragUpdate` never firing for
/// the destination at all), so anything that depends on drag *position*
/// rather than just where it finally lands should move like this.
Future<void> _dragTo(WidgetTester tester, TestGesture gesture, Offset from, Offset to) async {
  const steps = 20;
  final stepDelta = (to - from) / steps.toDouble();
  var current = from;
  for (var i = 0; i < steps; i++) {
    current = current + stepDelta;
    await gesture.moveTo(current);
    await tester.pump(const Duration(milliseconds: 8));
  }
}

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

  testWidgets('dragging near an edge auto-scrolls the list', (tester) async {
    // The reported bug: on a long list, dragging a selected note towards the
    // bottom of the screen to reorder it never actually got there — nothing
    // scrolled the list to catch up with the drag.
    final controller = ScrollController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 600,
            child: ListView.builder(
              controller: controller,
              itemCount: 30,
              itemBuilder: (context, i) => ReorderableNote(
                index: i,
                canDrag: i == 0,
                canReceive: true,
                onMove: (_, _) {},
                child: SizedBox(height: 100, width: 300, child: Text('row$i')),
              ),
            ),
          ),
        ),
      ),
    );
    expect(controller.position.pixels, 0);

    // The actual on-screen bounds of the list, rather than an assumed
    // absolute position — this only needs to hold for *this* layout, not for
    // whatever size `flutter_test`'s default surface happens to be.
    final listBounds = tester.getRect(find.byType(ListView));
    final start = tester.getCenter(find.text('row0'));
    final target = Offset(listBounds.center.dx, listBounds.bottom - 10);

    final gesture = await tester.startGesture(start);
    await tester.pump(kLongPressTimeout);
    // Move into, and hold within, the hot zone near the bottom edge.
    await _dragTo(tester, gesture, start, target);
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }

    expect(controller.position.pixels, greaterThan(0));

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('auto-scroll stops once the drag ends', (tester) async {
    final controller = ScrollController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 600,
            child: ListView.builder(
              controller: controller,
              itemCount: 30,
              itemBuilder: (context, i) => ReorderableNote(
                index: i,
                canDrag: i == 0,
                canReceive: true,
                onMove: (_, _) {},
                child: SizedBox(height: 100, width: 300, child: Text('row$i')),
              ),
            ),
          ),
        ),
      ),
    );

    final listBounds = tester.getRect(find.byType(ListView));
    final start = tester.getCenter(find.text('row0'));
    final target = Offset(listBounds.center.dx, listBounds.bottom - 10);

    final gesture = await tester.startGesture(start);
    await tester.pump(kLongPressTimeout);
    await _dragTo(tester, gesture, start, target);
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    await gesture.up();
    await tester.pumpAndSettle();

    final afterRelease = controller.position.pixels;
    // If the timer were still running, a further pump would keep scrolling.
    await tester.pump(const Duration(milliseconds: 200));
    expect(controller.position.pixels, afterRelease);
  });
}
