// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get loginSubtitle => 'Přihlaste se svým účtem Nostr';

  @override
  String get loginWithAmberButton => 'Přihlásit se přes Amber';

  @override
  String get importAccountButton => 'Importovat účet Nostr';

  @override
  String get importAccountFieldLabel =>
      'Soukromý klíč (nsec) vašeho účtu Nostr';

  @override
  String get importButton => 'Importovat';

  @override
  String get relaysTitle => 'Relé';

  @override
  String get settingsTooltip => 'Nastavení';

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
      'Zatím žádné poznámky. Klepnutím na + vytvoříte novou.';

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
  String get newChecklistOption => 'Kontrolní seznam';

  @override
  String get newVoiceNoteOption => 'Hlasová poznámka';

  @override
  String get deleteNoteButton => 'Smazat poznámku';

  @override
  String get deleteNoteConfirmTitle => 'Smazat tuto poznámku?';

  @override
  String get deleteNoteConfirmBody =>
      'Tuto akci nelze vrátit zpět. Pokud byla poznámka synchronizována, bude odstraněna i z vašich relé.';

  @override
  String deleteNotesConfirmTitle(int count) {
    return 'Smazat $count poznámek?';
  }

  @override
  String get deleteNotesConfirmBody =>
      'Tuto akci nelze vrátit zpět. Pokud byla některá z těchto poznámek synchronizována, bude odstraněna i z vašich relé.';

  @override
  String selectionCount(int count) {
    return 'Vybráno: $count';
  }

  @override
  String get untitledNote => '(bez názvu)';

  @override
  String errorLoadingNotes(String error) {
    return 'Chyba při načítání poznámek: $error';
  }

  @override
  String get timeJustNow => 'teď';

  @override
  String timeMinutesAgo(int count) {
    return 'před $count min';
  }

  @override
  String timeHoursAgo(int count) {
    return 'před $count h';
  }

  @override
  String timeDaysAgo(int count) {
    return 'před $count dny';
  }

  @override
  String get notesLockedTitle => 'Poznámky jsou chráněny heslem';

  @override
  String get unlockButton => 'Odemknout';

  @override
  String get saveTooltip => 'Uložit';

  @override
  String get titleFieldLabel => 'Název';

  @override
  String get checklistLabel => 'Kontrolní seznam';

  @override
  String get bodyFieldHint => 'Pište sem... (podporuje markdown)';

  @override
  String get checklistItemHint => 'Položka seznamu';

  @override
  String get addItemButton => 'Přidat položku';

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
  String get addImageButton => 'Přidat obrázek';

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
  String get recordVoiceNoteTooltip => 'Nahrát hlasovou poznámku';

  @override
  String get recordVoiceNoteInstructions =>
      'Tap the red button to start recording, or ✕ to cancel.';

  @override
  String get stopRecordingTooltip => 'Zastavit nahrávání';

  @override
  String get cancelRecordingTooltip => 'Zrušit nahrávání';

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
  String get imageSizeMedium => 'Střední';

  @override
  String get imageSizeFull => 'Celá šířka';

  @override
  String get removeImageButton => 'Odebrat obrázek';

  @override
  String get relayUrlHint => 'wss://relay.example.com';

  @override
  String get noRelaysMessage => 'Zatím není nakonfigurováno žádné relé.';

  @override
  String relaysCount(int count) {
    return '$count relé';
  }

  @override
  String get settingsTitle => 'Nastavení';

  @override
  String get sectionSecurity => 'Zabezpečení';

  @override
  String get loadingLabel => 'Načítání…';

  @override
  String get encryptionLoadError => 'Nastavení šifrování se nepodařilo načíst';

  @override
  String get encryptionToggleTitle => 'Chránit poznámky heslem';

  @override
  String get encryptionToggleSubtitle =>
      'Šifruje uložené poznámky (AES-256-GCM) klíčem odvozeným z vašeho hesla. Heslo se nikdy neukládá — pokud jej zapomenete, poznámky nelze obnovit.';

  @override
  String get lockNotesNowTitle => 'Zamknout poznámky nyní';

  @override
  String get lockNotesNowSubtitle =>
      'Pro zobrazení poznámek bude znovu potřeba heslo';

  @override
  String get setPasswordDialogTitle => 'Nastavit heslo';

  @override
  String get passwordTooShortError => 'Alespoň 8 znaků';

  @override
  String get confirmPasswordLabel => 'Potvrďte heslo';

  @override
  String get passwordsDoNotMatchError => 'Hesla se neshodují';

  @override
  String enableEncryptionError(String error) {
    return 'Šifrování se nepodařilo aktivovat: $error';
  }

  @override
  String get enableButton => 'Aktivovat';

  @override
  String get disablePasswordDialogTitle =>
      'Zadejte heslo pro deaktivaci šifrování';

  @override
  String get disableButton => 'Deaktivovat';

  @override
  String get sectionAppearance => 'Vzhled';

  @override
  String get lightThemeToggleTitle => 'Světlý motiv';

  @override
  String get lightThemeToggleSubtitle =>
      'Použít světlé barevné schéma místo tmavého';

  @override
  String get noteLayoutToggleTitle => 'Rozvržení seznamu poznámek';

  @override
  String get manageRelaysTitle => 'Spravovat relé';

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
  String get confirmButton => 'Potvrdit';

  @override
  String get sectionLanguage => 'Jazyk';

  @override
  String get langSystem => 'Výchozí podle systému';

  @override
  String get sectionAccount => 'Účet';

  @override
  String get accountLocalOnlyMessage =>
      'Echoes se používá pouze lokálně — bez synchronizace s Nostr';

  @override
  String get accountSignInButton => 'Přihlásit se';

  @override
  String accountSignedInAs(String npub) {
    return 'Přihlášen jako $npub';
  }

  @override
  String get accountSignOutButton => 'Odhlásit se';

  @override
  String get accountSignOutConfirmTitle => 'Odhlásit se?';

  @override
  String get accountSignOutConfirmBody =>
      'Vaše poznámky zůstanou v tomto zařízení. Kdykoli se můžete přihlásit znovu.';

  @override
  String get onboardingWelcomeTitle => 'Vítejte v Echoes';

  @override
  String get onboardingIntroLocalTitle =>
      'Vaše poznámky vždy ve vašem zařízení';

  @override
  String get onboardingIntroLocalBody =>
      'Každá poznámka se nejprve uloží lokálně, takže aplikace funguje zcela offline. Nic neopustí vaše zařízení, pokud se nerozhodnete pro synchronizaci.';

  @override
  String get onboardingIntroSyncTitle => 'Volitelná synchronizace přes Nostr';

  @override
  String get onboardingIntroSyncBody =>
      'Zapněte synchronizaci a zálohujte si poznámky a čtěte je na dalších zařízeních pomocí otevřeného protokolu Nostr a relé podle vašeho výběru.';

  @override
  String get onboardingIntroEncryptionTitle => 'Vždy šifrováno';

  @override
  String get onboardingIntroEncryptionBody =>
      'Poznámky synchronizované s Nostr jsou šifrovány end-to-end, takže provozovatelé relé — ani nikdo jiný — nemohou nikdy přečíst jejich obsah.';

  @override
  String get onboardingIntroAmberTitle => 'Přihlaste se bez odhalení klíče';

  @override
  String get onboardingIntroAmberBody =>
      'Přihlaste se pomocí Amber: váš soukromý klíč zůstává v Amberu a nikdy není sdílen s Echoes.';

  @override
  String get onboardingIntroSecurityTitle => 'Bezpečnost od návrhu';

  @override
  String get onboardingIntroSecurityBody =>
      'Váš soukromý klíč je uložen v šifrovaném úložišti klíčů zařízení — nebo se s Amberem k Echoes vůbec nedostane. Fotky a hlasové poznámky jsou šifrovány dříve, než opustí zařízení. Poznámky lze uzamknout heslem a nic z toho není nikdy součástí zálohy telefonu.';

  @override
  String get onboardingNextButton => 'Další';

  @override
  String get onboardingBackButton => 'Zpět';

  @override
  String get onboardingSkipButton =>
      'Přeskočit — používat Echoes pouze lokálně';

  @override
  String get onboardingRelayTitle => 'Vyberte relé pro synchronizaci';

  @override
  String get onboardingRelayBody =>
      'Relé jsou místa, kam se ukládají vaše šifrované poznámky při synchronizaci. Přidejte jedno nebo více — tato oblíbená jsou dobrým začátkem:';

  @override
  String get onboardingFinishButton => 'Začít';

  @override
  String get syncNoteTooltip => 'Synchronizovat tuto poznámku';

  @override
  String get unsyncNoteTooltip => 'Odebrat z relé';

  @override
  String get syncSelectedTooltip => 'Synchronizovat vybrané poznámky';

  @override
  String get exportSelectedTooltip => 'Exportovat vybrané poznámky';

  @override
  String get deleteSelectedTooltip => 'Smazat vybrané poznámky';

  @override
  String syncNoteError(String error) {
    return 'Poznámku se nepodařilo synchronizovat: $error';
  }

  @override
  String unsyncNoteError(String error) {
    return 'Poznámku se nepodařilo odebrat z relé: $error';
  }

  @override
  String deleteNoteRelayError(String error) {
    return 'Poznámka byla smazána lokálně, ale nepodařilo se ji odebrat z relé: $error';
  }

  @override
  String deleteNotesRelayError(int count) {
    return '$count poznámek smazáno lokálně, ale nepodařilo se je odebrat z relé';
  }

  @override
  String get deletingNotesTitle => 'Mazání poznámek…';

  @override
  String deletingNotesProgress(int completed, int total) {
    return 'Mazání $completed z $total';
  }

  @override
  String get syncSelectedSuccess => 'Poznámky synchronizovány';

  @override
  String syncSelectedPartialError(int count) {
    return 'Nepodařilo se synchronizovat $count poznámek';
  }

  @override
  String get exportConfirmTitle => 'Exportovat poznámky';

  @override
  String get exportConfirmBody =>
      'Vytvoří záložní soubor vašich poznámek. Obsahuje také dešifrovací klíče pro připojené obrázky nebo hlasové poznámky — kdokoli se souborem by je mohl číst, pokud není šifrovaný.';

  @override
  String get exportEncryptToggleLabel => 'Šifrovat tento soubor';

  @override
  String get exportEncryptToggleSubtitle => 'Doporučeno — chrání zálohu heslem';

  @override
  String get exportPasswordDialogTitle => 'Zadejte své heslo';

  @override
  String get exportSetPasswordDialogTitle => 'Nastavte heslo pro tento export';

  @override
  String get importPasswordDialogTitle => 'Zadejte heslo exportu';

  @override
  String get sectionData => 'Data';

  @override
  String get exportNotesButton => 'Exportovat poznámky';

  @override
  String get exportNotesSubtitle =>
      'Uložte všechny poznámky do souboru, který můžete později znovu importovat';

  @override
  String get importNotesButton => 'Importovat poznámky';

  @override
  String get importNotesSubtitle =>
      'Obnovte poznámky ze souboru exportovaného dříve';

  @override
  String get exportNotesSuccess => 'Poznámky byly exportovány';

  @override
  String exportNotesError(Object error) {
    return 'Poznámky se nepodařilo exportovat: $error';
  }

  @override
  String importNotesSuccess(int count) {
    return 'Importováno $count poznámek';
  }

  @override
  String importNotesError(Object error) {
    return 'Poznámky se nepodařilo importovat: $error';
  }

  @override
  String get sectionAttachments => 'Přílohy';

  @override
  String get attachmentProviderSubtitle =>
      'Kam se nahrávají šifrované obrázky a hlasové poznámky při synchronizaci';

  @override
  String get attachmentProviderCustom => 'Vlastní…';

  @override
  String get attachmentCustomUrlLabel => 'URL serveru';

  @override
  String get attachmentProviderHint =>
      'Some public hosts (e.g. Primal, nostr.build) reject encrypted uploads outright — they validate real image content, which ciphertext never is. Prefer a Blossom host that stores opaque blobs, or point Custom… at a self-hosted one.';

  @override
  String get sectionSupport => 'Podpora';

  @override
  String get supportEchoesTitle => 'Podpořte Echoes';

  @override
  String lightningAddressCopied(String address) {
    return '⚡ $address zkopírováno do schránky';
  }

  @override
  String get cancelButton => 'Zrušit';

  @override
  String get passwordLabel => 'Heslo';

  @override
  String get invalidPrivateKeyError =>
      'Soukromý klíč není platný. Zadejte platný nsec nebo hex klíč.';

  @override
  String get wrongPasswordError => 'Nesprávné heslo';

  @override
  String genericErrorPrefix(String error) {
    return 'Chyba: $error';
  }
}
