// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get loginSubtitle => 'Войдите с помощью учётной записи Nostr';

  @override
  String get loginWithAmberButton => 'Войти через Amber';

  @override
  String get importAccountButton => 'Импортировать учётную запись Nostr';

  @override
  String get importAccountFieldLabel => 'Приватный ключ (nsec) вашей учётной записи Nostr';

  @override
  String get importButton => 'Импортировать';

  @override
  String get bunkerLoginButton => 'Подключить удалённый подписант (bunker)';

  @override
  String get bunkerFieldLabel => 'Вставьте свой токен подключения bunker://';

  @override
  String get bunkerConnectButton => 'Подключить';

  @override
  String get bunkerAuthPrompt => 'Подтвердите подключение в подписанте и вернитесь';

  @override
  String get relaysTitle => 'Реле';

  @override
  String get settingsTooltip => 'Настройки';

  @override
  String get searchTooltip => 'Поиск';

  @override
  String get closeSearchTooltip => 'Закрыть поиск';

  @override
  String get searchNotesHint => 'Поиск по заметкам';

  @override
  String get noSearchResultsMessage => 'Совпадений нет.';

  @override
  String get emptyNotesMessage => 'Заметок пока нет. Нажмите +, чтобы создать новую.';

  @override
  String get notesTabLabel => 'Заметки';

  @override
  String get diaryTabLabel => 'Дневник';

  @override
  String get emptyDiaryMessage => 'Записей в дневнике пока нет. Нажмите +, чтобы написать.';

  @override
  String get diaryToday => 'Сегодня';

  @override
  String get diaryYesterday => 'Вчера';

  @override
  String get newPlainNoteOption => 'Заметка';

  @override
  String get newChecklistOption => 'Чек-лист';

  @override
  String get newVoiceNoteOption => 'Голосовая заметка';

  @override
  String get deleteNoteButton => 'Удалить заметку';

  @override
  String get deleteNoteConfirmTitle => 'Удалить эту заметку?';

  @override
  String get deleteNoteConfirmBody =>
      'Это действие нельзя отменить. Если заметка была синхронизирована, она также будет удалена с ваших реле.';

  @override
  String deleteNotesConfirmTitle(int count) {
    return 'Удалить $count заметок?';
  }

  @override
  String get deleteNotesConfirmBody =>
      'Это действие нельзя отменить. Если какая-либо из этих заметок была синхронизирована, она также будет удалена с ваших реле.';

  @override
  String selectionCount(int count) {
    return 'Выбрано: $count';
  }

  @override
  String get untitledNote => '(без названия)';

  @override
  String errorLoadingNotes(String error) {
    return 'Ошибка загрузки заметок: $error';
  }

  @override
  String get timeJustNow => 'сейчас';

  @override
  String timeMinutesAgo(int count) {
    return '$count мин назад';
  }

  @override
  String timeHoursAgo(int count) {
    return '$count ч назад';
  }

  @override
  String timeDaysAgo(int count) {
    return '$count дн назад';
  }

  @override
  String get notesLockedTitle => 'Заметки защищены паролем';

  @override
  String get unlockButton => 'Разблокировать';

  @override
  String get saveTooltip => 'Сохранить';

  @override
  String get titleFieldLabel => 'Заголовок';

  @override
  String get bodyFieldHint => 'Пишите здесь... (поддерживается markdown)';

  @override
  String get checklistItemHint => 'Пункт списка';

  @override
  String get addItemButton => 'Добавить пункт';

  @override
  String checklistProgress(int done, int total) {
    return 'Выполнено $done из $total';
  }

  @override
  String get showCompletedItemsTooltip => 'Показать выполненные пункты';

  @override
  String get hideCompletedItemsTooltip => 'Скрыть выполненные пункты';

  @override
  String get allChecklistItemsCompletedHidden => 'Все пункты выполнены и скрыты.';

  @override
  String get deleteCompletedItemsButton => 'Удалить выполненные пункты';

  @override
  String get deleteCompletedItemsConfirmTitle => 'Удалить выполненные пункты?';

  @override
  String deleteCompletedItemsConfirmBody(int count) {
    return 'Из списка будет удалено $count отмеченных пунктов. Это нельзя отменить.';
  }

  @override
  String get addImageButton => 'Добавить изображение';

  @override
  String get noteColorButton => 'Цвет заметки';

  @override
  String get noteColorDefault => 'По умолчанию';

  @override
  String get noteColorYellow => 'Жёлтый';

  @override
  String get noteColorRed => 'Красный';

  @override
  String get noteColorPurple => 'Фиолетовый';

  @override
  String get noteColorBlue => 'Синий';

  @override
  String get noteColorGreen => 'Зелёный';

  @override
  String get noteColorOrange => 'Оранжевый';

  @override
  String get noteColorWhite => 'Белый';

  @override
  String get recordVoiceNoteTooltip => 'Записать голосовую заметку';

  @override
  String get recordVoiceNoteInstructions =>
      'Нажмите красную кнопку, чтобы начать запись, или ✕ для отмены.';

  @override
  String get stopRecordingTooltip => 'Остановить запись';

  @override
  String get cancelRecordingTooltip => 'Отменить запись';

  @override
  String get addVoiceTimestampButton => 'Добавить метку времени';

  @override
  String get editVoiceTimestampButton => 'Изменить метку времени';

  @override
  String get voiceNoteUnsupportedOnPlatform =>
      'Голосовые заметки не поддерживаются на этом устройстве';

  @override
  String get formatBoldTooltip => 'Жирный';

  @override
  String get formatItalicTooltip => 'Курсив';

  @override
  String get formatHeadingTooltip => 'Заголовок';

  @override
  String get formatListTooltip => 'Маркированный список';

  @override
  String get formatLinkTooltip => 'Ссылка';

  @override
  String get imageSizeSmall => 'Маленький';

  @override
  String get imageSizeMedium => 'Средний';

  @override
  String get imageSizeFull => 'Полная ширина';

  @override
  String get removeImageButton => 'Удалить изображение';

  @override
  String get relayUrlHint => 'wss://relay.example.com';

  @override
  String get noRelaysMessage => 'Пока не настроено ни одного реле.';

  @override
  String relaysCount(int count) {
    return '$count реле';
  }

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get sectionSecurity => 'Безопасность';

  @override
  String get loadingLabel => 'Загрузка…';

  @override
  String get encryptionLoadError => 'Не удалось загрузить настройки шифрования';

  @override
  String get encryptionToggleTitle => 'Защитить заметки паролем';

  @override
  String get encryptionToggleSubtitle =>
      'Шифрует сохранённые заметки (AES-256-GCM) ключом, полученным из вашего пароля. Пароль никогда не сохраняется — если вы его забудете, заметки нельзя будет восстановить.';

  @override
  String get lockNotesNowTitle => 'Заблокировать заметки сейчас';

  @override
  String get lockNotesNowSubtitle => 'Для просмотра заметок снова потребуется пароль';

  @override
  String get setPasswordDialogTitle => 'Установить пароль';

  @override
  String get passwordTooShortError => 'Не менее 8 символов';

  @override
  String get confirmPasswordLabel => 'Подтвердите пароль';

  @override
  String get passwordsDoNotMatchError => 'Пароли не совпадают';

  @override
  String enableEncryptionError(String error) {
    return 'Не удалось включить шифрование: $error';
  }

  @override
  String get enableButton => 'Включить';

  @override
  String get disablePasswordDialogTitle => 'Введите пароль, чтобы отключить шифрование';

  @override
  String get disableButton => 'Отключить';

  @override
  String get sectionAppearance => 'Внешний вид';

  @override
  String get lightThemeToggleTitle => 'Светлая тема';

  @override
  String get lightThemeToggleSubtitle => 'Использовать светлую цветовую схему вместо тёмной';

  @override
  String get noteLayoutToggleTitle => 'Переключение между списком и сеткой';

  @override
  String get manageRelaysTitle => 'Управление реле';

  @override
  String get republishAllNotesButton => 'Переопубликовать все синхронизированные заметки';

  @override
  String get republishAllNotesSubtitle =>
      'Дополняет каждый релей выше заметками, уже опубликованными на других — полезно сразу после добавления нового, например собственного резервного релея';

  @override
  String republishAllNotesSuccess(int count) {
    return 'Переопубликовано $count заметок';
  }

  @override
  String republishAllNotesError(String error) {
    return 'Не удалось переопубликовать заметки: $error';
  }

  @override
  String get forceFullResyncButton => 'Принудительная полная ресинхронизация';

  @override
  String get forceFullResyncSubtitle =>
      'Повторно запрашивает у реле всю историю заметки, а не только новое — полезно, если синхронизация выглядит застрявшей и пропускает старые заметки, например после устранения недоступного реле';

  @override
  String get forceFullResyncSuccess => 'Заметки обновлены с реле';

  @override
  String forceFullResyncError(String error) {
    return 'Не удалось ресинхронизировать заметки: $error';
  }

  @override
  String get confirmButton => 'Подтвердить';

  @override
  String get sectionLanguage => 'Язык';

  @override
  String get langSystem => 'Системный по умолчанию';

  @override
  String get sectionAccount => 'Аккаунт';

  @override
  String get accountLocalOnlyMessage => 'Echoes используется локально — без синхронизации с Nostr';

  @override
  String get accountSignInButton => 'Войти';

  @override
  String accountSignedInAs(String npub) {
    return 'Вы вошли как $npub';
  }

  @override
  String get accountSignOutButton => 'Выйти';

  @override
  String get accountSignOutConfirmTitle => 'Выйти из аккаунта?';

  @override
  String get accountSignOutConfirmBody =>
      'Ваши заметки останутся на этом устройстве. Вы можете войти снова в любое время.';

  @override
  String get onboardingWelcomeTitle => 'Добро пожаловать в Echoes';

  @override
  String get onboardingIntroLocalTitle => 'Ваши заметки всегда на вашем устройстве';

  @override
  String get onboardingIntroLocalBody =>
      'Каждая заметка сначала сохраняется локально, поэтому приложение полностью работает offline. Ничего не покидает ваше устройство, если вы не решите синхронизировать данные.';

  @override
  String get onboardingIntroSyncTitle => 'Необязательная синхронизация через Nostr';

  @override
  String get onboardingIntroSyncBody =>
      'Включите синхронизацию, чтобы создавать резервные копии заметок и читать их на других устройствах, используя открытый протокол Nostr и выбранные вами реле.';

  @override
  String get onboardingIntroEncryptionTitle => 'Всегда зашифровано';

  @override
  String get onboardingIntroEncryptionBody =>
      'Заметки, синхронизированные с Nostr, защищены сквозным шифрованием, поэтому операторы реле — и никто другой — никогда не смогут прочитать их содержимое.';

  @override
  String get onboardingIntroAmberTitle => 'Входите, не раскрывая свой ключ';

  @override
  String get onboardingIntroAmberBody =>
      'Используйте Amber для входа: ваш приватный ключ остаётся в Amber и никогда не передаётся приложению Echoes.';

  @override
  String get onboardingIntroSecurityTitle => 'Безопасность по умолчанию';

  @override
  String get onboardingIntroSecurityBody =>
      'Ваш закрытый ключ хранится в зашифрованном хранилище ключей устройства — либо, при использовании Amber, вообще никогда не попадает в Echoes. Фотографии и голосовые заметки шифруются до того, как покинут устройство. Заметки можно заблокировать паролем, и ничего из этого никогда не включается в резервные копии телефона.';

  @override
  String get onboardingNextButton => 'Далее';

  @override
  String get onboardingBackButton => 'Назад';

  @override
  String get onboardingSkipButton => 'Пропустить — использовать Echoes только локально';

  @override
  String get onboardingRelayTitle => 'Выберите реле для синхронизации';

  @override
  String get onboardingRelayBody =>
      'Реле — это место, где хранятся ваши зашифрованные заметки при синхронизации. Добавьте одно или несколько — эти популярные реле станут хорошим началом:';

  @override
  String get onboardingFinishButton => 'Начать';

  @override
  String get syncNoteTooltip => 'Синхронизировать эту заметку';

  @override
  String get unsyncNoteTooltip => 'Удалить с реле';

  @override
  String get syncSelectedTooltip => 'Синхронизировать выбранные заметки';

  @override
  String get exportSelectedTooltip => 'Экспортировать выбранные заметки';

  @override
  String get deleteSelectedTooltip => 'Удалить выбранные заметки';

  @override
  String syncNoteError(String error) {
    return 'Не удалось синхронизировать заметку: $error';
  }

  @override
  String unsyncNoteError(String error) {
    return 'Не удалось удалить заметку с реле: $error';
  }

  @override
  String deleteNoteRelayError(String error) {
    return 'Заметка удалена локально, но не удалось удалить её с реле: $error';
  }

  @override
  String deleteNotesRelayError(int count) {
    return '$count заметок удалено локально, но не удалось удалить их с реле';
  }

  @override
  String get deletingNotesTitle => 'Удаление заметок…';

  @override
  String deletingNotesProgress(int completed, int total) {
    return 'Удаление $completed из $total';
  }

  @override
  String get syncSelectedSuccess => 'Заметки синхронизированы';

  @override
  String syncSelectedPartialError(int count) {
    return 'Не удалось синхронизировать $count заметок';
  }

  @override
  String get exportConfirmTitle => 'Экспорт заметок';

  @override
  String get exportConfirmBody =>
      'Создаёт файл резервной копии ваших заметок. Он также включает ключи расшифровки для прикреплённых изображений или голосовых заметок — любой, у кого есть этот файл, сможет их прочитать, если он не зашифрован.';

  @override
  String get exportEncryptToggleLabel => 'Зашифровать этот файл';

  @override
  String get exportEncryptToggleSubtitle => 'Рекомендуется — защищает резервную копию паролем';

  @override
  String get exportPasswordDialogTitle => 'Введите свой пароль';

  @override
  String get exportSetPasswordDialogTitle => 'Установите пароль для этого экспорта';

  @override
  String get importPasswordDialogTitle => 'Введите пароль экспорта';

  @override
  String get sectionData => 'Данные';

  @override
  String get exportNotesButton => 'Экспортировать заметки';

  @override
  String get exportNotesSubtitle =>
      'Сохраните все свои заметки в файл, который позже можно будет снова импортировать';

  @override
  String get importNotesButton => 'Импортировать заметки';

  @override
  String get importNotesSubtitle => 'Восстановите заметки из ранее экспортированного файла';

  @override
  String get exportNotesSuccess => 'Заметки экспортированы';

  @override
  String exportNotesError(Object error) {
    return 'Не удалось экспортировать заметки: $error';
  }

  @override
  String importNotesSuccess(int count) {
    return 'Импортировано заметок: $count';
  }

  @override
  String importNotesError(Object error) {
    return 'Не удалось импортировать заметки: $error';
  }

  @override
  String get sectionAttachments => 'Вложения';

  @override
  String get attachmentProviderSubtitle =>
      'Куда загружаются зашифрованные изображения и голосовые заметки при синхронизации';

  @override
  String get attachmentProviderCustom => 'Свой вариант…';

  @override
  String get attachmentCustomUrlLabel => 'URL сервера';

  @override
  String get attachmentProviderHint =>
      'Некоторые публичные серверы (напр. Primal, nostr.build) отклоняют зашифрованные загрузки — они проверяют настоящее содержимое изображения, которым зашифрованные данные никогда не являются. Предпочтите Blossom-сервер, хранящий непрозрачные данные, или укажите «Свой…» на собственный сервер.';

  @override
  String get sectionSupport => 'Поддержка';

  @override
  String get supportEchoesTitle => 'Поддержать Echoes';

  @override
  String lightningAddressCopied(String address) {
    return '⚡ $address скопирован в буфер обмена';
  }

  @override
  String get cancelButton => 'Отмена';

  @override
  String get passwordLabel => 'Пароль';

  @override
  String get invalidPrivateKeyError =>
      'Закрытый ключ недействителен. Введите действительный ключ nsec или hex.';

  @override
  String get wrongPasswordError => 'Неверный пароль';

  @override
  String genericErrorPrefix(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get shareNoteTooltip => 'Поделиться';

  @override
  String get shareNoteTitle => 'Поделиться заметкой';

  @override
  String get shareRecipientFieldLabel => 'npub или открытый ключ получателя';

  @override
  String get shareAddRecipientButton => 'Добавить';

  @override
  String get shareInvalidRecipientError => 'Это не действительный npub или открытый ключ';

  @override
  String get shareRecipientNotFoundError => 'Учётная запись Nostr для этого имени не найдена';

  @override
  String get shareConfirmTitle => 'Поделиться этой заметкой?';

  @override
  String get shareConfirmButton => 'Поделиться';

  @override
  String get shareAlreadyRecipientError => 'Уже предоставлено этому человеку';

  @override
  String get shareCannotShareWithSelfError => 'Нельзя поделиться заметкой с самим собой';

  @override
  String get shareRecipientsHeader => 'Доступно для';

  @override
  String get shareNoRecipientsMessage => 'Пока никому не предоставлено.';

  @override
  String get stopSharingTooltip => 'Прекратить доступ для этого человека';

  @override
  String get shareRevocationNote =>
      'Любой, кому вы предоставили доступ, может читать эту заметку на своём устройстве. Удаление кого-либо прекращает будущие обновления, но не может стереть уже полученное.';

  @override
  String shareError(String error) {
    return 'Не удалось обновить доступ: $error';
  }

  @override
  String get sharedWithMeHeader => 'Доступно вам';

  @override
  String sharedByLabel(String npub) {
    return 'Поделился $npub';
  }

  @override
  String get sharedNoteEditableNote =>
      'Вы можете редактировать эту заметку; ваши изменения синхронизируются обратно владельцу, который их объединяет.';

  @override
  String get abandonSharedNoteButton => 'Покинуть эту общую заметку';

  @override
  String get abandonSharedNoteConfirmTitle => 'Покинуть эту общую заметку?';

  @override
  String get abandonSharedNoteConfirmBody =>
      'Она будет удалена с этого устройства, и вы перестанете получать обновления. Отменить нельзя — вы не сможете присоединиться снова.';

  @override
  String abandonSharedNoteError(String error) {
    return 'Не удалось покинуть: $error';
  }
}
