// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get loginSubtitle => '使用您的 Nostr 账户登录';

  @override
  String get loginWithAmberButton => '使用 Amber 登录';

  @override
  String get importAccountButton => '导入 Nostr 账户';

  @override
  String get importAccountFieldLabel => '您 Nostr 账户的私钥（nsec）';

  @override
  String get importButton => '导入';

  @override
  String get relaysTitle => '中继';

  @override
  String get settingsTooltip => '设置';

  @override
  String get searchTooltip => '搜索';

  @override
  String get closeSearchTooltip => '关闭搜索';

  @override
  String get searchNotesHint => '搜索笔记';

  @override
  String get noSearchResultsMessage => '没有匹配项。';

  @override
  String get emptyNotesMessage => '还没有笔记。点击 + 创建一条。';

  @override
  String get notesTabLabel => '笔记';

  @override
  String get diaryTabLabel => '日记';

  @override
  String get emptyDiaryMessage => '还没有日记。点按 + 写一篇。';

  @override
  String get diaryToday => '今天';

  @override
  String get diaryYesterday => '昨天';

  @override
  String get newPlainNoteOption => '笔记';

  @override
  String get newChecklistOption => '清单';

  @override
  String get newVoiceNoteOption => '语音笔记';

  @override
  String get deleteNoteButton => '删除笔记';

  @override
  String get deleteNoteConfirmTitle => '删除这条笔记？';

  @override
  String get deleteNoteConfirmBody => '此操作无法撤销。如果此笔记已同步，也会从您的中继中移除。';

  @override
  String deleteNotesConfirmTitle(int count) {
    return '删除$count条笔记？';
  }

  @override
  String get deleteNotesConfirmBody => '此操作无法撤销。如果其中任何一条笔记已同步，也会从您的中继中移除。';

  @override
  String selectionCount(int count) {
    return '已选择$count条';
  }

  @override
  String get untitledNote => '（无标题）';

  @override
  String errorLoadingNotes(String error) {
    return '加载笔记时出错：$error';
  }

  @override
  String get timeJustNow => '刚刚';

  @override
  String timeMinutesAgo(int count) {
    return '$count分钟前';
  }

  @override
  String timeHoursAgo(int count) {
    return '$count小时前';
  }

  @override
  String timeDaysAgo(int count) {
    return '$count天前';
  }

  @override
  String get notesLockedTitle => '笔记已通过密码保护';

  @override
  String get unlockButton => '解锁';

  @override
  String get saveTooltip => '保存';

  @override
  String get titleFieldLabel => '标题';

  @override
  String get bodyFieldHint => '在此输入...（支持 markdown）';

  @override
  String get checklistItemHint => '清单项';

  @override
  String get addItemButton => '添加项目';

  @override
  String checklistProgress(int done, int total) {
    return '已完成 $done/$total';
  }

  @override
  String get showCompletedItemsTooltip => '显示已完成项';

  @override
  String get hideCompletedItemsTooltip => '隐藏已完成项';

  @override
  String get allChecklistItemsCompletedHidden => '所有项目均已完成并隐藏。';

  @override
  String get deleteCompletedItemsButton => '删除已完成项';

  @override
  String get deleteCompletedItemsConfirmTitle => '删除已完成项？';

  @override
  String deleteCompletedItemsConfirmBody(int count) {
    return '将从此清单中移除 $count 个已勾选的项目。此操作无法撤销。';
  }

  @override
  String get addImageButton => '添加图片';

  @override
  String get noteColorButton => '笔记颜色';

  @override
  String get noteColorDefault => '默认';

  @override
  String get noteColorYellow => '黄色';

  @override
  String get noteColorRed => '红色';

  @override
  String get noteColorPurple => '紫色';

  @override
  String get noteColorBlue => '蓝色';

  @override
  String get noteColorGreen => '绿色';

  @override
  String get noteColorOrange => '橙色';

  @override
  String get noteColorWhite => '白色';

  @override
  String get recordVoiceNoteTooltip => '录制语音笔记';

  @override
  String get recordVoiceNoteInstructions => '点按红色按钮开始录音，或点按 ✕ 取消。';

  @override
  String get stopRecordingTooltip => '停止录音';

  @override
  String get cancelRecordingTooltip => '取消录音';

  @override
  String get addVoiceTimestampButton => '添加时间戳';

  @override
  String get editVoiceTimestampButton => '编辑时间戳';

  @override
  String get voiceNoteUnsupportedOnPlatform => '此设备不支持语音笔记';

  @override
  String get formatBoldTooltip => '粗体';

  @override
  String get formatItalicTooltip => '斜体';

  @override
  String get formatHeadingTooltip => '标题';

  @override
  String get formatListTooltip => '项目符号列表';

  @override
  String get formatLinkTooltip => '链接';

  @override
  String get imageSizeSmall => '小';

  @override
  String get imageSizeMedium => '中';

  @override
  String get imageSizeFull => '全宽';

  @override
  String get removeImageButton => '移除图片';

  @override
  String get relayUrlHint => 'wss://relay.example.com';

  @override
  String get noRelaysMessage => '尚未配置任何中继。';

  @override
  String relaysCount(int count) {
    return '$count 个中继';
  }

  @override
  String get settingsTitle => '设置';

  @override
  String get sectionSecurity => '安全';

  @override
  String get loadingLabel => '加载中…';

  @override
  String get encryptionLoadError => '无法加载加密设置';

  @override
  String get encryptionToggleTitle => '使用密码保护笔记';

  @override
  String get encryptionToggleSubtitle =>
      '使用从您的密码派生的密钥对已保存的笔记进行加密（AES-256-GCM）。密码永远不会被存储——如果忘记密码，笔记将无法恢复。';

  @override
  String get lockNotesNowTitle => '立即锁定笔记';

  @override
  String get lockNotesNowSubtitle => '再次查看笔记需要重新输入密码';

  @override
  String get setPasswordDialogTitle => '设置密码';

  @override
  String get passwordTooShortError => '至少 8 个字符';

  @override
  String get confirmPasswordLabel => '确认密码';

  @override
  String get passwordsDoNotMatchError => '两次输入的密码不一致';

  @override
  String enableEncryptionError(String error) {
    return '无法启用加密：$error';
  }

  @override
  String get enableButton => '启用';

  @override
  String get disablePasswordDialogTitle => '输入密码以禁用加密';

  @override
  String get disableButton => '禁用';

  @override
  String get sectionAppearance => '外观';

  @override
  String get lightThemeToggleTitle => '浅色主题';

  @override
  String get lightThemeToggleSubtitle => '使用浅色配色方案而非深色';

  @override
  String get noteLayoutToggleTitle => '在列表和网格视图间切换';

  @override
  String get manageRelaysTitle => '管理中继';

  @override
  String get republishAllNotesButton => '重新发布所有已同步的笔记';

  @override
  String get republishAllNotesSubtitle =>
      '用已在其他地方分享的笔记补齐上方每个中继 — 在刚添加新中继（如自托管备份中继）后很有用';

  @override
  String republishAllNotesSuccess(int count) {
    return '已重新发布 $count 条笔记';
  }

  @override
  String republishAllNotesError(String error) {
    return '无法重新发布笔记：$error';
  }

  @override
  String get forceFullResyncButton => '强制完全重新同步';

  @override
  String get forceFullResyncSubtitle =>
      '重新向中继请求笔记的完整历史记录，而不仅仅是新内容——如果同步似乎卡住并跳过了较旧的笔记（例如修复无法访问的中继后），这很有用';

  @override
  String get forceFullResyncSuccess => '已从中继刷新笔记';

  @override
  String forceFullResyncError(String error) {
    return '无法重新同步笔记：$error';
  }

  @override
  String get confirmButton => '确认';

  @override
  String get sectionLanguage => '语言';

  @override
  String get langSystem => '系统默认';

  @override
  String get sectionAccount => '账户';

  @override
  String get accountLocalOnlyMessage => '正在本地使用 Echoes——未与 Nostr 同步';

  @override
  String get accountSignInButton => '登录';

  @override
  String accountSignedInAs(String npub) {
    return '已以 $npub 身份登录';
  }

  @override
  String get accountSignOutButton => '退出登录';

  @override
  String get accountSignOutConfirmTitle => '要退出登录吗？';

  @override
  String get accountSignOutConfirmBody => '您的笔记将保留在此设备上。您可以随时重新登录。';

  @override
  String get onboardingWelcomeTitle => '欢迎使用 Echoes';

  @override
  String get onboardingIntroLocalTitle => '您的笔记，始终在您的设备上';

  @override
  String get onboardingIntroLocalBody =>
      '每条笔记都会先保存在本地，因此应用可以完全离线使用。除非您选择同步，否则任何内容都不会离开您的设备。';

  @override
  String get onboardingIntroSyncTitle => '通过 Nostr 进行可选同步';

  @override
  String get onboardingIntroSyncBody =>
      '开启同步以备份您的笔记，并使用开放的 Nostr 协议和您选择的中继在其他设备上阅读它们。';

  @override
  String get onboardingIntroEncryptionTitle => '始终加密';

  @override
  String get onboardingIntroEncryptionBody =>
      '同步到 Nostr 的笔记均经过端到端加密，因此中继运营者及其他任何人都无法读取其内容。';

  @override
  String get onboardingIntroAmberTitle => '登录时无需暴露您的密钥';

  @override
  String get onboardingIntroAmberBody =>
      '使用 Amber 登录：您的私钥保留在 Amber 中，绝不会与 Echoes 共享。';

  @override
  String get onboardingIntroSecurityTitle => '设计即安全';

  @override
  String get onboardingIntroSecurityBody =>
      '您的私钥保存在设备的加密密钥库中——如果使用 Amber，则完全不会接触 Echoes。照片和语音笔记在离开设备之前就已加密。笔记可以用密码锁定，且这些内容永远不会包含在手机备份中。';

  @override
  String get onboardingNextButton => '下一步';

  @override
  String get onboardingBackButton => '返回';

  @override
  String get onboardingSkipButton => '跳过——仅在本地使用 Echoes';

  @override
  String get onboardingRelayTitle => '选择用于同步的中继';

  @override
  String get onboardingRelayBody => '中继是您同步时加密笔记的存储位置。添加一个或多个——以下这些热门中继是不错的起点：';

  @override
  String get onboardingFinishButton => '开始使用';

  @override
  String get syncNoteTooltip => '同步此笔记';

  @override
  String get unsyncNoteTooltip => '从中继移除';

  @override
  String get syncSelectedTooltip => '同步所选笔记';

  @override
  String get exportSelectedTooltip => '导出所选笔记';

  @override
  String get deleteSelectedTooltip => '删除所选笔记';

  @override
  String syncNoteError(String error) {
    return '无法同步笔记：$error';
  }

  @override
  String unsyncNoteError(String error) {
    return '无法从中继移除笔记：$error';
  }

  @override
  String deleteNoteRelayError(String error) {
    return '笔记已在本地删除，但无法从中继中移除：$error';
  }

  @override
  String deleteNotesRelayError(int count) {
    return '$count条笔记已在本地删除，但无法从中继中移除';
  }

  @override
  String get deletingNotesTitle => '正在删除笔记…';

  @override
  String deletingNotesProgress(int completed, int total) {
    return '正在删除 $completed/$total';
  }

  @override
  String get syncSelectedSuccess => '笔记已同步';

  @override
  String syncSelectedPartialError(int count) {
    return '无法同步$count条笔记';
  }

  @override
  String get exportConfirmTitle => '导出笔记';

  @override
  String get exportConfirmBody =>
      '创建笔记的备份文件。其中还包含所附图片或语音笔记的解密密钥——除非文件已加密，否则任何持有该文件的人都可以读取它们。';

  @override
  String get exportEncryptToggleLabel => '加密此文件';

  @override
  String get exportEncryptToggleSubtitle => '推荐——使用密码保护备份';

  @override
  String get exportPasswordDialogTitle => '输入您的密码';

  @override
  String get exportSetPasswordDialogTitle => '为此次导出设置密码';

  @override
  String get importPasswordDialogTitle => '输入导出文件的密码';

  @override
  String get sectionData => '数据';

  @override
  String get exportNotesButton => '导出笔记';

  @override
  String get exportNotesSubtitle => '将所有笔记保存到文件中，以便日后重新导入';

  @override
  String get importNotesButton => '导入笔记';

  @override
  String get importNotesSubtitle => '从之前导出的文件恢复笔记';

  @override
  String get exportNotesSuccess => '笔记已导出';

  @override
  String exportNotesError(Object error) {
    return '无法导出笔记：$error';
  }

  @override
  String importNotesSuccess(int count) {
    return '已导入 $count 条笔记';
  }

  @override
  String importNotesError(Object error) {
    return '无法导入笔记：$error';
  }

  @override
  String get sectionAttachments => '附件';

  @override
  String get attachmentProviderSubtitle => '同步时加密的图片和语音笔记上传到的位置';

  @override
  String get attachmentProviderCustom => '自定义…';

  @override
  String get attachmentCustomUrlLabel => '服务器URL';

  @override
  String get attachmentProviderHint =>
      '部分公共主机（如 Primal、nostr.build）会直接拒绝加密上传 — 它们校验真实图片内容，而加密数据永远不是。请选择存储不透明数据的 Blossom 主机，或将「自定义…」指向自托管主机。';

  @override
  String get sectionSupport => '支持';

  @override
  String get supportEchoesTitle => '支持 Echoes';

  @override
  String lightningAddressCopied(String address) {
    return '⚡ $address 已复制到剪贴板';
  }

  @override
  String get cancelButton => '取消';

  @override
  String get passwordLabel => '密码';

  @override
  String get invalidPrivateKeyError => '私钥无效。请输入有效的 nsec 或十六进制密钥。';

  @override
  String get wrongPasswordError => '密码错误';

  @override
  String genericErrorPrefix(String error) {
    return '错误：$error';
  }

  @override
  String get shareNoteTooltip => '分享';

  @override
  String get shareNoteTitle => '分享笔记';

  @override
  String get shareRecipientFieldLabel => '接收者的 npub 或公钥';

  @override
  String get shareAddRecipientButton => '添加';

  @override
  String get shareInvalidRecipientError => '这不是有效的 npub 或公钥';

  @override
  String get shareRecipientNotFoundError => '找不到该名称对应的 Nostr 账户';

  @override
  String get shareConfirmTitle => '要分享这条笔记吗?';

  @override
  String get shareConfirmButton => '分享';

  @override
  String get shareAlreadyRecipientError => '已与此人分享';

  @override
  String get shareCannotShareWithSelfError => '不能把笔记分享给自己';

  @override
  String get shareRecipientsHeader => '已分享给';

  @override
  String get shareNoRecipientsMessage => '尚未与任何人分享。';

  @override
  String get stopSharingTooltip => '停止与此人分享';

  @override
  String get shareRevocationNote =>
      '任何被分享的人都能在其设备上阅读此笔记。移除某人会停止之后的更新，但无法删除其已收到的内容。';

  @override
  String shareError(String error) {
    return '无法更新分享：$error';
  }

  @override
  String get sharedWithMeHeader => '已分享给你';

  @override
  String sharedByLabel(String npub) {
    return '由 $npub 分享';
  }

  @override
  String get sharedNoteEditableNote => '你可以编辑此笔记；你的更改会同步回所有者，由其合并。';

  @override
  String get abandonSharedNoteButton => '退出此共享笔记';

  @override
  String get abandonSharedNoteConfirmTitle => '退出此共享笔记？';

  @override
  String get abandonSharedNoteConfirmBody =>
      '它将从此设备移除，你将不再收到更新。此操作无法撤销——之后你将无法重新加入。';

  @override
  String abandonSharedNoteError(String error) {
    return '无法退出：$error';
  }
}
