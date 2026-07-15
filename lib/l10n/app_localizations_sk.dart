// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class AppLocalizationsSk extends AppLocalizations {
  AppLocalizationsSk([String locale = 'sk']) : super(locale);

  @override
  String get loginSubtitle => 'Prihláste sa svojím účtom Nostr';

  @override
  String get loginWithAmberButton => 'Prihlásiť sa cez Amber';

  @override
  String get importAccountButton => 'Importovať účet Nostr';

  @override
  String get importAccountFieldLabel => 'Súkromný kľúč (nsec) vášho účtu Nostr';

  @override
  String get importButton => 'Importovať';

  @override
  String get relaysTitle => 'Relé';

  @override
  String get settingsTooltip => 'Nastavenia';

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
      'Zatiaľ žiadne poznámky. Klepnutím na + vytvoríte novú.';

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
  String get newPlainNoteOption => 'Poznámka';

  @override
  String get newChecklistOption => 'Kontrolný zoznam';

  @override
  String get newVoiceNoteOption => 'Hlasová poznámka';

  @override
  String get deleteNoteButton => 'Odstrániť poznámku';

  @override
  String get deleteNoteConfirmTitle => 'Odstrániť túto poznámku?';

  @override
  String get deleteNoteConfirmBody =>
      'Túto akciu nemožno vrátiť späť. Ak bola táto poznámka synchronizovaná, bude odstránená aj z vašich relé.';

  @override
  String deleteNotesConfirmTitle(int count) {
    return 'Odstrániť $count poznámok?';
  }

  @override
  String get deleteNotesConfirmBody =>
      'Túto akciu nemožno vrátiť späť. Ak bola ktorákoľvek z týchto poznámok synchronizovaná, bude odstránená aj z vašich relé.';

  @override
  String selectionCount(int count) {
    return 'Vybraté: $count';
  }

  @override
  String get untitledNote => '(bez názvu)';

  @override
  String errorLoadingNotes(String error) {
    return 'Chyba pri načítaní poznámok: $error';
  }

  @override
  String get timeJustNow => 'teraz';

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
    return 'pred $count dňami';
  }

  @override
  String get notesLockedTitle => 'Poznámky sú chránené heslom';

  @override
  String get unlockButton => 'Odomknúť';

  @override
  String get saveTooltip => 'Uložiť';

  @override
  String get titleFieldLabel => 'Názov';

  @override
  String get checklistLabel => 'Kontrolný zoznam';

  @override
  String get bodyFieldHint => 'Píšte sem... (podporuje sa markdown)';

  @override
  String get checklistItemHint => 'Položka zoznamu';

  @override
  String get addItemButton => 'Pridať položku';

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
  String get addImageButton => 'Pridať obrázok';

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
  String get recordVoiceNoteTooltip => 'Nahrať hlasovú poznámku';

  @override
  String get recordVoiceNoteInstructions =>
      'Tap the red button to start recording, or ✕ to cancel.';

  @override
  String get stopRecordingTooltip => 'Zastaviť nahrávanie';

  @override
  String get cancelRecordingTooltip => 'Zrušiť nahrávanie';

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
  String get imageSizeSmall => 'Malé';

  @override
  String get imageSizeMedium => 'Stredné';

  @override
  String get imageSizeFull => 'Celá šírka';

  @override
  String get removeImageButton => 'Odstrániť obrázok';

  @override
  String get relayUrlHint => 'wss://relay.example.com';

  @override
  String get noRelaysMessage => 'Zatiaľ nie je nakonfigurované žiadne relé.';

  @override
  String relaysCount(int count) {
    return '$count relé';
  }

  @override
  String get settingsTitle => 'Nastavenia';

  @override
  String get sectionSecurity => 'Zabezpečenie';

  @override
  String get loadingLabel => 'Načítava sa…';

  @override
  String get encryptionLoadError =>
      'Nastavenia šifrovania sa nepodarilo načítať';

  @override
  String get encryptionToggleTitle => 'Chrániť poznámky heslom';

  @override
  String get encryptionToggleSubtitle =>
      'Šifruje uložené poznámky (AES-256-GCM) kľúčom odvodeným z vášho hesla. Heslo sa nikdy neukladá — ak ho zabudnete, poznámky nebude možné obnoviť.';

  @override
  String get lockNotesNowTitle => 'Uzamknúť poznámky teraz';

  @override
  String get lockNotesNowSubtitle =>
      'Na zobrazenie poznámok bude znova potrebné heslo';

  @override
  String get setPasswordDialogTitle => 'Nastaviť heslo';

  @override
  String get passwordTooShortError => 'Aspoň 8 znakov';

  @override
  String get confirmPasswordLabel => 'Potvrďte heslo';

  @override
  String get passwordsDoNotMatchError => 'Heslá sa nezhodujú';

  @override
  String enableEncryptionError(String error) {
    return 'Šifrovanie sa nepodarilo aktivovať: $error';
  }

  @override
  String get enableButton => 'Aktivovať';

  @override
  String get disablePasswordDialogTitle =>
      'Zadajte heslo na deaktiváciu šifrovania';

  @override
  String get disableButton => 'Deaktivovať';

  @override
  String get sectionAppearance => 'Vzhľad';

  @override
  String get lightThemeToggleTitle => 'Svetlý motív';

  @override
  String get lightThemeToggleSubtitle =>
      'Použiť svetlú farebnú schému namiesto tmavej';

  @override
  String get noteLayoutToggleTitle => 'Rozloženie zoznamu poznámok';

  @override
  String get manageRelaysTitle => 'Spravovať relé';

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
  String get confirmButton => 'Potvrdiť';

  @override
  String get sectionLanguage => 'Jazyk';

  @override
  String get langSystem => 'Predvolené podľa systému';

  @override
  String get sectionAccount => 'Účet';

  @override
  String get accountLocalOnlyMessage =>
      'Echoes sa používa lokálne — bez synchronizácie s Nostr';

  @override
  String get accountSignInButton => 'Prihlásiť sa';

  @override
  String accountSignedInAs(String npub) {
    return 'Prihlásený ako $npub';
  }

  @override
  String get accountSignOutButton => 'Odhlásiť sa';

  @override
  String get accountSignOutConfirmTitle => 'Odhlásiť sa?';

  @override
  String get accountSignOutConfirmBody =>
      'Vaše poznámky zostanú v tomto zariadení. Kedykoľvek sa môžete prihlásiť znova.';

  @override
  String get onboardingWelcomeTitle => 'Vitajte v Echoes';

  @override
  String get onboardingIntroLocalTitle =>
      'Vaše poznámky vždy vo vašom zariadení';

  @override
  String get onboardingIntroLocalBody =>
      'Každá poznámka sa najprv uloží lokálne, takže aplikácia funguje úplne offline. Nič neopustí vaše zariadenie, pokiaľ sa nerozhodnete pre synchronizáciu.';

  @override
  String get onboardingIntroSyncTitle => 'Voliteľná synchronizácia cez Nostr';

  @override
  String get onboardingIntroSyncBody =>
      'Zapnite synchronizáciu a zálohujte si poznámky a čítajte ich na ďalších zariadeniach pomocou otvoreného protokolu Nostr a relé podľa vášho výberu.';

  @override
  String get onboardingIntroEncryptionTitle => 'Vždy šifrované';

  @override
  String get onboardingIntroEncryptionBody =>
      'Poznámky synchronizované s Nostr sú šifrované end-to-end, takže prevádzkovatelia relé — ani nikto iný — nikdy nemôžu prečítať ich obsah.';

  @override
  String get onboardingIntroAmberTitle => 'Prihláste sa bez odhalenia kľúča';

  @override
  String get onboardingIntroAmberBody =>
      'Na prihlásenie použite Amber: váš súkromný kľúč zostáva v Amberi a nikdy nie je zdieľaný s Echoes.';

  @override
  String get onboardingIntroSecurityTitle => 'Bezpečnosť od základu';

  @override
  String get onboardingIntroSecurityBody =>
      'Váš súkromný kľúč sa nachádza v šifrovanom úložisku kľúčov zariadenia — alebo sa s Amberom vôbec nedostane do Echoes. Fotografie a hlasové poznámky sú šifrované skôr, než opustia vaše zariadenie. Poznámky je možné uzamknúť heslom a nič z toho sa nikdy nezahŕňa do záloh telefónu.';

  @override
  String get onboardingNextButton => 'Ďalej';

  @override
  String get onboardingBackButton => 'Späť';

  @override
  String get onboardingSkipButton => 'Preskočiť — používať Echoes iba lokálne';

  @override
  String get onboardingRelayTitle => 'Vyberte relé na synchronizáciu';

  @override
  String get onboardingRelayBody =>
      'Relé sú miesta, kam sa ukladajú vaše šifrované poznámky pri synchronizácii. Pridajte jedno alebo viac — tieto obľúbené sú dobrým začiatkom:';

  @override
  String get onboardingFinishButton => 'Začať';

  @override
  String get syncNoteTooltip => 'Synchronizovať túto poznámku';

  @override
  String get unsyncNoteTooltip => 'Odstrániť z relé';

  @override
  String get syncSelectedTooltip => 'Synchronizovať vybrané poznámky';

  @override
  String get exportSelectedTooltip => 'Exportovať vybrané poznámky';

  @override
  String get deleteSelectedTooltip => 'Odstrániť vybrané poznámky';

  @override
  String syncNoteError(String error) {
    return 'Poznámku sa nepodarilo synchronizovať: $error';
  }

  @override
  String unsyncNoteError(String error) {
    return 'Poznámku sa nepodarilo odstrániť z relé: $error';
  }

  @override
  String deleteNoteRelayError(String error) {
    return 'Poznámka bola odstránená lokálne, ale nepodarilo sa ju odstrániť z relé: $error';
  }

  @override
  String deleteNotesRelayError(int count) {
    return '$count poznámok odstránených lokálne, ale nepodarilo sa ich odstrániť z relé';
  }

  @override
  String get deletingNotesTitle => 'Odstraňovanie poznámok…';

  @override
  String deletingNotesProgress(int completed, int total) {
    return 'Odstraňovanie $completed z $total';
  }

  @override
  String get syncSelectedSuccess => 'Poznámky synchronizované';

  @override
  String syncSelectedPartialError(int count) {
    return 'Nepodarilo sa synchronizovať $count poznámok';
  }

  @override
  String get exportConfirmTitle => 'Exportovať poznámky';

  @override
  String get exportConfirmBody =>
      'Vytvorí záložný súbor vašich poznámok. Obsahuje tiež dešifrovacie kľúče pre pripojené obrázky alebo hlasové poznámky — ktokoľvek so súborom by ich mohol čítať, ak nie je zašifrovaný.';

  @override
  String get exportEncryptToggleLabel => 'Zašifrovať tento súbor';

  @override
  String get exportEncryptToggleSubtitle => 'Odporúčané — chráni zálohu heslom';

  @override
  String get exportPasswordDialogTitle => 'Zadajte svoje heslo';

  @override
  String get exportSetPasswordDialogTitle => 'Nastavte heslo pre tento export';

  @override
  String get importPasswordDialogTitle => 'Zadajte heslo exportu';

  @override
  String get sectionData => 'Údaje';

  @override
  String get exportNotesButton => 'Exportovať poznámky';

  @override
  String get exportNotesSubtitle =>
      'Uložte všetky svoje poznámky do súboru, ktorý môžete neskôr znova importovať';

  @override
  String get importNotesButton => 'Importovať poznámky';

  @override
  String get importNotesSubtitle =>
      'Obnovte poznámky zo skôr exportovaného súboru';

  @override
  String get exportNotesSuccess => 'Poznámky exportované';

  @override
  String exportNotesError(Object error) {
    return 'Poznámky sa nepodarilo exportovať: $error';
  }

  @override
  String importNotesSuccess(int count) {
    return 'Importovaných $count poznámok';
  }

  @override
  String importNotesError(Object error) {
    return 'Poznámky sa nepodarilo importovať: $error';
  }

  @override
  String get sectionAttachments => 'Prílohy';

  @override
  String get attachmentProviderSubtitle =>
      'Kam sa nahrávajú šifrované obrázky a hlasové poznámky pri synchronizácii';

  @override
  String get attachmentProviderCustom => 'Vlastné…';

  @override
  String get attachmentCustomUrlLabel => 'URL servera';

  @override
  String get attachmentProviderHint =>
      'Some public hosts (e.g. Primal, nostr.build) reject encrypted uploads outright — they validate real image content, which ciphertext never is. Prefer a Blossom host that stores opaque blobs, or point Custom… at a self-hosted one.';

  @override
  String get sectionSupport => 'Podpora';

  @override
  String get supportEchoesTitle => 'Podporte Echoes';

  @override
  String lightningAddressCopied(String address) {
    return '⚡ $address skopírovaná do schránky';
  }

  @override
  String get cancelButton => 'Zrušiť';

  @override
  String get passwordLabel => 'Heslo';

  @override
  String get invalidPrivateKeyError =>
      'Súkromný kľúč nie je platný. Zadajte platný nsec alebo hex kľúč.';

  @override
  String get wrongPasswordError => 'Nesprávne heslo';

  @override
  String genericErrorPrefix(String error) {
    return 'Chyba: $error';
  }
}
