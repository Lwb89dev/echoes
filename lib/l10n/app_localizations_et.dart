// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Estonian (`et`).
class AppLocalizationsEt extends AppLocalizations {
  AppLocalizationsEt([String locale = 'et']) : super(locale);

  @override
  String get loginSubtitle => 'Logi sisse oma Nostr kontoga';

  @override
  String get loginWithAmberButton => 'Logi sisse Amberiga';

  @override
  String get importAccountButton => 'Impordi Nostr konto';

  @override
  String get importAccountFieldLabel => 'Sinu Nostr konto privaatvõti (nsec)';

  @override
  String get importButton => 'Impordi';

  @override
  String get relaysTitle => 'Relee';

  @override
  String get settingsTooltip => 'Seaded';

  @override
  String get searchTooltip => 'Otsi';

  @override
  String get closeSearchTooltip => 'Sulge otsing';

  @override
  String get searchNotesHint => 'Otsi märkmetest';

  @override
  String get noSearchResultsMessage => 'Vasteid pole.';

  @override
  String get emptyNotesMessage =>
      'Märkmeid pole veel. Uue loomiseks puuduta +.';

  @override
  String get notesTabLabel => 'Märkmed';

  @override
  String get diaryTabLabel => 'Päevik';

  @override
  String get emptyDiaryMessage =>
      'Päevikus pole veel sissekandeid. Puuduta +, et üks kirjutada.';

  @override
  String get diaryToday => 'Täna';

  @override
  String get diaryYesterday => 'Eile';

  @override
  String get newPlainNoteOption => 'Märge';

  @override
  String get newChecklistOption => 'Kontrollnimekiri';

  @override
  String get newVoiceNoteOption => 'Häälmärge';

  @override
  String get deleteNoteButton => 'Kustuta märge';

  @override
  String get deleteNoteConfirmTitle => 'Kustutada see märge?';

  @override
  String get deleteNoteConfirmBody =>
      'Seda ei saa tagasi võtta. Kui see märge oli sünkroonitud, eemaldatakse see ka releedest.';

  @override
  String deleteNotesConfirmTitle(int count) {
    return 'Kustutada $count märget?';
  }

  @override
  String get deleteNotesConfirmBody =>
      'Seda ei saa tagasi võtta. Kui mõni neist märgetest oli sünkroonitud, eemaldatakse see ka releedest.';

  @override
  String selectionCount(int count) {
    return '$count valitud';
  }

  @override
  String get untitledNote => '(pealkirjata)';

  @override
  String errorLoadingNotes(String error) {
    return 'Viga märkmete laadimisel: $error';
  }

  @override
  String get timeJustNow => 'just nüüd';

  @override
  String timeMinutesAgo(int count) {
    return '$count min tagasi';
  }

  @override
  String timeHoursAgo(int count) {
    return '$count t tagasi';
  }

  @override
  String timeDaysAgo(int count) {
    return '$count p tagasi';
  }

  @override
  String get notesLockedTitle => 'Märkmed on parooliga kaitstud';

  @override
  String get unlockButton => 'Ava lukust';

  @override
  String get saveTooltip => 'Salvesta';

  @override
  String get titleFieldLabel => 'Pealkiri';

  @override
  String get bodyFieldHint => 'Kirjuta siia... (markdown on toetatud)';

  @override
  String get checklistItemHint => 'Nimekirja punkt';

  @override
  String get addItemButton => 'Lisa punkt';

  @override
  String checklistProgress(int done, int total) {
    return '$done/$total tehtud';
  }

  @override
  String get showCompletedItemsTooltip => 'Näita tehtud üksusi';

  @override
  String get hideCompletedItemsTooltip => 'Peida tehtud üksused';

  @override
  String get allChecklistItemsCompletedHidden =>
      'Kõik üksused on tehtud ja peidetud.';

  @override
  String get deleteCompletedItemsButton => 'Kustuta tehtud üksused';

  @override
  String get deleteCompletedItemsConfirmTitle =>
      'Kas kustutada tehtud üksused?';

  @override
  String deleteCompletedItemsConfirmBody(int count) {
    return 'See eemaldab loendist $count märgitud üksust. Seda ei saa tagasi võtta.';
  }

  @override
  String get addImageButton => 'Lisa pilt';

  @override
  String get noteColorButton => 'Märkme värv';

