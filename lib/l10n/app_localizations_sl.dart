// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovenian (`sl`).
class AppLocalizationsSl extends AppLocalizations {
  AppLocalizationsSl([String locale = 'sl']) : super(locale);

  @override
  String get loginSubtitle => 'Prijavite se s svojim računom Nostr';

  @override
  String get loginWithAmberButton => 'Prijava z Amber';

  @override
  String get importAccountButton => 'Uvozi račun Nostr';

  @override
  String get importAccountFieldLabel => 'Zasebni ključ (nsec) vašega računa Nostr';

  @override
  String get importButton => 'Uvozi';

  @override
  String get bunkerLoginButton => 'Poveži oddaljeni podpisnik (bunker)';

  @override
  String get bunkerFieldLabel => 'Prilepi svoj povezovalni žeton bunker://';

  @override
  String get bunkerConnectButton => 'Poveži';

  @override
  String get bunkerAuthPrompt => 'Odobri povezavo v svojem podpisniku in se vrni';

  @override
  String get relaysTitle => 'Releji';

  @override
  String get settingsTooltip => 'Nastavitve';

  @override
  String get searchTooltip => 'Išči';

  @override
  String get closeSearchTooltip => 'Zapri iskanje';

  @override
  String get searchNotesHint => 'Išči po zapiskih';

  @override
  String get noSearchResultsMessage => 'Ni zadetkov.';

  @override
  String get emptyNotesMessage => 'Še ni zabeležk. Dotaknite se +, da ustvarite novo.';

  @override
  String get notesTabLabel => 'Zapiski';

  @override
  String get diaryTabLabel => 'Dnevnik';

  @override
  String get emptyDiaryMessage => 'V dnevniku še ni vnosov. Tapnite +, da ga napišete.';

  @override
  String get diaryToday => 'Danes';

  @override
  String get diaryYesterday => 'Včeraj';

  @override
  String get newPlainNoteOption => 'Zabeležka';

  @override
  String get newChecklistOption => 'Kontrolni seznam';

  @override
  String get newVoiceNoteOption => 'Glasovna zabeležka';

  @override
  String get deleteNoteButton => 'Izbriši zabeležko';

  @override
  String get deleteNoteConfirmTitle => 'Izbrišem to zabeležko?';

  @override
  String get deleteNoteConfirmBody =>
      'Tega dejanja ni mogoče razveljaviti. Če je bila ta zabeležka sinhronizirana, bo odstranjena tudi z vaših relejev.';

  @override
  String deleteNotesConfirmTitle(int count) {
    return 'Izbrišem $count zabeležk?';
  }

  @override
  String get deleteNotesConfirmBody =>
      'Tega dejanja ni mogoče razveljaviti. Če je bila katera od teh zabeležk sinhronizirana, bo odstranjena tudi z vaših relejev.';

  @override
  String selectionCount(int count) {
    return 'Izbranih: $count';
  }

  @override
  String get untitledNote => '(brez naslova)';

  @override
  String errorLoadingNotes(String error) {
    return 'Napaka pri nalaganju zabeležk: $error';
  }

  @override
  String get timeJustNow => 'zdaj';

  @override
  String timeMinutesAgo(int count) {
    return 'pred $count min';
  }

  @override
  String timeHoursAgo(int count) {
    return 'pred $count h';
  }

  @override
  String timeDaysAgo(int count) {
    return 'pred $count dnevi';
  }

  @override
  String get notesLockedTitle => 'Zabeležke so zaščitene z geslom';

  @override
  String get unlockButton => 'Odkleni';

  @override
  String get saveTooltip => 'Shrani';

  @override
  String get titleFieldLabel => 'Naslov';

  @override
  String get bodyFieldHint => 'Pišite tukaj... (markdown je podprt)';

  @override
  String get checklistItemHint => 'Postavka seznama';

  @override
  String get addItemButton => 'Dodaj postavko';

  @override
  String completedItemsSection(int count) {
    return 'Končano ($count)';
  }

  @override
  String get duplicateChecklistItemMessage => 'Že na seznamu, končano';

  @override
  String get restoreChecklistItemButton => 'Obnovi';

  @override
  String get noteSyncedMessage => 'Opomba sinhronizirana';

  @override
  String get noteSyncedFirstTimeMessage => 'Opomba prvič sinhronizirana';

