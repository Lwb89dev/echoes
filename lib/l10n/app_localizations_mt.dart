// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Maltese (`mt`).
class AppLocalizationsMt extends AppLocalizations {
  AppLocalizationsMt([String locale = 'mt']) : super(locale);

  @override
  String get loginSubtitle => 'Idħol bil-kont Nostr tiegħek';

  @override
  String get loginWithAmberButton => 'Idħol b\'Amber';

  @override
  String get importAccountButton => 'Importa kont Nostr';

  @override
  String get importAccountFieldLabel => 'Ċavetta privata (nsec) tal-kont Nostr tiegħek';

  @override
  String get importButton => 'Importa';

  @override
  String get bunkerLoginButton => 'Qabbad firmatarju remot (bunker)';

  @override
  String get bunkerFieldLabel => 'Waħħal it-token tal-konnessjoni bunker:// tiegħek';

  @override
  String get bunkerConnectButton => 'Qabbad';

  @override
  String get bunkerAuthPrompt => 'Approva l-konnessjoni fil-firmatarju tiegħek u erġa\' lura';

  @override
  String get relaysTitle => 'Relays';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get searchTooltip => 'Fittex';

  @override
  String get closeSearchTooltip => 'Agħlaq it-tfittxija';

  @override
  String get searchNotesHint => 'Fittex fin-noti';

  @override
  String get noSearchResultsMessage => 'L-ebda riżultat.';

  @override
  String get emptyNotesMessage => 'Għad m\'hemm l-ebda nota. Mess + biex toħloq waħda.';

  @override
  String get notesTabLabel => 'Noti';

  @override
  String get diaryTabLabel => 'Djarju';

  @override
  String get emptyDiaryMessage => 'Għad m\'hemmx entrati fid-djarju. Għafas + biex tikteb waħda.';

  @override
  String get diaryToday => 'Illum';

  @override
  String get diaryYesterday => 'Ilbieraħ';

  @override
  String get newPlainNoteOption => 'Nota';

  @override
  String get newChecklistOption => 'Lista ta\' kontroll';

  @override
  String get newVoiceNoteOption => 'Nota bil-vuċi';

  @override
  String get deleteNoteButton => 'Ħassar in-nota';

  @override
  String get deleteNoteConfirmTitle => 'Tħassar din in-nota?';

  @override
  String get deleteNoteConfirmBody =>
      'Din ma tistax titħassar lura. Jekk din in-nota kienet sinkronizzata, titneħħa wkoll mir-relays tiegħek.';

  @override
  String deleteNotesConfirmTitle(int count) {
    return 'Tħassar $count noti?';
  }

  @override
  String get deleteNotesConfirmBody =>
      'Din ma tistax titħassar lura. Jekk kwalunkwe waħda minn dawn in-noti kienet sinkronizzata, titneħħa wkoll mir-relays tiegħek.';

  @override
  String selectionCount(int count) {
    return '$count magħżula';
  }

  @override
  String get untitledNote => '(bla titlu)';

  @override
  String errorLoadingNotes(String error) {
    return 'Żball fit-tagħbija tan-noti: $error';
  }

  @override
  String get timeJustNow => 'issa';

  @override
  String timeMinutesAgo(int count) {
    return '$count min ilu';
  }

  @override
  String timeHoursAgo(int count) {
    return '$count sigħ ilu';
  }

  @override
  String timeDaysAgo(int count) {
    return '$count jum ilu';
  }

  @override
  String get notesLockedTitle => 'In-noti huma protetti b\'password';

  @override
  String get unlockButton => 'Iftaħ';

  @override
  String get saveTooltip => 'Issejvja';

  @override
  String get titleFieldLabel => 'Titlu';

  @override
  String get bodyFieldHint => 'Ikteb hawn... (markdown appoġġjat)';

  @override
  String get checklistItemHint => 'Element tal-lista';

  @override
  String get addItemButton => 'Żid element';

  @override
  String completedItemsSection(int count) {
    return 'Lesti ($count)';
  }

  @override
  String get duplicateChecklistItemMessage => 'Diġà f\'din il-lista, lest';

  @override
  String get restoreChecklistItemButton => 'Irkupra';

  @override
  String get noteSyncedMessage => 'In-nota ġiet sinkronizzata';

  @override
  String get noteSyncedFirstTimeMessage => 'In-nota ġiet sinkronizzata għall-ewwel darba';

  @override
  String notePartiallySyncedMessage(int accepted, int total) {
    return 'Sinkronizzata ma\' $accepted minn $total relays';
  }

