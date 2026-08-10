import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../utils/constants.dart';
import '../widgets/brand_mark.dart';
import 'home_screen.dart';
import 'widgets/nostr_login_form.dart';

/// Standalone login screen. Reached from Settings' "Sign in with Nostr"
/// entry when the user is in local-only mode and wants to add a Nostr
/// account later — the first-launch flow itself goes through
/// [OnboardingScreen], which embeds the same [NostrLoginForm] with a
/// skip option instead.
///
/// Echoes does not create new accounts (it isn't meant to onboard new users
/// to Nostr): the user either imports the private key of an existing
/// account, or logs in via Amber (NIP-55 external signer, Android only),
/// which avoids sharing the private key with the app at all.
///
/// TODO: for people who don't have a Nostr account yet, this should
/// eventually point to a full client like Amethyst to create one.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const BrandMark(size: 128),
                const SizedBox(height: 20),
                Text(AppConstants.appName, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text(
                  l.loginSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                NostrLoginForm(
                  onLoggedIn: () {
                    Navigator.of(
                      context,
                    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
