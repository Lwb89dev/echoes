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
  String get bunkerLoginButton => 'Távoli aláíró csatlakoztatása (bunker)';

  @override
  String get bunkerFieldLabel => 'Illeszd be a bunker:// kapcsolati tokened';

  @override
  String get bunkerConnectButton => 'Csatlakozás';

  @override
  String get bunkerAuthPrompt =>
      'Hagyd jóvá a kapcsolatot az aláíródban, majd térj vissza';

  @override
  String get relaysTitle => 'Relék';

  @override
  String get settingsTooltip => 'Beállítások';

  @override
  String get searchTooltip => 'Keresés';

  @override
  String get closeSearchTooltip => 'Keresés bezárása';

  @override
  String get searchNotesHint => 'Keresés a jegyzetekben';

  @override
  String get noSearchResultsMessage => 'Nincs találat.';

  @override
  String get emptyNotesMessage =>
      'Még nincsenek jegyzetek. Koppints a + gombra újhoz.';

  @override
  String get notesTabLabel => 'Jegyzetek';

  @override
  String get diaryTabLabel => 'Napló';

  @override
  String get emptyDiaryMessage =>
      'Még nincs naplóbejegyzés. Koppints a + gombra egy írásához.';

  @override
  String get diaryToday => 'Ma';

  @override
  String get diaryYesterday => 'Tegnap';

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
  String get bodyFieldHint => 'Írj ide... (markdown támogatott)';

  @override
  String get checklistItemHint => 'Listaelem';

  @override
  String get addItemButton => 'Elem hozzáadása';

  @override
  String checklistProgress(int done, int total) {
    return '$done/$total kész';
  }

  @override
  String get showCompletedItemsTooltip => 'Kész elemek megjelenítése';

  @override
  String get hideCompletedItemsTooltip => 'Kész elemek elrejtése';

  @override
  String get allChecklistItemsCompletedHidden =>
      'Minden elem kész és el van rejtve.';

  @override
  String get deleteCompletedItemsButton => 'Kész elemek törlése';

  @override
  String get deleteCompletedItemsConfirmTitle => 'Törlöd a kész elemeket?';

  @override
  String deleteCompletedItemsConfirmBody(int count) {
    return 'Ez $count kipipált elemet távolít el a listáról. Nem vonható vissza.';
  }

  @override
  String get addImageButton => 'Kép hozzáadása';

  @override
  String get noteColorButton => 'Jegyzet színe';

  @override
  String get noteColorDefault => 'Alapértelmezett';

  @override
  String get noteColorYellow => 'Sárga';

  @override
  String get noteColorRed => 'Piros';

  @override
  String get noteColorPurple => 'Lila';

  @override
  String get noteColorBlue => 'Kék';

  @override
  String get noteColorGreen => 'Zöld';

  @override
  String get noteColorOrange => 'Narancs';

  @override
  String get noteColorWhite => 'Fehér';

  @override
  String get recordVoiceNoteTooltip => 'Hangjegyzet rögzítése';

  @override
  String get recordVoiceNoteInstructions =>
      'Koppints a piros gombra a felvétel indításához, vagy a ✕ gombra a megszakításhoz.';

  @override
  String get stopRecordingTooltip => 'Felvétel leállítása';

  @override
  String get cancelRecordingTooltip => 'Felvétel megszakítása';

  @override
  String get addVoiceTimestampButton => 'Időbélyeg hozzáadása';

  @override
  String get editVoiceTimestampButton => 'Időbélyeg szerkesztése';

  @override
  String get voiceNoteUnsupportedOnPlatform =>
      'A hangjegyzetek nem támogatottak ezen az eszközön';

  @override
  String get formatBoldTooltip => 'Félkövér';

  @override
  String get formatItalicTooltip => 'Dőlt';

  @override
  String get formatHeadingTooltip => 'Címsor';

  @override
  String get formatListTooltip => 'Felsorolás';

  @override
  String get formatLinkTooltip => 'Hivatkozás';

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
  String get noteLayoutToggleTitle => 'Váltás lista- és rácsnézet között';

  @override
  String get manageRelaysTitle => 'Relék kezelése';

  @override
  String get republishAllNotesButton =>
      'Minden szinkronizált jegyzet újraközzététele';

  @override
  String get republishAllNotesSubtitle =>
      'Feltölti a fenti reléket a máshol már megosztott jegyzetekkel — hasznos közvetlenül egy új, pl. saját üzemeltetésű tartalék relé hozzáadása után';

  @override
  String republishAllNotesSuccess(int count) {
    return '$count jegyzet újraközzétéve';
  }

  @override
  String republishAllNotesError(String error) {
    return 'A jegyzeteket nem sikerült újraközzétenni: $error';
  }

  @override
  String get forceFullResyncButton => 'Teljes újraszinkronizálás kényszerítése';

  @override
  String get forceFullResyncSubtitle =>
      'Újra lekérdezi a relayktől egy jegyzet teljes előzményét ahelyett, hogy csak az újakat kérné — hasznos, ha a szinkronizálás elakadtnak tűnik és kihagyja a régebbi jegyzeteket, pl. egy elérhetetlen relay javítása után';

  @override
  String get forceFullResyncSuccess => 'Jegyzetek frissítve a relayktől';

  @override
  String forceFullResyncError(String error) {
    return 'A jegyzetek újraszinkronizálása nem sikerült: $error';
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
      'Egyes nyilvános kiszolgálók (pl. Primal, nostr.build) eleve elutasítják a titkosított feltöltéseket — valódi képtartalmat ellenőriznek, ami a titkosított adat sosem. Válassz olyan Blossom kiszolgálót, amely nyers adatokat tárol, vagy állítsd az Egyéni… opciót sajátra.';

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

  @override
  String get shareNoteTooltip => 'Megosztás';

  @override
  String get shareNoteTitle => 'Jegyzet megosztása';

  @override
  String get shareRecipientFieldLabel =>
      'A címzett npub-ja vagy nyilvános kulcsa';

  @override
  String get shareAddRecipientButton => 'Hozzáadás';

  @override
  String get shareInvalidRecipientError =>
      'Ez nem érvényes npub vagy nyilvános kulcs';

  @override
  String get shareRecipientNotFoundError =>
      'Nem található Nostr-fiók ehhez a névhez';

  @override
  String get shareConfirmTitle => 'Megosztod ezt a jegyzetet?';

  @override
  String get shareConfirmButton => 'Megosztás';

  @override
  String get shareAlreadyRecipientError => 'Már megosztva ezzel a személlyel';

  @override
  String get shareCannotShareWithSelfError =>
      'Nem oszthatsz meg jegyzetet önmagaddal';

  @override
  String get shareRecipientsHeader => 'Megosztva vele';

  @override
  String get shareNoRecipientsMessage => 'Még nincs megosztva senkivel.';

  @override
  String get stopSharingTooltip => 'Megosztás leállítása ezzel a személlyel';

  @override
  String get shareRevocationNote =>
      'Bárki, akivel megosztod, elolvashatja ezt a jegyzetet a saját eszközén. Valaki eltávolítása leállítja a jövőbeli frissítéseket, de nem törölheti azt, amit már megkapott.';

  @override
  String shareError(String error) {
    return 'A megosztás frissítése nem sikerült: $error';
  }

  @override
  String get sharedWithMeHeader => 'Megosztva veled';

  @override
  String sharedByLabel(String npub) {
    return 'Megosztotta: $npub';
  }

  @override
  String get sharedNoteEditableNote =>
      'Szerkesztheted ezt a jegyzetet; a módosításaid visszaszinkronizálódnak a tulajdonoshoz, aki egyesíti őket.';

  @override
  String get abandonSharedNoteButton => 'Kilépés ebből a megosztott jegyzetből';

  @override
  String get abandonSharedNoteConfirmTitle =>
      'Kilépsz ebből a megosztott jegyzetből?';

  @override
  String get abandonSharedNoteConfirmBody =>
      'Eltávolítjuk erről az eszközről, és nem kapsz több frissítést. Ez nem vonható vissza — később nem csatlakozhatsz újra.';

  @override
  String abandonSharedNoteError(String error) {
    return 'Nem sikerült kilépni: $error';
  }
}
