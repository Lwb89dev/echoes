import 'dart:convert';

import 'package:cryptography/cryptography.dart' show SecretBoxAuthenticationError;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../models/upload_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/note_encryption_provider.dart';
import '../providers/note_layout_provider.dart';
import '../providers/notes_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/relay_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/upload_settings_provider.dart';
import '../services/local_storage_service.dart';
import '../utils/formatter.dart';
import 'login_screen.dart';
import 'widgets/note_actions.dart';
import 'widgets/relay_widgets.dart';

/// App-wide settings: Nostr account (sign in/out), relay management, note
/// encryption toggle, appearance (theme/note layout), and language picker.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final encryptionState = ref.watch(noteEncryptionProvider);
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: ListView(
        children: [
          _SectionHeader(l.sectionAccount),
          const _AccountSection(),
          _SectionHeader(l.relaysTitle),
          const _RelaySection(),
          _SectionHeader(l.sectionSecurity),
          encryptionState.when(
            data: (state) => _EncryptionSection(state: state),
            loading: () => ListTile(
              leading: const CircularProgressIndicator(strokeWidth: 2),
              title: Text(l.loadingLabel),
            ),
            error: (error, stackTrace) => ListTile(
              leading: const Icon(Icons.error_outline),
              title: Text(l.encryptionLoadError),
              subtitle: Text('$error'),
            ),
          ),
          _SectionHeader(l.sectionAppearance),
          const _AppearanceSection(),
          _SectionHeader(l.sectionLanguage),
          const _LanguageSection(),
          _SectionHeader(l.sectionData),
          const _DataSection(),
          _SectionHeader(l.sectionAttachments),
          const _AttachmentsSection(),
          _SectionHeader(l.sectionSupport),
          const _DonationTile(),
        ],
      ),
    );
  }
}

// ── Account ──────────────────────────────────────────────────────────────

class _AccountSection extends ConsumerWidget {
  const _AccountSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final authState = ref.watch(authProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(l.accountLocalOnlyMessage),
            trailing: FilledButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
              child: Text(l.accountSignInButton),
            ),
          );
        }
        // Best-effort niceties on top of the always-available npub: a
        // display name and avatar from the account's public kind-0
        // profile, when one could be fetched. Both fall back cleanly
        // (truncated npub / plain icon) while loading or on failure —
        // this row must never block on either.
        final profile = ref.watch(profileProvider).value;
        final avatarUrl = profile?.picture;
        final avatarFile = avatarUrl != null ? ref.watch(avatarFileProvider(avatarUrl)).value : null;
        final displayName = profile?.label ?? Formatter.truncateKey(user.npub);

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: avatarFile != null ? FileImage(avatarFile) : null,
            child: avatarFile == null ? const Icon(Icons.verified_user_outlined) : null,
          ),
          title: Text(l.accountSignedInAs(displayName)),
          trailing: TextButton(
            onPressed: () => _confirmSignOut(context, ref, l),
            child: Text(l.accountSignOutButton),
          ),
        );
      },
      loading: () => ListTile(
        leading: const CircularProgressIndicator(strokeWidth: 2),
        title: Text(l.loadingLabel),
      ),
      error: (error, stackTrace) => ListTile(
        leading: const Icon(Icons.error_outline),
        title: Text(l.genericErrorPrefix(error.toString())),
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref, AppLocalizations l) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.accountSignOutConfirmTitle),
        content: Text(l.accountSignOutConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l.accountSignOutButton),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(authProvider.notifier).logout();
    }
  }
}

// ── Relays ───────────────────────────────────────────────────────────────

