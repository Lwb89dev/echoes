// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Irish (`ga`).
class AppLocalizationsGa extends AppLocalizations {
  AppLocalizationsGa([String locale = 'ga']) : super(locale);

  @override
  String get loginSubtitle => 'Sínigh isteach le do chuntas Nostr';

  @override
  String get loginWithAmberButton => 'Sínigh isteach le Amber';

  @override
  String get importAccountButton => 'Iompórtáil cuntas Nostr';

  @override
  String get importAccountFieldLabel =>
      'Eochair phríobháideach (nsec) do chuntais Nostr';

  @override
  String get importButton => 'Iompórtáil';

  @override
  String get relaysTitle => 'Athsheachadáin';

  @override
  String get settingsTooltip => 'Socruithe';

  @override
  String get searchTooltip => 'Search';

  @override
  String get closeSearchTooltip => 'Close search';

  @override
  String get searchNotesHint => 'Search notes';

  @override
  String get noSearchResultsMessage => 'No matches.';

  @override
  String get emptyNotesMessage =>
      'Níl aon nótaí ann fós. Tapáil + chun ceann a chruthú.';

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
  String get newPlainNoteOption => 'Nóta';

  @override
  String get newChecklistOption => 'Seicliosta';

  @override
  String get newVoiceNoteOption => 'Nóta gutha';

  @override
  String get deleteNoteButton => 'Scrios an nóta';

  @override
  String get deleteNoteConfirmTitle => 'An nóta seo a scriosadh?';

  @override
  String get deleteNoteConfirmBody =>
      'Ní féidir é seo a chur ar ceal. Má bhí an nóta seo sioncronaithe, bainfear é ó do réalaithe freisin.';

  @override
  String deleteNotesConfirmTitle(int count) {
    return '$count nóta a scriosadh?';
  }

  @override
  String get deleteNotesConfirmBody =>
      'Ní féidir é seo a chur ar ceal. Má bhí aon cheann de na nótaí seo sioncronaithe, bainfear iad ó do réalaithe freisin.';

  @override
  String selectionCount(int count) {
    return '$count roghnaithe';
  }

  @override
  String get untitledNote => '(gan teideal)';

  @override
  String errorLoadingNotes(String error) {
    return 'Earráid agus na nótaí á luchtú: $error';
  }

  @override
  String get timeJustNow => 'anois';

  @override
  String timeMinutesAgo(int count) {
    return '$count nóim ó shin';
  }

  @override
  String timeHoursAgo(int count) {
    return '$count uair ó shin';
  }

  @override
  String timeDaysAgo(int count) {
    return '$count lá ó shin';
  }

  @override
  String get notesLockedTitle => 'Tá na nótaí faoi chosaint ag focal faire';

  @override
  String get unlockButton => 'Díghlasáil';

  @override
  String get saveTooltip => 'Sábháil';

  @override
  String get titleFieldLabel => 'Teideal';

  @override
  String get checklistLabel => 'Seicliosta';

  @override
  String get bodyFieldHint => 'Scríobh anseo... (tacaítear le markdown)';

  @override
  String get checklistItemHint => 'Mír seicliosta';

  @override
  String get addItemButton => 'Cuir mír leis';

  @override
  String checklistProgress(int done, int total) {
    return '$done of $total done';
  }

  @override
  String get showCompletedItemsTooltip => 'Show completed items';

  @override
  String get hideCompletedItemsTooltip => 'Hide completed items';

  @override
  String get allChecklistItemsCompletedHidden =>
      'All items are completed and hidden.';

  @override
  String get deleteCompletedItemsButton => 'Delete completed items';

  @override
  String get deleteCompletedItemsConfirmTitle => 'Delete completed items?';

  @override
  String deleteCompletedItemsConfirmBody(int count) {
    return 'This removes $count checked-off item(s) from this checklist. This can\'t be undone.';
  }

  @override
  String get addImageButton => 'Cuir íomhá leis';

  @override
  String get noteColorButton => 'Note color';

  @override
  String get noteColorDefault => 'Default';

