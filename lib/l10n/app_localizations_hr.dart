// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String get loginSubtitle => 'Prijavite se svojim Nostr računom';

  @override
  String get loginWithAmberButton => 'Prijava putem Ambera';

  @override
  String get importAccountButton => 'Uvezi Nostr račun';

  @override
  String get importAccountFieldLabel =>
      'Privatni ključ (nsec) vašeg Nostr računa';

  @override
  String get importButton => 'Uvezi';

  @override
  String get relaysTitle => 'Releji';

  @override
  String get settingsTooltip => 'Postavke';

  @override
  String get searchTooltip => 'Pretraži';

  @override
  String get closeSearchTooltip => 'Zatvori pretraživanje';

  @override
  String get searchNotesHint => 'Pretraži bilješke';

  @override
  String get noSearchResultsMessage => 'Nema podudaranja.';

  @override
  String get emptyNotesMessage =>
      'Još nema bilješki. Dodirnite + za izradu nove.';

  @override
  String get notesTabLabel => 'Bilješke';

  @override
  String get diaryTabLabel => 'Dnevnik';

  @override
  String get emptyDiaryMessage =>
      'Još nema zapisa u dnevniku. Dodirnite + da biste napisali jedan.';

  @override
  String get diaryToday => 'Danas';

  @override
  String get diaryYesterday => 'Jučer';

  @override
  String get newPlainNoteOption => 'Bilješka';

  @override
  String get newChecklistOption => 'Popis za provjeru';

  @override
  String get newVoiceNoteOption => 'Glasovna bilješka';

  @override
  String get deleteNoteButton => 'Izbriši bilješku';

  @override
  String get deleteNoteConfirmTitle => 'Izbrisati ovu bilješku?';

  @override
  String get deleteNoteConfirmBody =>
      'Ovo se ne može poništiti. Ako je ova bilješka bila sinkronizirana, bit će uklonjena i s vaših releja.';

  @override
  String deleteNotesConfirmTitle(int count) {
    return 'Izbrisati $count bilješki?';
  }

  @override
  String get deleteNotesConfirmBody =>
      'Ovo se ne može poništiti. Ako je bilo koja od ovih bilješki bila sinkronizirana, bit će uklonjena i s vaših releja.';

  @override
  String selectionCount(int count) {
    return 'Odabrano: $count';
  }

  @override
  String get untitledNote => '(bez naslova)';

  @override
  String errorLoadingNotes(String error) {
    return 'Pogreška pri učitavanju bilješki: $error';
  }

  @override
  String get timeJustNow => 'upravo sada';

  @override
  String timeMinutesAgo(int count) {
    return 'prije $count min';
  }

  @override
  String timeHoursAgo(int count) {
    return 'prije $count h';
  }

  @override
  String timeDaysAgo(int count) {
    return 'prije $count d';
  }

  @override
  String get notesLockedTitle => 'Bilješke su zaštićene lozinkom';

  @override
  String get unlockButton => 'Otključaj';

  @override
  String get saveTooltip => 'Spremi';

  @override
  String get titleFieldLabel => 'Naslov';

  @override
  String get bodyFieldHint => 'Pišite ovdje... (markdown je podržan)';

  @override
  String get checklistItemHint => 'Stavka popisa';

  @override
  String get addItemButton => 'Dodaj stavku';

  @override
  String checklistProgress(int done, int total) {
    return 'Dovršeno $done od $total';
  }

  @override
  String get showCompletedItemsTooltip => 'Prikaži dovršene stavke';

  @override
  String get hideCompletedItemsTooltip => 'Sakrij dovršene stavke';

  @override
  String get allChecklistItemsCompletedHidden =>
      'Sve su stavke dovršene i skrivene.';

  @override
  String get deleteCompletedItemsButton => 'Izbriši dovršene stavke';

  @override
  String get deleteCompletedItemsConfirmTitle => 'Izbrisati dovršene stavke?';

  @override
  String deleteCompletedItemsConfirmBody(int count) {
    return 'Ovim se uklanja $count označenih stavki s ovog popisa. Ne može se poništiti.';
  }

  @override
  String get addImageButton => 'Dodaj sliku';

  @override
  String get noteColorButton => 'Boja bilješke';

  @override
  String get noteColorDefault => 'Zadano';

  @override
  String get noteColorYellow => 'Žuta';

  @override
  String get noteColorRed => 'Crvena';

  @override
  String get noteColorPurple => 'Ljubičasta';

  @override
  String get noteColorBlue => 'Plava';

  @override
  String get noteColorGreen => 'Zelena';

  @override
  String get noteColorOrange => 'Narančasta';

  @override
  String get noteColorWhite => 'Bijela';

  @override
  String get recordVoiceNoteTooltip => 'Snimi glasovnu bilješku';

  @override
  String get recordVoiceNoteInstructions =>
      'Dodirnite crveni gumb za početak snimanja ili ✕ za odustajanje.';

  @override
  String get stopRecordingTooltip => 'Zaustavi snimanje';

  @override
  String get cancelRecordingTooltip => 'Otkaži snimanje';

  @override
  String get addVoiceTimestampButton => 'Dodaj vremensku oznaku';

  @override
  String get editVoiceTimestampButton => 'Uredi vremensku oznaku';

  @override
  String get voiceNoteUnsupportedOnPlatform =>
      'Glasovne bilješke nisu podržane na ovom uređaju';

  @override
  String get formatBoldTooltip => 'Podebljano';

  @override
  String get formatItalicTooltip => 'Kurziv';

  @override
  String get formatHeadingTooltip => 'Naslov';

  @override
  String get formatListTooltip => 'Popis s grafičkim oznakama';

  @override
  String get formatLinkTooltip => 'Poveznica';

  @override
  String get imageSizeSmall => 'Malo';

  @override
  String get imageSizeMedium => 'Srednje';

  @override
  String get imageSizeFull => 'Puna širina';

  @override
  String get removeImageButton => 'Ukloni sliku';

  @override
  String get relayUrlHint => 'wss://relay.example.com';

  @override
  String get noRelaysMessage => 'Još nije konfiguriran nijedan relej.';

  @override
  String relaysCount(int count) {
    return '$count releja';
  }

  @override
  String get settingsTitle => 'Postavke';

  @override
  String get sectionSecurity => 'Sigurnost';

  @override
  String get loadingLabel => 'Učitavanje…';

  @override
  String get encryptionLoadError => 'Postavke šifriranja nije moguće učitati';

  @override
  String get encryptionToggleTitle => 'Zaštiti bilješke lozinkom';

  @override
  String get encryptionToggleSubtitle =>
      'Šifrira pohranjene bilješke (AES-256-GCM) ključem izvedenim iz vaše lozinke. Lozinka se nikada ne pohranjuje — ako je zaboravite, bilješke se ne mogu oporaviti.';

  @override
  String get lockNotesNowTitle => 'Zaključaj bilješke sada';

  @override
  String get lockNotesNowSubtitle =>
      'Za pregled bilješki ponovno će biti potrebna lozinka';

  @override
  String get setPasswordDialogTitle => 'Postavi lozinku';

  @override
  String get passwordTooShortError => 'Najmanje 8 znakova';

  @override
  String get confirmPasswordLabel => 'Potvrdi lozinku';

  @override
  String get passwordsDoNotMatchError => 'Lozinke se ne podudaraju';

  @override
  String enableEncryptionError(String error) {
    return 'Šifriranje nije moguće aktivirati: $error';
  }

  @override
  String get enableButton => 'Aktiviraj';

  @override
  String get disablePasswordDialogTitle =>
      'Unesite lozinku za deaktiviranje šifriranja';

  @override
  String get disableButton => 'Deaktiviraj';

  @override
  String get sectionAppearance => 'Izgled';

  @override
  String get lightThemeToggleTitle => 'Svijetla tema';

  @override
  String get lightThemeToggleSubtitle =>
      'Koristi svijetlu shemu boja umjesto tamne';

  @override
  String get noteLayoutToggleTitle => 'Prebaci između prikaza popisa i mreže';

  @override
  String get manageRelaysTitle => 'Upravljanje relejima';

  @override
  String get republishAllNotesButton =>
      'Ponovno objavi sve sinkronizirane bilješke';

  @override
  String get republishAllNotesSubtitle =>
      'Nadopunjuje svaki gornji relej bilješkama već podijeljenima drugdje — korisno odmah nakon dodavanja novog, npr. vlastitog pričuvnog releja';

  @override
  String republishAllNotesSuccess(int count) {
    return 'Ponovno objavljeno $count bilješki';
  }

  @override
  String republishAllNotesError(String error) {
    return 'Bilješke nije moguće ponovno objaviti: $error';
  }

  @override
  String get forceFullResyncButton => 'Prisilna potpuna ponovna sinkronizacija';

  @override
  String get forceFullResyncSubtitle =>
      'Ponovno provjerava relaye za cijelu povijest bilješke umjesto samo novoga — korisno ako se sinkronizacija čini zaglavljenom i preskače starije bilješke, npr. nakon rješavanja nedostupnog relaya';

  @override
  String get forceFullResyncSuccess => 'Bilješke osvježene s relaya';

  @override
  String forceFullResyncError(String error) {
    return 'Ponovna sinkronizacija bilježaka nije uspjela: $error';
  }

  @override
  String get confirmButton => 'Potvrdi';

  @override
  String get sectionLanguage => 'Jezik';

  @override
  String get langSystem => 'Zadano sustavom';

  @override
  String get sectionAccount => 'Račun';

  @override
  String get accountLocalOnlyMessage =>
      'Echoes se koristi lokalno — bez sinkronizacije s Nostrom';

  @override
  String get accountSignInButton => 'Prijava';

  @override
  String accountSignedInAs(String npub) {
    return 'Prijavljeni ste kao $npub';
  }

  @override
  String get accountSignOutButton => 'Odjava';

  @override
  String get accountSignOutConfirmTitle => 'Odjaviti se?';

  @override
  String get accountSignOutConfirmBody =>
      'Vaše bilješke ostaju na ovom uređaju. Možete se ponovno prijaviti u bilo kojem trenutku.';

  @override
  String get onboardingWelcomeTitle => 'Dobrodošli u Echoes';

  @override
  String get onboardingIntroLocalTitle =>
      'Vaše bilješke, uvijek na vašem uređaju';

  @override
  String get onboardingIntroLocalBody =>
      'Svaka bilješka prvo se sprema lokalno, tako da aplikacija radi potpuno izvanmrežno. Ništa ne napušta vaš uređaj osim ako ne odaberete sinkronizaciju.';

  @override
  String get onboardingIntroSyncTitle =>
      'Neobavezna sinkronizacija putem Nostra';

  @override
  String get onboardingIntroSyncBody =>
      'Uključite sinkronizaciju za sigurnosnu pohranu bilješki i njihovo čitanje na drugim uređajima, koristeći otvoreni protokol Nostr i releje po vašem izboru.';

  @override
  String get onboardingIntroEncryptionTitle => 'Uvijek šifrirano';

  @override
  String get onboardingIntroEncryptionBody =>
      'Bilješke sinkronizirane s Nostrom su end-to-end šifrirane, tako da operateri releja — kao ni bilo tko drugi — nikada ne mogu pročitati njihov sadržaj.';

  @override
  String get onboardingIntroAmberTitle => 'Prijavite se bez otkrivanja ključa';

  @override
  String get onboardingIntroAmberBody =>
      'Koristite Amber za prijavu: vaš privatni ključ ostaje u Amberu i nikada se ne dijeli s Echoesom.';

  @override
  String get onboardingIntroSecurityTitle => 'Sigurnost po dizajnu';

  @override
  String get onboardingIntroSecurityBody =>
      'Vaš privatni ključ nalazi se u šifriranom spremištu ključeva vašeg uređaja — ili, uz Amber, uopće ne dolazi u dodir s Echoesom. Fotografije i glasovne bilješke šifriraju se prije nego što ikada napuste vaš uređaj. Bilješke se mogu zaključati lozinkom, a ništa od toga nikada se ne uključuje u sigurnosne kopije telefona.';

  @override
  String get onboardingNextButton => 'Dalje';

  @override
  String get onboardingBackButton => 'Natrag';

  @override
  String get onboardingSkipButton => 'Preskoči — koristi Echoes samo lokalno';

  @override
  String get onboardingRelayTitle => 'Odaberite releje za sinkronizaciju';

  @override
  String get onboardingRelayBody =>
      'Releji su mjesto gdje se pohranjuju vaše šifrirane bilješke prilikom sinkronizacije. Dodajte jedan ili više — ovi popularni su dobar početak:';

  @override
  String get onboardingFinishButton => 'Započni';

  @override
  String get syncNoteTooltip => 'Sinkroniziraj ovu bilješku';

  @override
  String get unsyncNoteTooltip => 'Ukloni s releja';

  @override
  String get syncSelectedTooltip => 'Sinkroniziraj odabrane bilješke';

  @override
  String get exportSelectedTooltip => 'Izvezi odabrane bilješke';

  @override
  String get deleteSelectedTooltip => 'Izbriši odabrane bilješke';

  @override
  String syncNoteError(String error) {
    return 'Bilješku nije moguće sinkronizirati: $error';
  }

  @override
  String unsyncNoteError(String error) {
    return 'Bilješku nije bilo moguće ukloniti s releja: $error';
  }

  @override
  String deleteNoteRelayError(String error) {
    return 'Bilješka je izbrisana lokalno, ali ju nije bilo moguće ukloniti s releja: $error';
  }

  @override
  String deleteNotesRelayError(int count) {
    return '$count bilješki izbrisano lokalno, ali ih nije bilo moguće ukloniti s releja';
  }

  @override
  String get deletingNotesTitle => 'Brisanje bilješki…';

  @override
  String deletingNotesProgress(int completed, int total) {
    return 'Brisanje $completed od $total';
  }

  @override
  String get syncSelectedSuccess => 'Bilješke sinkronizirane';

  @override
  String syncSelectedPartialError(int count) {
    return 'Nije bilo moguće sinkronizirati $count bilješki';
  }

  @override
  String get exportConfirmTitle => 'Izvoz bilješki';

  @override
  String get exportConfirmBody =>
      'Stvara sigurnosnu kopiju vaših bilješki. Također uključuje ključeve za dešifriranje priloženih slika ili glasovnih bilješki — svatko tko ima datoteku mogao bi ih pročitati osim ako nije šifrirana.';

  @override
  String get exportEncryptToggleLabel => 'Šifriraj ovu datoteku';

  @override
  String get exportEncryptToggleSubtitle =>
      'Preporučeno — štiti sigurnosnu kopiju lozinkom';

  @override
  String get exportPasswordDialogTitle => 'Unesite svoju lozinku';

  @override
  String get exportSetPasswordDialogTitle => 'Postavite lozinku za ovaj izvoz';

  @override
  String get importPasswordDialogTitle => 'Unesite lozinku izvoza';

  @override
  String get sectionData => 'Podaci';

  @override
  String get exportNotesButton => 'Izvezi bilješke';

  @override
  String get exportNotesSubtitle =>
      'Spremite sve svoje bilješke u datoteku koju možete kasnije ponovno uvesti';

  @override
  String get importNotesButton => 'Uvezi bilješke';

  @override
  String get importNotesSubtitle =>
      'Vratite bilješke iz prethodno izvezene datoteke';

  @override
  String get exportNotesSuccess => 'Bilješke izvezene';

  @override
  String exportNotesError(Object error) {
    return 'Bilješke nije moguće izvesti: $error';
  }

  @override
  String importNotesSuccess(int count) {
    return 'Uvezeno $count bilješki';
  }

  @override
  String importNotesError(Object error) {
    return 'Bilješke nije moguće uvesti: $error';
  }

  @override
  String get sectionAttachments => 'Prilozi';

  @override
  String get attachmentProviderSubtitle =>
      'Gdje se prenose šifrirane slike i glasovne bilješke prilikom sinkronizacije';

  @override
  String get attachmentProviderCustom => 'Prilagođeno…';

  @override
  String get attachmentCustomUrlLabel => 'URL poslužitelja';

  @override
  String get attachmentProviderHint =>
      'Neki javni poslužitelji (npr. Primal, nostr.build) odbijaju šifrirane prijenose — provjeravaju stvarni sadržaj slike, što šifrirani podaci nikad nisu. Radije odaberite Blossom poslužitelj koji sprema neprozirne podatke ili usmjerite Prilagođeno… na vlastiti.';

  @override
  String get sectionSupport => 'Podrška';

  @override
  String get supportEchoesTitle => 'Podrži Echoes';

  @override
  String lightningAddressCopied(String address) {
    return '⚡ $address kopirano u međuspremnik';
  }

  @override
  String get cancelButton => 'Odustani';

  @override
  String get passwordLabel => 'Lozinka';

  @override
  String get invalidPrivateKeyError =>
      'Privatni ključ nije valjan. Unesite valjan nsec ili hex ključ.';

  @override
  String get wrongPasswordError => 'Pogrešna lozinka';

  @override
  String genericErrorPrefix(String error) {
    return 'Pogreška: $error';
  }

  @override
  String get shareNoteTooltip => 'Podijeli';

  @override
  String get shareNoteTitle => 'Podijeli bilješku';

  @override
  String get shareRecipientFieldLabel => 'npub ili javni ključ primatelja';

  @override
  String get shareAddRecipientButton => 'Dodaj';

  @override
  String get shareInvalidRecipientError => 'To nije valjan npub ni javni ključ';

  @override
  String get shareRecipientNotFoundError =>
      'Nije pronađen Nostr račun za to ime';

  @override
  String get shareConfirmTitle => 'Podijeliti ovu bilješku?';

  @override
  String get shareConfirmButton => 'Podijeli';

  @override
  String get shareAlreadyRecipientError => 'Već podijeljeno s ovom osobom';

  @override
  String get shareCannotShareWithSelfError =>
      'Ne možete podijeliti bilješku sa samim sobom';

  @override
  String get shareRecipientsHeader => 'Podijeljeno s';

  @override
  String get shareNoRecipientsMessage => 'Još nije podijeljeno ni s kim.';

  @override
  String get stopSharingTooltip => 'Prestani dijeliti s ovom osobom';

  @override
  String get shareRevocationNote =>
      'Svatko s kim podijelite može čitati ovu bilješku na svom uređaju. Uklanjanje nekoga zaustavlja buduća ažuriranja, ali ne može izbrisati ono što je već primio.';

  @override
  String shareError(String error) {
    return 'Ažuriranje dijeljenja nije uspjelo: $error';
  }

  @override
  String get sharedWithMeHeader => 'Podijeljeno s vama';

  @override
  String sharedByLabel(String npub) {
    return 'Podijelio/la $npub';
  }

  @override
  String get sharedNoteEditableNote =>
      'Možete uređivati ovu bilješku; vaše se promjene sinkroniziraju natrag vlasniku, koji ih spaja.';

  @override
  String get abandonSharedNoteButton => 'Napusti ovu dijeljenu bilješku';

  @override
  String get abandonSharedNoteConfirmTitle =>
      'Napustiti ovu dijeljenu bilješku?';

  @override
  String get abandonSharedNoteConfirmBody =>
      'Bit će uklonjena s ovog uređaja i prestat ćete primati ažuriranja. Ovo se ne može poništiti — nećete se moći ponovno pridružiti.';

  @override
  String abandonSharedNoteError(String error) {
    return 'Napuštanje nije uspjelo: $error';
  }
}
