// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bulgarian (`bg`).
class AppLocalizationsBg extends AppLocalizations {
  AppLocalizationsBg([String locale = 'bg']) : super(locale);

  @override
  String get loginSubtitle => 'Влезте с вашия Nostr акаунт';

  @override
  String get loginWithAmberButton => 'Вход с Amber';

  @override
  String get importAccountButton => 'Импортиране на Nostr акаунт';

  @override
  String get importAccountFieldLabel =>
      'Частен ключ (nsec) на вашия Nostr акаунт';

  @override
  String get importButton => 'Импортиране';

  @override
  String get relaysTitle => 'Релета';

  @override
  String get settingsTooltip => 'Настройки';

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
      'Все още няма бележки. Докоснете +, за да създадете нова.';

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
  String get newPlainNoteOption => 'Бележка';

  @override
  String get newChecklistOption => 'Списък със задачи';

  @override
  String get newVoiceNoteOption => 'Гласова бележка';

  @override
  String get deleteNoteButton => 'Изтрий бележката';

  @override
  String get deleteNoteConfirmTitle => 'Да се изтрие ли тази бележка?';

  @override
  String get deleteNoteConfirmBody =>
      'Това не може да бъде отменено. Ако бележката е била синхронизирана, тя ще бъде премахната и от релетата ви.';

  @override
  String deleteNotesConfirmTitle(int count) {
    return 'Да се изтрият ли $count бележки?';
  }

  @override
  String get deleteNotesConfirmBody =>
      'Това не може да бъде отменено. Ако някоя от тези бележки е била синхронизирана, тя ще бъде премахната и от релетата ви.';

  @override
  String selectionCount(int count) {
    return '$count избрани';
  }

  @override
  String get untitledNote => '(без заглавие)';

  @override
  String errorLoadingNotes(String error) {
    return 'Грешка при зареждане на бележките: $error';
  }

  @override
  String get timeJustNow => 'сега';

  @override
  String timeMinutesAgo(int count) {
    return 'преди $count мин';
  }

  @override
  String timeHoursAgo(int count) {
    return 'преди $count ч';
  }

  @override
  String timeDaysAgo(int count) {
    return 'преди $count дни';
  }

  @override
  String get notesLockedTitle => 'Бележките са защитени с парола';

  @override
  String get unlockButton => 'Отключване';

  @override
  String get saveTooltip => 'Запазване';

  @override
  String get titleFieldLabel => 'Заглавие';

  @override
  String get checklistLabel => 'Списък със задачи';

  @override
  String get bodyFieldHint => 'Пишете тук... (поддържа се markdown)';

  @override
  String get checklistItemHint => 'Елемент от списъка';

  @override
  String get addItemButton => 'Добавяне на елемент';

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
  String get addImageButton => 'Добави изображение';

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
  String get recordVoiceNoteTooltip => 'Запиши гласова бележка';

  @override
  String get recordVoiceNoteInstructions =>
      'Tap the red button to start recording, or ✕ to cancel.';

  @override
  String get stopRecordingTooltip => 'Спри записа';

  @override
  String get cancelRecordingTooltip => 'Отмени записа';

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
  String get imageSizeSmall => 'Малко';

  @override
  String get imageSizeMedium => 'Средно';

  @override
  String get imageSizeFull => 'Цяла ширина';

  @override
  String get removeImageButton => 'Премахване на изображението';

  @override
  String get relayUrlHint => 'wss://relay.example.com';

  @override
  String get noRelaysMessage => 'Все още няма конфигурирано реле.';

  @override
  String relaysCount(int count) {
    return '$count релета';
  }

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get sectionSecurity => 'Сигурност';

  @override
  String get loadingLabel => 'Зареждане…';

  @override
  String get encryptionLoadError =>
      'Настройките за криптиране не можаха да се заредят';

  @override
  String get encryptionToggleTitle => 'Защита на бележките с парола';

  @override
  String get encryptionToggleSubtitle =>
      'Криптира бележките в покой (AES-256-GCM) с ключ, извлечен от паролата ви. Паролата никога не се съхранява — ако я забравите, бележките не могат да бъдат възстановени.';

  @override
  String get lockNotesNowTitle => 'Заключване на бележките сега';

