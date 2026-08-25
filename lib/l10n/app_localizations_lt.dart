// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Lithuanian (`lt`).
class AppLocalizationsLt extends AppLocalizations {
  AppLocalizationsLt([String locale = 'lt']) : super(locale);

  @override
  String get loginSubtitle => 'Prisijunkite naudodami savo Nostr paskyrą';

  @override
  String get loginWithAmberButton => 'Prisijungti su Amber';

  @override
  String get importAccountButton => 'Importuoti Nostr paskyrą';

  @override
  String get importAccountFieldLabel => 'Jūsų Nostr paskyros privatus raktas (nsec)';

  @override
  String get importButton => 'Importuoti';

  @override
  String get bunkerLoginButton => 'Prijungti nuotolinį pasirašytoją (bunker)';

  @override
  String get bunkerFieldLabel => 'Įklijuokite savo bunker:// prisijungimo raktą';

  @override
  String get bunkerConnectButton => 'Prijungti';

  @override
  String get bunkerAuthPrompt => 'Patvirtinkite ryšį savo pasirašytojuje ir grįžkite';

  @override
  String get relaysTitle => 'Relės';

  @override
  String get settingsTooltip => 'Nustatymai';

  @override
  String get searchTooltip => 'Ieškoti';

  @override
  String get closeSearchTooltip => 'Užverti paiešką';

  @override
  String get searchNotesHint => 'Ieškoti užrašuose';

  @override
  String get noSearchResultsMessage => 'Atitikmenų nėra.';

  @override
  String get emptyNotesMessage => 'Užrašų dar nėra. Palieskite +, kad sukurtumėte naują.';

  @override
  String get notesTabLabel => 'Užrašai';

  @override
  String get diaryTabLabel => 'Dienoraštis';

  @override
  String get emptyDiaryMessage => 'Dienoraščio įrašų dar nėra. Palieskite +, kad parašytumėte.';

  @override
  String get diaryToday => 'Šiandien';

  @override
  String get diaryYesterday => 'Vakar';

  @override
  String get newPlainNoteOption => 'Užrašas';

  @override
  String get newChecklistOption => 'Kontrolinis sąrašas';

  @override
  String get newVoiceNoteOption => 'Balso užrašas';

  @override
  String get deleteNoteButton => 'Ištrinti užrašą';

  @override
  String get deleteNoteConfirmTitle => 'Ištrinti šį užrašą?';

  @override
  String get deleteNoteConfirmBody =>
      'Šio veiksmo anuliuoti negalima. Jei šis užrašas buvo sinchronizuotas, jis taip pat bus pašalintas iš jūsų relių.';

  @override
  String deleteNotesConfirmTitle(int count) {
    return 'Ištrinti $count užrašus?';
  }

  @override
  String get deleteNotesConfirmBody =>
      'Šio veiksmo anuliuoti negalima. Jei bet kuris iš šių užrašų buvo sinchronizuotas, jis taip pat bus pašalintas iš jūsų relių.';

  @override
  String selectionCount(int count) {
    return 'Pasirinkta: $count';
  }

  @override
  String get untitledNote => '(be pavadinimo)';

  @override
  String errorLoadingNotes(String error) {
    return 'Klaida įkeliant užrašus: $error';
  }

  @override
  String get timeJustNow => 'dabar';

  @override
  String timeMinutesAgo(int count) {
    return 'prieš $count min';
  }

  @override
  String timeHoursAgo(int count) {
    return 'prieš $count val';
  }

  @override
  String timeDaysAgo(int count) {
    return 'prieš $count d';
  }

  @override
  String get notesLockedTitle => 'Užrašai apsaugoti slaptažodžiu';

  @override
  String get unlockButton => 'Atrakinti';

  @override
  String get saveTooltip => 'Išsaugoti';

  @override
  String get titleFieldLabel => 'Pavadinimas';

  @override
  String get bodyFieldHint => 'Rašykite čia... (palaikoma markdown)';

  @override
  String get checklistItemHint => 'Sąrašo elementas';

  @override
  String get addItemButton => 'Pridėti elementą';

  @override
  String completedItemsSection(int count) {
    return 'Atlikta ($count)';
  }

  @override
  String get duplicateChecklistItemMessage => 'Jau šiame sąraše, atlikta';

  @override
  String get restoreChecklistItemButton => 'Atkurti';

  @override
  String get noteSyncedMessage => 'Užrašas sinchronizuotas';

