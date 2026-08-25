// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get loginSubtitle => 'Log in met je Nostr-account';

  @override
  String get loginWithAmberButton => 'Inloggen met Amber';

  @override
  String get importAccountButton => 'Nostr-account importeren';

  @override
  String get importAccountFieldLabel => 'Privésleutel (nsec) van je Nostr-account';

  @override
  String get importButton => 'Importeren';

  @override
  String get bunkerLoginButton => 'Verbind een externe ondertekenaar (bunker)';

  @override
  String get bunkerFieldLabel => 'Plak je bunker://-verbindingstoken';

  @override
  String get bunkerConnectButton => 'Verbinden';

  @override
  String get bunkerAuthPrompt => 'Keur de verbinding goed in je ondertekenaar en kom terug';

  @override
  String get relaysTitle => 'Relays';

  @override
  String get settingsTooltip => 'Instellingen';

  @override
  String get searchTooltip => 'Zoeken';

  @override
  String get closeSearchTooltip => 'Zoeken sluiten';

  @override
  String get searchNotesHint => 'Zoeken in notities';

  @override
  String get noSearchResultsMessage => 'Geen resultaten.';

  @override
  String get emptyNotesMessage => 'Nog geen notities. Tik op + om er een te maken.';

  @override
  String get notesTabLabel => 'Notities';

  @override
  String get diaryTabLabel => 'Dagboek';

  @override
  String get emptyDiaryMessage => 'Nog geen dagboeknotities. Tik op + om er een te schrijven.';

  @override
  String get diaryToday => 'Vandaag';

  @override
  String get diaryYesterday => 'Gisteren';

  @override
  String get newPlainNoteOption => 'Notitie';

  @override
  String get newChecklistOption => 'Checklist';

  @override
  String get newVoiceNoteOption => 'Spraaknotitie';

  @override
  String get deleteNoteButton => 'Notitie verwijderen';

  @override
  String get deleteNoteConfirmTitle => 'Deze notitie verwijderen?';

  @override
  String get deleteNoteConfirmBody =>
      'Dit kan niet ongedaan worden gemaakt. Als deze notitie gesynchroniseerd was, wordt deze ook van je relays verwijderd.';

  @override
  String deleteNotesConfirmTitle(int count) {
    return '$count notities verwijderen?';
  }

  @override
  String get deleteNotesConfirmBody =>
      'Dit kan niet ongedaan worden gemaakt. Als een van deze notities gesynchroniseerd was, wordt deze ook van je relays verwijderd.';

  @override
  String selectionCount(int count) {
    return '$count geselecteerd';
  }

  @override
  String get untitledNote => '(zonder titel)';

  @override
  String errorLoadingNotes(String error) {
    return 'Fout bij het laden van notities: $error';
  }

  @override
  String get timeJustNow => 'nu';

  @override
  String timeMinutesAgo(int count) {
    return '${count}m geleden';
  }

  @override
  String timeHoursAgo(int count) {
    return '${count}u geleden';
  }

  @override
  String timeDaysAgo(int count) {
    return '${count}d geleden';
  }

  @override
  String get notesLockedTitle => 'Notities zijn beveiligd met een wachtwoord';

  @override
  String get unlockButton => 'Ontgrendelen';

  @override
  String get saveTooltip => 'Opslaan';

  @override
  String get titleFieldLabel => 'Titel';

  @override
  String get bodyFieldHint => 'Schrijf hier... (markdown wordt ondersteund)';

  @override
  String get checklistItemHint => 'Checklistitem';

  @override
  String get addItemButton => 'Item toevoegen';

  @override
  String completedItemsSection(int count) {
    return 'Voltooid ($count)';
  }

  @override
  String get duplicateChecklistItemMessage => 'Staat al op deze lijst, voltooid';

  @override
  String get restoreChecklistItemButton => 'Herstellen';

  @override
  String get noteSyncedMessage => 'Notitie gesynchroniseerd';

  @override
  String get noteSyncedFirstTimeMessage => 'Notitie voor het eerst gesynchroniseerd';

  @override
  String notePartiallySyncedMessage(int accepted, int total) {
    return 'Gesynchroniseerd naar $accepted van $total relays';
  }

  @override
  String checklistProgress(int done, int total) {
    return '$done van $total voltooid';
  }

  @override
  String get showCompletedItemsTooltip => 'Voltooide items tonen';

  @override
  String get hideCompletedItemsTooltip => 'Voltooide items verbergen';

  @override
  String get allChecklistItemsCompletedHidden => 'Alle items zijn voltooid en verborgen.';

  @override
  String get deleteCompletedItemsButton => 'Voltooide items verwijderen';

  @override
  String get deleteCompletedItemsConfirmTitle => 'Voltooide items verwijderen?';

  @override
  String deleteCompletedItemsConfirmBody(int count) {
    return 'Hiermee worden $count afgevinkte items uit deze checklist verwijderd. Kan niet ongedaan worden gemaakt.';
  }

  @override
  String get addImageButton => 'Afbeelding toevoegen';

  @override
  String get noteColorButton => 'Notitiekleur';

  @override
  String get noteColorDefault => 'Standaard';

  @override
  String get noteColorYellow => 'Geel';

  @override
  String get noteColorRed => 'Rood';

  @override
  String get noteColorPurple => 'Paars';

  @override
  String get noteColorBlue => 'Blauw';

  @override
  String get noteColorGreen => 'Groen';

  @override
  String get noteColorOrange => 'Oranje';

  @override
  String get noteColorWhite => 'Wit';

  @override
  String get recordVoiceNoteTooltip => 'Spraaknotitie opnemen';

  @override
  String get recordVoiceNoteInstructions =>
      'Tik op de rode knop om de opname te starten, of op ✕ om te annuleren.';

  @override
  String get stopRecordingTooltip => 'Opname stoppen';

  @override
  String get cancelRecordingTooltip => 'Opname annuleren';

  @override
  String get addVoiceTimestampButton => 'Tijdstempel toevoegen';

  @override
  String get editVoiceTimestampButton => 'Tijdstempel bewerken';

  @override
  String get voiceNoteUnsupportedOnPlatform =>
      'Spraaknotities worden niet ondersteund op dit apparaat';

  @override
  String get formatBoldTooltip => 'Vet';

  @override
  String get formatItalicTooltip => 'Cursief';

  @override
  String get formatStrikethroughTooltip => 'Doorhalen';

  @override
  String get formatHeadingTooltip => 'Kop';

  @override
  String get formatListTooltip => 'Opsommingslijst';

  @override
  String get formatLinkTooltip => 'Link';

  @override
  String get imageSizeSmall => 'Klein';

  @override
  String get imageSizeMedium => 'Middel';

  @override
  String get imageSizeFull => 'Volledige breedte';

  @override
  String get removeImageButton => 'Afbeelding verwijderen';

  @override
  String get relayUrlHint => 'wss://relay.example.com';

  @override
  String get noRelaysMessage => 'Nog geen relay geconfigureerd.';

  @override
  String relaysCount(int count) {
    return '$count relays';
  }

  @override
  String get settingsTitle => 'Instellingen';

  @override
  String get sectionSecurity => 'Beveiliging';

  @override
  String get loadingLabel => 'Bezig met laden…';

  @override
  String get encryptionLoadError => 'Versleutelingsinstellingen konden niet worden geladen';

  @override
  String get encryptionToggleTitle => 'Notities beveiligen met een wachtwoord';

  @override
  String get encryptionToggleSubtitle =>
      'Versleutelt opgeslagen notities (AES-256-GCM) met een sleutel afgeleid van je wachtwoord. Het wachtwoord wordt nooit opgeslagen — als je het vergeet, kunnen de notities niet worden hersteld.';

  @override
  String get lockNotesNowTitle => 'Notities nu vergrendelen';

  @override
  String get lockNotesNowSubtitle => 'Vereist het wachtwoord opnieuw om notities te bekijken';

  @override
  String get setPasswordDialogTitle => 'Wachtwoord instellen';

  @override
  String get passwordTooShortError => 'Minstens 8 tekens';

  @override
  String get confirmPasswordLabel => 'Wachtwoord bevestigen';

  @override
  String get passwordsDoNotMatchError => 'Wachtwoorden komen niet overeen';

  @override
  String enableEncryptionError(String error) {
    return 'Versleuteling kon niet worden ingeschakeld: $error';
  }

  @override
  String get enableButton => 'Inschakelen';

  @override
  String get disablePasswordDialogTitle =>
      'Voer je wachtwoord in om versleuteling uit te schakelen';

  @override
  String get disableButton => 'Uitschakelen';

  @override
  String get sectionAppearance => 'Weergave';

  @override
  String get lightThemeToggleTitle => 'Licht thema';

  @override
  String get lightThemeToggleSubtitle => 'Gebruik een licht kleurenschema in plaats van donker';

  @override
  String get noteLayoutToggleTitle => 'Wisselen tussen lijst- en rasterweergave';

  @override
  String get manageRelaysTitle => 'Relays beheren';

  @override
  String get autoSyncOnSaveTitle => 'Publiceren bij opslaan';

  @override
  String get autoSyncOnSaveSubtitle =>
      'Notities die je al synchroniseert worden opnieuw gepubliceerd zodra je ze opslaat. Lokale notities nooit.';

  @override
  String get noteBackgroundPhoto => 'Foto';

  @override
  String get noteBackgroundRemove => 'Foto verwijderen';

  @override
  String get republishAllNotesButton => 'Alle gesynchroniseerde notities opnieuw publiceren';

  @override
  String get republishAllNotesSubtitle =>
      'Vult elk relay hierboven aan met notities die al elders gedeeld zijn — handig direct na het toevoegen van een nieuw, bijv. een zelfgehost back-uprelay';

  @override
  String republishAllNotesSuccess(int count) {
    return '$count notities opnieuw gepubliceerd';
  }

  @override
  String republishAllNotesError(String error) {
    return 'Notities konden niet opnieuw worden gepubliceerd: $error';
  }

  @override
  String get forceFullResyncButton => 'Volledige hersynchronisatie forceren';

  @override
  String get forceFullResyncSubtitle =>
      'Controleert relays opnieuw op de volledige geschiedenis van een notitie in plaats van alleen wat nieuw is — handig als synchronisatie vast lijkt te zitten en oudere notities overslaat, bijv. na het oplossen van een onbereikbare relay';

  @override
  String get forceFullResyncSuccess => 'Notities bijgewerkt vanaf relays';

  @override
  String forceFullResyncError(String error) {
    return 'Kon notities niet opnieuw synchroniseren: $error';
  }

  @override
  String get confirmButton => 'Bevestigen';

  @override
  String get sectionLanguage => 'Taal';

  @override
  String get langSystem => 'Systeemstandaard';

  @override
  String get sectionAccount => 'Account';

  @override
  String get accountLocalOnlyMessage =>
      'Echoes wordt lokaal gebruikt — niet gesynchroniseerd met Nostr';

  @override
  String get accountSignInButton => 'Inloggen';

  @override
  String accountSignedInAs(String npub) {
    return 'Ingelogd als $npub';
  }

  @override
  String get accountSignOutButton => 'Uitloggen';

  @override
  String get accountSignOutConfirmTitle => 'Uitloggen?';

  @override
  String get accountSignOutConfirmBody =>
      'Je notities blijven op dit apparaat staan. Je kunt altijd opnieuw inloggen.';

  @override
  String get onboardingWelcomeTitle => 'Welkom bij Echoes';

  @override
  String get onboardingIntroLocalTitle => 'Je notities, altijd op je apparaat';

  @override
  String get onboardingIntroLocalBody =>
      'Elke notitie wordt eerst lokaal opgeslagen, zodat de app volledig offline werkt. Er verlaat niets je apparaat, tenzij je ervoor kiest om te synchroniseren.';

  @override
  String get onboardingIntroSyncTitle => 'Optionele synchronisatie via Nostr';

  @override
  String get onboardingIntroSyncBody =>
      'Schakel synchronisatie in om je notities te back-uppen en op andere apparaten te lezen, met behulp van het open Nostr-protocol en relays naar keuze.';

  @override
  String get onboardingIntroEncryptionTitle => 'Altijd versleuteld';

  @override
  String get onboardingIntroEncryptionBody =>
      'Notities die naar Nostr worden gesynchroniseerd zijn end-to-end versleuteld, zodat relay-beheerders — en verder niemand — de inhoud ooit kunnen lezen.';

  @override
  String get onboardingIntroAmberTitle => 'Inloggen zonder je sleutel bloot te geven';

  @override
  String get onboardingIntroAmberBody =>
      'Gebruik Amber om in te loggen: je privésleutel blijft in Amber en wordt nooit met Echoes gedeeld.';

  @override
  String get onboardingIntroSecurityTitle => 'Beveiliging vanaf het ontwerp';

  @override
  String get onboardingIntroSecurityBody =>
      'Je privésleutel bevindt zich in de versleutelde keystore van je apparaat — of komt met Amber helemaal nooit in aanraking met Echoes. Foto\'s en spraakmemo\'s worden versleuteld voordat ze je apparaat verlaten. Notities kunnen worden vergrendeld met een wachtwoord, en niets hiervan wordt ooit opgenomen in telefoonback-ups.';

  @override
  String get onboardingNextButton => 'Volgende';

  @override
  String get onboardingBackButton => 'Terug';

  @override
  String get onboardingSkipButton => 'Overslaan — Echoes alleen lokaal gebruiken';

  @override
  String get onboardingRelayTitle => 'Kies relays om te synchroniseren';

  @override
  String get onboardingRelayBody =>
      'Relays zijn waar je versleutelde notities worden opgeslagen bij synchronisatie. Voeg er een of meer toe — deze populaire zijn een goed begin:';

  @override
  String get onboardingFinishButton => 'Aan de slag';

  @override
  String get syncNoteTooltip => 'Deze notitie synchroniseren';

  @override
  String get unsyncNoteTooltip => 'Verwijderen van relays';

  @override
  String get syncSelectedTooltip => 'Geselecteerde notities synchroniseren';

  @override
  String get exportSelectedTooltip => 'Geselecteerde notities exporteren';

  @override
  String get deleteSelectedTooltip => 'Geselecteerde notities verwijderen';

  @override
  String syncNoteError(String error) {
    return 'Kon notitie niet synchroniseren: $error';
  }

  @override
  String unsyncNoteError(String error) {
    return 'Kon notitie niet van de relays verwijderen: $error';
  }

  @override
  String deleteNoteRelayError(String error) {
    return 'Notitie lokaal verwijderd, maar kon niet van de relays worden verwijderd: $error';
  }

  @override
  String deleteNotesRelayError(int count) {
    return '$count notities lokaal verwijderd, maar konden niet van de relays worden verwijderd';
  }

  @override
  String get deletingNotesTitle => 'Notities verwijderen…';

  @override
  String deletingNotesProgress(int completed, int total) {
    return 'Bezig met verwijderen van $completed van $total';
  }

  @override
  String get syncSelectedSuccess => 'Notities gesynchroniseerd';

  @override
  String syncSelectedPartialError(int count) {
    return 'Kon $count notities niet synchroniseren';
  }

  @override
  String get exportConfirmTitle => 'Notities exporteren';

  @override
  String get exportConfirmBody =>
      'Maakt een back-upbestand van je notities. Dit bevat ook de decoderingssleutels voor bijgevoegde afbeeldingen of spraakmemo\'s — iedereen met het bestand zou ze kunnen lezen, tenzij het versleuteld is.';

  @override
  String get exportEncryptToggleLabel => 'Dit bestand versleutelen';

  @override
  String get exportEncryptToggleSubtitle => 'Aanbevolen — beschermt de back-up met een wachtwoord';

  @override
  String get exportPasswordDialogTitle => 'Voer je wachtwoord in';

  @override
  String get exportSetPasswordDialogTitle => 'Stel een wachtwoord in voor deze export';

  @override
  String get importPasswordDialogTitle => 'Voer het wachtwoord van de export in';

  @override
  String get sectionData => 'Gegevens';

  @override
  String get exportNotesButton => 'Notities exporteren';

  @override
  String get exportNotesSubtitle =>
      'Sla al je notities op in een bestand dat je later opnieuw kunt importeren';

  @override
  String get importNotesButton => 'Notities importeren';

  @override
  String get importNotesSubtitle => 'Herstel notities uit een eerder geëxporteerd bestand';

  @override
  String get exportNotesSuccess => 'Notities geëxporteerd';

  @override
  String exportNotesError(Object error) {
    return 'Kon notities niet exporteren: $error';
  }

  @override
  String importNotesSuccess(int count) {
    return '$count notities geïmporteerd';
  }

  @override
  String importNotesError(Object error) {
    return 'Kon notities niet importeren: $error';
  }

  @override
  String get sectionAttachments => 'Bijlagen';

  @override
  String get attachmentProviderSubtitle =>
      'Waar versleutelde afbeeldingen en spraaknotities worden geüpload bij synchroniseren';

  @override
  String get attachmentProviderCustom => 'Aangepast…';

  @override
  String get attachmentCustomUrlLabel => 'Server-URL';

  @override
  String get attachmentProviderHint =>
      'Sommige publieke hosts (bijv. Primal, nostr.build) weigeren versleutelde uploads — ze controleren op echte afbeeldingsinhoud, wat versleutelde data nooit is. Kies liever een Blossom-host die ruwe data opslaat, of wijs Aangepast… naar een zelfgehoste.';

  @override
  String get sectionSupport => 'Ondersteuning';

  @override
  String get supportEchoesTitle => 'Steun Echoes';

  @override
  String lightningAddressCopied(String address) {
    return '⚡ $address gekopieerd naar klembord';
  }

  @override
  String get cancelButton => 'Annuleren';

  @override
  String get passwordLabel => 'Wachtwoord';

  @override
  String get invalidPrivateKeyError =>
      'De privésleutel is ongeldig. Voer een geldige nsec- of hex-sleutel in.';

  @override
  String get wrongPasswordError => 'Onjuist wachtwoord';

  @override
  String genericErrorPrefix(String error) {
    return 'Fout: $error';
  }

  @override
  String get shareNoteTooltip => 'Delen';

  @override
  String get shareNoteTitle => 'Notitie delen';

  @override
  String get shareRecipientFieldLabel => 'npub of publieke sleutel van de ontvanger';

  @override
  String get shareAddRecipientButton => 'Toevoegen';

  @override
  String get shareInvalidRecipientError => 'Dat is geen geldige npub of publieke sleutel';

  @override
  String get shareRecipientNotFoundError => 'Geen Nostr-account gevonden voor die naam';

  @override
  String get shareConfirmTitle => 'Deze notitie delen?';

  @override
  String get shareConfirmButton => 'Delen';

  @override
  String get shareAlreadyRecipientError => 'Al gedeeld met deze persoon';

  @override
  String get shareCannotShareWithSelfError => 'Je kunt een notitie niet met jezelf delen';

  @override
  String get shareRecipientsHeader => 'Gedeeld met';

  @override
  String get shareNoRecipientsMessage => 'Nog met niemand gedeeld.';

  @override
  String get stopSharingTooltip => 'Delen met deze persoon stoppen';

  @override
  String get shareRevocationNote =>
      'Iedereen met wie je deelt, kan deze notitie op zijn apparaat lezen. Iemand verwijderen stopt toekomstige updates, maar kan niet wissen wat al is ontvangen.';

  @override
  String shareError(String error) {
    return 'Delen kon niet worden bijgewerkt: $error';
  }

  @override
  String get sharedWithMeHeader => 'Met jou gedeeld';

  @override
  String sharedByLabel(String npub) {
    return 'Gedeeld door $npub';
  }

  @override
  String get sharedNoteEditableNote =>
      'Je kunt deze notitie bewerken; je wijzigingen worden teruggesynchroniseerd naar de eigenaar, die ze samenvoegt.';

  @override
  String get abandonSharedNoteButton => 'Deze gedeelde notitie verlaten';

  @override
  String get abandonSharedNoteConfirmTitle => 'Deze gedeelde notitie verlaten?';

  @override
  String get abandonSharedNoteConfirmBody =>
      'Hij wordt van dit apparaat verwijderd en je ontvangt geen updates meer. Dit kan niet ongedaan worden gemaakt — je kunt later niet opnieuw deelnemen.';

  @override
  String abandonSharedNoteError(String error) {
    return 'Verlaten mislukt: $error';
  }
}
