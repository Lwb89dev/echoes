// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Latvian (`lv`).
class AppLocalizationsLv extends AppLocalizations {
  AppLocalizationsLv([String locale = 'lv']) : super(locale);

  @override
  String get loginSubtitle => 'Pierakstieties ar savu Nostr kontu';

  @override
  String get loginWithAmberButton => 'Pierakstīties ar Amber';

  @override
  String get importAccountButton => 'Importēt Nostr kontu';

  @override
  String get importAccountFieldLabel => 'Jūsu Nostr konta privātā atslēga (nsec)';

  @override
  String get importButton => 'Importēt';

  @override
  String get bunkerLoginButton => 'Pievienot attālo parakstītāju (bunker)';

  @override
  String get bunkerFieldLabel => 'Ielīmē savu bunker:// savienojuma marķieri';

  @override
  String get bunkerConnectButton => 'Savienot';

  @override
  String get bunkerAuthPrompt => 'Apstiprini savienojumu savā parakstītājā un atgriezies';

  @override
  String get relaysTitle => 'Releji';

  @override
  String get settingsTooltip => 'Iestatījumi';

  @override
  String get searchTooltip => 'Meklēt';

  @override
  String get closeSearchTooltip => 'Aizvērt meklēšanu';

  @override
  String get searchNotesHint => 'Meklēt piezīmēs';

  @override
  String get noSearchResultsMessage => 'Nav atbilstību.';

  @override
  String get emptyNotesMessage => 'Vēl nav piezīmju. Pieskarieties +, lai izveidotu jaunu.';

  @override
  String get notesTabLabel => 'Piezīmes';

  @override
  String get diaryTabLabel => 'Dienasgrāmata';

  @override
  String get emptyDiaryMessage =>
      'Vēl nav dienasgrāmatas ierakstu. Pieskarieties +, lai uzrakstītu.';

  @override
  String get diaryToday => 'Šodien';

  @override
  String get diaryYesterday => 'Vakar';

  @override
  String get newPlainNoteOption => 'Piezīme';

  @override
  String get newChecklistOption => 'Kontrolsaraksts';

  @override
  String get newVoiceNoteOption => 'Balss piezīme';

  @override
  String get deleteNoteButton => 'Dzēst piezīmi';

  @override
  String get deleteNoteConfirmTitle => 'Dzēst šo piezīmi?';

  @override
  String get deleteNoteConfirmBody =>
      'Šo darbību nevar atsaukt. Ja šī piezīme bija sinhronizēta, tā tiks noņemta arī no jūsu relejiem.';

  @override
  String deleteNotesConfirmTitle(int count) {
    return 'Dzēst $count piezīmes?';
  }

  @override
  String get deleteNotesConfirmBody =>
      'Šo darbību nevar atsaukt. Ja kāda no šīm piezīmēm bija sinhronizēta, tā tiks noņemta arī no jūsu relejiem.';

  @override
  String selectionCount(int count) {
    return 'Atlasītas: $count';
  }

  @override
  String get untitledNote => '(bez nosaukuma)';

  @override
  String errorLoadingNotes(String error) {
    return 'Kļūda ielādējot piezīmes: $error';
  }

  @override
  String get timeJustNow => 'tikko';

  @override
  String timeMinutesAgo(int count) {
    return 'pirms $count min';
  }

  @override
  String timeHoursAgo(int count) {
    return 'pirms $count h';
  }

  @override
  String timeDaysAgo(int count) {
    return 'pirms $count d';
  }

  @override
  String get notesLockedTitle => 'Piezīmes ir aizsargātas ar paroli';

  @override
  String get unlockButton => 'Atbloķēt';

  @override
  String get saveTooltip => 'Saglabāt';

  @override
  String get titleFieldLabel => 'Nosaukums';

  @override
  String get bodyFieldHint => 'Rakstiet šeit... (atbalstīts markdown)';

  @override
  String get checklistItemHint => 'Saraksta vienums';

  @override
  String get addItemButton => 'Pievienot vienumu';

  @override
  String completedItemsSection(int count) {
    return 'Pabeigti ($count)';
  }

  @override
  String get duplicateChecklistItemMessage => 'Jau šajā sarakstā, pabeigts';

  @override
  String get restoreChecklistItemButton => 'Atjaunot';

  @override
  String get noteSyncedMessage => 'Piezīme sinhronizēta';

