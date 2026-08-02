import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../utils/network_url.dart';
import '../../utils/platform_support.dart';

/// The Amber / import-nsec login controls, shared by [LoginScreen] and the
/// onboarding carousel's login step. Calls [onLoggedIn] once [authProvider]
/// resolves to a non-null user right after a login attempt — the two call
/// sites decide what "logged in" means for them (push to [HomeScreen],
/// advance to the next onboarding page, pop a dialog, ...).
class NostrLoginForm extends ConsumerStatefulWidget {
  const NostrLoginForm({super.key, required this.onLoggedIn});

  final VoidCallback onLoggedIn;

  @override
  ConsumerState<NostrLoginForm> createState() => _NostrLoginFormState();
}

class _NostrLoginFormState extends ConsumerState<NostrLoginForm> {
  final _importController = TextEditingController();
  final _bunkerController = TextEditingController();
  bool _showImportField = false;
  bool _showBunkerField = false;

  @override
  void dispose() {
    _importController.dispose();
    _bunkerController.dispose();
    super.dispose();
  }

  Future<void> _loginWithAmber() async {
    await ref.read(authProvider.notifier).loginWithAmber();
    _notifyIfLoggedIn();
  }

  Future<void> _importAccount() async {
    final privateKey = _importController.text.trim();
    if (privateKey.isEmpty) return;
    await ref.read(authProvider.notifier).importAccount(privateKey);
    _notifyIfLoggedIn();
  }

  Future<void> _loginWithBunker() async {
    final token = _bunkerController.text.trim();
    if (token.isEmpty) return;
    await ref
        .read(authProvider.notifier)
        .loginWithBunker(token, onAuthChallenge: _openAuthChallenge);
    _notifyIfLoggedIn();
  }

  /// The signer asked the user to approve the connection out of band: open the
  /// URL it handed us and tell the user to approve there. The connect call is
  /// still waiting, so the real result lands once they do.
  Future<void> _openAuthChallenge(String authUrl) async {
    final l = AppLocalizations.of(context);
    final uri = tryParseHttpsUri(authUrl);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.bunkerAuthPrompt)));
    }
  }

  void _notifyIfLoggedIn() {
    if (ref.read(authProvider).value != null) widget.onLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (authState.hasError)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              // Never interpolate the raw error for a bad private key: it
              // can embed the key the user just typed (see
              // [InvalidPrivateKeyException]). Only non-key errors (e.g.
              // Amber failures) get the detailed message.
              authState.error is InvalidPrivateKeyException
                  ? l.invalidPrivateKeyError
                  : l.genericErrorPrefix(authState.error.toString()),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
              textAlign: TextAlign.center,
            ),
          ),
        // Amber (NIP-55) is Android-only — see [PlatformSupport.supportsAmber].
        if (PlatformSupport.supportsAmber) ...[
          FilledButton.icon(
            onPressed: isLoading ? null : _loginWithAmber,
            icon: const Icon(Icons.shield_outlined),
            label: Text(l.loginWithAmberButton),
          ),
          const SizedBox(height: 12),
        ],
        OutlinedButton.icon(
          onPressed: isLoading ? null : () => setState(() => _showImportField = !_showImportField),
          icon: const Icon(Icons.key),
          label: Text(l.importAccountButton),
        ),
        if (_showImportField) ...[
          const SizedBox(height: 16),
          TextField(
            controller: _importController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: l.importAccountFieldLabel,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(onPressed: isLoading ? null : _importAccount, child: Text(l.importButton)),
        ],
        const SizedBox(height: 12),
        // Remote signer (NIP-46 "bunker") — every platform, unlike Amber.
        // The private key stays in the signer; the app only ever holds an
        // ephemeral connection key.
        OutlinedButton.icon(
          onPressed: isLoading ? null : () => setState(() => _showBunkerField = !_showBunkerField),
          icon: const Icon(Icons.hub_outlined),
          label: Text(l.bunkerLoginButton),
        ),
        if (_showBunkerField) ...[
          const SizedBox(height: 16),
          TextField(
            controller: _bunkerController,
            autocorrect: false,
            enableSuggestions: false,
            decoration: InputDecoration(
              labelText: l.bunkerFieldLabel,
              hintText: 'bunker://…',
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => _loginWithBunker(),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: isLoading ? null : _loginWithBunker,
            child: Text(l.bunkerConnectButton),
          ),
        ],
        if (isLoading) ...[
          const SizedBox(height: 24),
          const Center(child: CircularProgressIndicator()),
        ],
      ],
    );
  }
}
