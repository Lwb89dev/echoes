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
  String get bunkerLoginButton => 'Entfernten Signierer verbinden (Bunker)';

  @override
  String get bunkerFieldLabel => 'Füge deinen bunker://-Verbindungstoken ein';

  @override
  String get bunkerConnectButton => 'Verbinden';

  @override
  String get bunkerAuthPrompt =>
      'Bestätige die Verbindung in deinem Signierer und komm zurück';

  @override
  String get relaysTitle => 'Relays';

  @override
  String get settingsTooltip => 'Einstellungen';

  @override
  String get searchTooltip => 'Suchen';

  @override
  String get closeSearchTooltip => 'Suche schließen';

  @override
  String get searchNotesHint => 'Notizen durchsuchen';

  @override
  String get noSearchResultsMessage => 'Keine Treffer.';

  @override
  String get emptyNotesMessage =>
      'Noch keine Notizen. Tippe auf +, um eine zu erstellen.';

  @override
  String get notesTabLabel => 'Notizen';

  @override
  String get diaryTabLabel => 'Tagebuch';

  @override
  String get emptyDiaryMessage =>
      'Noch keine Tagebucheinträge. Tippe auf +, um einen zu schreiben.';

  @override
  String get diaryToday => 'Heute';

  @override
  String get diaryYesterday => 'Gestern';

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
  String get saveTooltip => 'Speichern';

  @override
  String get titleFieldLabel => 'Titel';

  @override
  String get bodyFieldHint => 'Hier schreiben... (Markdown wird unterstützt)';

  @override
  String get checklistItemHint => 'Listeneintrag';

  @override
  String get addItemButton => 'Eintrag hinzufügen';

  @override
  String checklistProgress(int done, int total) {
    return '$done von $total erledigt';
  }

  @override
  String get showCompletedItemsTooltip => 'Erledigte Einträge anzeigen';

  @override
  String get hideCompletedItemsTooltip => 'Erledigte Einträge ausblenden';

  @override
  String get allChecklistItemsCompletedHidden =>
      'Alle Einträge sind erledigt und ausgeblendet.';

  @override
  String get deleteCompletedItemsButton => 'Erledigte Einträge löschen';

  @override
  String get deleteCompletedItemsConfirmTitle => 'Erledigte Einträge löschen?';

  @override
  String deleteCompletedItemsConfirmBody(int count) {
    return 'Dadurch werden $count abgehakte Einträge aus dieser Checkliste entfernt. Das kann nicht rückgängig gemacht werden.';
  }

  @override
  String get addImageButton => 'Bild hinzufügen';

  @override
  String get noteColorButton => 'Notizfarbe';

  @override
  String get noteColorDefault => 'Standard';

  @override
  String get noteColorYellow => 'Gelb';

  @override
  String get noteColorRed => 'Rot';

  @override
  String get noteColorPurple => 'Violett';

  @override
  String get noteColorBlue => 'Blau';

  @override
  String get noteColorGreen => 'Grün';

  @override
  String get noteColorOrange => 'Orange';

  @override
  String get noteColorWhite => 'Weiß';

  @override
  String get recordVoiceNoteTooltip => 'Sprachnotiz aufnehmen';

  @override
  String get recordVoiceNoteInstructions =>
      'Tippe auf den roten Knopf, um die Aufnahme zu starten, oder auf ✕ zum Abbrechen.';

  @override
  String get stopRecordingTooltip => 'Aufnahme stoppen';

  @override
  String get cancelRecordingTooltip => 'Aufnahme abbrechen';

  @override
  String get addVoiceTimestampButton => 'Zeitstempel hinzufügen';

  @override
  String get editVoiceTimestampButton => 'Zeitstempel bearbeiten';

  @override
  String get voiceNoteUnsupportedOnPlatform =>
      'Sprachnotizen werden auf diesem Gerät nicht unterstützt';

  @override
  String get formatBoldTooltip => 'Fett';

  @override
  String get formatItalicTooltip => 'Kursiv';

  @override
  String get formatHeadingTooltip => 'Überschrift';

  @override
  String get formatListTooltip => 'Aufzählung';

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
  String get noteLayoutToggleTitle =>
      'Zwischen Listen- und Rasteransicht wechseln';

  @override
  String get manageRelaysTitle => 'Relais verwalten';

  @override
  String get republishAllNotesButton =>
      'Alle synchronisierten Notizen erneut veröffentlichen';

  @override
  String get republishAllNotesSubtitle =>
      'Füllt jedes Relais oben mit bereits anderswo geteilten Notizen auf — nützlich direkt nach dem Hinzufügen eines neuen, z. B. eines selbst gehosteten Backup-Relais';

  @override
  String republishAllNotesSuccess(int count) {
    return '$count Notizen erneut veröffentlicht';
  }

  @override
  String republishAllNotesError(String error) {
    return 'Notizen konnten nicht erneut veröffentlicht werden: $error';
  }

  @override
  String get forceFullResyncButton =>
      'Vollständige Neusynchronisierung erzwingen';

  @override
  String get forceFullResyncSubtitle =>
      'Prüft Relays erneut auf die komplette Verlaufshistorie einer Notiz statt nur auf Neues — nützlich, wenn die Synchronisierung feststeckt und ältere Notizen überspringt, z. B. nach der Behebung eines nicht erreichbaren Relays';

  @override
  String get forceFullResyncSuccess => 'Notizen von Relays aktualisiert';

  @override
  String forceFullResyncError(String error) {
    return 'Notizen konnten nicht neu synchronisiert werden: $error';
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
      'Manche öffentlichen Hosts (z. B. Primal, nostr.build) lehnen verschlüsselte Uploads grundsätzlich ab — sie prüfen auf echten Bildinhalt, was verschlüsselte Daten nie sind. Bevorzuge einen Blossom-Host, der beliebige Daten speichert, oder richte „Benutzerdefiniert…“ auf einen selbst gehosteten.';

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

  @override
  String get shareNoteTooltip => 'Teilen';

  @override
  String get shareNoteTitle => 'Notiz teilen';

  @override
  String get shareRecipientFieldLabel =>
      'npub oder öffentlicher Schlüssel des Empfängers';

  @override
  String get shareAddRecipientButton => 'Hinzufügen';

  @override
  String get shareInvalidRecipientError =>
      'Das ist kein gültiger npub oder öffentlicher Schlüssel';

  @override
  String get shareRecipientNotFoundError =>
      'Kein Nostr-Konto für diesen Namen gefunden';

  @override
  String get shareConfirmTitle => 'Diese Notiz teilen?';

  @override
  String get shareConfirmButton => 'Teilen';

  @override
  String get shareAlreadyRecipientError => 'Bereits mit dieser Person geteilt';

  @override
  String get shareCannotShareWithSelfError =>
      'Du kannst eine Notiz nicht mit dir selbst teilen';

  @override
  String get shareRecipientsHeader => 'Geteilt mit';

  @override
  String get shareNoRecipientsMessage => 'Noch mit niemandem geteilt.';

  @override
  String get stopSharingTooltip => 'Teilen mit dieser Person beenden';

  @override
  String get shareRevocationNote =>
      'Jeder, mit dem du teilst, kann diese Notiz auf seinem Gerät lesen. Jemanden zu entfernen stoppt künftige Aktualisierungen an ihn, kann aber bereits Erhaltenes nicht löschen.';

  @override
  String shareError(String error) {
    return 'Freigabe konnte nicht aktualisiert werden: $error';
  }

  @override
  String get sharedWithMeHeader => 'Mit dir geteilt';

  @override
  String sharedByLabel(String npub) {
    return 'Geteilt von $npub';
  }

  @override
  String get sharedNoteEditableNote =>
      'Du kannst diese Notiz bearbeiten; deine Änderungen werden zurück an den Eigentümer synchronisiert, der sie zusammenführt.';

  @override
  String get abandonSharedNoteButton => 'Diese geteilte Notiz verlassen';

  @override
  String get abandonSharedNoteConfirmTitle => 'Diese geteilte Notiz verlassen?';

  @override
  String get abandonSharedNoteConfirmBody =>
      'Sie wird von diesem Gerät entfernt und du erhältst keine Aktualisierungen mehr. Das kann nicht rückgängig gemacht werden — du kannst später nicht wieder beitreten.';

  @override
  String abandonSharedNoteError(String error) {
    return 'Verlassen fehlgeschlagen: $error';
  }
}
