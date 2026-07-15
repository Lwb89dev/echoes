// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get loginSubtitle => 'Log ind med din Nostr-konto';

  @override
  String get loginWithAmberButton => 'Log ind med Amber';

  @override
  String get importAccountButton => 'Importér Nostr-konto';

  @override
  String get importAccountFieldLabel =>
      'Privat nøgle (nsec) til din Nostr-konto';

  @override
  String get importButton => 'Importér';

  @override
  String get relaysTitle => 'Relæer';

  @override
  String get settingsTooltip => 'Indstillinger';

  @override
  String get searchTooltip => 'Search';

  @override
  String get closeSearchTooltip => 'Close search';

  @override
  String get searchNotesHint => 'Search notes';

  @override
  String get noSearchResultsMessage => 'No matches.';

  @override
  String get emptyNotesMessage =>
      'Ingen noter endnu. Tryk på + for at oprette en.';

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
  String get newChecklistOption => 'Tjekliste';

  @override
  String get newVoiceNoteOption => 'Talenote';

  @override
  String get deleteNoteButton => 'Slet note';

  @override
  String get deleteNoteConfirmTitle => 'Slet denne note?';

  @override
  String get deleteNoteConfirmBody =>
      'Dette kan ikke fortrydes. Hvis noten var synkroniseret, fjernes den også fra dine reléer.';

  @override
  String deleteNotesConfirmTitle(int count) {
    return 'Slet $count noter?';
  }

  @override
  String get deleteNotesConfirmBody =>
      'Dette kan ikke fortrydes. Hvis nogen af disse noter var synkroniseret, fjernes de også fra dine reléer.';

  @override
  String selectionCount(int count) {
    return '$count valgt';
  }

  @override
  String get untitledNote => '(uden titel)';

  @override
  String errorLoadingNotes(String error) {
    return 'Fejl ved indlæsning af noter: $error';
  }

  @override
  String get timeJustNow => 'lige nu';

  @override
  String timeMinutesAgo(int count) {
    return 'for $count min. siden';
  }

  @override
  String timeHoursAgo(int count) {
    return 'for $count t. siden';
  }

  @override
  String timeDaysAgo(int count) {
    return 'for $count dage siden';
  }

  @override
  String get notesLockedTitle => 'Noter er beskyttet med en adgangskode';

  @override
  String get unlockButton => 'Lås op';

  @override
  String get saveTooltip => 'Gem';

  @override
  String get titleFieldLabel => 'Titel';

  @override
  String get checklistLabel => 'Tjekliste';

  @override
  String get bodyFieldHint => 'Skriv her... (markdown understøttes)';

  @override
  String get checklistItemHint => 'Punkt på tjekliste';

  @override
  String get addItemButton => 'Tilføj punkt';

  @override
  String checklistProgress(int done, int total) {
    return '$done of $total done';
  }

  @override
  String get showCompletedItemsTooltip => 'Show completed items';

  @override
  String get hideCompletedItemsTooltip => 'Hide completed items';

  @override
  String get allChecklistItemsCompletedHidden =>
      'All items are completed and hidden.';

  @override
  String get deleteCompletedItemsButton => 'Delete completed items';

  @override
  String get deleteCompletedItemsConfirmTitle => 'Delete completed items?';

  @override
  String deleteCompletedItemsConfirmBody(int count) {
    return 'This removes $count checked-off item(s) from this checklist. This can\'t be undone.';
  }

  @override
  String get addImageButton => 'Tilføj billede';

  @override
  String get noteColorButton => 'Note color';

  @override
  String get noteColorDefault => 'Default';

  @override
  String get noteColorYellow => 'Yellow';

  @override
  String get noteColorRed => 'Red';

  @override
  String get noteColorPurple => 'Purple';

  @override
  String get noteColorBlue => 'Blue';

  @override
  String get noteColorGreen => 'Green';

  @override
  String get noteColorOrange => 'Orange';

  @override
  String get noteColorWhite => 'White';

  @override
  String get recordVoiceNoteTooltip => 'Optag en talenote';

  @override
  String get recordVoiceNoteInstructions =>
      'Tap the red button to start recording, or ✕ to cancel.';

  @override
  String get stopRecordingTooltip => 'Stop optagelse';

  @override
  String get cancelRecordingTooltip => 'Annuller optagelse';

  @override
  String get addVoiceTimestampButton => 'Add timestamp';

  @override
  String get editVoiceTimestampButton => 'Edit timestamp';

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
  String get imageSizeSmall => 'Lille';

  @override
  String get imageSizeMedium => 'Mellem';

  @override
  String get imageSizeFull => 'Fuld bredde';

  @override
  String get removeImageButton => 'Fjern billede';

  @override
  String get relayUrlHint => 'wss://relay.example.com';

  @override
  String get noRelaysMessage => 'Intet relæ konfigureret endnu.';

  @override
  String relaysCount(int count) {
    return '$count relæer';
  }

  @override
  String get settingsTitle => 'Indstillinger';

  @override
  String get sectionSecurity => 'Sikkerhed';

  @override
  String get loadingLabel => 'Indlæser…';

  @override
  String get encryptionLoadError =>
      'Kunne ikke indlæse krypteringsindstillinger';

  @override
  String get encryptionToggleTitle => 'Beskyt noter med en adgangskode';

  @override
  String get encryptionToggleSubtitle =>
      'Krypterer gemte noter (AES-256-GCM) med en nøgle udledt af din adgangskode. Adgangskoden gemmes aldrig — glemmer du den, kan noterne ikke gendannes.';

  @override
  String get lockNotesNowTitle => 'Lås noter nu';

  @override
  String get lockNotesNowSubtitle => 'Kræver adgangskoden igen for at se noter';

  @override
  String get setPasswordDialogTitle => 'Angiv en adgangskode';

  @override
  String get passwordTooShortError => 'Mindst 8 tegn';

  @override
  String get confirmPasswordLabel => 'Bekræft adgangskode';

  @override
  String get passwordsDoNotMatchError => 'Adgangskoderne stemmer ikke overens';

  @override
  String enableEncryptionError(String error) {
    return 'Kunne ikke aktivere kryptering: $error';
  }

  @override
  String get enableButton => 'Aktivér';

  @override
  String get disablePasswordDialogTitle =>
      'Indtast din adgangskode for at deaktivere kryptering';

  @override
  String get disableButton => 'Deaktivér';

  @override
  String get sectionAppearance => 'Udseende';

  @override
  String get lightThemeToggleTitle => 'Lyst tema';

  @override
  String get lightThemeToggleSubtitle =>
      'Brug et lyst farveskema i stedet for mørkt';

  @override
  String get noteLayoutToggleTitle => 'Layout for notatliste';

  @override
  String get manageRelaysTitle => 'Administrer relæer';

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
  String get confirmButton => 'Bekræft';

  @override
  String get sectionLanguage => 'Sprog';

  @override
  String get langSystem => 'Systemstandard';

  @override
  String get sectionAccount => 'Konto';

  @override
  String get accountLocalOnlyMessage =>
      'Bruger Echoes lokalt — synkroniseres ikke med Nostr';

  @override
  String get accountSignInButton => 'Log ind';

  @override
  String accountSignedInAs(String npub) {
    return 'Logget ind som $npub';
  }

  @override
  String get accountSignOutButton => 'Log ud';

  @override
  String get accountSignOutConfirmTitle => 'Log ud?';

  @override
  String get accountSignOutConfirmBody =>
      'Dine noter forbliver på denne enhed. Du kan altid logge ind igen.';

  @override
  String get onboardingWelcomeTitle => 'Velkommen til Echoes';

  @override
  String get onboardingIntroLocalTitle => 'Dine noter, altid på din enhed';

  @override
  String get onboardingIntroLocalBody =>
      'Hver note gemmes først lokalt, så appen fungerer helt offline. Intet forlader din enhed, medmindre du vælger at synkronisere det.';

  @override
  String get onboardingIntroSyncTitle => 'Valgfri synkronisering via Nostr';

  @override
  String get onboardingIntroSyncBody =>
      'Slå synkronisering til for at sikkerhedskopiere dine noter og læse dem på andre enheder ved hjælp af den åbne Nostr-protokol og relæer efter eget valg.';

  @override
  String get onboardingIntroEncryptionTitle => 'Altid krypteret';

  @override
  String get onboardingIntroEncryptionBody =>
      'Noter, der synkroniseres til Nostr, er end-to-end-krypterede, så relæoperatører — og alle andre — aldrig kan læse deres indhold.';

  @override
  String get onboardingIntroAmberTitle => 'Log ind uden at afsløre din nøgle';

  @override
  String get onboardingIntroAmberBody =>
      'Brug Amber til at logge ind: din private nøgle forbliver i Amber og deles aldrig med Echoes.';

  @override
  String get onboardingIntroSecurityTitle => 'Sikkerhed fra bunden';

  @override
  String get onboardingIntroSecurityBody =>
      'Din private nøgle ligger i enhedens krypterede nøglelager — eller rører, med Amber, aldrig Echoes overhovedet. Billeder og talenoter krypteres, før de nogensinde forlader din enhed. Noter kan låses med en adgangskode, og intet af det indgår nogensinde i telefonbackups.';

  @override
  String get onboardingNextButton => 'Næste';

  @override
  String get onboardingBackButton => 'Tilbage';

  @override
  String get onboardingSkipButton => 'Spring over — brug kun Echoes lokalt';

  @override
  String get onboardingRelayTitle => 'Vælg relæer til synkronisering';

  @override
  String get onboardingRelayBody =>
      'Relæer er der, hvor dine krypterede noter gemmes, når du synkroniserer. Tilføj et eller flere — disse populære er en god start:';

  @override
  String get onboardingFinishButton => 'Kom i gang';

  @override
  String get syncNoteTooltip => 'Synkronisér denne note';

  @override
  String get unsyncNoteTooltip => 'Fjern fra reléer';

  @override
  String get syncSelectedTooltip => 'Synkroniser valgte noter';

  @override
  String get exportSelectedTooltip => 'Eksportér valgte noter';

  @override
  String get deleteSelectedTooltip => 'Slet valgte noter';

  @override
  String syncNoteError(String error) {
    return 'Kunne ikke synkronisere note: $error';
  }

  @override
  String unsyncNoteError(String error) {
    return 'Kunne ikke fjerne noten fra reléerne: $error';
  }

  @override
  String deleteNoteRelayError(String error) {
    return 'Noten blev slettet lokalt, men kunne ikke fjernes fra reléerne: $error';
  }

  @override
  String deleteNotesRelayError(int count) {
    return '$count noter slettet lokalt, men kunne ikke fjernes fra reléerne';
  }

  @override
  String get deletingNotesTitle => 'Sletter noter…';

  @override
  String deletingNotesProgress(int completed, int total) {
    return 'Sletter $completed af $total';
  }

  @override
  String get syncSelectedSuccess => 'Noter synkroniseret';

  @override
  String syncSelectedPartialError(int count) {
    return 'Kunne ikke synkronisere $count noter';
  }

  @override
  String get exportConfirmTitle => 'Eksportér noter';

  @override
  String get exportConfirmBody =>
      'Opretter en sikkerhedskopi af dine noter. Den indeholder også dekrypteringsnøglerne til vedhæftede billeder eller talenoter — enhver med filen kunne læse dem, medmindre den er krypteret.';

  @override
  String get exportEncryptToggleLabel => 'Krypter denne fil';

  @override
  String get exportEncryptToggleSubtitle =>
      'Anbefalet — beskytter sikkerhedskopien med en adgangskode';

  @override
  String get exportPasswordDialogTitle => 'Indtast din adgangskode';

  @override
  String get exportSetPasswordDialogTitle =>
      'Angiv en adgangskode til denne eksport';

  @override
  String get importPasswordDialogTitle => 'Indtast eksportens adgangskode';

  @override
  String get sectionData => 'Data';

  @override
  String get exportNotesButton => 'Eksportér noter';

  @override
  String get exportNotesSubtitle =>
      'Gem alle dine noter i en fil, du kan importere igen senere';

  @override
  String get importNotesButton => 'Importér noter';

  @override
  String get importNotesSubtitle =>
      'Gendan noter fra en tidligere eksporteret fil';

  @override
  String get exportNotesSuccess => 'Noter eksporteret';

  @override
  String exportNotesError(Object error) {
    return 'Kunne ikke eksportere noter: $error';
  }

  @override
  String importNotesSuccess(int count) {
    return 'Importerede $count noter';
  }

  @override
  String importNotesError(Object error) {
    return 'Kunne ikke importere noter: $error';
  }

  @override
  String get sectionAttachments => 'Vedhæftede filer';

  @override
  String get attachmentProviderSubtitle =>
      'Hvor krypterede billeder og talenoter uploades, når du synkroniserer';

  @override
  String get attachmentProviderCustom => 'Brugerdefineret…';

  @override
  String get attachmentCustomUrlLabel => 'Server-URL';

  @override
  String get attachmentProviderHint =>
      'Some public hosts (e.g. Primal, nostr.build) reject encrypted uploads outright — they validate real image content, which ciphertext never is. Prefer a Blossom host that stores opaque blobs, or point Custom… at a self-hosted one.';

  @override
  String get sectionSupport => 'Støtte';

  @override
  String get supportEchoesTitle => 'Støt Echoes';

  @override
  String lightningAddressCopied(String address) {
    return '⚡ $address kopieret til udklipsholderen';
  }

  @override
  String get cancelButton => 'Annullér';

  @override
  String get passwordLabel => 'Adgangskode';

  @override
  String get invalidPrivateKeyError =>
      'Den private nøgle er ikke gyldig. Indtast en gyldig nsec- eller hex-nøgle.';

  @override
  String get wrongPasswordError => 'Forkert adgangskode';

  @override
  String genericErrorPrefix(String error) {
    return 'Fejl: $error';
  }
}