  @override
  String get noteColorDefault => 'Vaikimisi';

  @override
  String get noteColorYellow => 'Kollane';

  @override
  String get noteColorRed => 'Punane';

  @override
  String get noteColorPurple => 'Lilla';

  @override
  String get noteColorBlue => 'Sinine';

  @override
  String get noteColorGreen => 'Roheline';

  @override
  String get noteColorOrange => 'Oranž';

  @override
  String get noteColorWhite => 'Valge';

  @override
  String get recordVoiceNoteTooltip => 'Salvesta häälmärge';

  @override
  String get recordVoiceNoteInstructions =>
      'Salvestamise alustamiseks puuduta punast nuppu, tühistamiseks ✕.';

  @override
  String get stopRecordingTooltip => 'Peata salvestamine';

  @override
  String get cancelRecordingTooltip => 'Tühista salvestamine';

  @override
  String get addVoiceTimestampButton => 'Lisa ajatempel';

  @override
  String get editVoiceTimestampButton => 'Muuda ajatemplit';

  @override
  String get voiceNoteUnsupportedOnPlatform =>
      'Häälmärkmed ei ole selles seadmes toetatud';

  @override
  String get formatBoldTooltip => 'Paks';

  @override
  String get formatItalicTooltip => 'Kaldkiri';

  @override
  String get formatHeadingTooltip => 'Pealkiri';

  @override
  String get formatListTooltip => 'Täpploend';

  @override
  String get formatLinkTooltip => 'Link';

  @override
  String get imageSizeSmall => 'Väike';

  @override
  String get imageSizeMedium => 'Keskmine';

  @override
  String get imageSizeFull => 'Täislaius';

  @override
  String get removeImageButton => 'Eemalda pilt';

  @override
  String get relayUrlHint => 'wss://relay.example.com';

  @override
  String get noRelaysMessage => 'Ühtegi releed pole veel seadistatud.';

  @override
  String relaysCount(int count) {
    return '$count releed';
  }

  @override
  String get settingsTitle => 'Seaded';

  @override
  String get sectionSecurity => 'Turvalisus';

  @override
  String get loadingLabel => 'Laadimine…';

  @override
  String get encryptionLoadError => 'Krüptimisseadeid ei õnnestunud laadida';

  @override
  String get encryptionToggleTitle => 'Kaitse märkmeid parooliga';

  @override
  String get encryptionToggleSubtitle =>
      'Krüptib salvestatud märkmed (AES-256-GCM) sinu paroolist tuletatud võtmega. Parooli ei salvestata kunagi — kui unustad selle, ei saa märkmeid taastada.';

  @override
  String get lockNotesNowTitle => 'Lukusta märkmed kohe';

  @override
  String get lockNotesNowSubtitle =>
      'Märgete vaatamiseks on vaja parooli uuesti sisestada';

  @override
  String get setPasswordDialogTitle => 'Määra parool';

  @override
  String get passwordTooShortError => 'Vähemalt 8 tähemärki';

  @override
  String get confirmPasswordLabel => 'Kinnita parool';

  @override
  String get passwordsDoNotMatchError => 'Paroolid ei ühti';

  @override
  String enableEncryptionError(String error) {
    return 'Krüptimist ei õnnestunud aktiveerida: $error';
  }

  @override
  String get enableButton => 'Aktiveeri';

  @override
  String get disablePasswordDialogTitle =>
      'Sisesta parool krüptimise keelamiseks';

  @override
  String get disableButton => 'Keela';

  @override
  String get sectionAppearance => 'Välimus';

  @override
  String get lightThemeToggleTitle => 'Hele teema';

  @override
  String get lightThemeToggleSubtitle =>
      'Kasuta tumeda asemel heledat värviskeemi';

  @override
  String get noteLayoutToggleTitle => 'Lülitu loendi- ja ruudustikuvaate vahel';

  @override
  String get manageRelaysTitle => 'Halda releesid';

  @override
  String get republishAllNotesButton =>
      'Avalda kõik sünkroonitud märkmed uuesti';

  @override
  String get republishAllNotesSubtitle =>
      'Täidab iga ülaloleva relee mujal juba jagatud märkmetega — kasulik kohe pärast uue lisamist, nt oma varureleed';

  @override
  String republishAllNotesSuccess(int count) {
    return 'Uuesti avaldatud $count märget';
  }

