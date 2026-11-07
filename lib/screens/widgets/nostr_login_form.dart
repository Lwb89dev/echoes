import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../../models/relay.dart';
import '../../providers/auth_provider.dart';
import '../../providers/relay_provider.dart';
import '../../services/credential_store.dart';
import '../../services/nip46_client.dart';
import '../../utils/network_url.dart';
import '../../utils/platform_support.dart';
import 'nostr_connect_panel.dart';

/// The Amber / NIP-46 / import-nsec login controls, shared by [LoginScreen]
/// and the onboarding carousel's login step. Calls [onLoggedIn] once
/// [authProvider] resolves to a non-null user right after a login attempt.
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
  Nip46ConnectOffer? _offer;
  Nip46LoginAttempt? _attempt;

  @override
  void dispose() {
    _importController.dispose();
    _bunkerController.dispose();
    final attempt = _attempt;
    _attempt = null;
    attempt?.cancel();
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

  List<String> _connectRelays() {
    final configured = ref.read(relayProvider).value;
    final urls = configured?.map((relay) => relay.url).where((url) => url.isNotEmpty).toList();
    if (urls != null && urls.isNotEmpty) return urls;
    return defaultRelayUrls;
  }

  Future<void> _startNostrConnect() async {
    final offer = Nip46ConnectOffer.generate(relays: _connectRelays());
    final attempt = Nip46LoginAttempt();
    setState(() {
      _offer = offer;
      _attempt = attempt;
    });
    await ref.read(authProvider.notifier).loginWithNostrConnect(offer, attempt: attempt);
    if (!mounted) return;
    _notifyIfLoggedIn();
  }

  Future<void> _cancelNostrConnect() async {
    final attempt = _attempt;
    _attempt = null;
    setState(() => _offer = null);
    await attempt?.cancel();
    if (mounted) setState(() {});
  }

  Future<void> _copyNostrConnect() async {
    final uri = _offer?.uri;
    if (uri == null) return;
    await Clipboard.setData(ClipboardData(text: uri));
    if (!mounted) return;
    final l = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.nostrConnectCopied)));
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

  String _errorText(AppLocalizations l, Object error) {
    if (error is InvalidPrivateKeyException) return l.invalidPrivateKeyError;
    if (error is SecretStorageException) return l.secretStorageUnavailable;
    return l.genericErrorPrefix(error.toString());
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;
    final offer = _offer;
    final buttonSize = const Size(48, 48);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (authState.hasError)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              _errorText(l, authState.error!),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
              textAlign: TextAlign.center,
            ),
          ),
        if (PlatformSupport.supportsAmber) ...[
          FilledButton.icon(
            onPressed: isLoading ? null : _loginWithAmber,
            icon: const Icon(Icons.shield_outlined),
            label: Text(l.loginWithAmberButton),
            style: FilledButton.styleFrom(minimumSize: buttonSize),
          ),
          const SizedBox(height: 12),
        ],
        FilledButton.icon(
          onPressed: isLoading ? null : _startNostrConnect,
          icon: const Icon(Icons.qr_code_2),
          label: Text(l.nostrConnectButton),
          style: FilledButton.styleFrom(minimumSize: buttonSize),
        ),
        if (offer != null)
          NostrConnectPanel(
            uri: offer.uri,
            waiting: isLoading,
            onCopy: _copyNostrConnect,
            onCancel: _cancelNostrConnect,
          ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: isLoading ? null : () => setState(() => _showBunkerField = !_showBunkerField),
          icon: const Icon(Icons.hub_outlined),
          label: Text(l.bunkerLoginButton),
          style: OutlinedButton.styleFrom(minimumSize: buttonSize),
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
            style: FilledButton.styleFrom(minimumSize: buttonSize),
            child: Text(l.bunkerConnectButton),
          ),
        ],
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: isLoading ? null : () => setState(() => _showImportField = !_showImportField),
          icon: const Icon(Icons.key),
          label: Text(l.importAccountButton),
          style: OutlinedButton.styleFrom(minimumSize: buttonSize),
        ),
        if (_showImportField) ...[
          const SizedBox(height: 16),
          TextField(
            controller: _importController,
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            decoration: InputDecoration(
              labelText: l.importAccountFieldLabel,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: isLoading ? null : _importAccount,
            style: FilledButton.styleFrom(minimumSize: buttonSize),
            child: Text(l.importButton),
          ),
        ],
        if (isLoading && offer == null) ...[
          const SizedBox(height: 24),
          const Center(child: CircularProgressIndicator()),
        ],
      ],
    );
  }
}
