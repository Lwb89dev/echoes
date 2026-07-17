import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../providers/onboarding_provider.dart';
import '../providers/relay_provider.dart';
import '../utils/platform_support.dart';
import '../utils/responsive.dart';
import 'widgets/nostr_login_form.dart';
import 'widgets/relay_widgets.dart';

/// First-launch, three-step carousel:
///  1. [_IntroPage] — explains local storage, optional Nostr sync,
///     end-to-end encryption, and Amber login.
///  2. [_LoginPage] — sign in with Nostr (Amber or an imported key), or
///     skip to a local-only session.
///  3. [_RelaySetupPage] — pick relays to sync through.
///
/// Shown exactly once: [OnboardingNotifier] persists completion so
/// `_AppRoot` (see main.dart) routes straight to [HomeScreen] afterwards,
/// whether or not the user ended up signed in.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const _pageCount = 3;

  final _pageController = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finish() async {
    await ref.read(onboardingProvider.notifier).complete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _page = page),
                children: [
                  const _IntroPage(),
                  _LoginPage(onAdvance: () => _goToPage(2)),
                  const _RelaySetupPage(),
                ],
              ),
            ),
            _OnboardingBottomBar(
              page: _page,
              pageCount: _pageCount,
              onBack: () => _goToPage(_page - 1),
              onNext: () => _goToPage(_page + 1),
              // Skipping login means there's no Nostr account to sync with,
              // so relay setup (page 3) would be meaningless — go straight
              // to finishing onboarding instead of just advancing a page.
              // Relays can still be configured later from Settings.
              onSkip: _finish,
              onFinish: _finish,
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingBottomBar extends StatelessWidget {
  const _OnboardingBottomBar({
    required this.page,
    required this.pageCount,
    required this.onBack,
    required this.onNext,
    required this.onSkip,
    required this.onFinish,
  });

  final int page;
  final int pageCount;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isFirst = page == 0;
    final isLast = page == pageCount - 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 16),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: isFirst
                ? null
                : TextButton(
                    onPressed: onBack,
                    child: Text(l.onboardingBackButton),
                  ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pageCount,
                (i) => _Dot(active: i == page),
              ),
            ),
          ),
          if (isLast)
            FilledButton(
              onPressed: onFinish,
              child: Text(l.onboardingFinishButton),
            )
          else if (page == 1)
            TextButton(onPressed: onSkip, child: Text(l.onboardingSkipButton))
          else
            FilledButton(
              onPressed: onNext,
              child: Text(l.onboardingNextButton),
            ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: active ? 20 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: active
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

// ── Page 1: how Echoes works ────────────────────────────────────────────

class _IntroPage extends StatelessWidget {
  const _IntroPage();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: MaxWidthCenter(
        maxWidth: 560,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.graphic_eq,
              size: 56,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              l.onboardingWelcomeTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            _FeatureRow(
              icon: Icons.smartphone,
              title: l.onboardingIntroLocalTitle,
              body: l.onboardingIntroLocalBody,
            ),
            _FeatureRow(
              icon: Icons.sync,
              title: l.onboardingIntroSyncTitle,
              body: l.onboardingIntroSyncBody,
            ),
            _FeatureRow(
              icon: Icons.lock_outline,
              title: l.onboardingIntroEncryptionTitle,
              body: l.onboardingIntroEncryptionBody,
            ),
            // Amber (NIP-55) is Android-only — see [PlatformSupport.supportsAmber].
            if (PlatformSupport.supportsAmber)
              _FeatureRow(
                icon: Icons.shield_outlined,
                title: l.onboardingIntroAmberTitle,
                body: l.onboardingIntroAmberBody,
              ),
            _FeatureRow(
              icon: Icons.security,
              title: l.onboardingIntroSecurityTitle,
              body: l.onboardingIntroSecurityBody,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(body, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Page 2: sign in or skip ─────────────────────────────────────────────

class _LoginPage extends StatelessWidget {
  const _LoginPage({required this.onAdvance});

  final VoidCallback onAdvance;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: MaxWidthCenter(
        maxWidth: 480,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.key,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              l.loginSubtitle,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            NostrLoginForm(onLoggedIn: onAdvance),
          ],
        ),
      ),
    );
  }
}

// ── Page 3: relay setup ─────────────────────────────────────────────────

class _RelaySetupPage extends ConsumerWidget {
  const _RelaySetupPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final relaysState = ref.watch(relayProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: MaxWidthCenter(
        maxWidth: 560,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.dns_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              l.onboardingRelayTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              l.onboardingRelayBody,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            const RelayUrlInput(),
            const SizedBox(height: 8),
            const SuggestedRelayList(),
            const SizedBox(height: 8),
            relaysState.when(
              data: (relays) => relays.isEmpty
                  ? const SizedBox.shrink()
                  : RelayListView(relays: relays, shrinkWrap: true),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  Text(l.genericErrorPrefix(error.toString())),
            ),
          ],
        ),
      ),
    );
  }
}
