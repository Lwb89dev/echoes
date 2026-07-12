// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginSubtitle => 'Sign in with your Nostr account';

  @override
  String get loginWithAmberButton => 'Sign in with Amber';

  @override
  String get importAccountButton => 'Import Nostr account';

  @override
  String get importAccountFieldLabel =>
      'Private key (nsec) of your Nostr account';

  @override
  String get importButton => 'Import';

  @override
  String get relaysTitle => 'Relays';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get emptyNotesMessage => 'No notes yet. Tap + to create one.';

  @override
  String get notesTabLabel => 'Notes';

  @override
  String get diaryTabLabel => 'Diary';

  @override
  String get emptyDiaryMessage => 'No diary entries yet. Tap + to write one.';

  @override
  String get diaryToday => 'Today';

  @override
  String get diaryYesterday => 'Yesterday';

  @override
  String get newPlainNoteOption => 'Note';

  @override
  String get newChecklistOption => 'Checklist';

  @override
  String get newVoiceNoteOption => 'Voice note';

  @override
  String get deleteNoteButton => 'Delete note';

  @override
  String get deleteNoteConfirmTitle => 'Delete this note?';

  @override
  String get deleteNoteConfirmBody =>
      'This can\'t be undone. If this note was synced, it will also be removed from your relays.';

  @override
  String deleteNotesConfirmTitle(int count) {
    return 'Delete $count notes?';
  }

  @override
  String get deleteNotesConfirmBody =>
      'This can\'t be undone. If any of these notes were synced, they will also be removed from your relays.';

  @override
  String selectionCount(int count) {
    return '$count selected';
  }

  @override
  String get untitledNote => '(untitled)';

  @override
  String errorLoadingNotes(String error) {
    return 'Error loading notes: $error';
  }

  @override
  String get timeJustNow => 'now';

  @override
  String timeMinutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String timeHoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String timeDaysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String get notesLockedTitle => 'Notes are protected with a password';

  @override
  String get unlockButton => 'Unlock';

  @override
  String get newNoteTitle => 'New note';

  @override
  String get editNoteTitle => 'Edit note';

  @override
  String get newDiaryEntryTitle => 'New diary entry';

  @override
  String get editDiaryEntryTitle => 'Edit diary entry';

  @override
  String get saveTooltip => 'Save';

  @override
  String get titleFieldLabel => 'Title';

  @override
  String get checklistLabel => 'Checklist';

  @override
  String get bodyFieldHint => 'Write here... (markdown supported)';

  @override
  String get checklistItemHint => 'Checklist item';

  @override
  String get addItemButton => 'Add item';

  @override
  String get addImageButton => 'Add image';

  @override
  String get recordVoiceNoteTooltip => 'Record a voice note';

  @override
  String get stopRecordingTooltip => 'Stop recording';

  @override
  String get cancelRecordingTooltip => 'Cancel recording';

  @override
  String get formatBoldTooltip => 'Bold';

  @override
  String get formatItalicTooltip => 'Italic';

  @override
  String get formatHeadingTooltip => 'Heading';

  @override
  String get formatListTooltip => 'Bulleted list';

  @override
  String get formatLinkTooltip => 'Link';

  @override
  String get imageSizeSmall => 'Small';

  @override
  String get imageSizeMedium => 'Medium';

  @override
  String get imageSizeFull => 'Full width';

  @override
  String get removeImageButton => 'Remove image';

  @override
  String get relayUrlHint => 'wss://relay.example.com';

  @override
  String get noRelaysMessage => 'No relay configured yet.';

  @override
  String relaysCount(int count) {
    return '$count relays';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get sectionSecurity => 'Security';

  @override
  String get loadingLabel => 'Loading…';

  @override
  String get encryptionLoadError => 'Could not load encryption settings';

  @override
  String get encryptionToggleTitle => 'Protect notes with a password';

  @override
  String get encryptionToggleSubtitle =>
      'Encrypts notes at rest (AES-256-GCM) with a key derived from your password. The password is never stored — forgetting it means the notes cannot be recovered.';

  @override
  String get lockNotesNowTitle => 'Lock notes now';

  @override
  String get lockNotesNowSubtitle =>
      'Requires the password again to view notes';

  @override
  String get setPasswordDialogTitle => 'Set a password';

  @override
  String get passwordTooShortError => 'At least 8 characters';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get passwordsDoNotMatchError => 'Passwords do not match';

  @override
  String enableEncryptionError(String error) {
    return 'Could not enable encryption: $error';
  }

  @override
  String get enableButton => 'Enable';

  @override
  String get disablePasswordDialogTitle =>
      'Enter your password to disable encryption';

  @override
  String get disableButton => 'Disable';

  @override
  String get sectionAppearance => 'Appearance';

  @override
  String get lightThemeToggleTitle => 'Light theme';

  @override
  String get lightThemeToggleSubtitle =>
      'Use a light color scheme instead of dark';

  @override
  String get noteLayoutToggleTitle => 'Note list layout';

  @override
  String get noteLayoutToggleSubtitle => 'Switch between list and grid view';

  @override
  String get manageRelaysTitle => 'Manage relays';

  @override
  String get republishAllNotesButton => 'Republish all synced notes';

  @override
  String get republishAllNotesSubtitle =>
      'Backfills every relay above with notes already shared elsewhere — useful right after adding one, e.g. a self-hosted backup relay';

  @override
  String republishAllNotesSuccess(int count) {
    return 'Republished $count note(s)';
  }

  @override
  String republishAllNotesError(String error) {
    return 'Could not republish notes: $error';
  }

  @override
  String get confirmButton => 'Confirm';

  @override
  String get sectionLanguage => 'Language';

  @override
  String get langSystem => 'System default';

  @override
  String get sectionAccount => 'Account';

  @override
  String get accountLocalOnlyMessage =>
      'Using Echoes locally — not synced to Nostr';

  @override
  String get accountSignInButton => 'Sign in';

  @override
  String accountSignedInAs(String npub) {
    return 'Signed in as $npub';
  }

  @override
  String get accountSignOutButton => 'Sign out';

  @override
  String get accountSignOutConfirmTitle => 'Sign out?';

  @override
  String get accountSignOutConfirmBody =>
      'Your notes stay on this device. You can sign in again anytime.';

  @override
  String get onboardingWelcomeTitle => 'Welcome to Echoes';

  @override
  String get onboardingIntroLocalTitle => 'Your notes, always on your device';

  @override
  String get onboardingIntroLocalBody =>
      'Every note is saved locally first, so the app works fully offline. Nothing leaves your device unless you choose to sync it.';

  @override
  String get onboardingIntroSyncTitle => 'Optional sync over Nostr';

  @override
  String get onboardingIntroSyncBody =>
      'Turn on sync to back up your notes and read them on other devices, using the open Nostr protocol and relays of your choice.';

  @override
  String get onboardingIntroEncryptionTitle => 'Always encrypted';

  @override
  String get onboardingIntroEncryptionBody =>
      'Notes synced to Nostr are end-to-end encrypted, so relay operators — and everyone else — can never read their content.';

  @override
  String get onboardingIntroAmberTitle => 'Sign in without exposing your key';

  @override
  String get onboardingIntroAmberBody =>
      'Use Amber to sign in: your private key stays in Amber and is never shared with Echoes.';

  @override
  String get onboardingIntroSecurityTitle => 'Security by design';

  @override
  String get onboardingIntroSecurityBody =>
      'Your private key lives in your device\'s encrypted keystore — or, with Amber, never touches Echoes at all. Photos and voice notes are encrypted before they ever leave your device. Notes can be locked with a password, and none of it is ever included in phone backups.';

  @override
  String get onboardingNextButton => 'Next';

  @override
  String get onboardingBackButton => 'Back';

  @override
  String get onboardingSkipButton => 'Skip — use Echoes locally only';

  @override
  String get onboardingRelayTitle => 'Choose relays for syncing';

  @override
  String get onboardingRelayBody =>
      'Relays are where your encrypted notes get stored when you sync. Add one or more — these popular ones are a good start:';

  @override
  String get onboardingFinishButton => 'Get started';

  @override
  String get syncNoteTooltip => 'Sync this note';

  @override
  String get unsyncNoteTooltip => 'Remove from relays';

  @override
  String get syncSelectedTooltip => 'Sync selected notes';

  @override
  String get exportSelectedTooltip => 'Export selected notes';

  @override
  String get deleteSelectedTooltip => 'Delete selected notes';

  @override
  String syncNoteError(String error) {
    return 'Could not sync note: $error';
  }

  @override
  String unsyncNoteError(String error) {
    return 'Could not remove note from relays: $error';
  }

  @override
  String deleteNoteRelayError(String error) {
    return 'Note deleted locally, but could not remove it from relays: $error';
  }

  @override
  String deleteNotesRelayError(int count) {
    return '$count note(s) deleted locally, but could not be removed from relays';
  }

  @override
  String get deletingNotesTitle => 'Deleting notes…';

  @override
  String deletingNotesProgress(int completed, int total) {
    return 'Deleting $completed of $total';
  }

  @override
  String get syncSelectedSuccess => 'Notes synced';

  @override
  String syncSelectedPartialError(int count) {
    return 'Could not sync $count note(s)';
  }

  @override
  String get exportConfirmTitle => 'Export notes';

  @override
  String get exportConfirmBody =>
      'Creates a backup file of your notes. It also includes the decryption keys for any attached images or voice notes — anyone with the file could read them unless it\'s encrypted.';

  @override
  String get exportEncryptToggleLabel => 'Encrypt this file';

  @override
  String get exportEncryptToggleSubtitle =>
      'Recommended — protects the backup with a password';

  @override
  String get exportPasswordDialogTitle => 'Enter your password';

  @override
  String get exportSetPasswordDialogTitle => 'Set a password for this export';

  @override
  String get importPasswordDialogTitle => 'Enter the export\'s password';

  @override
  String get sectionData => 'Data';

  @override
  String get exportNotesButton => 'Export notes';

  @override
  String get exportNotesSubtitle =>
      'Save all your notes to a file you can import again later';

  @override
  String get importNotesButton => 'Import notes';

  @override
  String get importNotesSubtitle =>
      'Restore notes from a file exported earlier';

  @override
  String get exportNotesSuccess => 'Notes exported';

  @override
  String exportNotesError(Object error) {
    return 'Could not export notes: $error';
  }

  @override
  String importNotesSuccess(int count) {
    return 'Imported $count note(s)';
  }

  @override
  String importNotesError(Object error) {
    return 'Could not import notes: $error';
  }

  @override
  String get sectionAttachments => 'Attachments';

  @override
  String get attachmentProviderSubtitle =>
      'Where encrypted images and voice notes are uploaded when you sync';

  @override
  String get attachmentProviderCustom => 'Custom…';

  @override
  String get attachmentCustomUrlLabel => 'Server URL';

  @override
  String get attachmentProviderHint =>
      'Some public hosts (e.g. Primal, nostr.build) reject encrypted uploads outright — they validate real image content, which ciphertext never is. Prefer a Blossom host that stores opaque blobs, or point Custom… at a self-hosted one.';

  @override
  String get sectionSupport => 'Support';

  @override
  String get supportEchoesTitle => 'Support Echoes';

  @override
  String lightningAddressCopied(String address) {
    return '⚡ $address copied to clipboard';
  }

  @override
  String get cancelButton => 'Cancel';

  @override
  String get passwordLabel => 'Password';

  @override
  String get invalidPrivateKeyError =>
      'The private key is not valid. Enter a valid nsec or hex key.';

  @override
  String get wrongPasswordError => 'Wrong password';

  @override
  String genericErrorPrefix(String error) {
    return 'Error: $error';
  }
}