  @override
  String get noteSyncedFirstTimeMessage => 'Piezīme sinhronizēta pirmo reizi';

  @override
  String notePartiallySyncedMessage(int accepted, int total) {
    return 'Sinhronizēts ar $accepted no $total relejiem';
  }

  @override
  String checklistProgress(int done, int total) {
    return 'Pabeigti $done no $total';
  }

  @override
  String get showCompletedItemsTooltip => 'Rādīt pabeigtos punktus';

  @override
  String get hideCompletedItemsTooltip => 'Slēpt pabeigtos punktus';

  @override
  String get allChecklistItemsCompletedHidden => 'Visi punkti ir pabeigti un paslēpti.';

  @override
  String get deleteCompletedItemsButton => 'Dzēst pabeigtos punktus';

  @override
  String get deleteCompletedItemsConfirmTitle => 'Vai dzēst pabeigtos punktus?';

  @override
  String deleteCompletedItemsConfirmBody(int count) {
    return 'Tas noņems $count atzīmētus punktus no šī saraksta. To nevar atsaukt.';
  }

  @override
  String get addImageButton => 'Pievienot attēlu';

  @override
  String get noteColorButton => 'Piezīmes krāsa';

  @override
  String get noteColorDefault => 'Noklusējums';

  @override
  String get noteColorYellow => 'Dzeltena';

  @override
  String get noteColorRed => 'Sarkana';

  @override
  String get noteColorPurple => 'Violeta';

  @override
  String get noteColorBlue => 'Zila';

  @override
  String get noteColorGreen => 'Zaļa';

  @override
  String get noteColorOrange => 'Oranža';

  @override
  String get noteColorWhite => 'Balta';

  @override
  String get recordVoiceNoteTooltip => 'Ierakstīt balss piezīmi';

  @override
  String get recordVoiceNoteInstructions =>
      'Pieskarieties sarkanajai pogai, lai sāktu ierakstu, vai ✕, lai atceltu.';

  @override
  String get stopRecordingTooltip => 'Apturēt ierakstīšanu';

  @override
  String get cancelRecordingTooltip => 'Atcelt ierakstīšanu';

  @override
  String get addVoiceTimestampButton => 'Pievienot laika zīmogu';

  @override
  String get editVoiceTimestampButton => 'Rediģēt laika zīmogu';

  @override
  String get voiceNoteUnsupportedOnPlatform => 'Balss piezīmes šajā ierīcē netiek atbalstītas';

  @override
  String get formatBoldTooltip => 'Treknraksts';

  @override
  String get formatItalicTooltip => 'Slīpraksts';

  @override
  String get formatHeadingTooltip => 'Virsraksts';

  @override
  String get formatListTooltip => 'Saraksts ar aizzīmēm';

  @override
  String get formatLinkTooltip => 'Saite';

  @override
  String get imageSizeSmall => 'Mazs';

  @override
  String get imageSizeMedium => 'Vidējs';

  @override
  String get imageSizeFull => 'Pilns platums';

  @override
  String get removeImageButton => 'Noņemt attēlu';

  @override
  String get relayUrlHint => 'wss://relay.example.com';

  @override
  String get noRelaysMessage => 'Vēl nav konfigurēts neviens relejs.';

  @override
  String relaysCount(int count) {
    return '$count releji';
  }

  @override
  String get settingsTitle => 'Iestatījumi';

  @override
  String get sectionSecurity => 'Drošība';

  @override
  String get loadingLabel => 'Ielādē…';

  @override
  String get encryptionLoadError => 'Neizdevās ielādēt šifrēšanas iestatījumus';

  @override
  String get encryptionToggleTitle => 'Aizsargāt piezīmes ar paroli';

  @override
  String get encryptionToggleSubtitle =>
      'Šifrē saglabātās piezīmes (AES-256-GCM) ar atslēgu, kas iegūta no jūsu paroles. Parole nekad netiek saglabāta — ja to aizmirsīsiet, piezīmes nevarēs atgūt.';

  @override
  String get lockNotesNowTitle => 'Bloķēt piezīmes tagad';

  @override
  String get lockNotesNowSubtitle => 'Lai skatītu piezīmes, atkal būs nepieciešama parole';

  @override
  String get setPasswordDialogTitle => 'Iestatīt paroli';

  @override
  String get passwordTooShortError => 'Vismaz 8 rakstzīmes';

