import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../models/note.dart';
import '../../models/profile.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notes_provider.dart';
import '../../providers/profile_provider.dart'
    show avatarFileProvider, contactsProvider, peerProfileProvider;
import '../../providers/relay_provider.dart';
import '../../providers/service_providers.dart';
import '../../utils/formatter.dart';

/// A recipient the share field has resolved from what the user typed — an
/// `npub`/hex pubkey, or a `name@domain` NIP-05 identifier — together with
/// the public profile card (avatar + name) fetched for that pubkey. Shown as
/// a live preview so the user can *visually* confirm who they're about to
/// share with before committing: a lookalike identifier (`aliice@…` vs
/// `alice@…`) resolves to a different key with a different face, which the
/// avatar makes obvious in a way a truncated npub alone doesn't.
class _RecipientPreview {
  final String query;
  final String hex;
  final NostrProfile? profile;
  final bool viaNip05;

  const _RecipientPreview({
    required this.query,
    required this.hex,
    required this.profile,
    required this.viaNip05,
  });
}

/// Bottom-sheet UI for sharing a note. Two distinct modes:
///
///  * **I own the note** — add recipients (npub, hex, or a `name@domain`
///    NIP-05 identifier), see who it's shared with, and stop sharing with any
///    of them. Every action publishes immediately through [NotesNotifier] and
///    reports failures inline.
///  * **The note was shared with me** — shows who shared it and a single
///    "leave" action ([NotesNotifier.abandonSharedNote]); leaving is
///    permanent and can't be rejoined (see `NoteSharing`).
///
/// [onChanged] is called with the updated note after a recipient change, or
/// with `null` after the note is abandoned (so the caller can pop the
/// editor — the note no longer exists locally).
class ShareNoteSheet extends ConsumerStatefulWidget {
  const ShareNoteSheet({super.key, required this.note, required this.onChanged});

  final Note note;
  final void Function(Note? updated) onChanged;

  @override
  ConsumerState<ShareNoteSheet> createState() => _ShareNoteSheetState();
}

class _ShareNoteSheetState extends ConsumerState<ShareNoteSheet> {
  final _recipientController = TextEditingController();
  late Note _note;
  bool _busy = false;
  String? _error;

  // Live-preview state. `_resolveToken` guards against out-of-order async
  // results: every resolve captures the current token, and a completion whose
  // token is stale (the user kept typing) is discarded instead of clobbering
  // the preview for what's now in the field.
  Timer? _debounce;
  int _resolveToken = 0;
  bool _resolving = false;
  _RecipientPreview? _preview;

  @override
  void initState() {
    super.initState();
    _note = widget.note;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _recipientController.dispose();
    super.dispose();
  }

  String _shortNpub(String pubHex) {
    // Display as a truncated npub — never the raw hex, and never the full
    // key (which is long and adds nothing for recognition).
    try {
      return Formatter.truncateKey(ref.read(nostrServiceProvider).publicKeyToNpub(pubHex));
    } catch (_) {
      return Formatter.truncateKey(pubHex);
    }
  }

