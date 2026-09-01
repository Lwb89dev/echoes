import 'dart:async';

import 'package:flutter/material.dart';

/// Wraps a note card so a **selected** note can be dragged onto another card
/// to take its place.
///
/// The gesture is long-press-then-drag, in two steps: the long press selects
/// the note (the app's existing gesture, which also lights the card up), and
/// dragging that now-selected card reorders it. Making the long press itself
/// start the drag would have taken multi-select — delete/export several
/// notes — away from the only gesture that offers it; this way both live on
/// the same familiar press, the same way Keep handles it.
///
/// Used by both home layouts. A `ReorderableListView` would cover the single
/// column but has no answer for the masonry grid, where tiles differ in
/// height and there are no rows to slide between; dragging onto a target is
/// the one interaction that reads the same in either layout, so both share
/// this instead of each growing its own.
class ReorderableNote extends StatefulWidget {
  const ReorderableNote({
    super.key,
    required this.index,
    required this.canDrag,
    required this.canReceive,
    required this.onMove,
    required this.child,
  });

  /// This card's position in the currently displayed list.
  final int index;

  /// Whether this card can be **picked up**. True only for a selected card
  /// outside of search: dragging a filtered subset would write back an
  /// arrangement covering notes the user can't currently see.
  final bool canDrag;

  /// Whether this card can be **dropped onto**. Deliberately independent of
  /// [canDrag] and true for every card while reordering is possible: only the
  /// selected note can be lifted, but it has to be able to land on any of the
  /// others. Tying the two together left the lifted card with nowhere to go —
  /// the drag started and then silently did nothing.
  final bool canReceive;

  /// Called with the dragged card's index and the index it was dropped on.
  final void Function(int from, int to) onMove;

  final Widget child;

  @override
  State<ReorderableNote> createState() => _ReorderableNoteState();
}

class _ReorderableNoteState extends State<ReorderableNote> {
  bool _hovered = false;

  // Auto-scroll while dragging near the top/bottom edge of the enclosing
  // list/grid. `Draggable` moves its feedback widget on an `Overlay`, fully
  // independent of the scroll view underneath — Flutter does not scroll a
  // list for you just because a drag is hovering at its edge, so without
  // this a card being reordered towards the top or bottom of a long list
  // could never actually get there: the drag simply stalls at the edge,
  // going nowhere, which reads as the screen having frozen.
  Timer? _autoScrollTimer;
  double _autoScrollDelta = 0;
  // Re-read every tick rather than closed over once: the timer can outlive
  // the `Scrollable` it started against (e.g. the home screen's list/grid
  // layout toggle swapping the ancestor mid-drag), and ticking against a
  // stale, detached one would throw.
  ScrollableState? _activeScrollable;

  static const _hotZoneExtent = 80.0;
  static const _maxScrollSpeed = 18.0; // px per tick, at the very edge
  static const _tickInterval = Duration(milliseconds: 16); // ~60fps

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  /// Called on every pointer move while this card is being dragged. Finds
  /// the nearest scrollable ancestor (the note list or grid itself) and
  /// starts, adjusts, or stops auto-scrolling based on how close the finger
  /// is to its top/bottom edge.
  void _handleDragUpdate(DragUpdateDetails details) {
    final scrollable = Scrollable.maybeOf(context);
    final scrollBox = scrollable?.context.findRenderObject() as RenderBox?;
    if (scrollable == null || scrollBox == null || !scrollBox.attached) {
      _stopAutoScroll();
      return;
    }

    final local = scrollBox.globalToLocal(details.globalPosition);
    final height = scrollBox.size.height;
    final fromTop = local.dy;
    final fromBottom = height - local.dy;

    double delta = 0;
    if (fromTop >= 0 && fromTop < _hotZoneExtent) {
      // Deeper into the hot zone -> faster, up to the cap at the very edge.
      delta = -_maxScrollSpeed * (1 - fromTop / _hotZoneExtent);
    } else if (fromBottom >= 0 && fromBottom < _hotZoneExtent) {
      delta = _maxScrollSpeed * (1 - fromBottom / _hotZoneExtent);
    }

    if (delta == 0) {
      _stopAutoScroll();
      return;
    }
    _autoScrollDelta = delta;
    _activeScrollable = scrollable;
    _autoScrollTimer ??= Timer.periodic(_tickInterval, (_) => _tickAutoScroll());
  }

  void _tickAutoScroll() {
    final scrollable = _activeScrollable;
    if (scrollable == null || !scrollable.context.mounted) {
      _stopAutoScroll();
      return;
    }
    final position = scrollable.position;
    final next = (position.pixels + _autoScrollDelta).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    if (next != position.pixels) position.jumpTo(next);
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
    _activeScrollable = null;
  }

  @override
  Widget build(BuildContext context) {
    // Nothing to do at all: not liftable and not a landing spot.
    if (!widget.canDrag && !widget.canReceive) return widget.child;

    return DragTarget<int>(
      // Never accept a card onto itself: it would be a no-op move that still
      // repaints and rewrites the saved order.
      onWillAcceptWithDetails: (details) {
        final accepts = widget.canReceive && details.data != widget.index;
        if (accepts && !_hovered) setState(() => _hovered = true);
        return accepts;
      },
      onLeave: (_) => setState(() => _hovered = false),
      onAcceptWithDetails: (details) {
        setState(() => _hovered = false);
        widget.onMove(details.data, widget.index);
      },
      builder: (context, candidate, rejected) {
        // The drop target eases aside slightly as a card hovers over it, so
        // it's obvious *where* the card is about to land rather than only
        // that something is being dragged.
        return AnimatedScale(
          scale: _hovered ? 0.96 : 1,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _hovered ? Theme.of(context).colorScheme.primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: _draggableOrPlain(),
          ),
        );
      },
    );
  }

  /// The card itself: liftable when this is the selected note, otherwise the
  /// plain card — which is still wrapped by the [DragTarget] above, so it can
  /// receive whatever is being dragged.
  Widget _draggableOrPlain() {
    if (!widget.canDrag) return widget.child;
    // A plain Draggable, not a LongPressDraggable: the long press already
    // happened — it is what selected this card and enabled dragging in the
    // first place. Asking for a second one would make reordering a
    // press-wait-press-wait affair.
    //
    // The card's on-screen width has to be measured here, where it is actually
    // laid out: a `feedback` widget is given unbounded constraints, so without
    // pinning it the card would balloon to its intrinsic width the instant
    // it's picked up.
    return LayoutBuilder(
      builder: (context, constraints) => Draggable<int>(
        data: widget.index,
        // Lifted copy that follows the finger: scaled up a touch and given a
        // real shadow, so it reads as picked up rather than smeared across
        // the list.
        feedback: _LiftedCard(width: constraints.maxWidth, child: widget.child),
        childWhenDragging: Opacity(opacity: 0.25, child: widget.child),
        onDragUpdate: _handleDragUpdate,
        onDragEnd: (_) => _stopAutoScroll(),
        onDraggableCanceled: (_, _) => _stopAutoScroll(),
        child: widget.child,
      ),
    );
  }
}

/// The card as it looks while being dragged: same width it occupied in the
/// list (see the [LayoutBuilder] that measures it), lifted with a shadow and
/// a slight scale-up.
class _LiftedCard extends StatelessWidget {
  const _LiftedCard({required this.width, required this.child});

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 8,
      borderRadius: BorderRadius.circular(16),
      shadowColor: Colors.black54,
      child: Transform.scale(
        scale: 1.04,
        child: SizedBox(width: width, child: child),
      ),
    );
  }
}
