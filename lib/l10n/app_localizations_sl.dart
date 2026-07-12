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
  String get importAccountFieldLabel =>
      'Zasebni ključ (nsec) vašega računa Nostr';

  @override
  String get importButton => 'Uvozi';

  @override
  String get relaysTitle => 'Releji';

  @override
  String get settingsTooltip => 'Nastavitve';

  @override
  String get emptyNotesMessage =>
      'Še ni zabeležk. Dotaknite se +, da ustvarite novo.';

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
  String get newNoteTitle => 'Nova zabeležka';

  @override
  String get editNoteTitle => 'Uredi zabeležko';

  @override
  String get newDiaryEntryTitle => 'New diary entry';

  @override
  String get editDiaryEntryTitle => 'Edit diary entry';

  @override
  String get saveTooltip => 'Shrani';

  @override
  String get titleFieldLabel => 'Naslov';

  @override
  String get checklistLabel => 'Kontrolni seznam';

  @override
  String get bodyFieldHint => 'Pišite tukaj... (markdown je podprt)';

  @override
  String get checklistItemHint => 'Postavka seznama';

  @override
  String get addItemButton => 'Dodaj postavko';

  @override
  String get addImageButton => 'Dodaj sliko';

  @override
  String get recordVoiceNoteTooltip => 'Posnemi glasovno zabeležko';

  @override
  String get stopRecordingTooltip => 'Ustavi snemanje';

  @override
  String get cancelRecordingTooltip => 'Prekliči snemanje';

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
  String get encryptionLoadError =>
      'Nastavitev šifriranja ni bilo mogoče naložiti';

  @override
  String get encryptionToggleTitle => 'Zaščiti zabeležke z geslom';

  @override
  String get encryptionToggleSubtitle =>
      'Shranjene zabeležke šifrira (AES-256-GCM) s ključem, izpeljanim iz vašega gesla. Geslo ni nikoli shranjeno — če ga pozabite, zabeležk ni mogoče obnoviti.';

  @override
  String get lockNotesNowTitle => 'Zakleni zabeležke zdaj';

  @override
  String get lockNotesNowSubtitle =>
      'Za ogled zabeležk bo znova potrebno geslo';

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
  String get disablePasswordDialogTitle =>
      'Vnesite geslo za onemogočanje šifriranja';

  @override
  String get disableButton => 'Onemogoči';

  @override
  String get sectionAppearance => 'Videz';

  @override
  String get lightThemeToggleTitle => 'Svetla tema';

  @override
  String get lightThemeToggleSubtitle =>
      'Uporabi svetlo barvno shemo namesto temne';

  @override
  String get noteLayoutToggleTitle => 'Postavitev seznama zabeležk';

  @override
  String get noteLayoutToggleSubtitle =>
      'Preklopi med prikazom seznama in mreže';

  @override
  String get manageRelaysTitle => 'Upravljanje relejev';

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
  String get confirmButton => 'Potrdi';

  @override
  String get sectionLanguage => 'Jezik';

  @override
  String get langSystem => 'Privzeto v sistemu';

  @override
  String get sectionAccount => 'Račun';

  @override
  String get accountLocalOnlyMessage =>
      'Echoes se uporablja lokalno — ni sinhronizirano z Nostr';

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
  String get onboardingIntroLocalTitle =>
      'Vaše zabeležke, vedno na vaši napravi';

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
  String get onboardingIntroAmberTitle =>
      'Prijavite se, ne da bi razkrili svoj ključ';

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
  String get onboardingSkipButton =>
      'Preskoči — uporabljaj Echoes samo lokalno';

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
  String get exportEncryptToggleSubtitle =>
      'Priporočeno — ščiti varnostno kopijo z geslom';

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
  String get importNotesSubtitle =>
      'Obnovite zabeležke iz predhodno izvožene datoteke';

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
      'Some public hosts (e.g. Primal, nostr.build) reject encrypted uploads outright — they validate real image content, which ciphertext never is. Prefer a Blossom host that stores opaque blobs, or point Custom… at a self-hosted one.';

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
}