  @override
  String republishAllNotesError(String error) {
    return 'Märkmeid ei õnnestunud uuesti avaldada: $error';
  }

  @override
  String get forceFullResyncButton => 'Sunni täielik taassünkroonimine';

  @override
  String get forceFullResyncSubtitle =>
      'Kontrollib relaysid uuesti märkme kogu ajaloo, mitte ainult uue osas — kasulik, kui sünkroonimine tundub kinni jäävat ja jätab vanemad märkmed vahele, nt pärast kättesaamatu relay parandamist';

  @override
  String get forceFullResyncSuccess => 'Märkmed värskendatud relaydelt';

  @override
  String forceFullResyncError(String error) {
    return 'Märkmete taassünkroonimine ebaõnnestus: $error';
  }

  @override
  String get confirmButton => 'Kinnita';

  @override
  String get sectionLanguage => 'Keel';

  @override
  String get langSystem => 'Süsteemi vaikeseade';

  @override
  String get sectionAccount => 'Konto';

  @override
  String get accountLocalOnlyMessage =>
      'Echoes kasutamine kohalikult — Nostriga ei sünkroonita';

  @override
  String get accountSignInButton => 'Logi sisse';

  @override
  String accountSignedInAs(String npub) {
    return 'Sisse logitud kui $npub';
  }

  @override
  String get accountSignOutButton => 'Logi välja';

  @override
  String get accountSignOutConfirmTitle => 'Kas logida välja?';

  @override
  String get accountSignOutConfirmBody =>
      'Sinu märkmed jäävad sellesse seadmesse. Saad igal ajal uuesti sisse logida.';

  @override
  String get onboardingWelcomeTitle => 'Tere tulemast Echoesisse';

  @override
  String get onboardingIntroLocalTitle => 'Sinu märkmed on alati sinu seadmes';

  @override
  String get onboardingIntroLocalBody =>
      'Iga märge salvestatakse kõigepealt kohalikult, nii et rakendus töötab täielikult võrguühenduseta. Miski ei lahku sinu seadmest, kui sa ei vali sünkroonimist.';

  @override
  String get onboardingIntroSyncTitle =>
      'Valikuline sünkroonimine Nostri kaudu';

  @override
  String get onboardingIntroSyncBody =>
      'Lülita sisse sünkroonimine, et varundada oma märkmed ja lugeda neid teistes seadmetes, kasutades avatud Nostri protokolli ja enda valitud releesid.';

  @override
  String get onboardingIntroEncryptionTitle => 'Alati krüptitud';

  @override
  String get onboardingIntroEncryptionBody =>
      'Nostriga sünkroonitud märkmed on otsast lõpuni krüptitud, nii et releede haldajad — ega keegi teine — ei saa kunagi nende sisu lugeda.';

  @override
  String get onboardingIntroAmberTitle => 'Logi sisse ilma võtit paljastamata';

  @override
  String get onboardingIntroAmberBody =>
      'Kasuta sisselogimiseks Amberit: sinu privaatvõti jääb Amberisse ega jagata kunagi Echoesiga.';

  @override
  String get onboardingIntroSecurityTitle => 'Turvalisus disaini poolest';

  @override
  String get onboardingIntroSecurityBody =>
      'Teie privaatvõti asub seadme krüptitud võtmehoidlas — või Amberi kasutades ei puutu see Echoesiga üldse kokku. Fotod ja häälmärkmed krüpditakse enne seadmest lahkumist. Märkmeid saab lukustada parooliga ning midagi sellest ei kaasata kunagi telefoni varukoopiatesse.';

  @override
  String get onboardingNextButton => 'Edasi';

  @override
  String get onboardingBackButton => 'Tagasi';

  @override
  String get onboardingSkipButton =>
      'Jäta vahele — kasuta Echoesi ainult kohalikult';

  @override
  String get onboardingRelayTitle => 'Vali sünkroonimiseks releed';

  @override
  String get onboardingRelayBody =>
      'Releed on kohad, kuhu sinu krüptitud märkmed sünkroonimisel salvestatakse. Lisa üks või mitu — need populaarsed on hea algus:';

  @override
  String get onboardingFinishButton => 'Alusta';

  @override
  String get syncNoteTooltip => 'Sünkrooni see märge';

  @override
  String get unsyncNoteTooltip => 'Eemalda releedest';

