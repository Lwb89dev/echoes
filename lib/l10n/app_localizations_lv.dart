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
  String get importAccountFieldLabel =>
      'Jūsu Nostr konta privātā atslēga (nsec)';

  @override
  String get importButton => 'Importēt';

  @override
  String get relaysTitle => 'Releji';

  @override
  String get settingsTooltip => 'Iestatījumi';

  @override
  String get emptyNotesMessage =>
      'Vēl nav piezīmju. Pieskarieties +, lai izveidotu jaunu.';

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
  String get newNoteTitle => 'Jauna piezīme';

  @override
  String get editNoteTitle => 'Rediģēt piezīmi';

  @override
  String get newDiaryEntryTitle => 'New diary entry';

  @override
  String get editDiaryEntryTitle => 'Edit diary entry';

  @override
  String get saveTooltip => 'Saglabāt';

  @override
  String get titleFieldLabel => 'Nosaukums';

  @override
  String get checklistLabel => 'Kontrolsaraksts';

  @override
  String get bodyFieldHint => 'Rakstiet šeit... (atbalstīts markdown)';

  @override
  String get checklistItemHint => 'Saraksta vienums';

  @override
  String get addItemButton => 'Pievienot vienumu';

  @override
  String get addImageButton => 'Pievienot attēlu';

  @override
  String get recordVoiceNoteTooltip => 'Ierakstīt balss piezīmi';

  @override
  String get stopRecordingTooltip => 'Apturēt ierakstīšanu';

  @override
  String get cancelRecordingTooltip => 'Atcelt ierakstīšanu';

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
  String get lockNotesNowSubtitle =>
      'Lai skatītu piezīmes, atkal būs nepieciešama parole';

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
  String get disablePasswordDialogTitle =>
      'Ievadiet paroli, lai atspējotu šifrēšanu';

  @override
  String get disableButton => 'Atspējot';

  @override
  String get sectionAppearance => 'Izskats';

  @override
  String get lightThemeToggleTitle => 'Gaiša tēma';

  @override
  String get lightThemeToggleSubtitle =>
      'Izmantot gaišu krāsu shēmu tumšas vietā';

  @override
  String get noteLayoutToggleTitle => 'Piezīmju saraksta izkārtojums';

  @override
  String get noteLayoutToggleSubtitle =>
      'Pārslēgties starp saraksta un režģa skatu';

  @override
  String get manageRelaysTitle => 'Pārvaldīt relejus';

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
  String get onboardingIntroAmberTitle =>
      'Pierakstieties, neatklājot savu atslēgu';

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
  String get exportEncryptToggleSubtitle =>
      'Ieteicams — aizsargā dublējumu ar paroli';

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
  String get importNotesSubtitle =>
      'Atjaunojiet piezīmes no iepriekš eksportēta faila';

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
      'Some public hosts (e.g. Primal, nostr.build) reject encrypted uploads outright — they validate real image content, which ciphertext never is. Prefer a Blossom host that stores opaque blobs, or point Custom… at a self-hosted one.';

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
}