  @override
  String get confirmPasswordLabel => 'Apstipriniet paroli';

  @override
  String get passwordsDoNotMatchError => 'Paroles nesakrīt';

  @override
  String enableEncryptionError(String error) {
    return 'Neizdevās iespējot šifrēšanu: $error';
  }

  @override
  String get enableButton => 'Iespējot';

  @override
  String get disablePasswordDialogTitle => 'Ievadiet paroli, lai atspējotu šifrēšanu';

  @override
  String get disableButton => 'Atspējot';

  @override
  String get sectionAppearance => 'Izskats';

  @override
  String get lightThemeToggleTitle => 'Gaiša tēma';

  @override
  String get lightThemeToggleSubtitle => 'Izmantot gaišu krāsu shēmu tumšas vietā';

  @override
  String get noteLayoutToggleTitle => 'Pārslēgties starp saraksta un režģa skatu';

  @override
  String get manageRelaysTitle => 'Pārvaldīt relejus';

  @override
  String get republishAllNotesButton => 'Atkārtoti publicēt visas sinhronizētās piezīmes';

  @override
  String get republishAllNotesSubtitle =>
      'Papildina katru augstāk esošo releju ar piezīmēm, kas jau kopīgotas citur — noderīgi uzreiz pēc jauna pievienošanas, piem., pašizvietota rezerves releja';

  @override
  String republishAllNotesSuccess(int count) {
    return 'Atkārtoti publicētas $count piezīmes';
  }

  @override
  String republishAllNotesError(String error) {
    return 'Piezīmes neizdevās atkārtoti publicēt: $error';
  }

  @override
  String get forceFullResyncButton => 'Piespiest pilnu atkārtotu sinhronizāciju';

  @override
  String get forceFullResyncSubtitle =>
      'Atkārtoti pārbauda releja serveros piezīmes pilnu vēsturi, nevis tikai jauno — noderīgi, ja sinhronizācija šķiet iestrēgusi un izlaiž vecākas piezīmes, piemēram, pēc nesasniedzama releja servera novēršanas';

  @override
  String get forceFullResyncSuccess => 'Piezīmes atjauninātas no releja serveriem';

  @override
  String forceFullResyncError(String error) {
    return 'Neizdevās atkārtoti sinhronizēt piezīmes: $error';
  }

  @override
  String get confirmButton => 'Apstiprināt';

  @override
  String get sectionLanguage => 'Valoda';

  @override
  String get langSystem => 'Sistēmas noklusējums';

  @override
  String get sectionAccount => 'Konts';

  @override
  String get accountLocalOnlyMessage =>
      'Echoes tiek izmantots lokāli — bez sinhronizācijas ar Nostr';

  @override
  String get accountSignInButton => 'Pierakstīties';

  @override
  String accountSignedInAs(String npub) {
    return 'Pierakstījies kā $npub';
  }

  @override
  String get accountSignOutButton => 'Izrakstīties';

  @override
  String get accountSignOutConfirmTitle => 'Vai izrakstīties?';

  @override
  String get accountSignOutConfirmBody =>
      'Jūsu piezīmes paliks šajā ierīcē. Varat pierakstīties atkārtoti jebkurā laikā.';

  @override
  String get onboardingWelcomeTitle => 'Laipni lūdzam Echoes';

  @override
  String get onboardingIntroLocalTitle => 'Jūsu piezīmes vienmēr jūsu ierīcē';

  @override
  String get onboardingIntroLocalBody =>
      'Katra piezīme vispirms tiek saglabāta lokāli, tāpēc lietotne darbojas pilnībā bezsaistē. Nekas nepamet jūsu ierīci, ja vien neizvēlaties to sinhronizēt.';

  @override
  String get onboardingIntroSyncTitle => 'Neobligāta sinhronizācija caur Nostr';

  @override
  String get onboardingIntroSyncBody =>
      'Ieslēdziet sinhronizāciju, lai izveidotu piezīmju dublējumkopijas un lasītu tās citās ierīcēs, izmantojot atvērto Nostr protokolu un jūsu izvēlētus relejus.';

  @override
  String get onboardingIntroEncryptionTitle => 'Vienmēr šifrēts';

  @override
  String get onboardingIntroEncryptionBody =>
      'Ar Nostr sinhronizētās piezīmes ir šifrētas no gala līdz galam, tāpēc releju operatori — un ikviens cits — nekad nevar izlasīt to saturu.';

