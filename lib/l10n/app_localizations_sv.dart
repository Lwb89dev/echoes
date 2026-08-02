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
  String get importAccountFieldLabel => 'Privat nyckel (nsec) för ditt Nostr-konto';

  @override
  String get importButton => 'Importera';

  @override
  String get bunkerLoginButton => 'Anslut en fjärrsignerare (bunker)';

  @override
  String get bunkerFieldLabel => 'Klistra in din bunker://-anslutningstoken';

  @override
  String get bunkerConnectButton => 'Anslut';

  @override
  String get bunkerAuthPrompt => 'Godkänn anslutningen i din signerare och kom tillbaka';

  @override
  String get relaysTitle => 'Reläer';

  @override
  String get settingsTooltip => 'Inställningar';

  @override
  String get searchTooltip => 'Sök';

  @override
  String get closeSearchTooltip => 'Stäng sökningen';

  @override
  String get searchNotesHint => 'Sök i anteckningar';

  @override
  String get noSearchResultsMessage => 'Inga träffar.';

  @override
  String get emptyNotesMessage => 'Inga anteckningar än. Tryck på + för att skapa en.';

  @override
  String get notesTabLabel => 'Anteckningar';

  @override
  String get diaryTabLabel => 'Dagbok';

  @override
  String get emptyDiaryMessage => 'Inga dagboksinlägg ännu. Tryck på + för att skriva ett.';

  @override
  String get diaryToday => 'Idag';

  @override
  String get diaryYesterday => 'Igår';

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
  String get saveTooltip => 'Spara';

  @override
  String get titleFieldLabel => 'Titel';

  @override
  String get bodyFieldHint => 'Skriv här... (markdown stöds)';

  @override
  String get checklistItemHint => 'Checklisteobjekt';

  @override
  String get addItemButton => 'Lägg till objekt';

  @override
  String checklistProgress(int done, int total) {
    return '$done av $total klara';
  }

  @override
  String get showCompletedItemsTooltip => 'Visa klara punkter';

  @override
  String get hideCompletedItemsTooltip => 'Dölj klara punkter';

  @override
  String get allChecklistItemsCompletedHidden => 'Alla punkter är klara och dolda.';

  @override
  String get deleteCompletedItemsButton => 'Ta bort klara punkter';

  @override
  String get deleteCompletedItemsConfirmTitle => 'Ta bort klara punkter?';

  @override
  String deleteCompletedItemsConfirmBody(int count) {
    return 'Detta tar bort $count avbockade punkter från listan. Kan inte ångras.';
  }

  @override
  String get addImageButton => 'Lägg till bild';

  @override
  String get noteColorButton => 'Anteckningens färg';

  @override
  String get noteColorDefault => 'Standard';

  @override
  String get noteColorYellow => 'Gul';

  @override
  String get noteColorRed => 'Röd';

  @override
  String get noteColorPurple => 'Lila';

  @override
  String get noteColorBlue => 'Blå';

  @override
  String get noteColorGreen => 'Grön';

  @override
  String get noteColorOrange => 'Orange';

  @override
  String get noteColorWhite => 'Vit';

  @override
  String get recordVoiceNoteTooltip => 'Spela in en röstanteckning';

  @override
  String get recordVoiceNoteInstructions =>
      'Tryck på den röda knappen för att börja spela in, eller ✕ för att avbryta.';

  @override
  String get stopRecordingTooltip => 'Stoppa inspelning';

  @override
  String get cancelRecordingTooltip => 'Avbryt inspelning';

  @override
  String get addVoiceTimestampButton => 'Lägg till tidsstämpel';

  @override
  String get editVoiceTimestampButton => 'Redigera tidsstämpel';

  @override
  String get voiceNoteUnsupportedOnPlatform => 'Röstanteckningar stöds inte på den här enheten';

  @override
  String get formatBoldTooltip => 'Fet';

  @override
  String get formatItalicTooltip => 'Kursiv';

  @override
  String get formatHeadingTooltip => 'Rubrik';

  @override
  String get formatListTooltip => 'Punktlista';

  @override
  String get formatLinkTooltip => 'Länk';

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
  String get encryptionLoadError => 'Kunde inte läsa in krypteringsinställningarna';

  @override
  String get encryptionToggleTitle => 'Skydda anteckningar med ett lösenord';

  @override
  String get encryptionToggleSubtitle =>
      'Krypterar lagrade anteckningar (AES-256-GCM) med en nyckel som härleds från ditt lösenord. Lösenordet lagras aldrig — glömmer du det kan anteckningarna inte återställas.';

  @override
  String get lockNotesNowTitle => 'Lås anteckningar nu';

  @override
  String get lockNotesNowSubtitle => 'Lösenordet krävs igen för att visa anteckningarna';

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
  String get disablePasswordDialogTitle => 'Ange ditt lösenord för att inaktivera kryptering';

  @override
  String get disableButton => 'Inaktivera';

  @override
  String get sectionAppearance => 'Utseende';

  @override
  String get lightThemeToggleTitle => 'Ljust tema';

  @override
  String get lightThemeToggleSubtitle => 'Använd ett ljust färgschema istället för mörkt';

  @override
  String get noteLayoutToggleTitle => 'Växla mellan list- och rutnätsvy';

  @override
  String get manageRelaysTitle => 'Hantera reläer';

  @override
  String get republishAllNotesButton => 'Publicera om alla synkroniserade anteckningar';

  @override
  String get republishAllNotesSubtitle =>
      'Fyller på varje relä ovan med anteckningar som redan delats någon annanstans — användbart direkt efter att du lagt till ett nytt, t.ex. ett självhostat backup-relä';

  @override
  String republishAllNotesSuccess(int count) {
    return '$count anteckningar publicerades om';
  }

  @override
  String republishAllNotesError(String error) {
    return 'Anteckningarna kunde inte publiceras om: $error';
  }

  @override
  String get forceFullResyncButton => 'Tvinga fullständig omsynkronisering';

  @override
  String get forceFullResyncSubtitle =>
      'Kontrollerar reläer igen efter en antecknings hela historik i stället för bara det nya — användbart om synkroniseringen verkar fastna och hoppar över äldre anteckningar, t.ex. efter att ha åtgärdat ett oåtkomligt relä';

  @override
  String get forceFullResyncSuccess => 'Anteckningar uppdaterade från reläer';

  @override
  String forceFullResyncError(String error) {
    return 'Det gick inte att omsynkronisera anteckningarna: $error';
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
  String get accountLocalOnlyMessage => 'Använder Echoes lokalt — synkroniseras inte med Nostr';

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
  String get onboardingIntroLocalTitle => 'Dina anteckningar, alltid på din enhet';

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
  String get onboardingIntroAmberTitle => 'Logga in utan att exponera din nyckel';

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
  String get exportSetPasswordDialogTitle => 'Ange ett lösenord för denna export';

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
  String get importNotesSubtitle => 'Återställ anteckningar från en tidigare exporterad fil';

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
      'Vissa publika värdar (t.ex. Primal, nostr.build) avvisar krypterade uppladdningar direkt — de validerar äkta bildinnehåll, vilket krypterad data aldrig är. Föredra en Blossom-värd som lagrar rå data, eller peka Anpassad… mot en självhostad.';

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

  @override
  String get shareNoteTooltip => 'Dela';

  @override
  String get shareNoteTitle => 'Dela anteckning';

  @override
  String get shareRecipientFieldLabel => 'Mottagarens npub eller offentliga nyckel';

  @override
  String get shareAddRecipientButton => 'Lägg till';

  @override
  String get shareInvalidRecipientError => 'Det är inte en giltig npub eller offentlig nyckel';

  @override
  String get shareRecipientNotFoundError => 'Inget Nostr-konto hittades för det namnet';

  @override
  String get shareConfirmTitle => 'Dela den här anteckningen?';

  @override
  String get shareConfirmButton => 'Dela';

  @override
  String get shareAlreadyRecipientError => 'Redan delad med den här personen';

  @override
  String get shareCannotShareWithSelfError => 'Du kan inte dela en anteckning med dig själv';

  @override
  String get shareRecipientsHeader => 'Delad med';

  @override
  String get shareNoRecipientsMessage => 'Ännu inte delad med någon.';

  @override
  String get stopSharingTooltip => 'Sluta dela med den här personen';

  @override
  String get shareRevocationNote =>
      'Alla du delar med kan läsa den här anteckningen på sin enhet. Att ta bort någon stoppar framtida uppdateringar, men kan inte radera det de redan fått.';

  @override
  String shareError(String error) {
    return 'Det gick inte att uppdatera delningen: $error';
  }

  @override
  String get sharedWithMeHeader => 'Delad med dig';

  @override
  String sharedByLabel(String npub) {
    return 'Delad av $npub';
  }

  @override
  String get sharedNoteEditableNote =>
      'Du kan redigera den här anteckningen; dina ändringar synkas tillbaka till ägaren, som slår samman dem.';

  @override
  String get abandonSharedNoteButton => 'Lämna den här delade anteckningen';

  @override
  String get abandonSharedNoteConfirmTitle => 'Lämna den här delade anteckningen?';

  @override
  String get abandonSharedNoteConfirmBody =>
      'Den tas bort från den här enheten och du slutar få uppdateringar. Detta kan inte ångras — du kan inte gå med igen senare.';

  @override
  String abandonSharedNoteError(String error) {
    return 'Det gick inte att lämna: $error';
  }
}
