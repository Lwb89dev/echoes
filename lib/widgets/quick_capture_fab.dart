import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../providers/fab_menu_provider.dart';
import '../theme/echoes_theme.dart';
import '../utils/platform_support.dart';
import '../screens/note_editor_screen.dart';

/// The desk's capture button.
///
/// A tap opens a short fan — note, checklist, photo, and voice where the
/// device can play a recording back. A long press writes a plain note
/// immediately, so the common case stays one gesture. Only actions the
/// editor already supports are offered.
class QuickCaptureFab extends ConsumerStatefulWidget {
  const QuickCaptureFab({super.key});

  @override
  ConsumerState<QuickCaptureFab> createState() => _QuickCaptureFabState();
}

class _CaptureOption {
  const _CaptureOption({
    required this.heroTag,
    required this.label,
    required this.icon,
    required this.screen,
  });

  final String heroTag;
  final String label;
  final IconData icon;
  final Widget screen;
}

class _QuickCaptureFabState extends ConsumerState<QuickCaptureFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
  );
  Timer? _hold;
  var _held = false;

  late final List<Animation<double>> _steps = List.generate(4, (order) {
    final start = order * 0.08;
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(start, (start + 0.72).clamp(0, 1), curve: Curves.easeOutBack),
      reverseCurve: Interval(start, (start + 0.72).clamp(0, 1), curve: Curves.easeInCubic),
    );
  });

  @override
  void dispose() {
    _hold?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _holdStart(PointerDownEvent event) {
    _hold?.cancel();
    _held = false;
    _hold = Timer(const Duration(milliseconds: 450), () {
      if (!mounted || ref.read(fabMenuProvider)) return;
      _held = true;
      _open(const NoteEditorScreen());
    });
  }

  void _holdEnd(PointerEvent event) => _hold?.cancel();

  void _open(Widget screen) {
    ref.read(fabMenuProvider.notifier).close();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  List<_CaptureOption> _options(AppLocalizations l) {
    return [
      _CaptureOption(
        heroTag: 'fab_note',
        label: l.newPlainNoteOption,
        icon: Icons.edit_outlined,
        screen: const NoteEditorScreen(),
      ),
      _CaptureOption(
        heroTag: 'fab_checklist',
        label: l.newChecklistOption,
        icon: Icons.checklist_rounded,
        screen: const NoteEditorScreen(startAsChecklist: true),
      ),
      _CaptureOption(
        heroTag: 'fab_photo',
        label: l.newPhotoOption,
        icon: Icons.image_outlined,
        screen: const NoteEditorScreen(startWithImage: true),
      ),
      if (PlatformSupport.supportsVoiceNotes)
        _CaptureOption(
          heroTag: 'fab_voice',
          label: l.newVoiceNoteOption,
          icon: Icons.mic_none_outlined,
          screen: const NoteEditorScreen(startRecording: true),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final open = ref.watch(fabMenuProvider);
    ref.listen<bool>(fabMenuProvider, (previous, next) {
      if (next) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    final options = _options(l);
    // Voice is the furthest; the list above is near-to-far, so paint far first.
    final painted = options.reversed.toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < painted.length; i++)
          _FanOption(
            animation: _steps[painted.length - 1 - i],
            option: painted[i],
            onTap: () => _open(painted[i].screen),
          ),
        Semantics(
          button: true,
          label: l.newNoteSemantics,
          child: Listener(
            onPointerDown: _holdStart,
            onPointerUp: _holdEnd,
            onPointerCancel: _holdEnd,
            child: FloatingActionButton(
              heroTag: 'fab_main',
              onPressed: () {
                if (_held) {
                  _held = false;
                  return;
                }
                ref.read(fabMenuProvider.notifier).toggle();
              },
              child: AnimatedRotation(
                turns: open ? 0.125 : 0,
                duration: EchoesTokens.standardMotion,
                curve: Curves.easeOutBack,
                child: const Icon(Icons.add, size: 32),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FanOption extends StatelessWidget {
  const _FanOption({required this.animation, required this.option, required this.onTap});

  final Animation<double> animation;
  final _CaptureOption option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = EchoesPalette.of(context);
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final t = animation.value.clamp(0.0, 1.0);
        return IgnorePointer(
          ignoring: t < 0.4,
          child: Align(
            alignment: Alignment.centerRight,
            heightFactor: t,
            widthFactor: 1,
            child: Opacity(
              opacity: t,
              child: Transform.translate(offset: Offset(0, (1 - t) * 12), child: child),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GlassPane(
              radius: EchoesTokens.radiusSm,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text(
                option.label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: palette.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 10),
            // The small button is 40px and the main one is 56. An 8px inset
            // puts their centers on the same vertical line.
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FloatingActionButton.small(
                heroTag: option.heroTag,
                onPressed: onTap,
                child: Icon(option.icon),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Diary capture stays a single action: an entry is just a note dated to a day.
class DiaryCaptureFab extends StatelessWidget {
  const DiaryCaptureFab({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return FloatingActionButton(
      heroTag: 'fab_diary',
      tooltip: l.diaryTabLabel,
      onPressed: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const NoteEditorScreen(isDiaryEntry: true))),
      child: const Icon(Icons.add),
    );
  }
}
