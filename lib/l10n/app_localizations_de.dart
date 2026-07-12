// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get loginSubtitle => 'Melde dich mit deinem Nostr-Konto an';

  @override
  String get loginWithAmberButton => 'Mit Amber anmelden';

  @override
  String get importAccountButton => 'Nostr-Konto importieren';

  @override
  String get importAccountFieldLabel =>
      'Privater Schlüssel (nsec) deines Nostr-Kontos';

  @override
  String get importButton => 'Importieren';

  @override
  String get relaysTitle => 'Relays';

  @override
  String get settingsTooltip => 'Einstellungen';

  @override
  String get emptyNotesMessage =>
      'Noch keine Notizen. Tippe auf +, um eine zu erstellen.';

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
  String get newPlainNoteOption => 'Notiz';

  @override
  String get newChecklistOption => 'Checkliste';

  @override
  String get newVoiceNoteOption => 'Sprachnotiz';

  @override
  String get deleteNoteButton => 'Notiz löschen';

  @override
  String get deleteNoteConfirmTitle => 'Diese Notiz löschen?';

  @override
  String get deleteNoteConfirmBody =>
      'Dies kann nicht rückgängig gemacht werden. Wenn diese Notiz synchronisiert war, wird sie auch von deinen Relais entfernt.';

  @override
  String deleteNotesConfirmTitle(int count) {
    return '$count Notizen löschen?';
  }

  @override
  String get deleteNotesConfirmBody =>
      'Dies kann nicht rückgängig gemacht werden. Wenn eine dieser Notizen synchronisiert war, wird sie auch von deinen Relais entfernt.';

  @override
  String selectionCount(int count) {
    return '$count ausgewählt';
  }

  @override
  String get untitledNote => '(ohne Titel)';

  @override
  String errorLoadingNotes(String error) {
    return 'Fehler beim Laden der Notizen: $error';
  }

  @override
  String get timeJustNow => 'gerade eben';

  @override
  String timeMinutesAgo(int count) {
    return 'vor $count Min.';
  }

  @override
  String timeHoursAgo(int count) {
    return 'vor $count Std.';
  }

  @override
  String timeDaysAgo(int count) {
    return 'vor $count Tg.';
  }

  @override
  String get notesLockedTitle => 'Notizen sind mit einem Passwort geschützt';

  @override
  String get unlockButton => 'Entsperren';

  @override
  String get newNoteTitle => 'Neue Notiz';

  @override
  String get editNoteTitle => 'Notiz bearbeiten';

  @override
  String get newDiaryEntryTitle => 'New diary entry';

  @override
  String get editDiaryEntryTitle => 'Edit diary entry';

  @override
  String get saveTooltip => 'Speichern';

  @override
  String get titleFieldLabel => 'Titel';

  @override
  String get checklistLabel => 'Checkliste';

  @override
  String get bodyFieldHint => 'Hier schreiben... (Markdown wird unterstützt)';

  @override
  String get checklistItemHint => 'Listeneintrag';

  @override
  String get addItemButton => 'Eintrag hinzufügen';

  @override
  String get addImageButton => 'Bild hinzufügen';

  @override
  String get recordVoiceNoteTooltip => 'Sprachnotiz aufnehmen';

  @override
  String get stopRecordingTooltip => 'Aufnahme stoppen';

  @override
  String get cancelRecordingTooltip => 'Aufnahme abbrechen';

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
  String get imageSizeSmall => 'Klein';

  @override
  String get imageSizeMedium => 'Mittel';

  @override
  String get imageSizeFull => 'Volle Breite';

  @override
  String get removeImageButton => 'Bild entfernen';

  @override
  String get relayUrlHint => 'wss://relay.example.com';

  @override
  String get noRelaysMessage => 'Noch kein Relay konfiguriert.';

  @override
  String relaysCount(int count) {
    return '$count Relais';
  }

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get sectionSecurity => 'Sicherheit';

  @override
  String get loadingLabel => 'Wird geladen…';

  @override
  String get encryptionLoadError =>
      'Verschlüsselungseinstellungen konnten nicht geladen werden';

  @override
  String get encryptionToggleTitle => 'Notizen mit einem Passwort schützen';

  @override
  String get encryptionToggleSubtitle =>
      'Verschlüsselt gespeicherte Notizen (AES-256-GCM) mit einem aus deinem Passwort abgeleiteten Schlüssel. Das Passwort wird nie gespeichert — vergisst du es, können die Notizen nicht wiederhergestellt werden.';

  @override
  String get lockNotesNowTitle => 'Notizen jetzt sperren';

  @override
  String get lockNotesNowSubtitle =>
      'Zum Anzeigen der Notizen ist erneut das Passwort erforderlich';

  @override
  String get setPasswordDialogTitle => 'Passwort festlegen';

  @override
  String get passwordTooShortError => 'Mindestens 8 Zeichen';

  @override
  String get confirmPasswordLabel => 'Passwort bestätigen';

  @override
  String get passwordsDoNotMatchError => 'Passwörter stimmen nicht überein';

  @override
  String enableEncryptionError(String error) {
    return 'Verschlüsselung konnte nicht aktiviert werden: $error';
  }

  @override
  String get enableButton => 'Aktivieren';

  @override
  String get disablePasswordDialogTitle =>
      'Gib dein Passwort ein, um die Verschlüsselung zu deaktivieren';

  @override
  String get disableButton => 'Deaktivieren';

  @override
  String get sectionAppearance => 'Erscheinungsbild';

  @override
  String get lightThemeToggleTitle => 'Helles Design';

  @override
  String get lightThemeToggleSubtitle =>
      'Helles statt dunkles Farbschema verwenden';

  @override
  String get noteLayoutToggleTitle => 'Notizlisten-Layout';

  @override
  String get noteLayoutToggleSubtitle =>
      'Zwischen Listen- und Rasteransicht wechseln';

  @override
  String get manageRelaysTitle => 'Relais verwalten';

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
  String get confirmButton => 'Bestätigen';

  @override
  String get sectionLanguage => 'Sprache';

  @override
  String get langSystem => 'Systemstandard';

  @override
  String get sectionAccount => 'Konto';

  @override
  String get accountLocalOnlyMessage =>
      'Echoes wird lokal verwendet — keine Synchronisierung mit Nostr';

  @override
  String get accountSignInButton => 'Anmelden';

  @override
  String accountSignedInAs(String npub) {
    return 'Angemeldet als $npub';
  }

  @override
  String get accountSignOutButton => 'Abmelden';

  @override
  String get accountSignOutConfirmTitle => 'Abmelden?';

  @override
  String get accountSignOutConfirmBody =>
      'Deine Notizen bleiben auf diesem Gerät. Du kannst dich jederzeit wieder anmelden.';

  @override
  String get onboardingWelcomeTitle => 'Willkommen bei Echoes';

  @override
  String get onboardingIntroLocalTitle =>
      'Deine Notizen, immer auf deinem Gerät';

  @override
  String get onboardingIntroLocalBody =>
      'Jede Notiz wird zuerst lokal gespeichert, sodass die App vollständig offline funktioniert. Nichts verlässt dein Gerät, es sei denn, du entscheidest dich für die Synchronisierung.';

  @override
  String get onboardingIntroSyncTitle =>
      'Optionale Synchronisierung über Nostr';

  @override
  String get onboardingIntroSyncBody =>
      'Aktiviere die Synchronisierung, um deine Notizen zu sichern und sie auf anderen Geräten zu lesen — über das offene Nostr-Protokoll und Relays deiner Wahl.';

  @override
  String get onboardingIntroEncryptionTitle => 'Immer verschlüsselt';

  @override
  String get onboardingIntroEncryptionBody =>
      'Mit Nostr synchronisierte Notizen sind Ende-zu-Ende-verschlüsselt, sodass Relay-Betreiber — und alle anderen — ihren Inhalt niemals lesen können.';

  @override
  String get onboardingIntroAmberTitle =>
      'Anmelden, ohne deinen Schlüssel preiszugeben';

  @override
  String get onboardingIntroAmberBody =>
      'Melde dich mit Amber an: Dein privater Schlüssel bleibt in Amber und wird niemals mit Echoes geteilt.';

  @override
  String get onboardingIntroSecurityTitle => 'Sicherheit von Grund auf';

  @override
  String get onboardingIntroSecurityBody =>
      'Dein privater Schlüssel liegt im verschlüsselten Schlüsselspeicher deines Geräts — oder kommt mit Amber überhaupt nie mit Echoes in Berührung. Fotos und Sprachnotizen werden verschlüsselt, bevor sie dein Gerät verlassen. Notizen können mit einem Passwort gesperrt werden, und nichts davon landet jemals in Telefon-Backups.';

  @override
  String get onboardingNextButton => 'Weiter';

  @override
  String get onboardingBackButton => 'Zurück';

  @override
  String get onboardingSkipButton => 'Überspringen — Echoes nur lokal nutzen';

  @override
  String get onboardingRelayTitle => 'Relays für die Synchronisierung wählen';

  @override
  String get onboardingRelayBody =>
      'Relays sind der Ort, an dem deine verschlüsselten Notizen bei der Synchronisierung gespeichert werden. Füge eines oder mehrere hinzu — diese beliebten sind ein guter Anfang:';

  @override
  String get onboardingFinishButton => 'Los geht\'s';

  @override
  String get syncNoteTooltip => 'Diese Notiz synchronisieren';

  @override
  String get unsyncNoteTooltip => 'Von Relais entfernen';

  @override
  String get syncSelectedTooltip => 'Ausgewählte Notizen synchronisieren';

  @override
  String get exportSelectedTooltip => 'Ausgewählte Notizen exportieren';

  @override
  String get deleteSelectedTooltip => 'Ausgewählte Notizen löschen';

  @override
  String syncNoteError(String error) {
    return 'Notiz konnte nicht synchronisiert werden: $error';
  }

  @override
  String unsyncNoteError(String error) {
    return 'Notiz konnte nicht von den Relais entfernt werden: $error';
  }

  @override
  String deleteNoteRelayError(String error) {
    return 'Notiz lokal gelöscht, konnte aber nicht von den Relais entfernt werden: $error';
  }

  @override
  String deleteNotesRelayError(int count) {
    return '$count Notizen lokal gelöscht, konnten aber nicht von den Relais entfernt werden';
  }

  @override
  String get deletingNotesTitle => 'Notizen werden gelöscht…';

  @override
  String deletingNotesProgress(int completed, int total) {
    return 'Lösche $completed von $total';
  }

  @override
  String get syncSelectedSuccess => 'Notizen synchronisiert';

  @override
  String syncSelectedPartialError(int count) {
    return '$count Notizen konnten nicht synchronisiert werden';
  }

  @override
  String get exportConfirmTitle => 'Notizen exportieren';

  @override
  String get exportConfirmBody =>
      'Erstellt eine Sicherungsdatei deiner Notizen. Sie enthält auch die Entschlüsselungscodes für angehängte Bilder oder Sprachnotizen — jeder mit der Datei könnte sie lesen, sofern sie nicht verschlüsselt ist.';

  @override
  String get exportEncryptToggleLabel => 'Diese Datei verschlüsseln';

  @override
  String get exportEncryptToggleSubtitle =>
      'Empfohlen — schützt die Sicherung mit einem Passwort';

  @override
  String get exportPasswordDialogTitle => 'Gib dein Passwort ein';

  @override
  String get exportSetPasswordDialogTitle =>
      'Lege ein Passwort für diesen Export fest';

  @override
  String get importPasswordDialogTitle => 'Gib das Passwort des Exports ein';

  @override
  String get sectionData => 'Daten';

  @override
  String get exportNotesButton => 'Notizen exportieren';

  @override
  String get exportNotesSubtitle =>
      'Speichere alle deine Notizen in einer Datei, die du später wieder importieren kannst';

  @override
  String get importNotesButton => 'Notizen importieren';

  @override
  String get importNotesSubtitle =>
      'Notizen aus einer zuvor exportierten Datei wiederherstellen';

  @override
  String get exportNotesSuccess => 'Notizen exportiert';

  @override
  String exportNotesError(Object error) {
    return 'Notizen konnten nicht exportiert werden: $error';
  }

  @override
  String importNotesSuccess(int count) {
    return '$count Notizen importiert';
  }

  @override
  String importNotesError(Object error) {
    return 'Notizen konnten nicht importiert werden: $error';
  }

  @override
  String get sectionAttachments => 'Anhänge';

  @override
  String get attachmentProviderSubtitle =>
      'Wohin verschlüsselte Bilder und Sprachnotizen beim Synchronisieren hochgeladen werden';

  @override
  String get attachmentProviderCustom => 'Benutzerdefiniert…';

  @override
  String get attachmentCustomUrlLabel => 'Server-URL';

  @override
  String get attachmentProviderHint =>
      'Some public hosts (e.g. Primal, nostr.build) reject encrypted uploads outright — they validate real image content, which ciphertext never is. Prefer a Blossom host that stores opaque blobs, or point Custom… at a self-hosted one.';

  @override
  String get sectionSupport => 'Unterstützung';

  @override
  String get supportEchoesTitle => 'Echoes unterstützen';

  @override
  String lightningAddressCopied(String address) {
    return '⚡ $address in die Zwischenablage kopiert';
  }

  @override
  String get cancelButton => 'Abbrechen';

  @override
  String get passwordLabel => 'Passwort';

  @override
  String get invalidPrivateKeyError =>
      'Der private Schlüssel ist ungültig. Gib einen gültigen nsec- oder Hex-Schlüssel ein.';

  @override
  String get wrongPasswordError => 'Falsches Passwort';

  @override
  String genericErrorPrefix(String error) {
    return 'Fehler: $error';
  }
}