  @override
  String notePartiallySyncedMessage(int accepted, int total) {
    return 'Sinhronizirano na $accepted od $total relejev';
  }

  @override
  String checklistProgress(int done, int total) {
    return 'Dokončano $done od $total';
  }

  @override
  String get showCompletedItemsTooltip => 'Pokaži dokončane postavke';

  @override
  String get hideCompletedItemsTooltip => 'Skrij dokončane postavke';

  @override
  String get allChecklistItemsCompletedHidden => 'Vse postavke so dokončane in skrite.';

  @override
  String get deleteCompletedItemsButton => 'Izbriši dokončane postavke';

  @override
  String get deleteCompletedItemsConfirmTitle => 'Izbrišem dokončane postavke?';

  @override
  String deleteCompletedItemsConfirmBody(int count) {
    return 'S tem se s seznama odstrani $count odkljukanih postavk. Tega ni mogoče razveljaviti.';
  }

  @override
  String get addImageButton => 'Dodaj sliko';

  @override
  String get noteColorButton => 'Barva zapiska';

  @override
  String get noteColorDefault => 'Privzeto';

  @override
  String get noteColorYellow => 'Rumena';

  @override
  String get noteColorRed => 'Rdeča';

  @override
  String get noteColorPurple => 'Vijolična';

  @override
  String get noteColorBlue => 'Modra';

  @override
  String get noteColorGreen => 'Zelena';

  @override
  String get noteColorOrange => 'Oranžna';

  @override
  String get noteColorWhite => 'Bela';

  @override
  String get noteColorPink => 'Roza';

  @override
  String get noteColorTeal => 'Turkizna';

  @override
  String get noteColorIndigo => 'Indigo';

  @override
  String get noteColorBrown => 'Rjava';

  @override
  String get noteColorLime => 'Limeta';

  @override
  String get recordVoiceNoteTooltip => 'Posnemi glasovno zabeležko';

  @override
  String get recordVoiceNoteInstructions =>
      'Tapnite rdeči gumb za začetek snemanja ali ✕ za preklic.';

  @override
  String get stopRecordingTooltip => 'Ustavi snemanje';

  @override
  String get cancelRecordingTooltip => 'Prekliči snemanje';

  @override
  String get addVoiceTimestampButton => 'Dodaj časovni žig';

  @override
  String get editVoiceTimestampButton => 'Uredi časovni žig';

  @override
  String get voiceNoteUnsupportedOnPlatform => 'Glasovni zapiski niso podprti v tej napravi';

  @override
  String get formatBoldTooltip => 'Krepko';

  @override
  String get formatItalicTooltip => 'Ležeče';

  @override
  String get formatStrikethroughTooltip => 'Prečrtano';

  @override
  String get formatUnderlineTooltip => 'Podčrtano';

  @override
  String get formatHeadingTooltip => 'Naslov';

  @override
  String get formatListTooltip => 'Označen seznam';

  @override
  String get formatLinkTooltip => 'Povezava';

  @override
  String get imageSizeSmall => 'Majhna';

  @override
  String get imageSizeMedium => 'Srednja';

  @override
  String get imageSizeFull => 'Polna širina';

  @override
  String get removeImageButton => 'Odstrani sliko';

  @override
  String get relayUrlHint => 'wss://relay.example.com';

  @override
  String get noRelaysMessage => 'Še ni konfiguriranega releja.';

  @override
  String relaysCount(int count) {
    return '$count relejev';
  }

  @override
  String get settingsTitle => 'Nastavitve';

  @override
  String get sectionSecurity => 'Varnost';

  @override
  String get loadingLabel => 'Nalaganje…';

  @override
  String get encryptionLoadError => 'Nastavitev šifriranja ni bilo mogoče naložiti';

  @override
  String get encryptionToggleTitle => 'Zaščiti zabeležke z geslom';

  @override
  String get encryptionToggleSubtitle =>
      'Shranjene zabeležke šifrira (AES-256-GCM) s ključem, izpeljanim iz vašega gesla. Geslo ni nikoli shranjeno — če ga pozabite, zabeležk ni mogoče obnoviti.';

  @override
  String get lockNotesNowTitle => 'Zakleni zabeležke zdaj';

  @override
  String get lockNotesNowSubtitle => 'Za ogled zabeležk bo znova potrebno geslo';

  @override
  String get setPasswordDialogTitle => 'Nastavi geslo';

