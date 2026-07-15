// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get loginSubtitle => 'Jelentkezz be Nostr-fiókoddal';

  @override
  String get loginWithAmberButton => 'Bejelentkezés Amberrel';

  @override
  String get importAccountButton => 'Nostr-fiók importálása';

  @override
  String get importAccountFieldLabel => 'Nostr-fiókod privát kulcsa (nsec)';

  @override
  String get importButton => 'Importálás';

  @override
  String get relaysTitle => 'Relék';

  @override
  String get settingsTooltip => 'Beállítások';

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
      'Még nincsenek jegyzetek. Koppints a + gombra újhoz.';

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
  String get newPlainNoteOption => 'Jegyzet';

  @override
  String get newChecklistOption => 'Ellenőrzőlista';

  @override
  String get newVoiceNoteOption => 'Hangjegyzet';

  @override
  String get deleteNoteButton => 'Jegyzet törlése';

  @override
  String get deleteNoteConfirmTitle => 'Törli ezt a jegyzetet?';

  @override
  String get deleteNoteConfirmBody =>
      'Ez nem vonható vissza. Ha ez a jegyzet szinkronizálva volt, a relékről is eltávolításra kerül.';

  @override
  String deleteNotesConfirmTitle(int count) {
    return 'Törli ezt a $count jegyzetet?';
  }

  @override
  String get deleteNotesConfirmBody =>
      'Ez nem vonható vissza. Ha ezek közül bármelyik jegyzet szinkronizálva volt, a relékről is eltávolításra kerül.';

  @override
  String selectionCount(int count) {
    return '$count kiválasztva';
  }

  @override
  String get untitledNote => '(névtelen)';

  @override
  String errorLoadingNotes(String error) {
    return 'Hiba a jegyzetek betöltésekor: $error';
  }

  @override
  String get timeJustNow => 'most';

  @override
  String timeMinutesAgo(int count) {
    return '$count perce';
  }

  @override
  String timeHoursAgo(int count) {
    return '$count órája';
  }

  @override
  String timeDaysAgo(int count) {
    return '$count napja';
  }

  @override
  String get notesLockedTitle => 'A jegyzetek jelszóval védettek';

  @override
  String get unlockButton => 'Feloldás';

  @override
  String get saveTooltip => 'Mentés';

  @override
  String get titleFieldLabel => 'Cím';

  @override
  String get checklistLabel => 'Ellenőrzőlista';

  @override
  String get bodyFieldHint => 'Írj ide... (markdown támogatott)';

  @override
  String get checklistItemHint => 'Listaelem';

  @override
  String get addItemButton => 'Elem hozzáadása';

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
  String get addImageButton => 'Kép hozzáadása';

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
  String get recordVoiceNoteTooltip => 'Hangjegyzet rögzítése';

  @override
  String get recordVoiceNoteInstructions =>
      'Tap the red button to start recording, or ✕ to cancel.';

  @override
  String get stopRecordingTooltip => 'Felvétel leállítása';

  @override
  String get cancelRecordingTooltip => 'Felvétel megszakítása';

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
  String get imageSizeSmall => 'Kicsi';

  @override
  String get imageSizeMedium => 'Közepes';

  @override
  String get imageSizeFull => 'Teljes szélesség';

  @override
  String get removeImageButton => 'Kép eltávolítása';

  @override
  String get relayUrlHint => 'wss://relay.example.com';

  @override
  String get noRelaysMessage => 'Még nincs beállítva relé.';

  @override
  String relaysCount(int count) {
    return '$count relé';
  }

  @override
  String get settingsTitle => 'Beállítások';

  @override
  String get sectionSecurity => 'Biztonság';

  @override
  String get loadingLabel => 'Betöltés…';

  @override
  String get encryptionLoadError =>
      'A titkosítási beállításokat nem sikerült betölteni';

  @override
  String get encryptionToggleTitle => 'Jegyzetek védelme jelszóval';

  @override
  String get encryptionToggleSubtitle =>
      'A tárolt jegyzeteket (AES-256-GCM) a jelszavadból származtatott kulccsal titkosítja. A jelszó soha nincs elmentve — ha elfelejted, a jegyzetek nem állíthatók vissza.';

  @override
  String get lockNotesNowTitle => 'Jegyzetek zárolása most';

  @override
  String get lockNotesNowSubtitle =>
      'A jegyzetek megtekintéséhez ismét szükség lesz a jelszóra';

  @override
  String get setPasswordDialogTitle => 'Jelszó beállítása';

  @override
  String get passwordTooShortError => 'Legalább 8 karakter';

  @override
  String get confirmPasswordLabel => 'Jelszó megerősítése';

  @override
  String get passwordsDoNotMatchError => 'A jelszavak nem egyeznek';

  @override
  String enableEncryptionError(String error) {
    return 'A titkosítást nem sikerült engedélyezni: $error';
  }

  @override
  String get enableButton => 'Engedélyezés';

  @override
  String get disablePasswordDialogTitle =>
      'Add meg a jelszavadat a titkosítás letiltásához';

  @override
  String get disableButton => 'Letiltás';

  @override
  String get sectionAppearance => 'Megjelenés';

  @override
  String get lightThemeToggleTitle => 'Világos téma';

  @override
  String get lightThemeToggleSubtitle =>
      'Világos színséma használata sötét helyett';

  @override
  String get noteLayoutToggleTitle => 'Jegyzetlista elrendezése';

  @override
  String get manageRelaysTitle => 'Relék kezelése';

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
  String get confirmButton => 'Megerősítés';

  @override
  String get sectionLanguage => 'Nyelv';

  @override
  String get langSystem => 'Rendszer alapértelmezése';

  @override
  String get sectionAccount => 'Fiók';

  @override
  String get accountLocalOnlyMessage =>
      'Echoes helyi használatban — nincs szinkronizálva a Nostrral';

  @override
  String get accountSignInButton => 'Bejelentkezés';

  @override
  String accountSignedInAs(String npub) {
    return 'Bejelentkezve mint $npub';
  }

  @override
  String get accountSignOutButton => 'Kijelentkezés';

  @override
  String get accountSignOutConfirmTitle => 'Kijelentkezel?';

  @override
  String get accountSignOutConfirmBody =>
      'A jegyzeteid ezen az eszközön maradnak. Bármikor újra bejelentkezhetsz.';

  @override
  String get onboardingWelcomeTitle => 'Üdvözlünk az Echoesban';

  @override
  String get onboardingIntroLocalTitle => 'A jegyzeteid mindig az eszközödön';

  @override
  String get onboardingIntroLocalBody =>
      'Minden jegyzet először helyben kerül mentésre, így az alkalmazás teljesen offline is működik. Semmi sem hagyja el az eszközödet, hacsak nem választod a szinkronizálást.';

  @override
  String get onboardingIntroSyncTitle =>
      'Opcionális szinkronizálás Nostron keresztül';

  @override
  String get onboardingIntroSyncBody =>
      'Kapcsold be a szinkronizálást, hogy biztonsági mentést készíts a jegyzeteidről, és más eszközökön is olvashasd őket a nyílt Nostr protokoll és a választott relék segítségével.';

  @override
  String get onboardingIntroEncryptionTitle => 'Mindig titkosítva';

  @override
  String get onboardingIntroEncryptionBody =>
      'A Nostrra szinkronizált jegyzetek végpontok közötti titkosítással vannak védve, így a relé üzemeltetői — és mindenki más — soha nem olvashatják a tartalmukat.';

  @override
  String get onboardingIntroAmberTitle =>
      'Jelentkezz be a kulcsod felfedése nélkül';

  @override
  String get onboardingIntroAmberBody =>
      'Használd az Ambert a bejelentkezéshez: a privát kulcsod az Amberben marad, és soha nem kerül megosztásra az Echoesszal.';

  @override
  String get onboardingIntroSecurityTitle => 'Beépített biztonság';

  @override
  String get onboardingIntroSecurityBody =>
      'A privát kulcsod az eszközöd titkosított kulcstárolójában van — vagy az Amberrel egyáltalán nem érinti az Echoes-t. A fényképek és hangjegyzetek titkosítva vannak, mielőtt elhagynák az eszközödet. A jegyzetek jelszóval zárolhatók, és mindez soha nem kerül be a telefon biztonsági mentéseibe.';

  @override
  String get onboardingNextButton => 'Tovább';

  @override
  String get onboardingBackButton => 'Vissza';

  @override
  String get onboardingSkipButton =>
      'Kihagyás — Echoes használata csak helyben';

  @override
  String get onboardingRelayTitle => 'Válassz relékat a szinkronizáláshoz';

  @override
  String get onboardingRelayBody =>
      'A relék azok a helyek, ahol a titkosított jegyzeteid tárolódnak szinkronizáláskor. Adj hozzá egyet vagy többet — ezek a népszerűek jó kezdésnek számítanak:';

  @override
  String get onboardingFinishButton => 'Kezdés';

  @override
  String get syncNoteTooltip => 'Jegyzet szinkronizálása';

  @override
  String get unsyncNoteTooltip => 'Eltávolítás a relékről';

  @override
  String get syncSelectedTooltip => 'Kiválasztott jegyzetek szinkronizálása';

  @override
  String get exportSelectedTooltip => 'Kiválasztott jegyzetek exportálása';

  @override
  String get deleteSelectedTooltip => 'Kiválasztott jegyzetek törlése';

  @override
  String syncNoteError(String error) {
    return 'A jegyzetet nem sikerült szinkronizálni: $error';
  }

  @override
  String unsyncNoteError(String error) {
    return 'Nem sikerült eltávolítani a jegyzetet a relékről: $error';
  }

  @override
  String deleteNoteRelayError(String error) {
    return 'A jegyzet helyileg törölve, de nem sikerült eltávolítani a relékről: $error';
  }

  @override
  String deleteNotesRelayError(int count) {
    return '$count jegyzet helyileg törölve, de nem sikerült eltávolítani a relékről';
  }

  @override
  String get deletingNotesTitle => 'Jegyzetek törlése…';

  @override
  String deletingNotesProgress(int completed, int total) {
    return 'Törlés: $completed/$total';
  }

  @override
  String get syncSelectedSuccess => 'Jegyzetek szinkronizálva';

  @override
  String syncSelectedPartialError(int count) {
    return '$count jegyzet szinkronizálása sikertelen';
  }

  @override
  String get exportConfirmTitle => 'Jegyzetek exportálása';

  @override
  String get exportConfirmBody =>
      'Biztonsági mentési fájlt hoz létre a jegyzeteidről. Tartalmazza a csatolt képek vagy hangjegyzetek visszafejtő kulcsait is — bárki, akinél a fájl van, elolvashatja őket, hacsak nincs titkosítva.';

  @override
  String get exportEncryptToggleLabel => 'Fájl titkosítása';

  @override
  String get exportEncryptToggleSubtitle =>
      'Javasolt — jelszóval védi a biztonsági mentést';

  @override
  String get exportPasswordDialogTitle => 'Add meg a jelszavad';

  @override
  String get exportSetPasswordDialogTitle =>
      'Állíts be jelszót ehhez az exporthoz';

  @override
  String get importPasswordDialogTitle => 'Add meg az export jelszavát';

  @override
  String get sectionData => 'Adatok';

  @override
  String get exportNotesButton => 'Jegyzetek exportálása';

  @override
  String get exportNotesSubtitle =>
      'Mentsd el az összes jegyzetedet egy fájlba, amelyet később újra importálhatsz';

  @override
  String get importNotesButton => 'Jegyzetek importálása';

  @override
  String get importNotesSubtitle =>
      'Jegyzetek visszaállítása egy korábban exportált fájlból';

  @override
  String get exportNotesSuccess => 'Jegyzetek exportálva';

  @override
  String exportNotesError(Object error) {
    return 'A jegyzeteket nem sikerült exportálni: $error';
  }

  @override
  String importNotesSuccess(int count) {
    return '$count jegyzet importálva';
  }

  @override
  String importNotesError(Object error) {
    return 'A jegyzeteket nem sikerült importálni: $error';
  }

  @override
  String get sectionAttachments => 'Mellékletek';

  @override
  String get attachmentProviderSubtitle =>
      'Hova töltődnek fel a titkosított képek és hangjegyzetek szinkronizáláskor';

  @override
  String get attachmentProviderCustom => 'Egyéni…';

  @override
  String get attachmentCustomUrlLabel => 'Szerver URL';

  @override
  String get attachmentProviderHint =>
      'Some public hosts (e.g. Primal, nostr.build) reject encrypted uploads outright — they validate real image content, which ciphertext never is. Prefer a Blossom host that stores opaque blobs, or point Custom… at a self-hosted one.';

  @override
  String get sectionSupport => 'Támogatás';

  @override
  String get supportEchoesTitle => 'Támogasd az Echoest';

  @override
  String lightningAddressCopied(String address) {
    return '⚡ $address vágólapra másolva';
  }

  @override
  String get cancelButton => 'Mégse';

  @override
  String get passwordLabel => 'Jelszó';

  @override
  String get invalidPrivateKeyError =>
      'A privát kulcs érvénytelen. Adjon meg érvényes nsec vagy hex kulcsot.';

  @override
  String get wrongPasswordError => 'Helytelen jelszó';

  @override
  String genericErrorPrefix(String error) {
    return 'Hiba: $error';
  }
}