  @override
  String get noteSyncedFirstTimeMessage => 'Užrašas sinchronizuotas pirmą kartą';

  @override
  String notePartiallySyncedMessage(int accepted, int total) {
    return 'Sinchronizuota su $accepted iš $total relių';
  }

  @override
  String checklistProgress(int done, int total) {
    return 'Atlikta $done iš $total';
  }

  @override
  String get showCompletedItemsTooltip => 'Rodyti atliktus punktus';

  @override
  String get hideCompletedItemsTooltip => 'Slėpti atliktus punktus';

  @override
  String get allChecklistItemsCompletedHidden => 'Visi punktai atlikti ir paslėpti.';

  @override
  String get deleteCompletedItemsButton => 'Ištrinti atliktus punktus';

  @override
  String get deleteCompletedItemsConfirmTitle => 'Ištrinti atliktus punktus?';

  @override
  String deleteCompletedItemsConfirmBody(int count) {
    return 'Iš šio sąrašo bus pašalinta $count pažymėtų punktų. To atšaukti negalima.';
  }

  @override
  String get addImageButton => 'Pridėti vaizdą';

  @override
  String get noteColorButton => 'Užrašo spalva';

  @override
  String get noteColorDefault => 'Numatytoji';

  @override
  String get noteColorYellow => 'Geltona';

  @override
  String get noteColorRed => 'Raudona';

  @override
  String get noteColorPurple => 'Violetinė';

  @override
  String get noteColorBlue => 'Mėlyna';

  @override
  String get noteColorGreen => 'Žalia';

  @override
  String get noteColorOrange => 'Oranžinė';

  @override
  String get noteColorWhite => 'Balta';

  @override
  String get recordVoiceNoteTooltip => 'Įrašyti balso užrašą';

  @override
  String get recordVoiceNoteInstructions =>
      'Palieskite raudoną mygtuką, kad pradėtumėte įrašymą, arba ✕, kad atšauktumėte.';

  @override
  String get stopRecordingTooltip => 'Sustabdyti įrašymą';

  @override
  String get cancelRecordingTooltip => 'Atšaukti įrašymą';

  @override
  String get addVoiceTimestampButton => 'Pridėti laiko žymą';

  @override
  String get editVoiceTimestampButton => 'Redaguoti laiko žymą';

  @override
  String get voiceNoteUnsupportedOnPlatform => 'Balso įrašai šiame įrenginyje nepalaikomi';

  @override
  String get formatBoldTooltip => 'Pusjuodis';

  @override
  String get formatItalicTooltip => 'Kursyvas';

  @override
  String get formatStrikethroughTooltip => 'Perbrauktas';

  @override
  String get formatHeadingTooltip => 'Antraštė';

  @override
  String get formatListTooltip => 'Sąrašas su ženkleliais';

  @override
  String get formatLinkTooltip => 'Nuoroda';

  @override
  String get imageSizeSmall => 'Mažas';

  @override
  String get imageSizeMedium => 'Vidutinis';

  @override
  String get imageSizeFull => 'Visas plotis';

  @override
  String get removeImageButton => 'Pašalinti paveikslėlį';

  @override
  String get relayUrlHint => 'wss://relay.example.com';

  @override
  String get noRelaysMessage => 'Kol kas nesukonfigūruota nė viena relė.';

  @override
  String relaysCount(int count) {
    return '$count relės';
  }

  @override
  String get settingsTitle => 'Nustatymai';

  @override
  String get sectionSecurity => 'Sauga';

  @override
  String get loadingLabel => 'Įkeliama…';

  @override
  String get encryptionLoadError => 'Nepavyko įkelti šifravimo nustatymų';

  @override
  String get encryptionToggleTitle => 'Apsaugoti užrašus slaptažodžiu';

  @override
  String get encryptionToggleSubtitle =>
      'Užšifruoja saugomus užrašus (AES-256-GCM) raktu, gautu iš jūsų slaptažodžio. Slaptažodis niekada nesaugomas — jei jį pamiršite, užrašų atkurti nebus galima.';

  @override
  String get lockNotesNowTitle => 'Užrakinti užrašus dabar';

  @override
  String get lockNotesNowSubtitle => 'Norint peržiūrėti užrašus, vėl reikės slaptažodžio';

  @override
  String get setPasswordDialogTitle => 'Nustatyti slaptažodį';

  @override
  String get passwordTooShortError => 'Bent 8 simboliai';

  @override
  String get confirmPasswordLabel => 'Patvirtinkite slaptažodį';