/// The relay list used to live behind its own AppBar button on the home
/// screen; it's here now instead, and the list itself sits behind a
/// collapsed [ExpansionTile] rather than being always visible. That's not
/// just tidiness: each relay row pings its own online/offline status (see
/// [RelayListView]/`relayStatusProvider`), and `ExpansionTile` doesn't
/// build its children at all until first expanded — so simply opening
/// Settings never triggers a single one of those pings, only actually
/// opening this section does.
class _RelaySection extends ConsumerWidget {
  const _RelaySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final relaysState = ref.watch(relayProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: RelayUrlInput(),
        ),
        const SizedBox(height: 12),
        // A darker surface tone when expanded (animated, via
        // `ExpansionTile`'s own built-in color tween — no manual
        // AnimationController needed) is the separation, instead of a
        // border/divider line: `surfaceContainerHigh` is a Material 3
        // tonal surface variant that's consistently a step more elevated
        // than the base surface in *both* light and dark themes, unlike
        // hand-picking a single shade that would only read right in one
        // brightness. `shape`/`collapsedShape: Border()` also suppress
        // ExpansionTile's own default top/bottom divider lines.
        ExpansionTile(
          shape: const Border(),
          collapsedShape: const Border(),
          backgroundColor: colorScheme.surfaceContainerHigh,
          collapsedBackgroundColor: Colors.transparent,
          title: Text(l.manageRelaysTitle),
          subtitle: Text(
            relaysState.maybeWhen(
              data: (relays) => l.relaysCount(relays.length),
              orElse: () => '',
            ),
          ),
          children: [
            // No fixed height: the list sizes itself to however many
            // relays there actually are, instead of always reserving
            // room for several that leaves a slab of dead space below a
            // short list.
            relaysState.when(
              data: (relays) => RelayListView(relays: relays, shrinkWrap: true),
              loading: () => const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stackTrace) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text(l.genericErrorPrefix(error.toString())),
              ),
            ),
            const _RepublishAllTile(),
          ],
        ),
      ],
    );
  }
}

/// "Backfill this relay list" action: republishes every previously-synced
/// note to every currently configured relay (see
/// [NotesNotifier.republishAllToRelays]). Meant for right after adding a
/// relay that wasn't there when a note was first synced — e.g. a
/// self-hosted backup relay at home — since the normal per-note sync only
/// ever reaches a newly added relay on that note's *next* edit, not
/// retroactively.
///
/// Only shown once signed in: without a Nostr account there is nothing to
/// republish anywhere.
class _RepublishAllTile extends ConsumerStatefulWidget {
  const _RepublishAllTile();

  @override
  ConsumerState<_RepublishAllTile> createState() => _RepublishAllTileState();
}

class _RepublishAllTileState extends ConsumerState<_RepublishAllTile> {
  bool _running = false;

  Future<void> _run() async {
    final l = AppLocalizations.of(context);
    setState(() => _running = true);
    try {
      final count = await ref.read(notesProvider.notifier).republishAllToRelays();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.republishAllNotesSuccess(count))),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.republishAllNotesError(e.toString()))),
      );
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final hasNostrAccount = ref.watch(authProvider).value != null;
    if (!hasNostrAccount) return const SizedBox.shrink();

    return ListTile(
      leading: _running
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.cloud_sync_outlined),
      title: Text(l.republishAllNotesButton),
      subtitle: Text(l.republishAllNotesSubtitle),
      onTap: _running ? null : _run,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}

// ── Security / note encryption ──────────────────────────────────────────

class _EncryptionSection extends ConsumerWidget {
  const _EncryptionSection({required this.state});

