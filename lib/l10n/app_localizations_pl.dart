// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get loginSubtitle => 'Zaloguj się swoim kontem Nostr';

  @override
  String get loginWithAmberButton => 'Zaloguj się przez Amber';

  @override
  String get importAccountButton => 'Importuj konto Nostr';

  @override
  String get importAccountFieldLabel =>
      'Klucz prywatny (nsec) Twojego konta Nostr';

  @override
  String get importButton => 'Importuj';

  @override
  String get relaysTitle => 'Przekaźniki';

  @override
  String get settingsTooltip => 'Ustawienia';

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
      'Nie masz jeszcze żadnych notatek. Dotknij +, aby utworzyć nową.';

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
  String get newPlainNoteOption => 'Notatka';

  @override
  String get newChecklistOption => 'Lista kontrolna';

  @override
  String get newVoiceNoteOption => 'Notatka głosowa';

  @override
  String get deleteNoteButton => 'Usuń notatkę';

  @override
  String get deleteNoteConfirmTitle => 'Usunąć tę notatkę?';

  @override
  String get deleteNoteConfirmBody =>
      'Tej czynności nie można cofnąć. Jeśli ta notatka była zsynchronizowana, zostanie również usunięta z Twoich przekaźników.';

  @override
  String deleteNotesConfirmTitle(int count) {
    return 'Usunąć $count notatek?';
  }

  @override
  String get deleteNotesConfirmBody =>
      'Tej czynności nie można cofnąć. Jeśli którakolwiek z tych notatek była zsynchronizowana, zostanie również usunięta z Twoich przekaźników.';

  @override
  String selectionCount(int count) {
    return 'Wybrano: $count';
  }

  @override
  String get untitledNote => '(bez tytułu)';

  @override
  String errorLoadingNotes(String error) {
    return 'Błąd podczas wczytywania notatek: $error';
  }

  @override
  String get timeJustNow => 'teraz';

  @override
  String timeMinutesAgo(int count) {
    return '$count min temu';
  }

  @override
  String timeHoursAgo(int count) {
    return '$count godz temu';
  }

  @override
  String timeDaysAgo(int count) {
    return '$count dni temu';
  }

  @override
  String get notesLockedTitle => 'Notatki są chronione hasłem';

  @override
  String get unlockButton => 'Odblokuj';

  @override
  String get saveTooltip => 'Zapisz';

  @override
  String get titleFieldLabel => 'Tytuł';

  @override
  String get checklistLabel => 'Lista kontrolna';

  @override
  String get bodyFieldHint => 'Pisz tutaj... (obsługiwany markdown)';

  @override
  String get checklistItemHint => 'Element listy';

  @override
  String get addItemButton => 'Dodaj element';

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
  String get addImageButton => 'Dodaj obraz';

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
  String get recordVoiceNoteTooltip => 'Nagraj notatkę głosową';

  @override
  String get recordVoiceNoteInstructions =>
      'Tap the red button to start recording, or ✕ to cancel.';

  @override
  String get stopRecordingTooltip => 'Zatrzymaj nagrywanie';

  @override
  String get cancelRecordingTooltip => 'Anuluj nagrywanie';

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
  String get imageSizeSmall => 'Małe';

  @override
  String get imageSizeMedium => 'Średnie';

  @override
  String get imageSizeFull => 'Pełna szerokość';

  @override
  String get removeImageButton => 'Usuń obraz';

  @override
  String get relayUrlHint => 'wss://relay.example.com';

  @override
  String get noRelaysMessage =>
      'Nie skonfigurowano jeszcze żadnego przekaźnika.';

  @override
  String relaysCount(int count) {
    return '$count przekaźników';
  }

  @override
  String get settingsTitle => 'Ustawienia';

  @override
  String get sectionSecurity => 'Bezpieczeństwo';

  @override
  String get loadingLabel => 'Wczytywanie…';

  @override
  String get encryptionLoadError =>
      'Nie udało się wczytać ustawień szyfrowania';

  @override
  String get encryptionToggleTitle => 'Chroń notatki hasłem';

  @override
  String get encryptionToggleSubtitle =>
      'Szyfruje zapisane notatki (AES-256-GCM) kluczem wyprowadzonym z Twojego hasła. Hasło nigdy nie jest zapisywane — jeśli je zapomnisz, notatek nie będzie można odzyskać.';

  @override
  String get lockNotesNowTitle => 'Zablokuj notatki teraz';

  @override
  String get lockNotesNowSubtitle =>
      'Aby zobaczyć notatki, ponownie będzie potrzebne hasło';

  @override
  String get setPasswordDialogTitle => 'Ustaw hasło';

  @override
  String get passwordTooShortError => 'Co najmniej 8 znaków';

  @override
  String get confirmPasswordLabel => 'Potwierdź hasło';

  @override
  String get passwordsDoNotMatchError => 'Hasła nie są zgodne';

  @override
  String enableEncryptionError(String error) {
    return 'Nie udało się włączyć szyfrowania: $error';
  }

  @override
  String get enableButton => 'Włącz';

  @override
  String get disablePasswordDialogTitle =>
      'Wprowadź hasło, aby wyłączyć szyfrowanie';

  @override
  String get disableButton => 'Wyłącz';

  @override
  String get sectionAppearance => 'Wygląd';

  @override
  String get lightThemeToggleTitle => 'Jasny motyw';

  @override
  String get lightThemeToggleSubtitle =>
      'Użyj jasnego schematu kolorów zamiast ciemnego';

  @override
  String get noteLayoutToggleTitle => 'Układ listy notatek';

  @override
  String get manageRelaysTitle => 'Zarządzaj przekaźnikami';

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
  String get confirmButton => 'Potwierdź';

  @override
  String get sectionLanguage => 'Język';

  @override
  String get langSystem => 'Domyślny systemowy';

  @override
  String get sectionAccount => 'Konto';

  @override
  String get accountLocalOnlyMessage =>
      'Echoes używane lokalnie — brak synchronizacji z Nostr';

  @override
  String get accountSignInButton => 'Zaloguj się';

  @override
  String accountSignedInAs(String npub) {
    return 'Zalogowano jako $npub';
  }

  @override
  String get accountSignOutButton => 'Wyloguj się';

  @override
  String get accountSignOutConfirmTitle => 'Wylogować się?';

  @override
  String get accountSignOutConfirmBody =>
      'Twoje notatki pozostaną na tym urządzeniu. Możesz zalogować się ponownie w dowolnym momencie.';

  @override
  String get onboardingWelcomeTitle => 'Witamy w Echoes';

  @override
  String get onboardingIntroLocalTitle =>
      'Twoje notatki, zawsze na Twoim urządzeniu';

  @override
  String get onboardingIntroLocalBody =>
      'Każda notatka jest najpierw zapisywana lokalnie, dzięki czemu aplikacja działa w pełni offline. Nic nie opuszcza Twojego urządzenia, chyba że zdecydujesz się na synchronizację.';

  @override
  String get onboardingIntroSyncTitle =>
      'Opcjonalna synchronizacja przez Nostr';

  @override
  String get onboardingIntroSyncBody =>
      'Włącz synchronizację, aby tworzyć kopie zapasowe notatek i czytać je na innych urządzeniach za pomocą otwartego protokołu Nostr i wybranych przekaźników.';

  @override
  String get onboardingIntroEncryptionTitle => 'Zawsze zaszyfrowane';

  @override
  String get onboardingIntroEncryptionBody =>
      'Notatki zsynchronizowane z Nostr są szyfrowane end-to-end, więc operatorzy przekaźników — i nikt inny — nigdy nie mogą odczytać ich zawartości.';

  @override
  String get onboardingIntroAmberTitle => 'Zaloguj się bez ujawniania klucza';

  @override
  String get onboardingIntroAmberBody =>
      'Użyj Amber do logowania: Twój klucz prywatny pozostaje w Amber i nigdy nie jest udostępniany aplikacji Echoes.';

  @override
  String get onboardingIntroSecurityTitle => 'Bezpieczeństwo od podstaw';

  @override
  String get onboardingIntroSecurityBody =>
      'Twój klucz prywatny znajduje się w zaszyfrowanym magazynie kluczy urządzenia — albo, dzięki Amber, w ogóle nie dociera do Echoes. Zdjęcia i notatki głosowe są szyfrowane, zanim opuszczą urządzenie. Notatki można zablokować hasłem, a nic z tego nigdy nie trafia do kopii zapasowych telefonu.';

  @override
  String get onboardingNextButton => 'Dalej';

  @override
  String get onboardingBackButton => 'Wstecz';

  @override
  String get onboardingSkipButton => 'Pomiń — używaj Echoes tylko lokalnie';

  @override
  String get onboardingRelayTitle => 'Wybierz przekaźniki do synchronizacji';

  @override
  String get onboardingRelayBody =>
      'Przekaźniki to miejsca, w których przechowywane są Twoje zaszyfrowane notatki podczas synchronizacji. Dodaj jeden lub więcej — te popularne to dobry początek:';

  @override
  String get onboardingFinishButton => 'Rozpocznij';

  @override
  String get syncNoteTooltip => 'Synchronizuj tę notatkę';

  @override
  String get unsyncNoteTooltip => 'Usuń z przekaźników';

  @override
  String get syncSelectedTooltip => 'Synchronizuj wybrane notatki';

  @override
  String get exportSelectedTooltip => 'Eksportuj wybrane notatki';

  @override
  String get deleteSelectedTooltip => 'Usuń wybrane notatki';

  @override
  String syncNoteError(String error) {
    return 'Nie udało się zsynchronizować notatki: $error';
  }

  @override
  String unsyncNoteError(String error) {
    return 'Nie udało się usunąć notatki z przekaźników: $error';
  }

  @override
  String deleteNoteRelayError(String error) {
    return 'Notatka usunięta lokalnie, ale nie udało się jej usunąć z przekaźników: $error';
  }

  @override
  String deleteNotesRelayError(int count) {
    return '$count notatek usunięto lokalnie, ale nie udało się ich usunąć z przekaźników';
  }

  @override
  String get deletingNotesTitle => 'Usuwanie notatek…';

  @override
  String deletingNotesProgress(int completed, int total) {
    return 'Usuwanie $completed z $total';
  }

  @override
  String get syncSelectedSuccess => 'Notatki zsynchronizowane';

  @override
  String syncSelectedPartialError(int count) {
    return 'Nie udało się zsynchronizować $count notatek';
  }

  @override
  String get exportConfirmTitle => 'Eksportuj notatki';

  @override
  String get exportConfirmBody =>
      'Tworzy plik kopii zapasowej Twoich notatek. Zawiera również klucze deszyfrujące do załączonych obrazów lub notatek głosowych — każdy, kto ma ten plik, mógłby je odczytać, chyba że jest zaszyfrowany.';

  @override
  String get exportEncryptToggleLabel => 'Zaszyfruj ten plik';

  @override
  String get exportEncryptToggleSubtitle =>
      'Zalecane — chroni kopię zapasową hasłem';

  @override
  String get exportPasswordDialogTitle => 'Wprowadź swoje hasło';

  @override
  String get exportSetPasswordDialogTitle => 'Ustaw hasło dla tego eksportu';

  @override
  String get importPasswordDialogTitle => 'Wprowadź hasło eksportu';

  @override
  String get sectionData => 'Dane';

  @override
  String get exportNotesButton => 'Eksportuj notatki';

  @override
  String get exportNotesSubtitle =>
      'Zapisz wszystkie notatki do pliku, który będzie można później ponownie zaimportować';

  @override
  String get importNotesButton => 'Importuj notatki';

  @override
  String get importNotesSubtitle =>
      'Przywróć notatki z wcześniej wyeksportowanego pliku';

  @override
  String get exportNotesSuccess => 'Notatki wyeksportowane';

  @override
  String exportNotesError(Object error) {
    return 'Nie udało się wyeksportować notatek: $error';
  }

  @override
  String importNotesSuccess(int count) {
    return 'Zaimportowano $count notatek';
  }

  @override
  String importNotesError(Object error) {
    return 'Nie udało się zaimportować notatek: $error';
  }

  @override
  String get sectionAttachments => 'Załączniki';

  @override
  String get attachmentProviderSubtitle =>
      'Gdzie przesyłane są zaszyfrowane obrazy i notatki głosowe podczas synchronizacji';

  @override
  String get attachmentProviderCustom => 'Niestandardowy…';

  @override
  String get attachmentCustomUrlLabel => 'Adres URL serwera';

  @override
  String get attachmentProviderHint =>
      'Some public hosts (e.g. Primal, nostr.build) reject encrypted uploads outright — they validate real image content, which ciphertext never is. Prefer a Blossom host that stores opaque blobs, or point Custom… at a self-hosted one.';

  @override
  String get sectionSupport => 'Wsparcie';

  @override
  String get supportEchoesTitle => 'Wesprzyj Echoes';

  @override
  String lightningAddressCopied(String address) {
    return '⚡ Skopiowano $address do schowka';
  }

  @override
  String get cancelButton => 'Anuluj';

  @override
  String get passwordLabel => 'Hasło';

  @override
  String get invalidPrivateKeyError =>
      'Klucz prywatny jest nieprawidłowy. Wprowadź prawidłowy klucz nsec lub hex.';

  @override
  String get wrongPasswordError => 'Nieprawidłowe hasło';

  @override
  String genericErrorPrefix(String error) {
    return 'Błąd: $error';
  }
}
