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
  String get emptyNotesMessage => '还没有笔记。点击 + 创建一条。';

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
  String get newNoteTitle => '新建笔记';

  @override
  String get editNoteTitle => '编辑笔记';

  @override
  String get newDiaryEntryTitle => 'New diary entry';

  @override
  String get editDiaryEntryTitle => 'Edit diary entry';

  @override
  String get saveTooltip => '保存';

  @override
  String get titleFieldLabel => '标题';

  @override
  String get checklistLabel => '清单';

  @override
  String get bodyFieldHint => '在此输入...（支持 markdown）';

  @override
  String get checklistItemHint => '清单项';

  @override
  String get addItemButton => '添加项目';

  @override
  String get addImageButton => '添加图片';

  @override
  String get recordVoiceNoteTooltip => '录制语音笔记';

  @override
  String get stopRecordingTooltip => '停止录音';

  @override
  String get cancelRecordingTooltip => '取消录音';

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
  String get noteLayoutToggleTitle => '笔记列表布局';

  @override
  String get noteLayoutToggleSubtitle => '在列表视图和网格视图之间切换';

  @override
  String get manageRelaysTitle => '管理中继';

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
      'Some public hosts (e.g. Primal, nostr.build) reject encrypted uploads outright — they validate real image content, which ciphertext never is. Prefer a Blossom host that stores opaque blobs, or point Custom… at a self-hosted one.';

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
}
