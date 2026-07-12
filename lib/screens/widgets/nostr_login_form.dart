import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';

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
  bool _showImportField = false;

  @override
  void dispose() {
    _importController.dispose();
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
        FilledButton.icon(
          onPressed: isLoading ? null : _loginWithAmber,
          icon: const Icon(Icons.shield_outlined),
          label: Text(l.loginWithAmberButton),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: isLoading
              ? null
              : () => setState(() => _showImportField = !_showImportField),
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
          FilledButton(
            onPressed: isLoading ? null : _importAccount,
            child: Text(l.importButton),
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