  @override
  String get passwordTooShortError => 'Vsaj 8 znakov';

  @override
  String get confirmPasswordLabel => 'Potrdi geslo';

  @override
  String get passwordsDoNotMatchError => 'Gesli se ne ujemata';

  @override
  String enableEncryptionError(String error) {
    return 'Šifriranja ni bilo mogoče omogočiti: $error';
  }

  @override
  String get enableButton => 'Omogoči';

  @override
  String get disablePasswordDialogTitle => 'Vnesite geslo za onemogočanje šifriranja';

  @override
  String get disableButton => 'Onemogoči';

  @override
  String get sectionAppearance => 'Videz';

  @override
  String get lightThemeToggleTitle => 'Svetla tema';

  @override
  String get lightThemeToggleSubtitle => 'Uporabi svetlo barvno shemo namesto temne';

  @override
  String get noteLayoutToggleTitle => 'Preklop med pogledom seznama in mreže';

  @override
  String get manageRelaysTitle => 'Upravljanje relejev';

  @override
  String get autoSyncOnSaveTitle => 'Objavi ob shranjevanju';

  @override
  String get autoSyncOnSaveSubtitle =>
      'Opombe, ki jih že sinhroniziraš, se ob shranjevanju znova objavijo. Zgolj lokalne nikoli.';

  @override
  String get noteBackgroundPhoto => 'Fotografija';

  @override
  String get noteBackgroundRemove => 'Odstrani fotografijo';

  @override
  String get republishAllNotesButton => 'Znova objavi vse sinhronizirane zapiske';

  @override
  String get republishAllNotesSubtitle =>
      'Vsak zgornji rele dopolni z zapiski, ki so drugje že deljeni — koristno takoj po dodajanju novega, npr. lastnega varnostnega releja';

  @override
  String republishAllNotesSuccess(int count) {
    return 'Znova objavljenih $count zapiskov';
  }

  @override
  String republishAllNotesError(String error) {
    return 'Zapiskov ni bilo mogoče znova objaviti: $error';
  }

  @override
  String get forceFullResyncButton => 'Vsili popolno ponovno sinhronizacijo';

  @override
  String get forceFullResyncSubtitle =>
      'Ponovno preveri releje za celotno zgodovino zapiska namesto samo novosti — uporabno, če je sinhronizacija videti zataknjena in preskoči starejše zapiske, npr. po odpravi nedosegljivega releja';

  @override
  String get forceFullResyncSuccess => 'Zapiski osveženi iz relejev';

  @override
  String forceFullResyncError(String error) {
    return 'Zapiskov ni bilo mogoče ponovno sinhronizirati: $error';
  }

  @override
  String get confirmButton => 'Potrdi';

  @override
  String get sectionLanguage => 'Jezik';

  @override
  String get langSystem => 'Privzeto v sistemu';

  @override
  String get sectionAccount => 'Račun';

  @override
  String get accountLocalOnlyMessage => 'Echoes se uporablja lokalno — ni sinhronizirano z Nostr';

  @override
  String get accountSignInButton => 'Prijava';

  @override
  String accountSignedInAs(String npub) {
    return 'Prijavljeni ste kot $npub';
  }

  @override
  String get accountSignOutButton => 'Odjava';

  @override
  String get accountSignOutConfirmTitle => 'Se želite odjaviti?';

  @override
  String get accountSignOutConfirmBody =>
      'Vaše zabeležke ostanejo na tej napravi. Kadar koli se lahko znova prijavite.';

  @override
  String get onboardingWelcomeTitle => 'Dobrodošli v Echoes';

  @override
  String get onboardingIntroLocalTitle => 'Vaše zabeležke, vedno na vaši napravi';

  @override
  String get onboardingIntroLocalBody =>
      'Vsaka zabeležka je najprej shranjena lokalno, zato aplikacija deluje popolnoma brez povezave. Nič ne zapusti vaše naprave, razen če se odločite za sinhronizacijo.';

  @override
  String get onboardingIntroSyncTitle => 'Neobvezna sinhronizacija prek Nostr';

  @override
  String get onboardingIntroSyncBody =>
      'Vklopite sinhronizacijo, da varnostno kopirate zabeležke in jih berete na drugih napravah z uporabo odprtega protokola Nostr in izbranih relejev.';

  @override
  String get onboardingIntroEncryptionTitle => 'Vedno šifrirano';

