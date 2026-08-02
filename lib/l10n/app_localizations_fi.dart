// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get loginSubtitle => 'Kirjaudu sisään Nostr-tililläsi';

  @override
  String get loginWithAmberButton => 'Kirjaudu Amberilla';

  @override
  String get importAccountButton => 'Tuo Nostr-tili';

  @override
  String get importAccountFieldLabel => 'Nostr-tilisi yksityinen avain (nsec)';

  @override
  String get importButton => 'Tuo';

  @override
  String get bunkerLoginButton => 'Yhdistä etäallekirjoittaja (bunker)';

  @override
  String get bunkerFieldLabel => 'Liitä bunker://-yhteystunnuksesi';

  @override
  String get bunkerConnectButton => 'Yhdistä';

  @override
  String get bunkerAuthPrompt => 'Hyväksy yhteys allekirjoittajassasi ja palaa takaisin';

  @override
  String get relaysTitle => 'Relet';

  @override
  String get settingsTooltip => 'Asetukset';

  @override
  String get searchTooltip => 'Hae';

  @override
  String get closeSearchTooltip => 'Sulje haku';

  @override
  String get searchNotesHint => 'Hae muistiinpanoista';

  @override
  String get noSearchResultsMessage => 'Ei osumia.';

  @override
  String get emptyNotesMessage => 'Ei vielä muistiinpanoja. Luo uusi napauttamalla +.';

  @override
  String get notesTabLabel => 'Muistiinpanot';

  @override
  String get diaryTabLabel => 'Päiväkirja';

  @override
  String get emptyDiaryMessage => 'Ei vielä päiväkirjamerkintöjä. Napauta + kirjoittaaksesi.';

  @override
  String get diaryToday => 'Tänään';

  @override
  String get diaryYesterday => 'Eilen';

  @override
  String get newPlainNoteOption => 'Muistiinpano';

  @override
  String get newChecklistOption => 'Tarkistuslista';

  @override
  String get newVoiceNoteOption => 'Äänimuistiinpano';

  @override
  String get deleteNoteButton => 'Poista muistiinpano';

  @override
  String get deleteNoteConfirmTitle => 'Poistetaanko tämä muistiinpano?';

  @override
  String get deleteNoteConfirmBody =>
      'Tätä ei voi kumota. Jos muistiinpano oli synkronoitu, se poistetaan myös releiltäsi.';

  @override
  String deleteNotesConfirmTitle(int count) {
    return 'Poistetaanko $count muistiinpanoa?';
  }

  @override
  String get deleteNotesConfirmBody =>
      'Tätä ei voi kumota. Jos jokin näistä muistiinpanoista oli synkronoitu, se poistetaan myös releiltäsi.';

  @override
  String selectionCount(int count) {
    return '$count valittu';
  }

  @override
  String get untitledNote => '(nimetön)';

  @override
  String errorLoadingNotes(String error) {
    return 'Virhe muistiinpanojen lataamisessa: $error';
  }

  @override
  String get timeJustNow => 'juuri nyt';

  @override
  String timeMinutesAgo(int count) {
    return '$count min sitten';
  }

  @override
  String timeHoursAgo(int count) {
    return '$count t sitten';
  }

  @override
  String timeDaysAgo(int count) {
    return '$count pv sitten';
  }

  @override
  String get notesLockedTitle => 'Muistiinpanot on suojattu salasanalla';

  @override
  String get unlockButton => 'Avaa lukitus';

  @override
  String get saveTooltip => 'Tallenna';

  @override
  String get titleFieldLabel => 'Otsikko';

  @override
  String get bodyFieldHint => 'Kirjoita tähän... (markdown tuettu)';

  @override
  String get checklistItemHint => 'Listan kohde';

  @override
  String get addItemButton => 'Lisää kohde';

  @override
  String checklistProgress(int done, int total) {
    return '$done/$total valmiina';
  }

  @override
  String get showCompletedItemsTooltip => 'Näytä valmiit kohdat';

  @override
  String get hideCompletedItemsTooltip => 'Piilota valmiit kohdat';

  @override
  String get allChecklistItemsCompletedHidden => 'Kaikki kohdat ovat valmiita ja piilotettuja.';

  @override
  String get deleteCompletedItemsButton => 'Poista valmiit kohdat';

  @override
  String get deleteCompletedItemsConfirmTitle => 'Poistetaanko valmiit kohdat?';

  @override
  String deleteCompletedItemsConfirmBody(int count) {
    return 'Tämä poistaa $count merkittyä kohtaa tästä listasta. Ei voi kumota.';
  }

  @override
  String get addImageButton => 'Lisää kuva';

  @override
  String get noteColorButton => 'Muistiinpanon väri';

  @override
  String get noteColorDefault => 'Oletus';

  @override
  String get noteColorYellow => 'Keltainen';

  @override
  String get noteColorRed => 'Punainen';

  @override
  String get noteColorPurple => 'Violetti';

  @override
  String get noteColorBlue => 'Sininen';

  @override
  String get noteColorGreen => 'Vihreä';

  @override
  String get noteColorOrange => 'Oranssi';

  @override
  String get noteColorWhite => 'Valkoinen';

  @override
  String get recordVoiceNoteTooltip => 'Nauhoita äänimuistiinpano';

  @override
  String get recordVoiceNoteInstructions =>
      'Aloita äänitys napauttamalla punaista painiketta, tai peruuta ✕.';

  @override
  String get stopRecordingTooltip => 'Lopeta nauhoitus';

  @override
  String get cancelRecordingTooltip => 'Peruuta nauhoitus';

  @override
  String get addVoiceTimestampButton => 'Lisää aikaleima';

  @override
  String get editVoiceTimestampButton => 'Muokkaa aikaleimaa';

  @override
  String get voiceNoteUnsupportedOnPlatform => 'Äänimuistiinpanoja ei tueta tällä laitteella';

  @override
  String get formatBoldTooltip => 'Lihavointi';

  @override
  String get formatItalicTooltip => 'Kursivointi';

  @override
  String get formatHeadingTooltip => 'Otsikko';

  @override
  String get formatListTooltip => 'Luettelo';

  @override
  String get formatLinkTooltip => 'Linkki';

  @override
  String get imageSizeSmall => 'Pieni';

  @override
  String get imageSizeMedium => 'Keskikokoinen';

  @override
  String get imageSizeFull => 'Koko leveys';

  @override
  String get removeImageButton => 'Poista kuva';

  @override
  String get relayUrlHint => 'wss://relay.example.com';

  @override
  String get noRelaysMessage => 'Yhtään relettä ei ole vielä määritetty.';

  @override
  String relaysCount(int count) {
    return '$count relettä';
  }

  @override
  String get settingsTitle => 'Asetukset';

  @override
  String get sectionSecurity => 'Tietoturva';

  @override
  String get loadingLabel => 'Ladataan…';

  @override
  String get encryptionLoadError => 'Salausasetuksia ei voitu ladata';

  @override
  String get encryptionToggleTitle => 'Suojaa muistiinpanot salasanalla';

  @override
  String get encryptionToggleSubtitle =>
      'Salaa tallennetut muistiinpanot (AES-256-GCM) salasanastasi johdetulla avaimella. Salasanaa ei koskaan tallenneta — jos unohdat sen, muistiinpanoja ei voi palauttaa.';

  @override
  String get lockNotesNowTitle => 'Lukitse muistiinpanot nyt';

  @override
  String get lockNotesNowSubtitle => 'Muistiinpanojen näyttäminen vaatii salasanan uudelleen';

  @override
  String get setPasswordDialogTitle => 'Aseta salasana';

  @override
  String get passwordTooShortError => 'Vähintään 8 merkkiä';

  @override
  String get confirmPasswordLabel => 'Vahvista salasana';

  @override
  String get passwordsDoNotMatchError => 'Salasanat eivät täsmää';

  @override
  String enableEncryptionError(String error) {
    return 'Salausta ei voitu ottaa käyttöön: $error';
  }

  @override
  String get enableButton => 'Ota käyttöön';

  @override
  String get disablePasswordDialogTitle => 'Anna salasanasi poistaaksesi salauksen käytöstä';

  @override
  String get disableButton => 'Poista käytöstä';

  @override
  String get sectionAppearance => 'Ulkoasu';

  @override
  String get lightThemeToggleTitle => 'Vaalea teema';

  @override
  String get lightThemeToggleSubtitle => 'Käytä vaaleaa väriteemaa tumman sijaan';

  @override
  String get noteLayoutToggleTitle => 'Vaihda luettelo- ja ruudukkonäkymän välillä';

  @override
  String get manageRelaysTitle => 'Hallitse releitä';

  @override
  String get republishAllNotesButton => 'Julkaise kaikki synkronoidut muistiinpanot uudelleen';

  @override
  String get republishAllNotesSubtitle =>
      'Täydentää jokaisen yllä olevan releen muualla jo jaetuilla muistiinpanoilla — hyödyllistä heti uuden lisäämisen jälkeen, esim. oman varareleen';

  @override
  String republishAllNotesSuccess(int count) {
    return 'Julkaistiin uudelleen $count muistiinpanoa';
  }

  @override
  String republishAllNotesError(String error) {
    return 'Muistiinpanoja ei voitu julkaista uudelleen: $error';
  }

  @override
  String get forceFullResyncButton => 'Pakota täysi uudelleensynkronointi';

  @override
  String get forceFullResyncSubtitle =>
      'Tarkistaa releiltä muistiinpanon koko historian pelkän uuden sijaan — hyödyllinen, jos synkronointi vaikuttaa jumiutuneen ja ohittaa vanhempia muistiinpanoja, esim. korjattuasi tavoittamattoman releen';

  @override
  String get forceFullResyncSuccess => 'Muistiinpanot päivitetty releiltä';

  @override
  String forceFullResyncError(String error) {
    return 'Muistiinpanojen uudelleensynkronointi epäonnistui: $error';
  }

  @override
  String get confirmButton => 'Vahvista';

  @override
  String get sectionLanguage => 'Kieli';

  @override
  String get langSystem => 'Järjestelmän oletus';

  @override
  String get sectionAccount => 'Tili';

  @override
  String get accountLocalOnlyMessage =>
      'Echoesia käytetään paikallisesti — ei synkronoida Nostriin';

  @override
  String get accountSignInButton => 'Kirjaudu sisään';

  @override
  String accountSignedInAs(String npub) {
    return 'Kirjautunut käyttäjänä $npub';
  }

  @override
  String get accountSignOutButton => 'Kirjaudu ulos';

  @override
  String get accountSignOutConfirmTitle => 'Kirjaudutaanko ulos?';

  @override
  String get accountSignOutConfirmBody =>
      'Muistiinpanosi säilyvät tässä laitteessa. Voit kirjautua sisään uudelleen milloin tahansa.';

  @override
  String get onboardingWelcomeTitle => 'Tervetuloa Echoesiin';

  @override
  String get onboardingIntroLocalTitle => 'Muistiinpanosi ovat aina laitteellasi';

  @override
  String get onboardingIntroLocalBody =>
      'Jokainen muistiinpano tallennetaan ensin paikallisesti, joten sovellus toimii täysin offline-tilassa. Mikään ei poistu laitteeltasi, ellet valitse synkronointia.';

  @override
  String get onboardingIntroSyncTitle => 'Valinnainen synkronointi Nostrin kautta';

  @override
  String get onboardingIntroSyncBody =>
      'Ota synkronointi käyttöön varmuuskopioidaksesi muistiinpanosi ja lukeaksesi niitä muilla laitteilla avoimen Nostr-protokollan ja valitsemiesi relejen avulla.';

  @override
  String get onboardingIntroEncryptionTitle => 'Aina salattu';

  @override
  String get onboardingIntroEncryptionBody =>
      'Nostriin synkronoidut muistiinpanot ovat päästä päähän salattuja, joten releiden ylläpitäjät — tai kukaan muukaan — eivät voi koskaan lukea niiden sisältöä.';

  @override
  String get onboardingIntroAmberTitle => 'Kirjaudu paljastamatta avaintasi';

  @override
  String get onboardingIntroAmberBody =>
      'Käytä Amberia kirjautumiseen: yksityinen avaimesi pysyy Amberissa eikä sitä koskaan jaeta Echoesin kanssa.';

  @override
  String get onboardingIntroSecurityTitle => 'Turvallisuus alusta asti';

  @override
  String get onboardingIntroSecurityBody =>
      'Yksityinen avaimesi säilyy laitteesi salatussa avainsäilössä — tai Amberin kanssa se ei koskaan kosketa Echoesia lainkaan. Kuvat ja äänimuistiinpanot salataan ennen kuin ne poistuvat laitteestasi. Muistiinpanot voi lukita salasanalla, eikä mikään näistä koskaan sisälly puhelimen varmuuskopioihin.';

  @override
  String get onboardingNextButton => 'Seuraava';

  @override
  String get onboardingBackButton => 'Takaisin';

  @override
  String get onboardingSkipButton => 'Ohita — käytä Echoesia vain paikallisesti';

  @override
  String get onboardingRelayTitle => 'Valitse relet synkronointiin';

  @override
  String get onboardingRelayBody =>
      'Releihin tallennetaan salatut muistiinpanosi synkronoinnin yhteydessä. Lisää yksi tai useampi — nämä suositut ovat hyvä alku:';

  @override
  String get onboardingFinishButton => 'Aloita';

  @override
  String get syncNoteTooltip => 'Synkronoi tämä muistiinpano';

  @override
  String get unsyncNoteTooltip => 'Poista releiltä';

  @override
  String get syncSelectedTooltip => 'Synkronoi valitut muistiinpanot';

  @override
  String get exportSelectedTooltip => 'Vie valitut muistiinpanot';

  @override
  String get deleteSelectedTooltip => 'Poista valitut muistiinpanot';

  @override
  String syncNoteError(String error) {
    return 'Muistiinpanoa ei voitu synkronoida: $error';
  }

  @override
  String unsyncNoteError(String error) {
    return 'Muistiinpanon poistaminen releiltä epäonnistui: $error';
  }

  @override
  String deleteNoteRelayError(String error) {
    return 'Muistiinpano poistettiin laitteelta, mutta sitä ei voitu poistaa releiltä: $error';
  }

  @override
  String deleteNotesRelayError(int count) {
    return '$count muistiinpanoa poistettiin laitteelta, mutta niitä ei voitu poistaa releiltä';
  }

  @override
  String get deletingNotesTitle => 'Poistetaan muistiinpanoja…';

  @override
  String deletingNotesProgress(int completed, int total) {
    return 'Poistetaan $completed/$total';
  }

  @override
  String get syncSelectedSuccess => 'Muistiinpanot synkronoitu';

  @override
  String syncSelectedPartialError(int count) {
    return '$count muistiinpanon synkronointi epäonnistui';
  }

  @override
  String get exportConfirmTitle => 'Vie muistiinpanot';

  @override
  String get exportConfirmBody =>
      'Luo varmuuskopiotiedoston muistiinpanoistasi. Se sisältää myös liitettyjen kuvien tai äänimuistiinpanojen salauksenpurkuavaimet — kuka tahansa tiedoston saava voisi lukea ne, ellei tiedosto ole salattu.';

  @override
  String get exportEncryptToggleLabel => 'Salaa tämä tiedosto';

  @override
  String get exportEncryptToggleSubtitle => 'Suositeltu — suojaa varmuuskopion salasanalla';

  @override
  String get exportPasswordDialogTitle => 'Anna salasanasi';

  @override
  String get exportSetPasswordDialogTitle => 'Aseta salasana tälle viennille';

  @override
  String get importPasswordDialogTitle => 'Anna viennin salasana';

  @override
  String get sectionData => 'Tiedot';

  @override
  String get exportNotesButton => 'Vie muistiinpanot';

  @override
  String get exportNotesSubtitle =>
      'Tallenna kaikki muistiinpanosi tiedostoon, jonka voit tuoda takaisin myöhemmin';

  @override
  String get importNotesButton => 'Tuo muistiinpanot';

  @override
  String get importNotesSubtitle => 'Palauta muistiinpanot aiemmin viedystä tiedostosta';

  @override
  String get exportNotesSuccess => 'Muistiinpanot viety';

  @override
  String exportNotesError(Object error) {
    return 'Muistiinpanoja ei voitu viedä: $error';
  }

  @override
  String importNotesSuccess(int count) {
    return 'Tuotiin $count muistiinpanoa';
  }

  @override
  String importNotesError(Object error) {
    return 'Muistiinpanoja ei voitu tuoda: $error';
  }

  @override
  String get sectionAttachments => 'Liitteet';

  @override
  String get attachmentProviderSubtitle =>
      'Minne salatut kuvat ja ääniviestit ladataan synkronoinnin yhteydessä';

  @override
  String get attachmentProviderCustom => 'Mukautettu…';

  @override
  String get attachmentCustomUrlLabel => 'Palvelimen URL-osoite';

  @override
  String get attachmentProviderHint =>
      'Jotkin julkiset palvelimet (esim. Primal, nostr.build) hylkäävät salatut lataukset suoraan — ne tarkistavat aidon kuvasisällön, jota salattu data ei koskaan ole. Suosi Blossom-palvelinta, joka tallentaa läpinäkymätöntä dataa, tai osoita Mukautettu… omaan palvelimeesi.';

  @override
  String get sectionSupport => 'Tuki';

  @override
  String get supportEchoesTitle => 'Tue Echoesia';

  @override
  String lightningAddressCopied(String address) {
    return '⚡ $address kopioitu leikepöydälle';
  }

  @override
  String get cancelButton => 'Peruuta';

  @override
  String get passwordLabel => 'Salasana';

  @override
  String get invalidPrivateKeyError =>
      'Yksityinen avain ei ole kelvollinen. Anna kelvollinen nsec- tai hex-avain.';

  @override
  String get wrongPasswordError => 'Väärä salasana';

  @override
  String genericErrorPrefix(String error) {
    return 'Virhe: $error';
  }

  @override
  String get shareNoteTooltip => 'Jaa';

  @override
  String get shareNoteTitle => 'Jaa muistiinpano';

  @override
  String get shareRecipientFieldLabel => 'Vastaanottajan npub tai julkinen avain';

  @override
  String get shareAddRecipientButton => 'Lisää';

  @override
  String get shareInvalidRecipientError => 'Tämä ei ole kelvollinen npub tai julkinen avain';

  @override
  String get shareRecipientNotFoundError => 'Nimelle ei löytynyt Nostr-tiliä';

  @override
  String get shareConfirmTitle => 'Jaetaanko tämä muistiinpano?';

  @override
  String get shareConfirmButton => 'Jaa';

  @override
  String get shareAlreadyRecipientError => 'Jaettu jo tämän henkilön kanssa';

  @override
  String get shareCannotShareWithSelfError => 'Et voi jakaa muistiinpanoa itsesi kanssa';

  @override
  String get shareRecipientsHeader => 'Jaettu käyttäjälle';

  @override
  String get shareNoRecipientsMessage => 'Ei vielä jaettu kenellekään.';

  @override
  String get stopSharingTooltip => 'Lopeta jakaminen tämän henkilön kanssa';

  @override
  String get shareRevocationNote =>
      'Kuka tahansa, jonka kanssa jaat, voi lukea tämän muistiinpanon laitteellaan. Jonkun poistaminen lopettaa tulevat päivitykset, mutta ei voi poistaa jo vastaanotettua.';

  @override
  String shareError(String error) {
    return 'Jakamisen päivitys epäonnistui: $error';
  }

  @override
  String get sharedWithMeHeader => 'Jaettu sinulle';

  @override
  String sharedByLabel(String npub) {
    return 'Jakoi $npub';
  }

  @override
  String get sharedNoteEditableNote =>
      'Voit muokata tätä muistiinpanoa; muutoksesi synkronoituvat takaisin omistajalle, joka yhdistää ne.';

  @override
  String get abandonSharedNoteButton => 'Poistu tästä jaetusta muistiinpanosta';

  @override
  String get abandonSharedNoteConfirmTitle => 'Poistutaanko tästä jaetusta muistiinpanosta?';

  @override
  String get abandonSharedNoteConfirmBody =>
      'Se poistetaan tältä laitteelta etkä enää saa päivityksiä. Tätä ei voi kumota — et voi liittyä uudelleen myöhemmin.';

  @override
  String abandonSharedNoteError(String error) {
    return 'Poistuminen epäonnistui: $error';
  }
}