  final NoteEncryptionState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);

    return Column(
      children: [
        SwitchListTile(
          title: Text(l.encryptionToggleTitle),
          subtitle: Text(l.encryptionToggleSubtitle),
          value: state.enabled,
          onChanged: (value) {
            if (value) {
              _showEnableDialog(context, ref, l);
            } else {
              _showDisableDialog(context, ref, l);
            }
          },
        ),
        if (state.enabled && state.unlocked)
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: Text(l.lockNotesNowTitle),
            subtitle: Text(l.lockNotesNowSubtitle),
            onTap: () => ref.read(noteEncryptionProvider.notifier).lock(),
          ),
      ],
    );
  }

  Future<void> _showEnableDialog(BuildContext context, WidgetRef ref, AppLocalizations l) async {
    final formKey = GlobalKey<FormState>();
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();
    var submitting = false;
    String? errorText;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: Text(l.setPasswordDialogTitle),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  autofocus: true,
                  decoration: InputDecoration(labelText: l.passwordLabel),
                  validator: (value) =>
                      (value == null || value.length < 8) ? l.passwordTooShortError : null,
                ),
                TextFormField(
                  controller: confirmController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: l.confirmPasswordLabel),
                  validator: (value) =>
                      value != passwordController.text ? l.passwordsDoNotMatchError : null,
                ),
                if (errorText != null) ...[
                  const SizedBox(height: 8),
                  Text(errorText!, style: TextStyle(color: Theme.of(dialogContext).colorScheme.error)),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: submitting ? null : () => Navigator.of(dialogContext).pop(),
              child: Text(l.cancelButton),
            ),
            FilledButton(
              onPressed: submitting
                  ? null
                  : () async {
                      if (!formKey.currentState!.validate()) return;
                      setState(() => submitting = true);
                      try {
                        await ref
                            .read(noteEncryptionProvider.notifier)
                            .enable(passwordController.text);
                        if (dialogContext.mounted) Navigator.of(dialogContext).pop();
                      } catch (e) {
                        setState(() {
                          submitting = false;
                          errorText = l.enableEncryptionError(e.toString());
                        });
                      }
                    },
              child: Text(l.enableButton),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDisableDialog(BuildContext context, WidgetRef ref, AppLocalizations l) async {
    final passwordController = TextEditingController();
    var submitting = false;
    String? errorText;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: Text(l.disablePasswordDialogTitle),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            autofocus: true,
            decoration: InputDecoration(
              labelText: l.passwordLabel,
              errorText: errorText,
            ),
          ),
          actions: [
            TextButton(
              onPressed: submitting ? null : () => Navigator.of(dialogContext).pop(),
              child: Text(l.cancelButton),
            ),
            FilledButton(
              onPressed: submitting
                  ? null
                  : () async {
                      setState(() {
                        submitting = true;
                        errorText = null;
                      });
                      try {
                        await ref
                            .read(noteEncryptionProvider.notifier)
                            .disable(passwordController.text);
                        if (dialogContext.mounted) Navigator.of(dialogContext).pop();
                      } catch (e) {
                        setState(() {
                          submitting = false;
                          errorText = l.wrongPasswordError;
                        });
                      }
                    },
              child: Text(l.disableButton),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Appearance (theme + note list layout) ───────────────────────────────

class _AppearanceSection extends ConsumerWidget {
  const _AppearanceSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final noteLayout = ref.watch(noteLayoutProvider);

    return Column(
      children: [
        SwitchListTile(
          title: Text(l.lightThemeToggleTitle),
          subtitle: Text(l.lightThemeToggleSubtitle),
          value: themeMode == ThemeMode.light,
          onChanged: (value) => ref
              .read(themeModeProvider.notifier)
              .setThemeMode(value ? ThemeMode.light : ThemeMode.dark),
        ),
        ListTile(
          title: Text(l.noteLayoutToggleTitle),
          subtitle: Text(l.noteLayoutToggleSubtitle),
          trailing: SegmentedButton<NoteLayout>(
            segments: [
              ButtonSegment(value: NoteLayout.list, icon: const Icon(Icons.view_list_outlined)),
              ButtonSegment(value: NoteLayout.grid, icon: const Icon(Icons.grid_view_outlined)),
            ],
            selected: {noteLayout},
            showSelectedIcon: false,
            onSelectionChanged: (selection) =>
                ref.read(noteLayoutProvider.notifier).setLayout(selection.first),
          ),
        ),
      ],
    );
  }
}

// ── Language ────────────────────────────────────────────────────────────

/// Language names are intentionally shown in their own native script (not
/// translated) so users can recognise their language regardless of the
/// app's current language.
const Map<String, String> _euOfficialLanguages = {
  'bg': 'Български', // Bulgarian
  'cs': 'Čeština', // Czech
  'da': 'Dansk', // Danish
  'de': 'Deutsch', // German
  'el': 'Ελληνικά', // Greek
  'en': 'English', // English
  'es': 'Español', // Spanish
  'et': 'Eesti', // Estonian
  'fi': 'Suomi', // Finnish
  'fr': 'Français', // French
  'ga': 'Gaeilge', // Irish
  'hr': 'Hrvatski', // Croatian
  'hu': 'Magyar', // Hungarian
  'it': 'Italiano', // Italian
  'lt': 'Lietuvių', // Lithuanian
  'lv': 'Latviešu', // Latvian
  'mt': 'Malti', // Maltese
  'nl': 'Nederlands', // Dutch
  'pl': 'Polski', // Polish
  'pt': 'Português', // Portuguese
  'ro': 'Română', // Romanian
  'sk': 'Slovenčina', // Slovak
  'sl': 'Slovenščina', // Slovenian
  'sv': 'Svenska', // Swedish
};

const Map<String, String> _additionalLanguages = {
  'ja': '日本語', // Japanese
  'ru': 'Русский', // Russian
  'zh': '中文', // Chinese (Simplified)
};

class _LanguageSection extends ConsumerWidget {
  const _LanguageSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: locale?.languageCode,
          isExpanded: true,
          borderRadius: BorderRadius.circular(12),
          items: [
            DropdownMenuItem<String?>(
              value: null,
              child: Text(l.langSystem),
            ),
            ..._buildLanguageItems(_euOfficialLanguages),
            ..._buildLanguageItems(_additionalLanguages),
          ],
          onChanged: (code) {
            ref.read(localeProvider.notifier).setLocale(code != null ? Locale(code) : null);
          },
        ),
      ),
    );
  }

  List<DropdownMenuItem<String?>> _buildLanguageItems(Map<String, String> languages) {
    final sorted = languages.entries.toList()..sort((a, b) => a.value.compareTo(b.value));
    return sorted
        .map((e) => DropdownMenuItem<String?>(value: e.key, child: Text(e.value)))
        .toList();
  }
}