  @override
  String get passwordsDoNotMatchError => 'Slaptažodžiai nesutampa';

  @override
  String enableEncryptionError(String error) {
    return 'Nepavyko įjungti šifravimo: $error';
  }

  @override
  String get enableButton => 'Įjungti';

  @override
  String get disablePasswordDialogTitle => 'Įveskite slaptažodį, kad išjungtumėte šifravimą';

  @override
  String get disableButton => 'Išjungti';

  @override
  String get sectionAppearance => 'Išvaizda';

  @override
  String get lightThemeToggleTitle => 'Šviesi tema';

  @override
  String get lightThemeToggleSubtitle => 'Naudoti šviesią spalvų schemą vietoj tamsios';

  @override
  String get noteLayoutToggleTitle => 'Perjungti tarp sąrašo ir tinklelio rodinio';

  @override
  String get manageRelaysTitle => 'Tvarkyti reles';

  @override
  String get autoSyncOnSaveTitle => 'Skelbti išsaugant';

  @override
  String get autoSyncOnSaveSubtitle =>
      'Jau sinchronizuojami užrašai iš naujo paskelbiami vos juos išsaugojus. Tik vietiniai – niekada.';

  @override
  String get noteBackgroundPhoto => 'Nuotrauka';

  @override
  String get noteBackgroundRemove => 'Pašalinti nuotrauką';

  @override
  String get republishAllNotesButton => 'Iš naujo paskelbti visus sinchronizuotus užrašus';

  @override
  String get republishAllNotesSubtitle =>
      'Papildo kiekvieną aukščiau esančią relę užrašais, jau pasidalytais kitur — naudinga iškart pridėjus naują, pvz., savo atsarginę relę';

  @override
  String republishAllNotesSuccess(int count) {
    return 'Iš naujo paskelbta $count užrašų';
  }

  @override
  String republishAllNotesError(String error) {
    return 'Nepavyko iš naujo paskelbti užrašų: $error';
  }

  @override
  String get forceFullResyncButton => 'Priverstinis pilnas persinchronizavimas';

  @override
  String get forceFullResyncSubtitle =>
      'Iš naujo tikrina relėse visą užrašo istoriją, o ne tik naujus — naudinga, jei sinchronizavimas atrodo įstrigęs ir praleidžia senesnius užrašus, pvz., pataisius nepasiekiamą relę';

  @override
  String get forceFullResyncSuccess => 'Užrašai atnaujinti iš relių';

  @override
  String forceFullResyncError(String error) {
    return 'Nepavyko persinchronizuoti užrašų: $error';
  }

  @override
  String get confirmButton => 'Patvirtinti';

  @override
  String get sectionLanguage => 'Kalba';

  @override
  String get langSystem => 'Sistemos numatytoji';

  @override
  String get sectionAccount => 'Paskyra';

  @override
  String get accountLocalOnlyMessage => '„Echoes“ naudojama vietoje — nesinchronizuojama su Nostr';

  @override
  String get accountSignInButton => 'Prisijungti';

  @override
  String accountSignedInAs(String npub) {
    return 'Prisijungę kaip $npub';
  }

  @override
  String get accountSignOutButton => 'Atsijungti';

  @override
  String get accountSignOutConfirmTitle => 'Atsijungti?';

  @override
  String get accountSignOutConfirmBody =>
      'Jūsų užrašai lieka šiame įrenginyje. Bet kada galite prisijungti iš naujo.';

  @override
  String get onboardingWelcomeTitle => 'Sveiki atvykę į „Echoes“';

  @override
  String get onboardingIntroLocalTitle => 'Jūsų užrašai visada jūsų įrenginyje';

  @override
  String get onboardingIntroLocalBody =>
      'Kiekvienas užrašas pirmiausia išsaugomas vietoje, todėl programėlė veikia visiškai neprisijungus. Niekas nepalieka jūsų įrenginio, nebent pasirinksite sinchronizuoti.';

  @override
  String get onboardingIntroSyncTitle => 'Neprivaloma sinchronizacija per Nostr';

  @override
  String get onboardingIntroSyncBody =>
      'Įjunkite sinchronizaciją, kad galėtumėte kurti atsargines užrašų kopijas ir juos skaityti kituose įrenginiuose, naudodami atvirą Nostr protokolą ir jūsų pasirinktas relees.';

  @override
  String get onboardingIntroEncryptionTitle => 'Visada šifruota';