  @override
  String get noteColorYellow => 'Yellow';

  @override
  String get noteColorRed => 'Red';

  @override
  String get noteColorPurple => 'Purple';

  @override
  String get noteColorBlue => 'Blue';

  @override
  String get noteColorGreen => 'Green';

  @override
  String get noteColorOrange => 'Orange';

  @override
  String get noteColorWhite => 'White';

  @override
  String get recordVoiceNoteTooltip => 'Taifead nóta gutha';

  @override
  String get recordVoiceNoteInstructions =>
      'Tap the red button to start recording, or ✕ to cancel.';

  @override
  String get stopRecordingTooltip => 'Stop an taifeadadh';

  @override
  String get cancelRecordingTooltip => 'Cealaigh an taifeadadh';

  @override
  String get addVoiceTimestampButton => 'Add timestamp';

  @override
  String get editVoiceTimestampButton => 'Edit timestamp';

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
  String get imageSizeSmall => 'Beag';

  @override
  String get imageSizeMedium => 'Meánmhéid';

  @override
  String get imageSizeFull => 'Leithead iomlán';

  @override
  String get removeImageButton => 'Bain an íomhá';

  @override
  String get relayUrlHint => 'wss://relay.example.com';

  @override
  String get noRelaysMessage => 'Níl aon athsheachadán cumraithe fós.';

  @override
  String relaysCount(int count) {
    return '$count athsheachadán';
  }

  @override
  String get settingsTitle => 'Socruithe';

  @override
  String get sectionSecurity => 'Slándáil';

  @override
  String get loadingLabel => 'Á luchtú…';

  @override
  String get encryptionLoadError =>
      'Níorbh fhéidir socruithe criptithe a luchtú';

  @override
  String get encryptionToggleTitle => 'Cosain nótaí le focal faire';

  @override
  String get encryptionToggleSubtitle =>
      'Criptíonn sé nótaí stórtha (AES-256-GCM) le heochair a dhíorthaítear ó d\'fhocal faire. Ní shábháiltear an focal faire riamh — má dhéanann tú dearmad air, ní féidir na nótaí a aischur.';

  @override
  String get lockNotesNowTitle => 'Glasáil nótaí anois';

  @override
  String get lockNotesNowSubtitle =>
      'Beidh an focal faire ag teastáil arís chun na nótaí a fheiceáil';

  @override
  String get setPasswordDialogTitle => 'Socraigh focal faire';

  @override
  String get passwordTooShortError => '8 gcarachtar ar a laghad';

  @override
  String get confirmPasswordLabel => 'Deimhnigh an focal faire';

  @override
  String get passwordsDoNotMatchError => 'Ní ionann na focail faire';

  @override
  String enableEncryptionError(String error) {
    return 'Níorbh fhéidir an criptiú a chumasú: $error';
  }

  @override
  String get enableButton => 'Cumasaigh';

  @override
  String get disablePasswordDialogTitle =>
      'Iontráil d\'fhocal faire chun an criptiú a dhíchumasú';

  @override
  String get disableButton => 'Díchumasaigh';

  @override
  String get sectionAppearance => 'Cuma';

  @override
  String get lightThemeToggleTitle => 'Téama geal';

  @override
  String get lightThemeToggleSubtitle =>
      'Úsáid scéim dathanna gheal in ionad dorcha';

  @override
  String get noteLayoutToggleTitle => 'Leagan amach liosta nótaí';

  @override
  String get manageRelaysTitle => 'Bainistigh athsheachadáin';

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
  String get confirmButton => 'Deimhnigh';

  @override
  String get sectionLanguage => 'Teanga';

  @override
  String get langSystem => 'Réamhshocrú an chórais';

  @override
  String get sectionAccount => 'Cuntas';

  @override
  String get accountLocalOnlyMessage =>
      'Echoes á úsáid go háitiúil — gan sioncronú le Nostr';

  @override
  String get accountSignInButton => 'Sínigh isteach';

  @override
  String accountSignedInAs(String npub) {
    return 'Sínithe isteach mar $npub';
  }