// ── Data (export / import) ──────────────────────────────────────────────

class _DataSection extends ConsumerWidget {
  const _DataSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);

    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.upload_outlined),
          title: Text(l.exportNotesButton),
          subtitle: Text(l.exportNotesSubtitle),
          onTap: () => exportNotesToFile(context, ref, l),
        ),
        ListTile(
          leading: const Icon(Icons.download_outlined),
          title: Text(l.importNotesButton),
          subtitle: Text(l.importNotesSubtitle),
          onTap: () => _importNotes(context, ref, l),
        ),
      ],
    );
  }

  Future<void> _importNotes(BuildContext context, WidgetRef ref, AppLocalizations l) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        withData: true,
      );
      final picked = result?.files.single;
      if (picked == null) return;

      final fileBytes = picked.bytes;
      if (fileBytes == null) {
        throw StateError('Could not read the selected file.');
      }
      final rawJson = utf8.decode(fileBytes);

      final int? count;
      if (LocalStorageService.isExportEncrypted(rawJson)) {
        if (!context.mounted) return;
        count = await _importEncrypted(context, ref, l, rawJson);
        if (count == null) return; // Password dialog cancelled.
      } else {
        count = await ref.read(notesProvider.notifier).importNotes(rawJson);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.importNotesSuccess(count))),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.importNotesError(e.toString()))),
        );
      }
    }
  }

  /// Password prompt for an encrypted export (see
  /// `LocalStorageService.isExportEncrypted`/`exportNotesAsJson`) — stays
  /// open and shows an inline "wrong password" on a failed attempt (via
  /// [SecretBoxAuthenticationError]) rather than closing and forcing the
  /// whole file picker flow to be redone. Returns the imported-note count,
  /// or null if cancelled.
  Future<int?> _importEncrypted(BuildContext context, WidgetRef ref, AppLocalizations l, String rawJson) async {
    final controller = TextEditingController();
    var submitting = false;
    String? errorText;

    final count = await showDialog<int>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: Text(l.importPasswordDialogTitle),
          content: TextField(
            controller: controller,
            obscureText: true,
            autofocus: true,
            decoration: InputDecoration(labelText: l.passwordLabel, errorText: errorText),
          ),
          actions: [
            TextButton(
              onPressed: submitting ? null : () => Navigator.of(dialogContext).pop(),
              child: Text(l.cancelButton),
            ),
            FilledButton(
              onPressed: submitting
                  ? null
                  : () async {
                      setState(() {
                        submitting = true;
                        errorText = null;
                      });
                      try {
                        final imported = await ref
                            .read(notesProvider.notifier)
                            .importNotes(rawJson, password: controller.text);
                        if (dialogContext.mounted) Navigator.of(dialogContext).pop(imported);
                      } on SecretBoxAuthenticationError {
                        setState(() {
                          submitting = false;
                          errorText = l.wrongPasswordError;
                        });
                      }
                    },
              child: Text(l.importNotesButton),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    return count;
  }
}

// ── Attachments (upload provider) ───────────────────────────────────────

/// Picks which file host (see [UploadProviderOption]) encrypted images and
/// voice notes get uploaded to on sync. A `ConsumerStatefulWidget` (rather
/// than the simpler `ConsumerWidget` most of this file uses) because the
/// custom-URL text field needs a controller that survives rebuilds without
/// losing focus/cursor position as the user types.
class _AttachmentsSection extends ConsumerStatefulWidget {
  const _AttachmentsSection();

  @override
  ConsumerState<_AttachmentsSection> createState() => _AttachmentsSectionState();
}

class _AttachmentsSectionState extends ConsumerState<_AttachmentsSection> {
  late final TextEditingController _customUrlController;

  @override
  void initState() {
    super.initState();
    final current = ref.read(uploadProviderProvider);
    _customUrlController = TextEditingController(text: current.id == 'custom' ? current.baseUrl : '');
  }

  @override
  void dispose() {
    _customUrlController.dispose();
    super.dispose();
  }

  void _selectCustom() {
    final current = ref.read(uploadProviderProvider);
    ref.read(uploadProviderProvider.notifier).setProvider(
          UploadProviderOption(
            id: 'custom',
            label: _customUrlController.text.trim(),
            protocol: current.id == 'custom' ? current.protocol : UploadProtocol.blossom,
            baseUrl: _customUrlController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final selected = ref.watch(uploadProviderProvider);
    final isCustom = selected.id == 'custom';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(l.attachmentProviderSubtitle, style: Theme.of(context).textTheme.bodySmall),
        ),
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: isCustom ? 'custom' : selected.id,
              isExpanded: true,
              borderRadius: BorderRadius.circular(12),
              items: [
                for (final provider in builtInUploadProviders)
                  DropdownMenuItem(value: provider.id, child: Text(provider.label)),
                DropdownMenuItem(value: 'custom', child: Text(l.attachmentProviderCustom)),
              ],
              onChanged: (id) {
                if (id == null) return;
                if (id == 'custom') {
                  _selectCustom();
                  return;
                }
                final provider = builtInUploadProviders.firstWhere((p) => p.id == id);
                ref.read(uploadProviderProvider.notifier).setProvider(provider);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
          child: Text(
            l.attachmentProviderHint,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ),
        if (isCustom) ...[
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _customUrlController,
                  decoration: InputDecoration(
                    labelText: l.attachmentCustomUrlLabel,
                    hintText: 'https://…',
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.url,
                  onSubmitted: (_) => _selectCustom(),
                  onEditingComplete: _selectCustom,
                ),
                const SizedBox(height: 8),
                SegmentedButton<UploadProtocol>(
                  segments: const [
                    ButtonSegment(value: UploadProtocol.blossom, label: Text('Blossom')),
                    ButtonSegment(value: UploadProtocol.nip96, label: Text('NIP-96')),
                  ],
                  selected: {selected.protocol},
                  onSelectionChanged: (protocols) {
                    ref.read(uploadProviderProvider.notifier).setProvider(
                          UploadProviderOption(
                            id: 'custom',
                            label: selected.label,
                            protocol: protocols.first,
                            baseUrl: selected.baseUrl,
                          ),
                        );
                  },
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 8),
      ],
    );
  }
}

// ── Support ──────────────────────────────────────────────────────────────

/// Same approach as Roadstr's developer-donation tile: hand a `lightning:`
/// URI to whatever wallet app is installed (it resolves the Lightning
/// address itself via LNURL-pay — no QR code or in-app invoice fetching
/// needed here). Falls back to copying the address to the clipboard if no
/// wallet app is installed to handle the URI.
class _DonationTile extends StatelessWidget {
  const _DonationTile();

  static const _lightningAddress = 'lwb89@blink.sv';

  Future<void> _donate(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final uri = Uri.parse('lightning:$_lightningAddress');
    var launched = false;
    try {
      launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      launched = false;
    }
    if (launched) return;

    await Clipboard.setData(const ClipboardData(text: _lightningAddress));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.lightningAddressCopied(_lightningAddress)),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => _donate(context),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colorScheme.primary.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Icon(Icons.bolt_rounded, color: colorScheme.primary, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.supportEchoesTitle,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(_lightningAddress, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Icon(Icons.open_in_new_rounded, size: 14, color: colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
