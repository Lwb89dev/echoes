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
    required this.enabled,
    required this.onMove,
    required this.child,
  });

  /// This card's position in the currently displayed list.
  final int index;

  /// True only for a selected card outside of search: dragging a filtered
  /// subset would write back an arrangement covering notes the user can't
  /// currently see.
  final bool enabled;

  /// Called with the dragged card's index and the index it was dropped on.
  final void Function(int from, int to) onMove;

  final Widget child;

  @override
  State<ReorderableNote> createState() => _ReorderableNoteState();
}

class _ReorderableNoteState extends State<ReorderableNote> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return DragTarget<int>(
      // Never accept a card onto itself: it would be a no-op move that still
      // repaints and rewrites the saved order.
      onWillAcceptWithDetails: (details) {
        final accepts = details.data != widget.index;
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
            // The card's on-screen width has to be measured here, where it is
            // actually laid out: a `feedback` widget is given unbounded
            // constraints, so without pinning it the card would balloon to its
            // intrinsic width the instant it's picked up.
            // A plain Draggable, not a LongPressDraggable: the long press
            // already happened — it is what selected this card and enabled
            // dragging in the first place. Asking for a second one would make
            // reordering a press-wait-press-wait affair.
            child: LayoutBuilder(
              builder: (context, constraints) => Draggable<int>(
                data: widget.index,
                // Lifted copy that follows the finger: scaled up a touch and
                // given a real shadow, so it reads as picked up rather than
                // smeared across the list.
                feedback: _LiftedCard(width: constraints.maxWidth, child: widget.child),
                childWhenDragging: Opacity(opacity: 0.25, child: widget.child),
                child: widget.child,
              ),
            ),
          ),
        );
      },
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