  @override
  String get accountSignOutButton => 'Sínigh amach';

  @override
  String get accountSignOutConfirmTitle => 'Sínigh amach?';

  @override
  String get accountSignOutConfirmBody =>
      'Fanann do chuid nótaí ar an ngléas seo. Is féidir leat síniú isteach arís am ar bith.';

  @override
  String get onboardingWelcomeTitle => 'Fáilte go Echoes';

  @override
  String get onboardingIntroLocalTitle =>
      'Do chuid nótaí, i gcónaí ar do ghléas';

  @override
  String get onboardingIntroLocalBody =>
      'Sábháiltear gach nóta go háitiúil ar dtús, mar sin oibríonn an aip go hiomlán as líne. Ní fhágann tada do ghléas mura roghnaíonn tú é a shioncronú.';

  @override
  String get onboardingIntroSyncTitle => 'Sioncronú roghnach trí Nostr';

  @override
  String get onboardingIntroSyncBody =>
      'Cuir sioncronú ar siúl chun cúltaca a dhéanamh ar do nótaí agus iad a léamh ar ghléasanna eile, ag baint úsáide as prótacal oscailte Nostr agus athsheachadáin de do rogha féin.';

  @override
  String get onboardingIntroEncryptionTitle => 'Criptithe i gcónaí';

  @override
  String get onboardingIntroEncryptionBody =>
      'Tá nótaí atá sioncronaithe le Nostr criptithe ó cheann go ceann, sa chaoi nach féidir le hoibreoirí athsheachadáin — ná duine ar bith eile — a bhfuil iontu a léamh riamh.';

  @override
  String get onboardingIntroAmberTitle =>
      'Sínigh isteach gan d\'eochair a nochtadh';

  @override
  String get onboardingIntroAmberBody =>
      'Bain úsáid as Amber le síniú isteach: fanann d\'eochair phríobháideach in Amber agus ní roinntear le Echoes í riamh.';

  @override
  String get onboardingIntroSecurityTitle => 'Slándáil ó dhearadh';

  @override
  String get onboardingIntroSecurityBody =>
      'Tá d\'eochair phríobháideach i stór eochracha criptithe do ghléis — nó, le Amber, ní bhaineann sé le Echoes ar chor ar bith. Déantar grianghraif agus nótaí gutha a chriptiú sula bhfágann siad do ghléas riamh. Is féidir nótaí a ghlasáil le pasfhocal, agus ní chuirtear aon rud díobh seo riamh i gcúltacaí fóin.';

  @override
  String get onboardingNextButton => 'Ar aghaidh';

  @override
  String get onboardingBackButton => 'Siar';

  @override
  String get onboardingSkipButton => 'Ná bac — úsáid Echoes go háitiúil amháin';

  @override
  String get onboardingRelayTitle =>
      'Roghnaigh athsheachadáin le haghaidh sioncronaithe';

  @override
  String get onboardingRelayBody =>
      'Is iad athsheachadáin an áit a stóráiltear do chuid nótaí criptithe nuair a shioncronaíonn tú. Cuir ceann amháin nó níos mó leis — is tús maith iad seo atá coitianta:';

  @override
  String get onboardingFinishButton => 'Tosaigh';

  @override
  String get syncNoteTooltip => 'Sioncronaigh an nóta seo';

  @override
  String get unsyncNoteTooltip => 'Bain de na réalaithe';

  @override
  String get syncSelectedTooltip => 'Sioncrónaigh na nótaí roghnaithe';

  @override
  String get exportSelectedTooltip => 'Easpórtáil na nótaí roghnaithe';

  @override
  String get deleteSelectedTooltip => 'Scrios na nótaí roghnaithe';

  @override
  String syncNoteError(String error) {
    return 'Níorbh fhéidir an nóta a shioncronú: $error';
  }

  @override
  String unsyncNoteError(String error) {
    return 'Níorbh fhéidir an nóta a bhaint de na réalaithe: $error';
  }

  @override
  String deleteNoteRelayError(String error) {
    return 'Scriosadh an nóta go háitiúil, ach níorbh fhéidir é a bhaint de na réalaithe: $error';
  }

