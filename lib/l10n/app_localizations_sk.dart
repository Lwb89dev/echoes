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
  String get bunkerLoginButton => 'Pripojiť vzdialený podpisovač (bunker)';

  @override
  String get bunkerFieldLabel => 'Vložte svoj pripojovací token bunker://';

  @override
  String get bunkerConnectButton => 'Pripojiť';

  @override
  String get bunkerAuthPrompt =>
      'Schváľte pripojenie vo svojom podpisovači a vráťte sa';

  @override
  String get relaysTitle => 'Relé';

  @override
  String get settingsTooltip => 'Nastavenia';

  @override
  String get searchTooltip => 'Hľadať';

  @override
  String get closeSearchTooltip => 'Zavrieť hľadanie';

  @override
  String get searchNotesHint => 'Hľadať v poznámkach';

  @override
  String get noSearchResultsMessage => 'Žiadne zhody.';

  @override
  String get emptyNotesMessage =>
      'Zatiaľ žiadne poznámky. Klepnutím na + vytvoríte novú.';

  @override
  String get notesTabLabel => 'Poznámky';

  @override
  String get diaryTabLabel => 'Denník';

  @override
  String get emptyDiaryMessage =>
      'Zatiaľ žiadne záznamy v denníku. Ťuknutím na + nejaký napíšte.';

  @override
  String get diaryToday => 'Dnes';

  @override
  String get diaryYesterday => 'Včera';

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
  String get bodyFieldHint => 'Píšte sem... (podporuje sa markdown)';

  @override
  String get checklistItemHint => 'Položka zoznamu';

  @override
  String get addItemButton => 'Pridať položku';

  @override
  String checklistProgress(int done, int total) {
    return 'Hotovo $done z $total';
  }

  @override
  String get showCompletedItemsTooltip => 'Zobraziť dokončené položky';

  @override
  String get hideCompletedItemsTooltip => 'Skryť dokončené položky';

  @override
  String get allChecklistItemsCompletedHidden =>
      'Všetky položky sú dokončené a skryté.';

  @override
  String get deleteCompletedItemsButton => 'Vymazať dokončené položky';

  @override
  String get deleteCompletedItemsConfirmTitle => 'Vymazať dokončené položky?';

  @override
  String deleteCompletedItemsConfirmBody(int count) {
    return 'Zo zoznamu sa odstráni $count odškrtnutých položiek. Nedá sa to vrátiť späť.';
  }

  @override
  String get addImageButton => 'Pridať obrázok';

  @override
  String get noteColorButton => 'Farba poznámky';

  @override
  String get noteColorDefault => 'Predvolená';

  @override
  String get noteColorYellow => 'Žltá';

  @override
  String get noteColorRed => 'Červená';

  @override
  String get noteColorPurple => 'Fialová';

  @override
  String get noteColorBlue => 'Modrá';

  @override
  String get noteColorGreen => 'Zelená';

  @override
  String get noteColorOrange => 'Oranžová';

  @override
  String get noteColorWhite => 'Biela';

  @override
  String get recordVoiceNoteTooltip => 'Nahrať hlasovú poznámku';

  @override
  String get recordVoiceNoteInstructions =>
      'Ťuknutím na červené tlačidlo spustíte nahrávanie, ✕ zruší.';

  @override
  String get stopRecordingTooltip => 'Zastaviť nahrávanie';

  @override
  String get cancelRecordingTooltip => 'Zrušiť nahrávanie';

  @override
  String get addVoiceTimestampButton => 'Pridať časovú pečiatku';

  @override
  String get editVoiceTimestampButton => 'Upraviť časovú pečiatku';

  @override
  String get voiceNoteUnsupportedOnPlatform =>
      'Hlasové poznámky nie sú na tomto zariadení podporované';

  @override
  String get formatBoldTooltip => 'Tučné';

  @override
  String get formatItalicTooltip => 'Kurzíva';

  @override
  String get formatHeadingTooltip => 'Nadpis';

  @override
  String get formatListTooltip => 'Zoznam s odrážkami';

  @override
  String get formatLinkTooltip => 'Odkaz';

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
  String get noteLayoutToggleTitle => 'Prepnúť medzi zoznamom a mriežkou';

  @override
  String get manageRelaysTitle => 'Spravovať relé';

  @override
  String get republishAllNotesButton =>
      'Znova publikovať všetky synchronizované poznámky';

  @override
  String get republishAllNotesSubtitle =>
      'Doplní každé relé vyššie o poznámky už zdieľané inde — užitočné hneď po pridaní nového, napr. vlastného záložného relé';

  @override
  String republishAllNotesSuccess(int count) {
    return 'Znova publikovaných $count poznámok';
  }

  @override
  String republishAllNotesError(String error) {
    return 'Poznámky sa nepodarilo znova publikovať: $error';
  }

  @override
  String get forceFullResyncButton => 'Vynútiť úplnú resynchronizáciu';

  @override
  String get forceFullResyncSubtitle =>
      'Znova skontroluje relay kvôli celej histórii poznámky namiesto len nového — užitočné, ak sa synchronizácia zdá zaseknutá a preskakuje staršie poznámky, napr. po oprave nedostupného relay';

  @override
  String get forceFullResyncSuccess => 'Poznámky obnovené z relay';

  @override
  String forceFullResyncError(String error) {
    return 'Poznámky sa nepodarilo resynchronizovať: $error';
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
      'Niektoré verejné servery (napr. Primal, nostr.build) šifrované nahrávania rovno odmietajú — overujú skutočný obsah obrázka, ktorým šifrované dáta nikdy nie sú. Uprednostnite Blossom server ukladajúci nepriehľadné dáta, alebo nastavte „Vlastný…“ na vlastný server.';

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

  @override
  String get shareNoteTooltip => 'Zdieľať';

  @override
  String get shareNoteTitle => 'Zdieľať poznámku';

  @override
  String get shareRecipientFieldLabel => 'npub alebo verejný kľúč príjemcu';

  @override
  String get shareAddRecipientButton => 'Pridať';

  @override
  String get shareInvalidRecipientError =>
      'To nie je platný npub ani verejný kľúč';

  @override
  String get shareRecipientNotFoundError =>
      'Pre toto meno sa nenašiel žiadny účet Nostr';

  @override
  String get shareConfirmTitle => 'Zdieľať túto poznámku?';

  @override
  String get shareConfirmButton => 'Zdieľať';

  @override
  String get shareAlreadyRecipientError => 'S touto osobou je už zdieľané';

  @override
  String get shareCannotShareWithSelfError =>
      'Poznámku nemôžete zdieľať sami so sebou';

  @override
  String get shareRecipientsHeader => 'Zdieľané s';

  @override
  String get shareNoRecipientsMessage => 'Zatiaľ s nikým nezdieľané.';

  @override
  String get stopSharingTooltip => 'Prestať zdieľať s touto osobou';

  @override
  String get shareRevocationNote =>
      'Ktokoľvek, s kým zdieľate, si môže túto poznámku prečítať na svojom zariadení. Odstránenie niekoho zastaví budúce aktualizácie, ale nemôže vymazať to, čo už dostal.';

  @override
  String shareError(String error) {
    return 'Nepodarilo sa aktualizovať zdieľanie: $error';
  }

  @override
  String get sharedWithMeHeader => 'Zdieľané s vami';

  @override
  String sharedByLabel(String npub) {
    return 'Zdieľal(a) $npub';
  }

  @override
  String get sharedNoteEditableNote =>
      'Túto poznámku môžete upravovať; vaše zmeny sa synchronizujú späť vlastníkovi, ktorý ich zlúči.';

  @override
  String get abandonSharedNoteButton => 'Opustiť túto zdieľanú poznámku';

  @override
  String get abandonSharedNoteConfirmTitle => 'Opustiť túto zdieľanú poznámku?';

  @override
  String get abandonSharedNoteConfirmBody =>
      'Bude odstránená z tohto zariadenia a prestanete dostávať aktualizácie. Toto sa nedá vrátiť — neskôr sa nebudete môcť znova pripojiť.';

  @override
  String abandonSharedNoteError(String error) {
    return 'Nepodarilo sa opustiť: $error';
  }
}