  @override
  String get syncSelectedTooltip => 'Sünkrooni valitud märked';

  @override
  String get exportSelectedTooltip => 'Ekspordi valitud märked';

  @override
  String get deleteSelectedTooltip => 'Kustuta valitud märked';

  @override
  String syncNoteError(String error) {
    return 'Märget ei õnnestunud sünkroonida: $error';
  }

  @override
  String unsyncNoteError(String error) {
    return 'Märkme releedest eemaldamine ebaõnnestus: $error';
  }

  @override
  String deleteNoteRelayError(String error) {
    return 'Märge kustutati kohalikult, kuid seda ei õnnestunud eemaldada releedest: $error';
  }

  @override
  String deleteNotesRelayError(int count) {
    return '$count märget kustutati kohalikult, kuid neid ei õnnestunud eemaldada releedest';
  }

  @override
  String get deletingNotesTitle => 'Märkmete kustutamine…';

  @override
  String deletingNotesProgress(int completed, int total) {
    return 'Kustutamine $completed/$total';
  }

  @override
  String get syncSelectedSuccess => 'Märked sünkroonitud';

  @override
  String syncSelectedPartialError(int count) {
    return '$count märke sünkroonimine ebaõnnestus';
  }

  @override
  String get exportConfirmTitle => 'Ekspordi märkmed';

  @override
  String get exportConfirmBody =>
      'Loob teie märkmete varukoopiafaili. See sisaldab ka manustatud piltide või häälmärkmete dekrüpteerimisvõtmeid — igaüks, kellel on fail, saaks neid lugeda, kui see pole krüpditud.';

  @override
  String get exportEncryptToggleLabel => 'Krüpti see fail';

  @override
  String get exportEncryptToggleSubtitle =>
      'Soovitatav — kaitseb varukoopiat parooliga';

  @override
  String get exportPasswordDialogTitle => 'Sisestage oma parool';

  @override
  String get exportSetPasswordDialogTitle =>
      'Määrake selle ekspordi jaoks parool';

  @override
  String get importPasswordDialogTitle => 'Sisestage ekspordi parool';

  @override
  String get sectionData => 'Andmed';

  @override
  String get exportNotesButton => 'Ekspordi märkmed';

  @override
  String get exportNotesSubtitle =>
      'Salvesta kõik märkmed faili, mida saad hiljem uuesti importida';

  @override
  String get importNotesButton => 'Impordi märkmed';

  @override
  String get importNotesSubtitle => 'Taasta märkmed varem eksporditud failist';

  @override
  String get exportNotesSuccess => 'Märkmed eksporditud';

  @override
  String exportNotesError(Object error) {
    return 'Märkmeid ei õnnestunud eksportida: $error';
  }

  @override
  String importNotesSuccess(int count) {
    return 'Imporditi $count märget';
  }

  @override
  String importNotesError(Object error) {
    return 'Märkmeid ei õnnestunud importida: $error';
  }

  @override
  String get sectionAttachments => 'Manused';

  @override
  String get attachmentProviderSubtitle =>
      'Kuhu laaditakse krüptitud pildid ja häälmärkmed sünkroonimisel';

  @override
  String get attachmentProviderCustom => 'Kohandatud…';

  @override
  String get attachmentCustomUrlLabel => 'Serveri URL';

  @override
  String get attachmentProviderHint =>
      'Mõned avalikud serverid (nt Primal, nostr.build) lükkavad krüptitud üleslaadimised tagasi — nad kontrollivad päris pildisisu, mida krüptitud andmed kunagi pole. Eelista Blossomi serverit, mis salvestab läbipaistmatuid andmeid, või suuna „Kohandatud…“ oma serverile.';

  @override
  String get sectionSupport => 'Toetus';

  @override
  String get supportEchoesTitle => 'Toeta Echoesi';

  @override
  String lightningAddressCopied(String address) {
    return '⚡ $address kopeeriti lõikelauale';
  }

  @override
  String get cancelButton => 'Tühista';

  @override
  String get passwordLabel => 'Parool';

  @override
  String get invalidPrivateKeyError =>
      'Privaatvõti ei ole kehtiv. Sisestage kehtiv nsec- või hex-võti.';

  @override
  String get wrongPasswordError => 'Vale parool';

  @override
  String genericErrorPrefix(String error) {
    return 'Viga: $error';
  }
}