  @override
  String deleteNotesRelayError(int count) {
    return 'Scriosadh $count nóta go háitiúil, ach níorbh fhéidir iad a bhaint de na réalaithe';
  }

  @override
  String get deletingNotesTitle => 'Nótaí á scriosadh…';

  @override
  String deletingNotesProgress(int completed, int total) {
    return 'Ag scriosadh $completed as $total';
  }

  @override
  String get syncSelectedSuccess => 'Nótaí sioncronaithe';

  @override
  String syncSelectedPartialError(int count) {
    return 'Níorbh fhéidir $count nóta a shioncrónú';
  }

  @override
  String get exportConfirmTitle => 'Easpórtáil nótaí';

  @override
  String get exportConfirmBody =>
      'Cruthaíonn sé comhad cúltaca de do chuid nótaí. Áirítear ann freisin na heochracha díchriptithe le haghaidh aon íomhánna nó nótaí gutha atá ceangailte — d\'fhéadfadh duine ar bith a bhfuil an comhad acu iad a léamh mura bhfuil sé criptithe.';

  @override
  String get exportEncryptToggleLabel => 'Criptigh an comhad seo';

  @override
  String get exportEncryptToggleSubtitle =>
      'Molta — cosnaíonn sé an cúltaca le pasfhocal';

  @override
  String get exportPasswordDialogTitle => 'Cuir isteach do phasfhocal';

  @override
  String get exportSetPasswordDialogTitle =>
      'Socraigh pasfhocal don easpórtáil seo';

  @override
  String get importPasswordDialogTitle =>
      'Cuir isteach pasfhocal na heaspórtála';

  @override
  String get sectionData => 'Sonraí';

  @override
  String get exportNotesButton => 'Easpórtáil nótaí';

  @override
  String get exportNotesSubtitle =>
      'Sábháil do chuid nótaí uile i gcomhad ar féidir leat é a iompórtáil arís níos déanaí';

  @override
  String get importNotesButton => 'Iompórtáil nótaí';

  @override
  String get importNotesSubtitle =>
      'Athchóirigh nótaí ó chomhad a easpórtáladh roimhe seo';

  @override
  String get exportNotesSuccess => 'Nótaí easpórtáilte';

  @override
  String exportNotesError(Object error) {
    return 'Níorbh fhéidir na nótaí a easpórtáil: $error';
  }

  @override
  String importNotesSuccess(int count) {
    return 'Iompórtáladh $count nóta';
  }

  @override
  String importNotesError(Object error) {
    return 'Níorbh fhéidir na nótaí a iompórtáil: $error';
  }

  @override
  String get sectionAttachments => 'Ceangaltáin';

  @override
  String get attachmentProviderSubtitle =>
      'An áit a n-uaslódáiltear íomhánna criptithe agus nótaí gutha nuair a shioncrónaíonn tú';

  @override
  String get attachmentProviderCustom => 'Saincheaptha…';

  @override
  String get attachmentCustomUrlLabel => 'URL an fhreastalaí';

  @override
  String get attachmentProviderHint =>
      'Some public hosts (e.g. Primal, nostr.build) reject encrypted uploads outright — they validate real image content, which ciphertext never is. Prefer a Blossom host that stores opaque blobs, or point Custom… at a self-hosted one.';

  @override
  String get sectionSupport => 'Tacaíocht';

  @override
  String get supportEchoesTitle => 'Tacaigh le Echoes';

  @override
  String lightningAddressCopied(String address) {
    return '⚡ Cóipeáladh $address chuig an ngearrthaisce';
  }

  @override
  String get cancelButton => 'Cealaigh';

  @override
  String get passwordLabel => 'Focal faire';

  @override
  String get invalidPrivateKeyError =>
      'Níl an eochair phríobháideach bailí. Cuir isteach eochair nsec nó hex bhailí.';

  @override
  String get wrongPasswordError => 'Focal faire mícheart';

  @override
  String genericErrorPrefix(String error) {
    return 'Earráid: $error';
  }
}