  @override
  String get onboardingIntroEncryptionBody =>
      'Su Nostr sinchronizuoti užrašai yra šifruojami ištisai, todėl relių operatoriai — ir visi kiti — niekada negali perskaityti jų turinio.';

  @override
  String get onboardingIntroAmberTitle => 'Prisijunkite neatskleisdami savo rakto';

  @override
  String get onboardingIntroAmberBody =>
      'Prisijungimui naudokite Amber: jūsų privatus raktas lieka Amber programėlėje ir niekada nėra bendrinamas su „Echoes“.';

  @override
  String get onboardingIntroSecurityTitle => 'Sauga nuo pat pradžių';

  @override
  String get onboardingIntroSecurityBody =>
      'Jūsų privatusis raktas saugomas įrenginio šifruotoje raktų saugykloje — arba, naudojant „Amber“, apskritai nepasiekia „Echoes“. Nuotraukos ir balso užrašai šifruojami prieš jiems paliekant įrenginį. Užrašus galima užrakinti slaptažodžiu, ir niekas iš to niekada nepatenka į telefono atsargines kopijas.';

  @override
  String get onboardingNextButton => 'Toliau';

  @override
  String get onboardingBackButton => 'Atgal';

  @override
  String get onboardingSkipButton => 'Praleisti — naudoti „Echoes“ tik vietoje';

  @override
  String get onboardingRelayTitle => 'Pasirinkite sinchronizavimo reles';

  @override
  String get onboardingRelayBody =>
      'Relėse saugomi jūsų šifruoti užrašai sinchronizavimo metu. Pridėkite vieną ar daugiau — šios populiarios yra geras pradžios taškas:';

  @override
  String get onboardingFinishButton => 'Pradėti';

  @override
  String get syncNoteTooltip => 'Sinchronizuoti šį užrašą';

  @override
  String get unsyncNoteTooltip => 'Pašalinti iš relių';

  @override
  String get syncSelectedTooltip => 'Sinchronizuoti pasirinktus užrašus';

  @override
  String get exportSelectedTooltip => 'Eksportuoti pasirinktus užrašus';

  @override
  String get deleteSelectedTooltip => 'Ištrinti pasirinktus užrašus';

  @override
  String syncNoteError(String error) {
    return 'Nepavyko sinchronizuoti užrašo: $error';
  }

  @override
  String unsyncNoteError(String error) {
    return 'Nepavyko pašalinti užrašo iš relių: $error';
  }

  @override
  String deleteNoteRelayError(String error) {
    return 'Užrašas ištrintas lokaliai, bet nepavyko jo pašalinti iš relių: $error';
  }

  @override
  String deleteNotesRelayError(int count) {
    return '$count užrašai ištrinti lokaliai, bet nepavyko jų pašalinti iš relių';
  }

  @override
  String get deletingNotesTitle => 'Trinami užrašai…';

  @override
  String deletingNotesProgress(int completed, int total) {
    return 'Trinama $completed iš $total';
  }

  @override
  String get syncSelectedSuccess => 'Užrašai sinchronizuoti';

  @override
  String syncSelectedPartialError(int count) {
    return 'Nepavyko sinchronizuoti $count užrašų';
  }

  @override
  String get exportConfirmTitle => 'Eksportuoti užrašus';

  @override
  String get exportConfirmBody =>
      'Sukuriamas jūsų užrašų atsarginės kopijos failas. Jame taip pat yra pridėtų paveikslėlių ar balso užrašų iššifravimo raktai — bet kas, turintis failą, galėtų juos perskaityti, jei jis nešifruotas.';

  @override
  String get exportEncryptToggleLabel => 'Šifruoti šį failą';

  @override
  String get exportEncryptToggleSubtitle =>
      'Rekomenduojama — apsaugo atsarginę kopiją slaptažodžiu';

  @override
  String get exportPasswordDialogTitle => 'Įveskite slaptažodį';

  @override
  String get exportSetPasswordDialogTitle => 'Nustatykite šio eksporto slaptažodį';

  @override
  String get importPasswordDialogTitle => 'Įveskite eksporto slaptažodį';

  @override
  String get sectionData => 'Duomenys';

  @override
  String get exportNotesButton => 'Eksportuoti užrašus';

  @override
  String get exportNotesSubtitle =>
      'Išsaugokite visus savo užrašus faile, kurį vėliau galėsite vėl importuoti';

  @override
  String get importNotesButton => 'Importuoti užrašus';

