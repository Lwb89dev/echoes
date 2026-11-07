import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../l10n/app_localizations.dart';

/// QR and actions for one `nostrconnect://` handshake. The URI is not drawn
/// as text: it contains the association secret, and the copy button is the
/// way to take it out of the widget.
class NostrConnectPanel extends StatelessWidget {
  const NostrConnectPanel({
    super.key,
    required this.uri,
    required this.waiting,
    required this.onCopy,
    required this.onCancel,
  });

  final String uri;
  final bool waiting;
  final VoidCallback onCopy;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Text(l.nostrConnectHint, style: theme.textTheme.bodySmall, textAlign: TextAlign.center),
        const SizedBox(height: 16),
        Center(
          child: Semantics(
            label: l.nostrConnectButton,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: QrImageView(
                  data: uri,
                  size: 220,
                  backgroundColor: Colors.white,
                  eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: Colors.black),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (waiting)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              l.nostrConnectWaiting,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        OutlinedButton.icon(
          onPressed: onCopy,
          icon: const Icon(Icons.copy),
          label: Text(l.copyNostrConnectButton),
          style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: onCancel,
          style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
          child: Text(l.cancelNostrConnectButton),
        ),
      ],
    );
  }
}