  /// Cheap, network-free check: is [q] complete enough to be worth a lookup?
  /// Debounced keystrokes fire a real resolve only once the text looks like a
  /// finished npub, hex key, or `name@domain` — never on every partial char.
  bool _looksResolvable(String q) {
    if (q.contains('@')) {
      return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(q);
    }
    if (q.startsWith('npub1')) return q.length >= 60;
    return RegExp(r'^[0-9a-fA-F]{64}$').hasMatch(q);
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    // Invalidate any resolve still in flight for the *previous* text: its
    // token goes stale here, so a slow lookup finishing late can't paint a
    // preview for something no longer in the field.
    _resolveToken++;
    final q = value.trim();
    if (_preview != null && _preview!.query == q) return;
    setState(() {
      _preview = null;
      _error = null;
    });
    if (!_looksResolvable(q)) {
      if (_resolving) setState(() => _resolving = false);
      return;
    }
    setState(() => _resolving = true);
    // npub/hex resolve instantly — [NostrService.recipientToPublicKeyHex] is
    // local bech32 decoding, no network round-trip, so there's nothing to
    // debounce and no reason to make it feel slower than it is.
    //
    // A NIP-05 identifier is different: resolving it sends an HTTPS request
    // — carrying the typed name — to whatever domain is currently in the
    // field. While someone is still typing `alice@domain.com`, intermediate
    // states like `alice@domain.co` are themselves well-formed identifiers
    // pointing at *entirely different registrable domains*, so an eager
    // debounce would leak the name (and the fact that this user is looking
    // it up) to hosts that were never meant to be contacted. The debounce is
    // therefore a deliberate full typing-pause, not a keystroke-smoother:
    // long enough that mid-word states almost never fire. The residual leak
    // (pausing exactly on a valid-looking prefix) is inherent to resolving
    // NIP-05 live at all and is why only the *final* identifier's domain
    // learning about the lookup is considered acceptable — that one is
    // unavoidable by design of NIP-05 itself.
    if (q.contains('@')) {
      _debounce = Timer(const Duration(milliseconds: 600), () => _resolvePreview(q));
    } else {
      _resolvePreview(q);
    }
  }

  Future<void> _resolvePreview(String q) async {
    final token = ++_resolveToken;
    _RecipientPreview? preview;
    try {
      preview = await _resolveRecipient(q);
    } catch (_) {
      preview = null;
    }
    if (token != _resolveToken || !mounted) return;
    setState(() {
      _resolving = false;
      _preview = preview;
    });
  }

  /// Resolves [q] (npub, hex, or a NIP-05 `name@domain` identifier) to a
  /// pubkey and its best-effort public profile. Throws if [q] isn't a
  /// recognisable recipient identifier at all; a failed/empty profile fetch
  /// is *not* an error here — it just leaves [_RecipientPreview.profile]
  /// null, so the caller falls back to the npub. Shared by the live-preview
  /// path ([_resolvePreview]) and the on-submit path ([_addRecipient]), so
  /// typing-then-pausing and typing-then-hitting-Add never re-derive this
  /// differently.
  Future<_RecipientPreview> _resolveRecipient(String q) async {
    final service = ref.read(nostrServiceProvider);
    final viaNip05 = q.contains('@');
    final hex = viaNip05 ? await service.resolveNip05(q) : service.recipientToPublicKeyHex(q);

    NostrProfile? profile;
    try {
      final relays = ref.read(relayProvider).value ?? const [];
      profile = await service.fetchProfileMetadata(publicKeyHex: hex, relays: relays);
    } catch (_) {
      // best-effort
    }
    return _RecipientPreview(query: q, hex: hex, profile: profile, viaNip05: viaNip05);
  }

  Future<void> _addRecipient() async {
    final l = AppLocalizations.of(context);
    final raw = _recipientController.text.trim();
    if (raw.isEmpty) return;

    setState(() {
      _busy = true;
      _error = null;
    });

    _RecipientPreview preview;
    try {
      // Reuse the already-resolved preview when it matches what's in the
      // field (no second network round-trip); otherwise resolve on the spot
      // so hitting Add before the debounce fires still works.
      preview = (_preview != null && _preview!.query == raw) ? _preview! : await _resolveRecipient(raw);
    } catch (_) {
      setState(() {
        _busy = false;
        _error = raw.contains('@') ? l.shareRecipientNotFoundError : l.shareInvalidRecipientError;
      });
      return;
    }
    await _confirmAndShare(preview);
  }