  @override
  String get lockNotesNowSubtitle =>
      'Изисква паролата отново за преглед на бележките';

  @override
  String get setPasswordDialogTitle => 'Задаване на парола';

  @override
  String get passwordTooShortError => 'Поне 8 символа';

  @override
  String get confirmPasswordLabel => 'Потвърдете паролата';

  @override
  String get passwordsDoNotMatchError => 'Паролите не съвпадат';

  @override
  String enableEncryptionError(String error) {
    return 'Криптирането не можа да бъде активирано: $error';
  }

  @override
  String get enableButton => 'Активиране';

  @override
  String get disablePasswordDialogTitle =>
      'Въведете паролата си, за да деактивирате криптирането';

  @override
  String get disableButton => 'Деактивиране';

  @override
  String get sectionAppearance => 'Външен вид';

  @override
  String get lightThemeToggleTitle => 'Светла тема';

  @override
  String get lightThemeToggleSubtitle =>
      'Използвайте светла цветова схема вместо тъмна';

  @override
  String get noteLayoutToggleTitle => 'Оформление на списъка с бележки';

  @override
  String get manageRelaysTitle => 'Управление на релета';

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
  String get confirmButton => 'Потвърди';

  @override
  String get sectionLanguage => 'Език';

  @override
  String get langSystem => 'По подразбиране на системата';

  @override
  String get sectionAccount => 'Акаунт';

  @override
  String get accountLocalOnlyMessage =>
      'Echoes се използва локално — без синхронизация с Nostr';

  @override
  String get accountSignInButton => 'Вход';

  @override
  String accountSignedInAs(String npub) {
    return 'Влезли сте като $npub';
  }

  @override
  String get accountSignOutButton => 'Изход';

  @override
  String get accountSignOutConfirmTitle => 'Изход от акаунта?';

  @override
  String get accountSignOutConfirmBody =>
      'Бележките ви остават на това устройство. Можете да влезете отново по всяко време.';

  @override
  String get onboardingWelcomeTitle => 'Добре дошли в Echoes';

  @override
  String get onboardingIntroLocalTitle =>
      'Вашите бележки, винаги на устройството ви';

  @override
  String get onboardingIntroLocalBody =>
      'Всяка бележка се запазва първо локално, така че приложението работи изцяло офлайн. Нищо не напуска устройството ви, освен ако не изберете да го синхронизирате.';

  @override
  String get onboardingIntroSyncTitle =>
      'Незадължителна синхронизация чрез Nostr';

  @override
  String get onboardingIntroSyncBody =>
      'Активирайте синхронизацията, за да архивирате бележките си и да ги четете на други устройства, използвайки отворения протокол Nostr и релета по ваш избор.';

  @override
  String get onboardingIntroEncryptionTitle => 'Винаги криптирани';

  @override
  String get onboardingIntroEncryptionBody =>
      'Бележките, синхронизирани с Nostr, са end-to-end криптирани, така че операторите на релета — и всички останали — никога не могат да прочетат съдържанието им.';

  @override
  String get onboardingIntroAmberTitle => 'Влезте, без да разкривате ключа си';

  @override
  String get onboardingIntroAmberBody =>
      'Използвайте Amber за вход: частният ви ключ остава в Amber и никога не се споделя с Echoes.';

  @override
  String get onboardingIntroSecurityTitle => 'Сигурност по замисъл';

  @override
  String get onboardingIntroSecurityBody =>
      'Частният ви ключ се съхранява в криптираното хранилище на устройството — или, с Amber, изобщо не докосва Echoes. Снимките и гласовите бележки се криптират, преди да напуснат устройството ви. Бележките могат да се заключат с парола и нищо от това никога не се включва в резервни копия на телефона.';

  @override
  String get onboardingNextButton => 'Напред';

  @override
  String get onboardingBackButton => 'Назад';

  @override
  String get onboardingSkipButton => 'Пропусни — използвай Echoes само локално';

  @override
  String get onboardingRelayTitle => 'Изберете релета за синхронизация';

  @override
  String get onboardingRelayBody =>
      'Релетата са мястото, където се съхраняват криптираните ви бележки при синхронизация. Добавете едно или повече — тези популярни са добро начало:';

  @override
  String get onboardingFinishButton => 'Започни';

