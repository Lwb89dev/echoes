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
  String get bunkerLoginButton => 'Připojit vzdálený podpisovač (bunker)';

  @override
  String get bunkerFieldLabel => 'Vložte svůj připojovací token bunker://';

  @override
  String get bunkerConnectButton => 'Připojit';

  @override
  String get bunkerAuthPrompt =>
      'Schvalte připojení ve svém podpisovači a vraťte se';

  @override
  String get relaysTitle => 'Relé';

  @override
  String get settingsTooltip => 'Nastavení';

  @override
  String get searchTooltip => 'Hledat';

  @override
  String get closeSearchTooltip => 'Zavřít hledání';

  @override
  String get searchNotesHint => 'Hledat v poznámkách';

  @override
  String get noSearchResultsMessage => 'Žádné shody.';

  @override
  String get emptyNotesMessage =>
      'Zatím žádné poznámky. Klepnutím na + vytvoříte novou.';

  @override
  String get notesTabLabel => 'Poznámky';

  @override
  String get diaryTabLabel => 'Deník';

  @override
  String get emptyDiaryMessage =>
      'Zatím žádné záznamy v deníku. Klepnutím na + nějaký napište.';

  @override
  String get diaryToday => 'Dnes';

  @override
  String get diaryYesterday => 'Včera';

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
  String get bodyFieldHint => 'Pište sem... (podporuje markdown)';

  @override
  String get checklistItemHint => 'Položka seznamu';

  @override
  String get addItemButton => 'Přidat položku';

  @override
  String checklistProgress(int done, int total) {
    return 'Hotovo $done z $total';
  }

  @override
  String get showCompletedItemsTooltip => 'Zobrazit dokončené položky';

  @override
  String get hideCompletedItemsTooltip => 'Skrýt dokončené položky';

  @override
  String get allChecklistItemsCompletedHidden =>
      'Všechny položky jsou dokončené a skryté.';

  @override
  String get deleteCompletedItemsButton => 'Smazat dokončené položky';

  @override
  String get deleteCompletedItemsConfirmTitle => 'Smazat dokončené položky?';

  @override
  String deleteCompletedItemsConfirmBody(int count) {
    return 'Tím se z tohoto seznamu odstraní $count odškrtnutých položek. Nelze vrátit zpět.';
  }

  @override
  String get addImageButton => 'Přidat obrázek';

  @override
  String get noteColorButton => 'Barva poznámky';

  @override
  String get noteColorDefault => 'Výchozí';

  @override
  String get noteColorYellow => 'Žlutá';

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
  String get noteColorWhite => 'Bílá';

  @override
  String get recordVoiceNoteTooltip => 'Nahrát hlasovou poznámku';

  @override
  String get recordVoiceNoteInstructions =>
      'Klepnutím na červené tlačítko začnete nahrávat, ✕ zruší.';

  @override
  String get stopRecordingTooltip => 'Zastavit nahrávání';

  @override
  String get cancelRecordingTooltip => 'Zrušit nahrávání';

  @override
  String get addVoiceTimestampButton => 'Přidat časové razítko';

  @override
  String get editVoiceTimestampButton => 'Upravit časové razítko';

  @override
  String get voiceNoteUnsupportedOnPlatform =>
      'Hlasové poznámky nejsou na tomto zařízení podporovány';

  @override
  String get formatBoldTooltip => 'Tučné';

  @override
  String get formatItalicTooltip => 'Kurzíva';

  @override
  String get formatHeadingTooltip => 'Nadpis';

  @override
  String get formatListTooltip => 'Odrážkový seznam';

  @override
  String get formatLinkTooltip => 'Odkaz';

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
  String get noteLayoutToggleTitle => 'Přepnout mezi seznamem a mřížkou';

  @override
  String get manageRelaysTitle => 'Spravovat relé';

  @override
  String get republishAllNotesButton =>
      'Znovu publikovat všechny synchronizované poznámky';

  @override
  String get republishAllNotesSubtitle =>
      'Doplní každé relé výše o poznámky již sdílené jinde — užitečné hned po přidání nového, např. vlastního záložního relé';

  @override
  String republishAllNotesSuccess(int count) {
    return 'Znovu publikováno $count poznámek';
  }

  @override
  String republishAllNotesError(String error) {
    return 'Poznámky se nepodařilo znovu publikovat: $error';
  }

  @override
  String get forceFullResyncButton => 'Vynutit úplnou resynchronizaci';

  @override
  String get forceFullResyncSubtitle =>
      'Znovu zkontroluje relaye kvůli celé historii poznámky místo jen nového — užitečné, pokud se synchronizace zdá zaseknutá a přeskakuje starší poznámky, např. po opravě nedostupného relaye';

  @override
  String get forceFullResyncSuccess => 'Poznámky obnoveny z relayů';

  @override
  String forceFullResyncError(String error) {
    return 'Resynchronizaci poznámek se nezdařilo provést: $error';
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
      'Některé veřejné servery (např. Primal, nostr.build) šifrovaná nahrání rovnou odmítají — ověřují skutečný obsah obrázku, kterým šifrovaná data nikdy nejsou. Zvolte Blossom server ukládající neprůhledná data, nebo nastavte „Vlastní…“ na vlastní server.';

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

  @override
  String get shareNoteTooltip => 'Sdílet';

  @override
  String get shareNoteTitle => 'Sdílet poznámku';

  @override
  String get shareRecipientFieldLabel => 'npub nebo veřejný klíč příjemce';

  @override
  String get shareAddRecipientButton => 'Přidat';

  @override
  String get shareInvalidRecipientError =>
      'To není platný npub ani veřejný klíč';

  @override
  String get shareRecipientNotFoundError =>
      'Pro toto jméno nebyl nalezen žádný účet Nostr';

  @override
  String get shareConfirmTitle => 'Sdílet tuto poznámku?';

  @override
  String get shareConfirmButton => 'Sdílet';

  @override
  String get shareAlreadyRecipientError => 'S touto osobou už je sdíleno';

  @override
  String get shareCannotShareWithSelfError =>
      'Nemůžete sdílet poznámku sami se sebou';

  @override
  String get shareRecipientsHeader => 'Sdíleno s';

  @override
  String get shareNoRecipientsMessage => 'Zatím s nikým nesdíleno.';

  @override
  String get stopSharingTooltip => 'Přestat sdílet s touto osobou';

  @override
  String get shareRevocationNote =>
      'Kdokoli, s kým poznámku sdílíte, si ji může přečíst na svém zařízení. Odebráním někoho zastavíte budoucí aktualizace, ale nelze smazat, co už obdržel.';

  @override
  String shareError(String error) {
    return 'Nepodařilo se aktualizovat sdílení: $error';
  }

  @override
  String get sharedWithMeHeader => 'Sdíleno s vámi';

  @override
  String sharedByLabel(String npub) {
    return 'Sdílel(a) $npub';
  }

  @override
  String get sharedNoteEditableNote =>
      'Tuto poznámku můžete upravovat; vaše změny se synchronizují zpět vlastníkovi, který je sloučí.';

  @override
  String get abandonSharedNoteButton => 'Opustit tuto sdílenou poznámku';

  @override
  String get abandonSharedNoteConfirmTitle => 'Opustit tuto sdílenou poznámku?';

  @override
  String get abandonSharedNoteConfirmBody =>
      'Bude odebrána z tohoto zařízení a přestanete dostávat aktualizace. Tuto akci nelze vrátit — nebudete se moci znovu připojit.';

  @override
  String abandonSharedNoteError(String error) {
    return 'Nepodařilo se opustit: $error';
  }
}