  @override
  String get onboardingIntroEncryptionBody =>
      'Zabeležke, sinhronizirane z Nostr, so šifrirane od konca do konca, zato upravljavci relejev — in nihče drug — nikoli ne morejo prebrati njihove vsebine.';

  @override
  String get onboardingIntroAmberTitle => 'Prijavite se, ne da bi razkrili svoj ključ';

  @override
  String get onboardingIntroAmberBody =>
      'Za prijavo uporabite Amber: vaš zasebni ključ ostane v Amberju in nikoli ni deljen z Echoes.';

  @override
  String get onboardingIntroSecurityTitle => 'Varnost že v zasnovi';

  @override
  String get onboardingIntroSecurityBody =>
      'Vaš zasebni ključ je shranjen v šifrirani shrambi ključev naprave — ali pa z Amberjem sploh nikoli ne pride v stik z Echoes. Fotografije in glasovne zabeležke so šifrirane, preden zapustijo napravo. Zabeležke lahko zaklenete z geslom, in nič od tega nikoli ni vključeno v varnostne kopije telefona.';

  @override
  String get onboardingNextButton => 'Naprej';

  @override
  String get onboardingBackButton => 'Nazaj';

  @override
  String get onboardingSkipButton => 'Preskoči — uporabljaj Echoes samo lokalno';

  @override
  String get onboardingRelayTitle => 'Izberite releje za sinhronizacijo';

  @override
  String get onboardingRelayBody =>
      'Releji so mesto, kjer so shranjene vaše šifrirane zabeležke ob sinhronizaciji. Dodajte enega ali več — ti priljubljeni so dober začetek:';

  @override
  String get onboardingFinishButton => 'Začni';

  @override
  String get syncNoteTooltip => 'Sinhroniziraj to zabeležko';

  @override
  String get unsyncNoteTooltip => 'Odstrani z relejev';

  @override
  String get syncSelectedTooltip => 'Sinhroniziraj izbrane zabeležke';

  @override
  String get exportSelectedTooltip => 'Izvozi izbrane zabeležke';

  @override
  String get deleteSelectedTooltip => 'Izbriši izbrane zabeležke';

  @override
  String syncNoteError(String error) {
    return 'Zabeležke ni bilo mogoče sinhronizirati: $error';
  }

  @override
  String unsyncNoteError(String error) {
    return 'Zabeležke ni bilo mogoče odstraniti z relejev: $error';
  }

  @override
  String deleteNoteRelayError(String error) {
    return 'Zabeležka je bila izbrisana lokalno, vendar je ni bilo mogoče odstraniti z relejev: $error';
  }

  @override
  String deleteNotesRelayError(int count) {
    return '$count zabeležk izbrisanih lokalno, vendar jih ni bilo mogoče odstraniti z relejev';
  }

  @override
  String get deletingNotesTitle => 'Brisanje zapiskov…';

  @override
  String deletingNotesProgress(int completed, int total) {
    return 'Brisanje $completed od $total';
  }

  @override
  String get syncSelectedSuccess => 'Zabeležke sinhronizirane';

  @override
  String syncSelectedPartialError(int count) {
    return '$count zabeležk ni bilo mogoče sinhronizirati';
  }

  @override
  String get exportConfirmTitle => 'Izvozi zabeležke';

  @override
  String get exportConfirmBody =>
      'Ustvari varnostno kopijo vaših zabeležk. Vključuje tudi ključe za dešifriranje priloženih slik ali glasovnih zabeležk — kdorkoli z datoteko bi jih lahko prebral, razen če je šifrirana.';

  @override
  String get exportEncryptToggleLabel => 'Šifriraj to datoteko';

  @override
  String get exportEncryptToggleSubtitle => 'Priporočeno — ščiti varnostno kopijo z geslom';

  @override
  String get exportPasswordDialogTitle => 'Vnesite svoje geslo';

  @override
  String get exportSetPasswordDialogTitle => 'Nastavite geslo za ta izvoz';

  @override
  String get importPasswordDialogTitle => 'Vnesite geslo izvoza';

  @override
  String get sectionData => 'Podatki';

  @override
  String get exportNotesButton => 'Izvozi zabeležke';

  @override
  String get exportNotesSubtitle =>
      'Shranite vse svoje zabeležke v datoteko, ki jo lahko pozneje znova uvozite';

