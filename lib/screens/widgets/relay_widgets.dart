import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../models/relay.dart';
import '../../providers/relay_provider.dart';
import '../../providers/relay_status_provider.dart';

/// A text field + "add" button for entering a custom relay URL. Shared by
/// Settings' relay section and the relay-setup step of [OnboardingScreen].
class RelayUrlInput extends ConsumerStatefulWidget {
  const RelayUrlInput({super.key});

  @override
  ConsumerState<RelayUrlInput> createState() => _RelayUrlInputState();
}

class _RelayUrlInputState extends ConsumerState<RelayUrlInput> {
  final _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _addRelay() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;
    await ref.read(relayProvider.notifier).addRelay(url);
    _urlController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _urlController,
            decoration: InputDecoration(
              labelText: l.relayUrlHint,
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => _addRelay(),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filled(
          icon: const Icon(Icons.add),
          onPressed: _addRelay,
        ),
      ],
    );
  }
}

/// A row of well-known, commonly-used relays with a one-tap "add" button
/// each — shown to the checkmark icon once already in the user's relay
/// list. Shown during onboarding to make relay setup fast for newcomers who
/// don't have a preferred relay list yet.
class SuggestedRelayList extends ConsumerWidget {
  const SuggestedRelayList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUrls = ref.watch(relayProvider).value?.map((r) => r.url).toSet() ?? const <String>{};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final url in defaultRelayUrls)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.dns_outlined),
            title: Text(url),
            trailing: currentUrls.contains(url)
                ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
                : IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => ref.read(relayProvider.notifier).addRelay(url),
                  ),
          ),
      ],
    );
  }
}

/// The current relay list, with a per-relay online/offline status dot and a
/// remove button. Shared by Settings' relay section and the relay-setup
/// step of [OnboardingScreen].
class RelayListView extends ConsumerWidget {
  const RelayListView({super.key, required this.relays, this.shrinkWrap = false});

  final List<Relay> relays;

  /// Set to true when embedded inside another scrollable (e.g. the
  /// onboarding carousel page), so this list sizes itself to its content
  /// instead of trying to scroll independently.
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);

    if (relays.isEmpty) {
      return Center(child: Text(l.noRelaysMessage));
    }

    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      itemCount: relays.length,
      itemBuilder: (context, index) {
        final relay = relays[index];
        // Only actually pings once this tile is mounted — see
        // [relayStatusProvider]'s doc comment for why that's safe to do
        // unconditionally here rather than gating it again locally.
        final status = ref.watch(relayStatusProvider(relay.url));
        return ListTile(
          leading: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.dns_outlined),
              Positioned(right: -3, bottom: -3, child: _RelayStatusDot(status: status)),
            ],
          ),
          title: Text(relay.url),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => ref.read(relayProvider.notifier).removeRelay(relay.url),
          ),
        );
      },
    );
  }
}

/// Green when the relay accepted a websocket connection, red when it
/// didn't (or the attempt errored), a neutral grey while the check is
/// still in flight — see [relayStatusProvider].
class _RelayStatusDot extends StatelessWidget {
  const _RelayStatusDot({required this.status});

  final AsyncValue<bool> status;

  @override
  Widget build(BuildContext context) {
    final color = status.when(
      data: (online) => online ? Colors.green : Colors.red,
      loading: () => Colors.grey,
      error: (error, stackTrace) => Colors.red,
    );
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: Theme.of(context).colorScheme.surface, width: 1.5),
      ),
    );
  }
}
