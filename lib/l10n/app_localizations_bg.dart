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
  String get importAccountFieldLabel => 'Частен ключ (nsec) на вашия Nostr акаунт';

  @override
  String get importButton => 'Импортиране';

  @override
  String get bunkerLoginButton => 'Свързване на отдалечен подписващ (bunker)';

  @override
  String get bunkerFieldLabel => 'Постави своя bunker:// токен за връзка';

  @override
  String get bunkerConnectButton => 'Свързване';

  @override
  String get bunkerAuthPrompt => 'Одобри връзката в подписващия и се върни';

  @override
  String get relaysTitle => 'Релета';

  @override
  String get settingsTooltip => 'Настройки';

  @override
  String get searchTooltip => 'Търсене';

  @override
  String get closeSearchTooltip => 'Затвори търсенето';

  @override
  String get searchNotesHint => 'Търсене в бележките';

  @override
  String get noSearchResultsMessage => 'Няма съвпадения.';

  @override
  String get emptyNotesMessage => 'Все още няма бележки. Докоснете +, за да създадете нова.';

  @override
  String get notesTabLabel => 'Бележки';

  @override
  String get diaryTabLabel => 'Дневник';

  @override
  String get emptyDiaryMessage => 'Все още няма записи в дневника. Докоснете +, за да напишете.';

  @override
  String get diaryToday => 'Днес';

  @override
  String get diaryYesterday => 'Вчера';

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
  String get bodyFieldHint => 'Пишете тук... (поддържа се markdown)';

  @override
  String get checklistItemHint => 'Елемент от списъка';

  @override
  String get addItemButton => 'Добавяне на елемент';

  @override
  String completedItemsSection(int count) {
    return 'Завършени ($count)';
  }

  @override
  String get duplicateChecklistItemMessage => 'Вече е в списъка, завършено';

  @override
  String get restoreChecklistItemButton => 'Възстанови';

  @override
  String get noteSyncedMessage => 'Бележката е синхронизирана';

  @override
  String get noteSyncedFirstTimeMessage => 'Бележката е синхронизирана за първи път';

  @override
  String notePartiallySyncedMessage(int accepted, int total) {
    return 'Синхронизирана с $accepted от $total релета';
  }

  @override
  String checklistProgress(int done, int total) {
    return '$done от $total завършени';
  }

  @override
  String get showCompletedItemsTooltip => 'Покажи завършените елементи';

  @override
  String get hideCompletedItemsTooltip => 'Скрий завършените елементи';

  @override
  String get allChecklistItemsCompletedHidden => 'Всички елементи са завършени и скрити.';

  @override
  String get deleteCompletedItemsButton => 'Изтрий завършените елементи';

  @override
  String get deleteCompletedItemsConfirmTitle => 'Да се изтрият ли завършените елементи?';

  @override
  String deleteCompletedItemsConfirmBody(int count) {
    return 'Това премахва $count отметнати елемента от този списък. Не може да бъде отменено.';
  }

  @override
  String get addImageButton => 'Добави изображение';

  @override
  String get noteColorButton => 'Цвят на бележката';

  @override
  String get noteColorDefault => 'По подразбиране';

  @override
  String get noteColorYellow => 'Жълто';

  @override
  String get noteColorRed => 'Червено';

  @override
  String get noteColorPurple => 'Лилаво';

  @override
  String get noteColorBlue => 'Синьо';

  @override
  String get noteColorGreen => 'Зелено';

  @override
  String get noteColorOrange => 'Оранжево';

  @override
  String get noteColorWhite => 'Бяло';

  @override
  String get noteColorPink => 'Розово';

  @override
  String get noteColorTeal => 'Тюркоазено';

  @override
  String get noteColorIndigo => 'Индиго';

  @override
  String get noteColorBrown => 'Кафяво';

  @override
  String get noteColorLime => 'Лаймово зелено';

  @override
  String get recordVoiceNoteTooltip => 'Запиши гласова бележка';

  @override
  String get recordVoiceNoteInstructions =>
      'Докоснете червения бутон, за да започнете запис, или ✕ за отказ.';

  @override
  String get stopRecordingTooltip => 'Спри записа';

  @override
  String get cancelRecordingTooltip => 'Отмени записа';

  @override
  String get addVoiceTimestampButton => 'Добави времево клеймо';

  @override
  String get editVoiceTimestampButton => 'Редактирай времевото клеймо';

  @override
  String get voiceNoteUnsupportedOnPlatform =>
      'Гласовите бележки не се поддържат на това устройство';

  @override
  String get formatBoldTooltip => 'Удебелен';

  @override
  String get formatItalicTooltip => 'Курсив';

  @override
  String get formatStrikethroughTooltip => 'Зачертан';

  @override
  String get formatUnderlineTooltip => 'Подчертано';

  @override
  String get formatHeadingTooltip => 'Заглавие';

  @override
  String get formatListTooltip => 'Списък с точки';

  @override
  String get formatLinkTooltip => 'Връзка';

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
  String get encryptionLoadError => 'Настройките за криптиране не можаха да се заредят';

  @override
  String get encryptionToggleTitle => 'Защита на бележките с парола';

  @override
  String get encryptionToggleSubtitle =>
      'Криптира бележките в покой (AES-256-GCM) с ключ, извлечен от паролата ви. Паролата никога не се съхранява — ако я забравите, бележките не могат да бъдат възстановени.';

  @override
  String get lockNotesNowTitle => 'Заключване на бележките сега';

  @override
  String get lockNotesNowSubtitle => 'Изисква паролата отново за преглед на бележките';

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
  String get disablePasswordDialogTitle => 'Въведете паролата си, за да деактивирате криптирането';

  @override
  String get disableButton => 'Деактивиране';

  @override
  String get sectionAppearance => 'Външен вид';

  @override
  String get lightThemeToggleTitle => 'Светла тема';

  @override
  String get lightThemeToggleSubtitle => 'Използвайте светла цветова схема вместо тъмна';

  @override
  String get noteLayoutToggleTitle => 'Превключване между изглед списък и мрежа';

  @override
  String get manageRelaysTitle => 'Управление на релета';

  @override
  String get autoSyncOnSaveTitle => 'Публикуване при запазване';

  @override
  String get autoSyncOnSaveSubtitle =>
      'Бележките, които вече синхронизирате, се публикуват отново веднага след запазване. Само локалните — никога.';

  @override
  String get noteBackgroundPhoto => 'Снимка';

  @override
  String get noteBackgroundRemove => 'Премахни снимката';

  @override
  String get republishAllNotesButton => 'Публикувай отново всички синхронизирани бележки';

  @override
  String get republishAllNotesSubtitle =>
      'Допълва всяко реле по-горе с бележки, вече споделени другаде — полезно веднага след добавяне на ново, напр. собствено резервно реле';

  @override
  String republishAllNotesSuccess(int count) {
    return 'Публикувани отново $count бележки';
  }

  @override
  String republishAllNotesError(String error) {
    return 'Бележките не можаха да бъдат публикувани отново: $error';
  }

  @override
  String get forceFullResyncButton => 'Пълна ресинхронизация';

  @override
  String get forceFullResyncSubtitle =>
      'Проверява отново релейте за цялата история на бележка, вместо само новото — полезно, ако синхронизацията изглежда заседнала и пропуска по-стари бележки, напр. след отстраняване на недостъпен релей';

  @override
  String get forceFullResyncSuccess => 'Бележките са опреснени от релейте';

  @override
  String forceFullResyncError(String error) {
    return 'Ресинхронизацията на бележките не бе възможна: $error';
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
  String get accountLocalOnlyMessage => 'Echoes се използва локално — без синхронизация с Nostr';

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
  String get onboardingIntroLocalTitle => 'Вашите бележки, винаги на устройството ви';

  @override
  String get onboardingIntroLocalBody =>
      'Всяка бележка се запазва първо локално, така че приложението работи изцяло офлайн. Нищо не напуска устройството ви, освен ако не изберете да го синхронизирате.';

  @override
  String get onboardingIntroSyncTitle => 'Незадължителна синхронизация чрез Nostr';

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
  String get exportEncryptToggleSubtitle => 'Препоръчително — защитава резервното копие с парола';

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
  String get importNotesSubtitle => 'Възстановете бележки от файл, експортиран по-рано';

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
      'Някои публични сървъри (напр. Primal, nostr.build) отхвърлят шифрованите качвания — те проверяват дали съдържанието е истинско изображение, а шифрованите данни никога не са. Предпочетете Blossom сървър, който съхранява непрозрачни данни, или насочете „Персонализиран…“ към собствен сървър.';

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

  @override
  String get shareNoteTooltip => 'Споделяне';

  @override
  String get shareNoteTitle => 'Споделяне на бележка';

  @override
  String get shareRecipientFieldLabel => 'npub или публичен ключ на получателя';

  @override
  String get shareAddRecipientButton => 'Добави';

  @override
  String get shareInvalidRecipientError => 'Това не е валиден npub или публичен ключ';

  @override
  String get shareRecipientNotFoundError => 'Не е намерен Nostr акаунт за това име';

  @override
  String get shareConfirmTitle => 'Споделяне на тази бележка?';

  @override
  String get shareConfirmButton => 'Споделяне';

  @override
  String get shareAlreadyRecipientError => 'Вече е споделена с този човек';

  @override
  String get shareCannotShareWithSelfError => 'Не можете да споделите бележка със себе си';

  @override
  String get shareRecipientsHeader => 'Споделена с';

  @override
  String get shareNoRecipientsMessage => 'Още не е споделена с никого.';

  @override
  String get stopSharingTooltip => 'Спри споделянето с този човек';

  @override
  String get shareRevocationNote =>
      'Всеки, с когото споделяте, може да чете тази бележка на своето устройство. Премахването на някого спира бъдещите актуализации към него, но не може да изтрие вече полученото.';

  @override
  String shareError(String error) {
    return 'Неуспешно обновяване на споделянето: $error';
  }

  @override
  String get sharedWithMeHeader => 'Споделена с вас';

  @override
  String sharedByLabel(String npub) {
    return 'Споделена от $npub';
  }

  @override
  String get sharedNoteEditableNote =>
      'Можете да редактирате тази бележка; промените ви се синхронизират обратно към собственика, който ги обединява.';

  @override
  String get abandonSharedNoteButton => 'Напусни тази споделена бележка';

  @override
  String get abandonSharedNoteConfirmTitle => 'Да напуснете тази споделена бележка?';

  @override
  String get abandonSharedNoteConfirmBody =>
      'Ще бъде премахната от това устройство и ще спрете да получавате актуализации. Това не може да се отмени — няма да можете да се присъедините отново.';

  @override
  String abandonSharedNoteError(String error) {
    return 'Неуспешно напускане: $error';
  }
}