  @override
  String get importNotesButton => 'Uvozi zabeležke';

  @override
  String get importNotesSubtitle => 'Obnovite zabeležke iz predhodno izvožene datoteke';

  @override
  String get exportNotesSuccess => 'Zabeležke izvožene';

  @override
  String exportNotesError(Object error) {
    return 'Zabeležk ni bilo mogoče izvoziti: $error';
  }

  @override
  String importNotesSuccess(int count) {
    return 'Uvoženih $count zabeležk';
  }

  @override
  String importNotesError(Object error) {
    return 'Zabeležk ni bilo mogoče uvoziti: $error';
  }

  @override
  String get sectionAttachments => 'Priloge';

  @override
  String get attachmentProviderSubtitle =>
      'Kam se naložijo šifrirane slike in glasovne zabeležke ob sinhronizaciji';

  @override
  String get attachmentProviderCustom => 'Po meri…';

  @override
  String get attachmentCustomUrlLabel => 'URL strežnika';

  @override
  String get attachmentProviderHint =>
      'Nekateri javni strežniki (npr. Primal, nostr.build) šifrirane prenose zavrnejo — preverjajo pravo slikovno vsebino, kar šifrirani podatki nikoli niso. Raje izberite strežnik Blossom, ki shranjuje neprozorne podatke, ali usmerite Po meri… na lastnega.';

  @override
  String get sectionSupport => 'Podpora';

  @override
  String get supportEchoesTitle => 'Podpri Echoes';

  @override
  String lightningAddressCopied(String address) {
    return '⚡ $address kopirano v odložišče';
  }

  @override
  String get cancelButton => 'Prekliči';

  @override
  String get passwordLabel => 'Geslo';

  @override
  String get invalidPrivateKeyError =>
      'Zasebni ključ ni veljaven. Vnesite veljaven ključ nsec ali hex.';

  @override
  String get wrongPasswordError => 'Napačno geslo';

  @override
  String genericErrorPrefix(String error) {
    return 'Napaka: $error';
  }

  @override
  String get shareNoteTooltip => 'Deli';

  @override
  String get shareNoteTitle => 'Deli zapisek';

  @override
  String get shareRecipientFieldLabel => 'npub ali javni ključ prejemnika';

  @override
  String get shareAddRecipientButton => 'Dodaj';

  @override
  String get shareInvalidRecipientError => 'To ni veljaven npub ali javni ključ';

  @override
  String get shareRecipientNotFoundError => 'Za to ime ni bilo najdenega računa Nostr';

  @override
  String get shareConfirmTitle => 'Deliti to opombo?';

  @override
  String get shareConfirmButton => 'Deli';

  @override
  String get shareAlreadyRecipientError => 'S to osebo je že deljeno';

  @override
  String get shareCannotShareWithSelfError => 'Zapiska ne morete deliti s samim seboj';

  @override
  String get shareRecipientsHeader => 'Deljeno z';

  @override
  String get shareNoRecipientsMessage => 'Še ni deljeno z nikomer.';

  @override
  String get stopSharingTooltip => 'Prenehaj deliti s to osebo';

  @override
  String get shareRevocationNote =>
      'Vsak, s komer delite, lahko bere ta zapisek na svoji napravi. Odstranitev nekoga ustavi prihodnje posodobitve, ne more pa izbrisati že prejetega.';

  @override
  String shareError(String error) {
    return 'Deljenja ni bilo mogoče posodobiti: $error';
  }

  @override
  String get sharedWithMeHeader => 'Deljeno z vami';

  @override
  String sharedByLabel(String npub) {
    return 'Delil(a) $npub';
  }

  @override
  String get sharedNoteEditableNote =>
      'Ta zapisek lahko urejate; vaše spremembe se sinhronizirajo nazaj lastniku, ki jih združi.';

  @override
  String get abandonSharedNoteButton => 'Zapusti ta deljeni zapisek';

  @override
  String get abandonSharedNoteConfirmTitle => 'Zapustiti ta deljeni zapisek?';

  @override
  String get abandonSharedNoteConfirmBody =>
      'Odstranjen bo iz te naprave in ne boste več prejemali posodobitev. Tega ni mogoče razveljaviti — pozneje se ne boste mogli znova pridružiti.';

  @override
  String abandonSharedNoteError(String error) {
    return 'Ni bilo mogoče zapustiti: $error';
  }
}