  @override
  String get onboardingIntroAmberTitle => 'Pierakstieties, neatklājot savu atslēgu';

  @override
  String get onboardingIntroAmberBody =>
      'Izmantojiet Amber, lai pierakstītos: jūsu privātā atslēga paliek Amber lietotnē un nekad netiek koplietota ar Echoes.';

  @override
  String get onboardingIntroSecurityTitle => 'Drošība pēc dizaina';

  @override
  String get onboardingIntroSecurityBody =>
      'Jūsu privātā atslēga atrodas ierīces šifrētajā atslēgu krātuvē — vai, izmantojot Amber, vispār nekad nesaskaras ar Echoes. Fotoattēli un balss piezīmes tiek šifrētas, pirms tās pamet jūsu ierīci. Piezīmes var bloķēt ar paroli, un nekas no tā nekad netiek iekļauts tālruņa dublējumos.';

  @override
  String get onboardingNextButton => 'Tālāk';

  @override
  String get onboardingBackButton => 'Atpakaļ';

  @override
  String get onboardingSkipButton => 'Izlaist — izmantot Echoes tikai lokāli';

  @override
  String get onboardingRelayTitle => 'Izvēlieties relejus sinhronizācijai';

  @override
  String get onboardingRelayBody =>
      'Relejos tiek glabātas jūsu šifrētās piezīmes sinhronizācijas laikā. Pievienojiet vienu vai vairākus — šie populārie ir labs sākums:';

  @override
  String get onboardingFinishButton => 'Sākt';

  @override
  String get syncNoteTooltip => 'Sinhronizēt šo piezīmi';

  @override
  String get unsyncNoteTooltip => 'Noņemt no relejiem';

  @override
  String get syncSelectedTooltip => 'Sinhronizēt atlasītās piezīmes';

  @override
  String get exportSelectedTooltip => 'Eksportēt atlasītās piezīmes';

  @override
  String get deleteSelectedTooltip => 'Dzēst atlasītās piezīmes';

  @override
  String syncNoteError(String error) {
    return 'Neizdevās sinhronizēt piezīmi: $error';
  }

  @override
  String unsyncNoteError(String error) {
    return 'Neizdevās noņemt piezīmi no relejiem: $error';
  }

  @override
  String deleteNoteRelayError(String error) {
    return 'Piezīme dzēsta lokāli, bet neizdevās to noņemt no relejiem: $error';
  }

  @override
  String deleteNotesRelayError(int count) {
    return '$count piezīmes dzēstas lokāli, bet neizdevās tās noņemt no relejiem';
  }

  @override
  String get deletingNotesTitle => 'Dzēš piezīmes…';

  @override
  String deletingNotesProgress(int completed, int total) {
    return 'Dzēš $completed no $total';
  }

  @override
  String get syncSelectedSuccess => 'Piezīmes sinhronizētas';

  @override
  String syncSelectedPartialError(int count) {
    return 'Neizdevās sinhronizēt $count piezīmes';
  }

  @override
  String get exportConfirmTitle => 'Eksportēt piezīmes';

  @override
  String get exportConfirmBody =>
      'Izveido jūsu piezīmju dublējuma failu. Tas ietver arī pievienoto attēlu vai balss piezīmju atšifrēšanas atslēgas — ikviens ar šo failu varētu tās nolasīt, ja vien tas nav šifrēts.';

  @override
  String get exportEncryptToggleLabel => 'Šifrēt šo failu';

  @override
  String get exportEncryptToggleSubtitle => 'Ieteicams — aizsargā dublējumu ar paroli';

  @override
  String get exportPasswordDialogTitle => 'Ievadiet savu paroli';

  @override
  String get exportSetPasswordDialogTitle => 'Iestatiet paroli šim eksportam';

  @override
  String get importPasswordDialogTitle => 'Ievadiet eksporta paroli';

  @override
  String get sectionData => 'Dati';

  @override
  String get exportNotesButton => 'Eksportēt piezīmes';

  @override
  String get exportNotesSubtitle =>
      'Saglabājiet visas savas piezīmes failā, kuru vēlāk varēsiet atkārtoti importēt';

  @override
  String get importNotesButton => 'Importēt piezīmes';

  @override
  String get importNotesSubtitle => 'Atjaunojiet piezīmes no iepriekš eksportēta faila';