  @override
  String get importNotesSubtitle => 'Atkurkite užrašus iš anksčiau eksportuoto failo';

  @override
  String get exportNotesSuccess => 'Užrašai eksportuoti';

  @override
  String exportNotesError(Object error) {
    return 'Nepavyko eksportuoti užrašų: $error';
  }

  @override
  String importNotesSuccess(int count) {
    return 'Importuota $count užrašų';
  }

  @override
  String importNotesError(Object error) {
    return 'Nepavyko importuoti užrašų: $error';
  }

  @override
  String get sectionAttachments => 'Priedai';

  @override
  String get attachmentProviderSubtitle =>
      'Kur įkeliami šifruoti vaizdai ir balso užrašai sinchronizuojant';

  @override
  String get attachmentProviderCustom => 'Pasirinktinis…';

  @override
  String get attachmentCustomUrlLabel => 'Serverio URL';

  @override
  String get attachmentProviderHint =>
      'Kai kurie vieši serveriai (pvz., Primal, nostr.build) atmeta šifruotus įkėlimus — jie tikrina tikrą vaizdo turinį, kuo šifruoti duomenys niekada nebūna. Rinkitės Blossom serverį, saugantį neskaidrius duomenis, arba nukreipkite „Pasirinktinis…“ į savo serverį.';

  @override
  String get sectionSupport => 'Parama';

  @override
  String get supportEchoesTitle => 'Paremkite Echoes';

  @override
  String lightningAddressCopied(String address) {
    return '⚡ $address nukopijuotas į iškarpinę';
  }

  @override
  String get cancelButton => 'Atšaukti';

  @override
  String get passwordLabel => 'Slaptažodis';

  @override
  String get invalidPrivateKeyError =>
      'Privatusis raktas negalioja. Įveskite galiojantį nsec arba hex raktą.';

  @override
  String get wrongPasswordError => 'Neteisingas slaptažodis';

  @override
  String genericErrorPrefix(String error) {
    return 'Klaida: $error';
  }

  @override
  String get shareNoteTooltip => 'Bendrinti';

  @override
  String get shareNoteTitle => 'Bendrinti užrašą';

  @override
  String get shareRecipientFieldLabel => 'Gavėjo npub arba viešasis raktas';

  @override
  String get shareAddRecipientButton => 'Pridėti';

  @override
  String get shareInvalidRecipientError => 'Tai netinkamas npub arba viešasis raktas';

  @override
  String get shareRecipientNotFoundError => 'Nerasta Nostr paskyra tuo vardu';

  @override
  String get shareConfirmTitle => 'Bendrinti šį užrašą?';

  @override
  String get shareConfirmButton => 'Bendrinti';

  @override
  String get shareAlreadyRecipientError => 'Jau bendrinama su šiuo asmeniu';

  @override
  String get shareCannotShareWithSelfError => 'Negalite bendrinti užrašo su savimi';

  @override
  String get shareRecipientsHeader => 'Bendrinama su';

  @override
  String get shareNoRecipientsMessage => 'Dar niekam nebendrinama.';

  @override
  String get stopSharingTooltip => 'Nustoti bendrinti su šiuo asmeniu';

  @override
  String get shareRevocationNote =>
      'Bet kas, su kuo bendrinate, gali skaityti šį užrašą savo įrenginyje. Pašalinus ką nors, būsimi atnaujinimai nutraukiami, bet jau gauto ištrinti negalima.';

  @override
  String shareError(String error) {
    return 'Nepavyko atnaujinti bendrinimo: $error';
  }

  @override
  String get sharedWithMeHeader => 'Bendrinama su jumis';

  @override
  String sharedByLabel(String npub) {
    return 'Bendrino $npub';
  }

  @override
  String get sharedNoteEditableNote =>
      'Galite redaguoti šį užrašą; jūsų pakeitimai sinchronizuojami atgal savininkui, kuris juos sujungia.';

  @override
  String get abandonSharedNoteButton => 'Palikti šį bendrinamą užrašą';

  @override
  String get abandonSharedNoteConfirmTitle => 'Palikti šį bendrinamą užrašą?';

  @override
  String get abandonSharedNoteConfirmBody =>
      'Jis bus pašalintas iš šio įrenginio ir nebegausite atnaujinimų. To atšaukti negalima — vėliau prisijungti iš naujo nebegalėsite.';

  @override
  String abandonSharedNoteError(String error) {
    return 'Nepavyko palikti: $error';
  }
}
