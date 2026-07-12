// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get loginSubtitle => 'Logga in med ditt Nostr-konto';

  @override
  String get loginWithAmberButton => 'Logga in med Amber';

  @override
  String get importAccountButton => 'Importera Nostr-konto';

  @override
  String get importAccountFieldLabel =>
      'Privat nyckel (nsec) för ditt Nostr-konto';

  @override
  String get importButton => 'Importera';

  @override
  String get relaysTitle => 'Reläer';

  @override
  String get settingsTooltip => 'Inställningar';

  @override
  String get emptyNotesMessage =>
      'Inga anteckningar än. Tryck på + för att skapa en.';

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
  String get newPlainNoteOption => 'Anteckning';

  @override
  String get newChecklistOption => 'Checklista';

  @override
  String get newVoiceNoteOption => 'Röstanteckning';

  @override
  String get deleteNoteButton => 'Ta bort anteckning';

  @override
  String get deleteNoteConfirmTitle => 'Ta bort den här anteckningen?';

  @override
  String get deleteNoteConfirmBody =>
      'Detta kan inte ångras. Om anteckningen var synkroniserad tas den även bort från dina reläer.';

  @override
  String deleteNotesConfirmTitle(int count) {
    return 'Ta bort $count anteckningar?';
  }

  @override
  String get deleteNotesConfirmBody =>
      'Detta kan inte ångras. Om någon av dessa anteckningar var synkroniserad tas den även bort från dina reläer.';

  @override
  String selectionCount(int count) {
    return '$count markerade';
  }

  @override
  String get untitledNote => '(utan titel)';

  @override
  String errorLoadingNotes(String error) {
    return 'Fel vid inläsning av anteckningar: $error';
  }

  @override
  String get timeJustNow => 'nu';

  @override
  String timeMinutesAgo(int count) {
    return '${count}m sedan';
  }

  @override
  String timeHoursAgo(int count) {
    return '${count}h sedan';
  }

  @override
  String timeDaysAgo(int count) {
    return '${count}d sedan';
  }

  @override
  String get notesLockedTitle => 'Anteckningarna skyddas med ett lösenord';

  @override
  String get unlockButton => 'Lås upp';

  @override
  String get newNoteTitle => 'Ny anteckning';

  @override
  String get editNoteTitle => 'Redigera anteckning';

  @override
  String get newDiaryEntryTitle => 'New diary entry';

  @override
  String get editDiaryEntryTitle => 'Edit diary entry';

  @override
  String get saveTooltip => 'Spara';

  @override
  String get titleFieldLabel => 'Titel';

  @override
  String get checklistLabel => 'Checklista';

  @override
  String get bodyFieldHint => 'Skriv här... (markdown stöds)';

  @override
  String get checklistItemHint => 'Checklisteobjekt';

  @override
  String get addItemButton => 'Lägg till objekt';

  @override
  String get addImageButton => 'Lägg till bild';

  @override
  String get recordVoiceNoteTooltip => 'Spela in en röstanteckning';

  @override
  String get stopRecordingTooltip => 'Stoppa inspelning';

  @override
  String get cancelRecordingTooltip => 'Avbryt inspelning';

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
  String get imageSizeSmall => 'Liten';

  @override
  String get imageSizeMedium => 'Medium';

  @override
  String get imageSizeFull => 'Full bredd';

  @override
  String get removeImageButton => 'Ta bort bild';

  @override
  String get relayUrlHint => 'wss://relay.example.com';

  @override
  String get noRelaysMessage => 'Inget relä har konfigurerats än.';

  @override
  String relaysCount(int count) {
    return '$count reläer';
  }

  @override
  String get settingsTitle => 'Inställningar';

  @override
  String get sectionSecurity => 'Säkerhet';

  @override
  String get loadingLabel => 'Läser in…';

  @override
  String get encryptionLoadError =>
      'Kunde inte läsa in krypteringsinställningarna';

  @override
  String get encryptionToggleTitle => 'Skydda anteckningar med ett lösenord';

  @override
  String get encryptionToggleSubtitle =>
      'Krypterar lagrade anteckningar (AES-256-GCM) med en nyckel som härleds från ditt lösenord. Lösenordet lagras aldrig — glömmer du det kan anteckningarna inte återställas.';

  @override
  String get lockNotesNowTitle => 'Lås anteckningar nu';

  @override
  String get lockNotesNowSubtitle =>
      'Lösenordet krävs igen för att visa anteckningarna';

  @override
  String get setPasswordDialogTitle => 'Ange ett lösenord';

  @override
  String get passwordTooShortError => 'Minst 8 tecken';

  @override
  String get confirmPasswordLabel => 'Bekräfta lösenord';

  @override
  String get passwordsDoNotMatchError => 'Lösenorden matchar inte';

  @override
  String enableEncryptionError(String error) {
    return 'Kunde inte aktivera kryptering: $error';
  }

  @override
  String get enableButton => 'Aktivera';

  @override
  String get disablePasswordDialogTitle =>
      'Ange ditt lösenord för att inaktivera kryptering';

  @override
  String get disableButton => 'Inaktivera';

  @override
  String get sectionAppearance => 'Utseende';

  @override
  String get lightThemeToggleTitle => 'Ljust tema';

  @override
  String get lightThemeToggleSubtitle =>
      'Använd ett ljust färgschema istället för mörkt';

  @override
  String get noteLayoutToggleTitle => 'Layout för anteckningslista';

  @override
  String get noteLayoutToggleSubtitle => 'Växla mellan list- och rutnätsvy';

  @override
  String get manageRelaysTitle => 'Hantera reläer';

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
  String get confirmButton => 'Bekräfta';

  @override
  String get sectionLanguage => 'Språk';

  @override
  String get langSystem => 'Systemstandard';

  @override
  String get sectionAccount => 'Konto';

  @override
  String get accountLocalOnlyMessage =>
      'Använder Echoes lokalt — synkroniseras inte med Nostr';

  @override
  String get accountSignInButton => 'Logga in';

  @override
  String accountSignedInAs(String npub) {
    return 'Inloggad som $npub';
  }

  @override
  String get accountSignOutButton => 'Logga ut';

  @override
  String get accountSignOutConfirmTitle => 'Logga ut?';

  @override
  String get accountSignOutConfirmBody =>
      'Dina anteckningar finns kvar på den här enheten. Du kan logga in igen när som helst.';

  @override
  String get onboardingWelcomeTitle => 'Välkommen till Echoes';

  @override
  String get onboardingIntroLocalTitle =>
      'Dina anteckningar, alltid på din enhet';

  @override
  String get onboardingIntroLocalBody =>
      'Varje anteckning sparas först lokalt, så appen fungerar helt offline. Inget lämnar din enhet om du inte väljer att synkronisera det.';

  @override
  String get onboardingIntroSyncTitle => 'Valfri synkronisering via Nostr';

  @override
  String get onboardingIntroSyncBody =>
      'Slå på synkronisering för att säkerhetskopiera dina anteckningar och läsa dem på andra enheter, med hjälp av det öppna Nostr-protokollet och reläer du väljer.';

  @override
  String get onboardingIntroEncryptionTitle => 'Alltid krypterat';

  @override
  String get onboardingIntroEncryptionBody =>
      'Anteckningar som synkroniseras till Nostr är end-to-end-krypterade, så relädrifter — och alla andra — kan aldrig läsa innehållet.';

  @override
  String get onboardingIntroAmberTitle =>
      'Logga in utan att exponera din nyckel';

  @override
  String get onboardingIntroAmberBody =>
      'Använd Amber för att logga in: din privata nyckel stannar i Amber och delas aldrig med Echoes.';

  @override
  String get onboardingIntroSecurityTitle => 'Säkerhet från grunden';

  @override
  String get onboardingIntroSecurityBody =>
      'Din privata nyckel finns i enhetens krypterade nyckellager — eller, med Amber, rör den aldrig Echoes alls. Foton och röstanteckningar krypteras innan de någonsin lämnar din enhet. Anteckningar kan låsas med ett lösenord, och inget av detta ingår någonsin i telefonens säkerhetskopior.';

  @override
  String get onboardingNextButton => 'Nästa';

  @override
  String get onboardingBackButton => 'Tillbaka';

  @override
  String get onboardingSkipButton => 'Hoppa över — använd Echoes endast lokalt';

  @override
  String get onboardingRelayTitle => 'Välj reläer för synkronisering';

  @override
  String get onboardingRelayBody =>
      'Reläer är där dina krypterade anteckningar lagras när du synkroniserar. Lägg till en eller flera — dessa populära är en bra start:';

  @override
  String get onboardingFinishButton => 'Kom igång';

  @override
  String get syncNoteTooltip => 'Synkronisera denna anteckning';

  @override
  String get unsyncNoteTooltip => 'Ta bort från reläer';

  @override
  String get syncSelectedTooltip => 'Synkronisera markerade anteckningar';

  @override
  String get exportSelectedTooltip => 'Exportera markerade anteckningar';

  @override
  String get deleteSelectedTooltip => 'Ta bort markerade anteckningar';

  @override
  String syncNoteError(String error) {
    return 'Det gick inte att synkronisera anteckningen: $error';
  }

  @override
  String unsyncNoteError(String error) {
    return 'Det gick inte att ta bort anteckningen från reläerna: $error';
  }

  @override
  String deleteNoteRelayError(String error) {
    return 'Anteckningen togs bort lokalt, men det gick inte att ta bort den från reläerna: $error';
  }

  @override
  String deleteNotesRelayError(int count) {
    return '$count anteckningar togs bort lokalt, men det gick inte att ta bort dem från reläerna';
  }

  @override
  String get deletingNotesTitle => 'Tar bort anteckningar…';

  @override
  String deletingNotesProgress(int completed, int total) {
    return 'Tar bort $completed av $total';
  }

  @override
  String get syncSelectedSuccess => 'Anteckningar synkroniserade';

  @override
  String syncSelectedPartialError(int count) {
    return 'Det gick inte att synkronisera $count anteckningar';
  }

  @override
  String get exportConfirmTitle => 'Exportera anteckningar';

  @override
  String get exportConfirmBody =>
      'Skapar en säkerhetskopia av dina anteckningar. Den innehåller även dekrypteringsnycklarna för eventuella bifogade bilder eller röstanteckningar — vem som helst med filen skulle kunna läsa dem om den inte är krypterad.';

  @override
  String get exportEncryptToggleLabel => 'Kryptera denna fil';

  @override
  String get exportEncryptToggleSubtitle =>
      'Rekommenderas — skyddar säkerhetskopian med ett lösenord';

  @override
  String get exportPasswordDialogTitle => 'Ange ditt lösenord';

  @override
  String get exportSetPasswordDialogTitle =>
      'Ange ett lösenord för denna export';

  @override
  String get importPasswordDialogTitle => 'Ange exportens lösenord';

  @override
  String get sectionData => 'Data';

  @override
  String get exportNotesButton => 'Exportera anteckningar';

  @override
  String get exportNotesSubtitle =>
      'Spara alla dina anteckningar i en fil som du kan importera igen senare';

  @override
  String get importNotesButton => 'Importera anteckningar';

  @override
  String get importNotesSubtitle =>
      'Återställ anteckningar från en tidigare exporterad fil';

  @override
  String get exportNotesSuccess => 'Anteckningar exporterade';

  @override
  String exportNotesError(Object error) {
    return 'Det gick inte att exportera anteckningarna: $error';
  }

  @override
  String importNotesSuccess(int count) {
    return '$count anteckningar importerade';
  }

  @override
  String importNotesError(Object error) {
    return 'Det gick inte att importera anteckningarna: $error';
  }

  @override
  String get sectionAttachments => 'Bilagor';

  @override
  String get attachmentProviderSubtitle =>
      'Var krypterade bilder och röstanteckningar laddas upp vid synkronisering';

  @override
  String get attachmentProviderCustom => 'Anpassad…';

  @override
  String get attachmentCustomUrlLabel => 'Server-URL';

  @override
  String get attachmentProviderHint =>
      'Some public hosts (e.g. Primal, nostr.build) reject encrypted uploads outright — they validate real image content, which ciphertext never is. Prefer a Blossom host that stores opaque blobs, or point Custom… at a self-hosted one.';

  @override
  String get sectionSupport => 'Stöd';

  @override
  String get supportEchoesTitle => 'Stöd Echoes';

  @override
  String lightningAddressCopied(String address) {
    return '⚡ $address kopierad till urklipp';
  }

  @override
  String get cancelButton => 'Avbryt';

  @override
  String get passwordLabel => 'Lösenord';

  @override
  String get invalidPrivateKeyError =>
      'Den privata nyckeln är ogiltig. Ange en giltig nsec- eller hex-nyckel.';

  @override
  String get wrongPasswordError => 'Fel lösenord';

  @override
  String genericErrorPrefix(String error) {
    return 'Fel: $error';
  }
}