  @override
  String checklistProgress(int done, int total) {
    return '$done minn $total lesti';
  }

  @override
  String get showCompletedItemsTooltip => 'Uri l-elementi lesti';

  @override
  String get hideCompletedItemsTooltip => 'Aħbi l-elementi lesti';

  @override
  String get allChecklistItemsCompletedHidden => 'L-elementi kollha huma lesti u moħbija.';

  @override
  String get deleteCompletedItemsButton => 'Ħassar l-elementi lesti';

  @override
  String get deleteCompletedItemsConfirmTitle => 'Tħassar l-elementi lesti?';

  @override
  String deleteCompletedItemsConfirmBody(int count) {
    return 'Dan ineħħi $count elementi mmarkati minn din il-lista. Ma jistax jiġi annullat.';
  }

  @override
  String get addImageButton => 'Żid ritratt';

  @override
  String get noteColorButton => 'Kulur tan-nota';

  @override
  String get noteColorDefault => 'Predefinit';

  @override
  String get noteColorYellow => 'Isfar';

  @override
  String get noteColorRed => 'Aħmar';

  @override
  String get noteColorPurple => 'Vjola';

  @override
  String get noteColorBlue => 'Blu';

  @override
  String get noteColorGreen => 'Aħdar';

  @override
  String get noteColorOrange => 'Oranġjo';

  @override
  String get noteColorWhite => 'Abjad';

  @override
  String get recordVoiceNoteTooltip => 'Irrekordja nota bil-vuċi';

  @override
  String get recordVoiceNoteInstructions =>
      'Għafas il-buttuna l-ħamra biex tibda tirrekordja, jew ✕ biex tikkanċella.';

  @override
  String get stopRecordingTooltip => 'Waqqaf ir-reġistrazzjoni';

  @override
  String get cancelRecordingTooltip => 'Ikkanċella r-reġistrazzjoni';

  @override
  String get addVoiceTimestampButton => 'Żid timbru tal-ħin';

  @override
  String get editVoiceTimestampButton => 'Editja t-timbru tal-ħin';

  @override
  String get voiceNoteUnsupportedOnPlatform => 'Noti bil-vuċi mhumiex sostnuti fuq dan l-apparat';

  @override
  String get formatBoldTooltip => 'Grassett';

  @override
  String get formatItalicTooltip => 'Korsiv';

  @override
  String get formatHeadingTooltip => 'Intestatura';

  @override
  String get formatListTooltip => 'Lista bil-punti';

  @override
  String get formatLinkTooltip => 'Ħolqa';

  @override
  String get imageSizeSmall => 'Żgħir';

  @override
  String get imageSizeMedium => 'Medju';

  @override
  String get imageSizeFull => 'Wisa\' sħiħa';

  @override
  String get removeImageButton => 'Neħħi l-istampa';

  @override
  String get relayUrlHint => 'wss://relay.example.com';

  @override
  String get noRelaysMessage => 'Għad m\'hemm l-ebda relay konfigurat.';