  @override
  String get syncNoteTooltip => 'Синхронизирай тази бележка';

  @override
  String get unsyncNoteTooltip => 'Премахни от релетата';

  @override
  String get syncSelectedTooltip => 'Синхронизирай избраните бележки';

  @override
  String get exportSelectedTooltip => 'Изнеси избраните бележки';

  @override
  String get deleteSelectedTooltip => 'Изтрий избраните бележки';

  @override
  String syncNoteError(String error) {
    return 'Синхронизацията на бележката не бе успешна: $error';
  }

  @override
  String unsyncNoteError(String error) {
    return 'Бележката не можа да бъде премахната от релетата: $error';
  }

  @override
  String deleteNoteRelayError(String error) {
    return 'Бележката е изтрита локално, но не можа да бъде премахната от релетата: $error';
  }

  @override
  String deleteNotesRelayError(int count) {
    return '$count бележки са изтрити локално, но не можаха да бъдат премахнати от релетата';
  }

  @override
  String get deletingNotesTitle => 'Изтриване на бележки…';

  @override
  String deletingNotesProgress(int completed, int total) {
    return 'Изтриване на $completed от $total';
  }

  @override
  String get syncSelectedSuccess => 'Бележките са синхронизирани';

  @override
  String syncSelectedPartialError(int count) {
    return 'Неуспешно синхронизиране на $count бележки';
  }

  @override
  String get exportConfirmTitle => 'Експортиране на бележки';

  @override
  String get exportConfirmBody =>
      'Създава резервен файл на бележките ви. Включва и ключовете за декриптиране на прикачени изображения или гласови бележки — всеки с файла би могъл да ги прочете, освен ако не е криптиран.';

  @override
  String get exportEncryptToggleLabel => 'Криптирай този файл';

  @override
  String get exportEncryptToggleSubtitle =>
      'Препоръчително — защитава резервното копие с парола';

  @override
  String get exportPasswordDialogTitle => 'Въведете паролата си';

  @override
  String get exportSetPasswordDialogTitle => 'Задайте парола за този износ';

  @override
  String get importPasswordDialogTitle => 'Въведете паролата на износа';

  @override
  String get sectionData => 'Данни';

  @override
  String get exportNotesButton => 'Експортиране на бележки';

  @override
  String get exportNotesSubtitle =>
      'Запазете всички бележки във файл, който можете да импортирате отново по-късно';

  @override
  String get importNotesButton => 'Импортиране на бележки';

  @override
  String get importNotesSubtitle =>
      'Възстановете бележки от файл, експортиран по-рано';

  @override
  String get exportNotesSuccess => 'Бележките са експортирани';

  @override
  String exportNotesError(Object error) {
    return 'Експортирането на бележките не бе успешно: $error';
  }

  @override
  String importNotesSuccess(int count) {
    return 'Импортирани $count бележки';
  }

  @override
  String importNotesError(Object error) {
    return 'Импортирането на бележките не бе успешно: $error';
  }

  @override
  String get sectionAttachments => 'Прикачени файлове';

  @override
  String get attachmentProviderSubtitle =>
      'Къде се качват криптираните изображения и гласови бележки при синхронизиране';

  @override
  String get attachmentProviderCustom => 'По избор…';

  @override
  String get attachmentCustomUrlLabel => 'URL адрес на сървъра';

  @override
  String get attachmentProviderHint =>
      'Some public hosts (e.g. Primal, nostr.build) reject encrypted uploads outright — they validate real image content, which ciphertext never is. Prefer a Blossom host that stores opaque blobs, or point Custom… at a self-hosted one.';

  @override
  String get sectionSupport => 'Подкрепа';

  @override
  String get supportEchoesTitle => 'Подкрепете Echoes';

  @override
  String lightningAddressCopied(String address) {
    return '⚡ $address копиран в клипборда';
  }

  @override
  String get cancelButton => 'Отказ';

  @override
  String get passwordLabel => 'Парола';

  @override
  String get invalidPrivateKeyError =>
      'Частният ключ не е валиден. Въведете валиден nsec или hex ключ.';

  @override
  String get wrongPasswordError => 'Грешна парола';

  @override
  String genericErrorPrefix(String error) {
    return 'Грешка: $error';
  }
}