  @override
  String get exportNotesSuccess => 'Piezīmes eksportētas';

  @override
  String exportNotesError(Object error) {
    return 'Neizdevās eksportēt piezīmes: $error';
  }

  @override
  String importNotesSuccess(int count) {
    return 'Importētas $count piezīmes';
  }

  @override
  String importNotesError(Object error) {
    return 'Neizdevās importēt piezīmes: $error';
  }

  @override
  String get sectionAttachments => 'Pielikumi';

  @override
  String get attachmentProviderSubtitle =>
      'Kur tiek augšupielādēti šifrētie attēli un balss piezīmes sinhronizējot';

  @override
  String get attachmentProviderCustom => 'Pielāgots…';

  @override
  String get attachmentCustomUrlLabel => 'Servera URL';

  @override
  String get attachmentProviderHint =>
      'Daži publiskie serveri (piem., Primal, nostr.build) noraida šifrētas augšupielādes — tie pārbauda īstu attēla saturu, kas šifrēti dati nekad nav. Izvēlieties Blossom serveri, kas glabā necaurspīdīgus datus, vai norādiet Pielāgots… uz savu serveri.';

  @override
  String get sectionSupport => 'Atbalsts';

  @override
  String get supportEchoesTitle => 'Atbalsti Echoes';

  @override
  String lightningAddressCopied(String address) {
    return '⚡ $address nokopēts starpliktuvē';
  }

  @override
  String get cancelButton => 'Atcelt';

  @override
  String get passwordLabel => 'Parole';

  @override
  String get invalidPrivateKeyError =>
      'Privātā atslēga nav derīga. Ievadiet derīgu nsec vai hex atslēgu.';

  @override
  String get wrongPasswordError => 'Nepareiza parole';

  @override
  String genericErrorPrefix(String error) {
    return 'Kļūda: $error';
  }

  @override
  String get shareNoteTooltip => 'Kopīgot';

  @override
  String get shareNoteTitle => 'Kopīgot piezīmi';

  @override
  String get shareRecipientFieldLabel => 'Saņēmēja npub vai publiskā atslēga';

  @override
  String get shareAddRecipientButton => 'Pievienot';

  @override
  String get shareInvalidRecipientError => 'Tas nav derīgs npub vai publiskā atslēga';

  @override
  String get shareRecipientNotFoundError => 'Šim vārdam netika atrasts neviens Nostr konts';

  @override
  String get shareConfirmTitle => 'Kopīgot šo piezīmi?';

  @override
  String get shareConfirmButton => 'Kopīgot';

  @override
  String get shareAlreadyRecipientError => 'Jau kopīgots ar šo personu';

  @override
  String get shareCannotShareWithSelfError => 'Nevar kopīgot piezīmi ar sevi';

  @override
  String get shareRecipientsHeader => 'Kopīgots ar';

  @override
  String get shareNoRecipientsMessage => 'Vēl nav ne ar vienu kopīgots.';

  @override
  String get stopSharingTooltip => 'Pārtraukt kopīgošanu ar šo personu';

  @override
  String get shareRevocationNote =>
      'Ikviens, ar ko kopīgojat, var lasīt šo piezīmi savā ierīcē. Kāda noņemšana aptur turpmākos atjauninājumus, bet nevar dzēst jau saņemto.';

  @override
  String shareError(String error) {
    return 'Neizdevās atjaunināt kopīgošanu: $error';
  }

  @override
  String get sharedWithMeHeader => 'Kopīgots ar jums';

  @override
  String sharedByLabel(String npub) {
    return 'Kopīgoja $npub';
  }

  @override
  String get sharedNoteEditableNote =>
      'Šo piezīmi varat rediģēt; jūsu izmaiņas tiek sinhronizētas atpakaļ īpašniekam, kurš tās apvieno.';

  @override
  String get abandonSharedNoteButton => 'Pamest šo kopīgoto piezīmi';

  @override
  String get abandonSharedNoteConfirmTitle => 'Pamest šo kopīgoto piezīmi?';

  @override
  String get abandonSharedNoteConfirmBody =>
      'Tā tiks noņemta no šīs ierīces, un jūs pārstāsiet saņemt atjauninājumus. To nevar atsaukt — vēlāk atkārtoti pievienoties nevarēsiet.';

  @override
  String abandonSharedNoteError(String error) {
    return 'Neizdevās pamest: $error';
  }
}
