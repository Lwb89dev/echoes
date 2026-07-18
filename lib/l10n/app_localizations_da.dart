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
  String get searchTooltip => 'Søg';

  @override
  String get closeSearchTooltip => 'Luk søgning';

  @override
  String get searchNotesHint => 'Søg i noter';

  @override
  String get noSearchResultsMessage => 'Ingen resultater.';

  @override
  String get emptyNotesMessage =>
      'Ingen noter endnu. Tryk på + for at oprette en.';

  @override
  String get notesTabLabel => 'Noter';

  @override
  String get diaryTabLabel => 'Dagbog';

  @override
  String get emptyDiaryMessage =>
      'Ingen dagbogsindlæg endnu. Tryk på + for at skrive et.';

  @override
  String get diaryToday => 'I dag';

  @override
  String get diaryYesterday => 'I går';

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
  String get bodyFieldHint => 'Skriv her... (markdown understøttes)';

  @override
  String get checklistItemHint => 'Punkt på tjekliste';

  @override
  String get addItemButton => 'Tilføj punkt';

  @override
  String checklistProgress(int done, int total) {
    return '$done af $total fuldført';
  }

  @override
  String get showCompletedItemsTooltip => 'Vis fuldførte punkter';

  @override
  String get hideCompletedItemsTooltip => 'Skjul fuldførte punkter';

  @override
  String get allChecklistItemsCompletedHidden =>
      'Alle punkter er fuldført og skjult.';

  @override
  String get deleteCompletedItemsButton => 'Slet fuldførte punkter';

  @override
  String get deleteCompletedItemsConfirmTitle => 'Slet fuldførte punkter?';

  @override
  String deleteCompletedItemsConfirmBody(int count) {
    return 'Dette fjerner $count afkrydsede punkter fra denne tjekliste. Kan ikke fortrydes.';
  }

  @override
  String get addImageButton => 'Tilføj billede';

  @override
  String get noteColorButton => 'Notefarve';

  @override
  String get noteColorDefault => 'Standard';

  @override
  String get noteColorYellow => 'Gul';

  @override
  String get noteColorRed => 'Rød';

  @override
  String get noteColorPurple => 'Lilla';

  @override
  String get noteColorBlue => 'Blå';

  @override
  String get noteColorGreen => 'Grøn';

  @override
  String get noteColorOrange => 'Orange';

  @override
  String get noteColorWhite => 'Hvid';

  @override
  String get recordVoiceNoteTooltip => 'Optag en talenote';

  @override
  String get recordVoiceNoteInstructions =>
      'Tryk på den røde knap for at starte optagelsen, eller ✕ for at annullere.';

  @override
  String get stopRecordingTooltip => 'Stop optagelse';

  @override
  String get cancelRecordingTooltip => 'Annuller optagelse';

  @override
  String get addVoiceTimestampButton => 'Tilføj tidsstempel';

  @override
  String get editVoiceTimestampButton => 'Rediger tidsstempel';

  @override
  String get voiceNoteUnsupportedOnPlatform =>
      'Talebeskeder understøttes ikke på denne enhed';

  @override
  String get formatBoldTooltip => 'Fed';

  @override
  String get formatItalicTooltip => 'Kursiv';

  @override
  String get formatHeadingTooltip => 'Overskrift';

  @override
  String get formatListTooltip => 'Punktliste';

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
  String get noteLayoutToggleTitle => 'Skift mellem liste- og gittervisning';

  @override
  String get manageRelaysTitle => 'Administrer relæer';

  @override
  String get republishAllNotesButton => 'Genudgiv alle synkroniserede noter';

  @override
  String get republishAllNotesSubtitle =>
      'Udfylder hvert relæ ovenfor med noter, der allerede er delt andre steder — nyttigt lige efter tilføjelse af et nyt, f.eks. et selvhostet backup-relæ';

  @override
  String republishAllNotesSuccess(int count) {
    return 'Genudgav $count noter';
  }

  @override
  String republishAllNotesError(String error) {
    return 'Noterne kunne ikke genudgives: $error';
  }

  @override
  String get forceFullResyncButton => 'Gennemtving fuld gensynkronisering';

  @override
  String get forceFullResyncSubtitle =>
      'Tjekker relays igen for en notes fulde historik i stedet for kun det nye — nyttigt hvis synkronisering ser ud til at sidde fast og springer ældre noter over, fx efter at have løst en utilgængelig relay';

  @override
  String get forceFullResyncSuccess => 'Noter opdateret fra relays';

  @override
  String forceFullResyncError(String error) {
    return 'Kunne ikke gensynkronisere noter: $error';
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
      'Nogle offentlige værter (f.eks. Primal, nostr.build) afviser krypterede uploads — de validerer ægte billedindhold, hvilket krypterede data aldrig er. Foretræk en Blossom-vært, der gemmer rå data, eller peg Tilpasset… på en selvhostet.';

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

  @override
  String get shareNoteTooltip => 'Del';

  @override
  String get shareNoteTitle => 'Del note';

  @override
  String get shareRecipientFieldLabel =>
      'Modtagerens npub eller offentlige nøgle';

  @override
  String get shareAddRecipientButton => 'Tilføj';

  @override
  String get shareInvalidRecipientError =>
      'Det er ikke en gyldig npub eller offentlig nøgle';

  @override
  String get shareRecipientNotFoundError =>
      'Ingen Nostr-konto fundet for det navn';

  @override
  String get shareConfirmTitle => 'Del denne note?';

  @override
  String get shareConfirmButton => 'Del';

  @override
  String get shareAlreadyRecipientError => 'Allerede delt med denne person';

  @override
  String get shareCannotShareWithSelfError =>
      'Du kan ikke dele en note med dig selv';

  @override
  String get shareRecipientsHeader => 'Delt med';

  @override
  String get shareNoRecipientsMessage => 'Endnu ikke delt med nogen.';

  @override
  String get stopSharingTooltip => 'Stop deling med denne person';

  @override
  String get shareRevocationNote =>
      'Alle du deler med kan læse denne note på deres enhed. At fjerne nogen stopper fremtidige opdateringer til dem, men kan ikke slette det, de allerede har modtaget.';

  @override
  String shareError(String error) {
    return 'Kunne ikke opdatere deling: $error';
  }

  @override
  String get sharedWithMeHeader => 'Delt med dig';

  @override
  String sharedByLabel(String npub) {
    return 'Delt af $npub';
  }

  @override
  String get sharedNoteEditableNote =>
      'Du kan redigere denne note; dine ændringer synkroniseres tilbage til ejeren, som fletter dem.';

  @override
  String get abandonSharedNoteButton => 'Forlad denne delte note';

  @override
  String get abandonSharedNoteConfirmTitle => 'Forlad denne delte note?';

  @override
  String get abandonSharedNoteConfirmBody =>
      'Den fjernes fra denne enhed, og du holder op med at modtage opdateringer. Dette kan ikke fortrydes — du kan ikke tilslutte dig igen senere.';

  @override
  String abandonSharedNoteError(String error) {
    return 'Kunne ikke forlade: $error';
  }
}