  /// Selects a suggestion from the local contacts autocomplete
  /// ([_matchingContacts]) directly — no field text is even required to look
  /// like a full identifier, since the pubkey and profile are already known
  /// from the contact list. Still goes through the exact same confirmation
  /// step as typing one out in full: which name/avatar is showing next to
  /// "share with?" is the thing that actually needs confirming, not how the
  /// recipient was found.
  Future<void> _selectContact(NostrProfile contact) async {
    final npub = ref.read(nostrServiceProvider).publicKeyToNpub(contact.publicKeyHex);
    _debounce?.cancel();
    // Also invalidate any resolve in flight for whatever was typed before
    // the tap, so it can't repaint a stale preview under the dialog.
    _resolveToken++;
    _recipientController.text = npub;
    setState(() {
      _preview = null;
      _resolving = false;
      _error = null;
    });
    await _confirmAndShare(
      _RecipientPreview(query: npub, hex: contact.publicKeyHex, profile: contact, viaNip05: false),
    );
  }

  /// Validates [preview] isn't self/already-shared, asks for explicit
  /// confirmation against its avatar+name+npub card, and — only once
  /// confirmed — publishes the share. Shared by both ways of arriving at a
  /// recipient: typing a full identifier ([_addRecipient]) and tapping a
  /// contacts suggestion ([_selectContact]).
  Future<void> _confirmAndShare(_RecipientPreview preview) async {
    final l = AppLocalizations.of(context);
    final hex = preview.hex;

    final me = ref.read(authProvider).value;
    if (me != null && hex == me.publicKeyHex) {
      setState(() {
        _busy = false;
        _error = l.shareCannotShareWithSelfError;
      });
      return;
    }
    if (_note.sharedWith.contains(hex)) {
      setState(() {
        _busy = false;
        _error = l.shareAlreadyRecipientError;
      });
      return;
    }

    // This is the actual decision point — sharing hands the note's content
    // to someone else, permanently as far as what they've already received
    // — so it's confirmed explicitly against the same avatar+name+npub card
    // used for the live preview, not just typed/tapped and auto-submitted.
    setState(() => _busy = false);
    if (!mounted) return;
    final confirmed = await _confirmShareDialog(l, preview);
    if (confirmed != true || !mounted) return;

    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final updated = await ref.read(notesProvider.notifier).shareNote(_note, [hex]);
      _recipientController.clear();
      setState(() {
        _note = updated;
        _preview = null;
      });
      widget.onChanged(updated);
    } catch (e) {
      setState(() => _error = l.shareError(e.toString()));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool?> _confirmShareDialog(AppLocalizations l, _RecipientPreview preview) {
    final npub = _shortNpub(preview.hex);
    final name = preview.profile?.label;
    // Snapshot the avatar file *before* opening the dialog: `ref.watch`
    // belongs to this sheet's build cycle, not a dialog builder (which the
    // sheet's rebuilds never re-run anyway). By this point the preview
    // card/suggestion row has already warmed [avatarFileProvider], so a
    // plain read gets the cached file; if it genuinely isn't there yet the
    // dialog just shows the fallback icon, same as everywhere else.
    final pictureUrl = preview.profile?.picture;
    final avatarFile = (pictureUrl != null && pictureUrl.startsWith('https://'))
        ? ref.read(avatarFileProvider(pictureUrl)).value
        : null;
    final avatar = CircleAvatar(
      backgroundImage: avatarFile != null ? FileImage(avatarFile) : null,
      child: avatarFile == null ? const Icon(Icons.person_outline) : null,
    );
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.shareConfirmTitle),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            avatar,
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name ?? npub, style: Theme.of(context).textTheme.titleMedium),
                  if (name != null)
                    Text(npub, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l.shareConfirmButton),
          ),
        ],
      ),
    );
  }

  Future<void> _stopSharingWith(String pubHex) async {
    final l = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final updated = await ref.read(notesProvider.notifier).stopSharingWith(_note, pubHex);
      setState(() => _note = updated);
      widget.onChanged(updated);
    } catch (e) {
      setState(() => _error = l.shareError(e.toString()));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _abandon() async {
    final l = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.abandonSharedNoteConfirmTitle),
        content: Text(l.abandonSharedNoteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l.abandonSharedNoteButton),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(notesProvider.notifier).abandonSharedNote(_note);
      if (!mounted) return;
      widget.onChanged(null);
      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _busy = false;
        _error = l.abandonSharedNoteError(e.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    // AnimatedPadding eases the keyboard inset instead of tracking every raw
    // viewInsets tick, and AnimatedSize turns the sheet's frequent content
    // height changes (preview card in/out, suggestions, recipient added)
    // into one smooth resize instead of an abrupt jump. Durations are kept
    // short — the goal is taking the edge off, not making the UI feel like
    // it's waiting on its own transitions.
    return SafeArea(
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        // The sheet's content height is dynamic (live preview card, up to 5
        // contact suggestions, an arbitrarily long recipient list) and grows
        // further once the on-screen keyboard eats into available height —
        // a plain min-size Column has no way to shrink to fit and just
        // overflows once the two combined exceed the screen. Scrolling lets
        // it keep behaving like a compact sheet when short and become
        // scrollable instead of overflowing when it isn't.
        child: SingleChildScrollView(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _note.isSharedWithMe ? _recipientView(l) : _ownerView(l),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _ownerView(AppLocalizations l) {
    return [
      Text(l.shareNoteTitle, style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 16),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextField(
              controller: _recipientController,
              enabled: !_busy,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                labelText: l.shareRecipientFieldLabel,
                hintText: 'npub1…  ·  name@domain',
                border: const OutlineInputBorder(),
                errorText: _error,
              ),
              onChanged: _onQueryChanged,
              onSubmitted: (_) => _addRecipient(),
            ),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: FilledButton(
              onPressed: _busy ? null : _addRecipient,
              child: Text(l.shareAddRecipientButton),
            ),
          ),
        ],
      ),
      if (_resolving || _preview != null) ...[
        const SizedBox(height: 8),
        // Crossfade spinner ↔ resolved card instead of swapping them cold.
        // The card is keyed by the resolved pubkey so switching straight
        // from one recipient's card to another's also animates, while
        // rebuilds of the *same* card (e.g. its avatar finishing loading)
        // don't re-trigger the transition.
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: _resolving
              ? KeyedSubtree(key: const ValueKey('resolving'), child: _resolvingRow(l))
              : KeyedSubtree(key: ValueKey('preview:${_preview!.hex}'), child: _previewCard(_preview!)),
        ),
      ] else
        ..._contactSuggestions(),
      const SizedBox(height: 20),
      Text(l.shareRecipientsHeader, style: Theme.of(context).textTheme.titleSmall),
      const SizedBox(height: 4),
      if (_note.sharedWith.isEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(l.shareNoRecipientsMessage, style: Theme.of(context).textTheme.bodyMedium),
        )
      else
        for (final pubHex in _note.sharedWith)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: _peerAvatar(pubHex),
            title: Text(_peerLabel(pubHex)),
            subtitle: _peerHasLabel(pubHex) ? Text(_shortNpub(pubHex)) : null,
            trailing: IconButton(
              icon: const Icon(Icons.close),
              tooltip: l.stopSharingTooltip,
              onPressed: _busy ? null : () => _stopSharingWith(pubHex),
            ),
          ),
      const SizedBox(height: 8),
      Text(
        l.shareRevocationNote,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    ];
  }

  Widget _resolvingRow(AppLocalizations l) {
    return Row(
      children: [
        const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        const SizedBox(width: 12),
        Text(l.loadingLabel, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  /// Contacts (people the user already follows — [contactsProvider]) whose
  /// name or npub contains what's currently typed, case-insensitively.
  /// Client-side only: no network call per keystroke, and no candidates
  /// beyond the user's own follow list — see [contactsProvider]'s doc
  /// comment for why that boundary matters here. Empty while the field is
  /// empty or already looks like a complete identifier (that path goes
  /// through the live-resolve preview instead, not suggestions).
  List<NostrProfile> _matchingContacts(String q) {
    if (q.isEmpty || _looksResolvable(q)) return const [];
    final contacts = ref.watch(contactsProvider).value ?? const [];
    final needle = q.toLowerCase();
    final service = ref.read(nostrServiceProvider);
    return contacts.where((c) {
      final label = c.label?.toLowerCase();
      if (label != null && label.contains(needle)) return true;
      try {
        return service.publicKeyToNpub(c.publicKeyHex).toLowerCase().contains(needle);
      } catch (_) {
        return false;
      }
    }).take(5).toList();
  }

  List<Widget> _contactSuggestions() {
    final matches = _matchingContacts(_recipientController.text.trim());
    if (matches.isEmpty) return const [];
    return [
      const SizedBox(height: 8),
      Card(
        margin: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final contact in matches)
              ListTile(
                dense: true,
                leading: _avatarFor(contact),
                title: Text(contact.label ?? _shortNpub(contact.publicKeyHex)),
                subtitle: contact.label != null ? Text(_shortNpub(contact.publicKeyHex)) : null,
                onTap: _busy ? null : () => _selectContact(contact),
              ),
          ],
        ),
      ),
    ];
  }

  Widget _previewCard(_RecipientPreview preview) {
    final npub = _shortNpub(preview.hex);
    final name = preview.profile?.label;
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: _avatarFor(preview.profile),
        title: Text(name ?? npub),
        // Always surface the actual npub so the key itself can be verified,
        // not just the (spoofable) display name / avatar.
        subtitle: Text(name != null ? npub : (preview.viaNip05 ? preview.query : npub)),
      ),
    );
  }

  /// Best-effort public profile for [pubHex], watched so avatar/name fill in
  /// live once the fetch resolves. Used anywhere the UI names another Nostr
  /// user (recipient list, "shared by" row) so a person is shown as they
  /// present themselves on Nostr rather than as a 63-character npub — the
  /// npub itself stays visible alongside it wherever it's shown ([_peerHasLabel]).
  NostrProfile? _peerProfile(String pubHex) => ref.watch(peerProfileProvider(pubHex)).value;

  bool _peerHasLabel(String pubHex) => _peerProfile(pubHex)?.label != null;

  String _peerLabel(String pubHex) => _peerProfile(pubHex)?.label ?? _shortNpub(pubHex);

  Widget _peerAvatar(String pubHex) => _avatarFor(_peerProfile(pubHex));

  /// Reuses the same disk-cached, HTTPS-only avatar loader Settings uses; a
  /// non-HTTPS or unreachable picture simply yields the fallback icon.
  Widget _avatarFor(NostrProfile? profile) {
    final pictureUrl = profile?.picture;
    final avatarFile = (pictureUrl != null && pictureUrl.startsWith('https://'))
        ? ref.watch(avatarFileProvider(pictureUrl)).value
        : null;
    return CircleAvatar(
      backgroundImage: avatarFile != null ? FileImage(avatarFile) : null,
      child: avatarFile == null ? const Icon(Icons.person_outline) : null,
    );
  }

  List<Widget> _recipientView(AppLocalizations l) {
    return [
      Text(l.sharedWithMeHeader, style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 12),
      Row(
        children: [
          _peerAvatar(_note.ownerPubkey!),
          const SizedBox(width: 8),
          Expanded(child: Text(l.sharedByLabel(_peerLabel(_note.ownerPubkey!)))),
        ],
      ),
      const SizedBox(height: 8),
      Text(
        l.sharedNoteEditableNote,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
      const SizedBox(height: 20),
      if (_error != null) ...[
        Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
        const SizedBox(height: 8),
      ],
      Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton.icon(
          onPressed: _busy ? null : _abandon,
          icon: const Icon(Icons.logout),
          style: OutlinedButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
          label: Text(l.abandonSharedNoteButton),
        ),
      ),
    ];
  }
}