  @override
  String relaysCount(int count) {
    return '$count relays';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get sectionSecurity => 'Sigurtà';

  @override
  String get loadingLabel => 'Qed jgħabbi…';

  @override
  String get encryptionLoadError => 'Ma setgħux jitgħabbew is-settings tal-kriptaġġ';

  @override
  String get encryptionToggleTitle => 'Ipproteġi n-noti b\'password';

  @override
  String get encryptionToggleSubtitle =>
      'Jikkripta n-noti maħżuna (AES-256-GCM) b\'ċavetta miksuba mill-password tiegħek. Il-password qatt ma tinħażen — jekk tinsieha, in-noti ma jistgħux jiġu rkuprati.';

  @override
  String get lockNotesNowTitle => 'Issakkar in-noti issa';

  @override
  String get lockNotesNowSubtitle => 'Il-password tkun meħtieġa mill-ġdid biex tara n-noti';

  @override
  String get setPasswordDialogTitle => 'Issettja password';

  @override
  String get passwordTooShortError => 'Mill-inqas 8 karattri';

  @override
  String get confirmPasswordLabel => 'Ikkonferma l-password';

  @override
  String get passwordsDoNotMatchError => 'Il-passwords ma jaqblux';

  @override
  String enableEncryptionError(String error) {
    return 'Ma setax jiġi attivat il-kriptaġġ: $error';
  }

  @override
  String get enableButton => 'Attiva';

  @override
  String get disablePasswordDialogTitle =>
      'Daħħal il-password tiegħek biex tiddiżattiva l-kriptaġġ';

  @override
  String get disableButton => 'Diżattiva';

  @override
  String get sectionAppearance => 'Dehra';

  @override
  String get lightThemeToggleTitle => 'Tema ċara';

  @override
  String get lightThemeToggleSubtitle => 'Uża skema ta\' kuluri ċari minflok skura';

  @override
  String get noteLayoutToggleTitle => 'Aqleb bejn il-lista u l-gradilja';

  @override
  String get manageRelaysTitle => 'Immaniġġja r-relays';

  @override
  String get autoSyncOnSaveTitle => 'Ippubblika meta tissejvja';

  @override
  String get autoSyncOnSaveSubtitle =>
      'In-noti li diġà tissinkronizza jerġgħu jiġu ppubblikati hekk kif tissejvjahom. In-noti lokali qatt.';

  @override
  String get noteBackgroundPhoto => 'Ritratt';

  @override
  String get noteBackgroundRemove => 'Neħħi r-ritratt';

  @override
  String get republishAllNotesButton => 'Erġa\' ippubblika n-noti sinkronizzati kollha';

  @override
  String get republishAllNotesSubtitle =>
      'Jimla kull relay ta\' fuq bin-noti diġà kondiviżi band\'oħra — utli eżatt wara li żżid wieħed ġdid, eż. relay ta\' backup self-hosted';

  @override
  String republishAllNotesSuccess(int count) {
    return 'Reġgħu ġew ippubblikati $count noti';
  }

  @override
  String republishAllNotesError(String error) {
    return 'In-noti ma setgħux jerġgħu jiġu ppubblikati: $error';
  }

  @override
  String get forceFullResyncButton => 'Sforza risinkronizzazzjoni sħiħa';

  @override
  String get forceFullResyncSubtitle =>
      'Jerġa\' jiċċekkja mar-relays għall-istorja sħiħa ta\' nota minflok dak li huwa ġdid biss — utli jekk is-sinkronizzazzjoni tidher imwaħħla u taqbeż noti eqdem, eż. wara li ssewwi relay li ma jintlaħaqx';

  @override
  String get forceFullResyncSuccess => 'Noti aġġornati mir-relays';

  @override
  String forceFullResyncError(String error) {
    return 'Ma setgħetx issir risinkronizzazzjoni tan-noti: $error';
  }

  @override
  String get confirmButton => 'Ikkonferma';

  @override
  String get sectionLanguage => 'Lingwa';

  @override
  String get langSystem => 'Awtomatika tas-sistema';

  @override
  String get sectionAccount => 'Kont';

  @override
  String get accountLocalOnlyMessage => 'Qed tuża Echoes lokalment — mhux sinkronizzat ma\' Nostr';

  @override
  String get accountSignInButton => 'Idħol';

  @override
  String accountSignedInAs(String npub) {
    return 'Illoggjat bħala $npub';
  }

  @override
  String get accountSignOutButton => 'Oħroġ';

  @override
  String get accountSignOutConfirmTitle => 'Toħroġ?';

  @override
  String get accountSignOutConfirmBody =>
      'In-noti tiegħek jibqgħu f\'dan l-apparat. Tista\' terġa\' tidħol fi kwalunkwe ħin.';

  @override
  String get onboardingWelcomeTitle => 'Merħba f\'Echoes';

  @override
  String get onboardingIntroLocalTitle => 'In-noti tiegħek, dejjem fuq l-apparat tiegħek';

  @override
  String get onboardingIntroLocalBody =>
      'Kull nota tiġi salvata lokalment l-ewwel, biex l-app taħdem kompletament offline. Xejn ma jitlaq mill-apparat tiegħek sakemm ma tagħżilx li tissinkronizzah.';

  @override
  String get onboardingIntroSyncTitle => 'Sinkronizzazzjoni fakultattiva permezz ta\' Nostr';

  @override
  String get onboardingIntroSyncBody =>
      'Ixgħel is-sinkronizzazzjoni biex tibbekkjajja n-noti tiegħek u taqrahom fuq apparati oħra, bl-użu tal-protokoll miftuħ Nostr u r-relays tal-għażla tiegħek.';

  @override
  String get onboardingIntroEncryptionTitle => 'Dejjem kriptati';

  @override
  String get onboardingIntroEncryptionBody =>
      'In-noti sinkronizzati ma\' Nostr huma kriptati minn tarf sa tarf, biex l-operaturi tar-relay — u kulħadd ħaddieħor — qatt ma jkunu jistgħu jaqraw il-kontenut tagħhom.';

  @override
  String get onboardingIntroAmberTitle => 'Idħol mingħajr ma tesponi ċ-ċavetta tiegħek';

  @override
  String get onboardingIntroAmberBody =>
      'Uża Amber biex tidħol: iċ-ċavetta privata tiegħek tibqa\' f\'Amber u qatt ma tinqasam ma\' Echoes.';

  @override
  String get onboardingIntroSecurityTitle => 'Sigurtà mid-disinn';

  @override
  String get onboardingIntroSecurityBody =>
      'Iċ-ċavetta privata tiegħek tgħix fil-ħażna taċ-ċwievet kriptata tal-apparat tiegħek — jew, b\'Amber, qatt ma tmiss Echoes. Ir-ritratti u n-noti tal-vuċi jiġu kriptati qabel ma jitilqu mill-apparat tiegħek. In-noti jistgħu jiġu msakkra b\'password, u xejn minn dan qatt ma jiġi inkluż fil-backups tat-telefon.';

  @override
  String get onboardingNextButton => 'Li jmiss';

  @override
  String get onboardingBackButton => 'Lura';

  @override
  String get onboardingSkipButton => 'Aqbeż — uża Echoes lokalment biss';

  @override
  String get onboardingRelayTitle => 'Agħżel relays għas-sinkronizzazzjoni';

  @override
  String get onboardingRelayBody =>
      'Ir-relays huma fejn jinħażnu n-noti kriptati tiegħek meta tissinkronizza. Żid wieħed jew aktar — dawn popolari huma bidu tajjeb:';

  @override
  String get onboardingFinishButton => 'Ibda';

  @override
  String get syncNoteTooltip => 'Sinkronizza din in-nota';

  @override
  String get unsyncNoteTooltip => 'Neħħi mir-relays';

  @override
  String get syncSelectedTooltip => 'Sinkronizza n-noti magħżula';

  @override
  String get exportSelectedTooltip => 'Esporta n-noti magħżula';

  @override
  String get deleteSelectedTooltip => 'Ħassar in-noti magħżula';

  @override
  String syncNoteError(String error) {
    return 'Ma setgħetx tiġi sinkronizzata n-nota: $error';
  }

  @override
  String unsyncNoteError(String error) {
    return 'Ma setax jitneħħa n-nota mir-relays: $error';
  }

  @override
  String deleteNoteRelayError(String error) {
    return 'In-nota tħassret lokalment, iżda ma setgħetx titneħħa mir-relays: $error';
  }

  @override
  String deleteNotesRelayError(int count) {
    return '$count noti tħassru lokalment, iżda ma setgħux jitneħħew mir-relays';
  }

  @override
  String get deletingNotesTitle => 'Qed jitħassru n-noti…';

  @override
  String deletingNotesProgress(int completed, int total) {
    return 'Qed jitħassar $completed minn $total';
  }

  @override
  String get syncSelectedSuccess => 'In-noti ġew sinkronizzati';

  @override
  String syncSelectedPartialError(int count) {
    return 'Ma setax jiġi sinkronizzat $count noti';
  }

  @override
  String get exportConfirmTitle => 'Esporta n-noti';

  @override
  String get exportConfirmBody =>
      'Joħloq fajl backup tan-noti tiegħek. Jinkludi wkoll iċ-ċwievet tad-dekriptazzjoni għal kwalunkwe stampa jew nota tal-vuċi mehmuża — kull min għandu l-fajl jista\' jaqrahom sakemm ma jkunx kriptat.';

  @override
  String get exportEncryptToggleLabel => 'Kripta dan il-fajl';

  @override
  String get exportEncryptToggleSubtitle => 'Rakkomandat — jipproteġi l-backup b\'password';

  @override
  String get exportPasswordDialogTitle => 'Daħħal il-password tiegħek';

  @override
  String get exportSetPasswordDialogTitle => 'Issettja password għal din l-esportazzjoni';

  @override
  String get importPasswordDialogTitle => 'Daħħal il-password tal-esportazzjoni';

  @override
  String get sectionData => 'Data';

  @override
  String get exportNotesButton => 'Esporta n-noti';

  @override
  String get exportNotesSubtitle =>
      'Issejvja n-noti kollha tiegħek f\'fajl li tista\' terġa\' timporta aktar tard';

  @override
  String get importNotesButton => 'Importa n-noti';

  @override
  String get importNotesSubtitle => 'Irkupra n-noti minn fajl esportat qabel';

  @override
  String get exportNotesSuccess => 'In-noti ġew esportati';

  @override
  String exportNotesError(Object error) {
    return 'Ma setgħux jiġu esportati n-noti: $error';
  }

  @override
  String importNotesSuccess(int count) {
    return 'Ġew importati $count noti';
  }

  @override
  String importNotesError(Object error) {
    return 'Ma setgħux jiġu importati n-noti: $error';
  }

  @override
  String get sectionAttachments => 'Mehmuż';

  @override
  String get attachmentProviderSubtitle =>
      'Fejn jitgħabbew ir-ritratti kriptati u n-noti bil-vuċi meta tissinkronizza';

  @override
  String get attachmentProviderCustom => 'Personalizzat…';

  @override
  String get attachmentCustomUrlLabel => 'URL tas-server';

  @override
  String get attachmentProviderHint =>
      'Xi servers pubbliċi (eż. Primal, nostr.build) jirrifjutaw uploads kriptati — jivverifikaw kontenut ta\' immaġni reali, li data kriptata qatt ma hi. Ippreferi server Blossom li jaħżen data opaka, jew ippunta Personalizzat… lejn wieħed self-hosted.';

  @override
  String get sectionSupport => 'Appoġġ';

  @override
  String get supportEchoesTitle => 'Appoġġja lil Echoes';

  @override
  String lightningAddressCopied(String address) {
    return '⚡ $address ikkupjat fil-clipboard';
  }

  @override
  String get cancelButton => 'Ikkanċella';

  @override
  String get passwordLabel => 'Password';

  @override
  String get invalidPrivateKeyError =>
      'Iċ-ċavetta privata mhijiex valida. Daħħal ċavetta nsec jew hex valida.';

  @override
  String get wrongPasswordError => 'Password ħażina';

  @override
  String genericErrorPrefix(String error) {
    return 'Żball: $error';
  }

  @override
  String get shareNoteTooltip => 'Aqsam';

  @override
  String get shareNoteTitle => 'Aqsam nota';

  @override
  String get shareRecipientFieldLabel => 'npub jew ċavetta pubblika tar-riċevitur';

  @override
  String get shareAddRecipientButton => 'Żid';

  @override
  String get shareInvalidRecipientError => 'Dan mhux npub jew ċavetta pubblika valida';

  @override
  String get shareRecipientNotFoundError => 'Ma nstab ebda kont Nostr għal dak l-isem';

  @override
  String get shareConfirmTitle => 'Aqsam din in-nota?';

  @override
  String get shareConfirmButton => 'Aqsam';

  @override
  String get shareAlreadyRecipientError => 'Diġà maqsuma ma\' din il-persuna';

  @override
  String get shareCannotShareWithSelfError => 'Ma tistax taqsam nota miegħek innifsek';

  @override
  String get shareRecipientsHeader => 'Maqsuma ma\'';

  @override
  String get shareNoRecipientsMessage => 'Għadha ma nqasmet ma\' ħadd.';

  @override
  String get stopSharingTooltip => 'Waqqaf il-qsim ma\' din il-persuna';

  @override
  String get shareRevocationNote =>
      'Kull min taqsam miegħu jista\' jaqra din in-nota fuq l-apparat tiegħu. It-tneħħija ta\' xi ħadd twaqqaf l-aġġornamenti futuri, iżda ma tistax tħassar dak li diġà rċieva.';

  @override
  String shareError(String error) {
    return 'Ma setax jiġi aġġornat il-qsim: $error';
  }

  @override
  String get sharedWithMeHeader => 'Maqsuma miegħek';

  @override
  String sharedByLabel(String npub) {
    return 'Maqsuma minn $npub';
  }

  @override
  String get sharedNoteEditableNote =>
      'Tista\' teditja din in-nota; il-bidliet tiegħek jiġu sinkronizzati lura lis-sid, li jgħaqqadhom.';

  @override
  String get abandonSharedNoteButton => 'Ħalli din in-nota maqsuma';

  @override
  String get abandonSharedNoteConfirmTitle => 'Tħalli din in-nota maqsuma?';

  @override
  String get abandonSharedNoteConfirmBody =>
      'Titneħħa minn dan l-apparat u tieqaf tirċievi aġġornamenti. Dan ma jistax jiġi revokat — mhux se tkun tista\' terġa\' tingħaqad.';

  @override
  String abandonSharedNoteError(String error) {
    return 'Ma setax jiġi mħolli: $error';
  }
}
