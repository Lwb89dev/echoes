// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get loginSubtitle => 'Nostrアカウントでサインインしてください';

  @override
  String get loginWithAmberButton => 'Amberでサインイン';

  @override
  String get importAccountButton => 'Nostrアカウントをインポート';

  @override
  String get importAccountFieldLabel => 'Nostrアカウントの秘密鍵（nsec）';

  @override
  String get importButton => 'インポート';

  @override
  String get relaysTitle => 'リレー';

  @override
  String get settingsTooltip => '設定';

  @override
  String get emptyNotesMessage => 'まだメモがありません。+をタップして作成してください。';

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
  String get newPlainNoteOption => 'メモ';

  @override
  String get newChecklistOption => 'チェックリスト';

  @override
  String get newVoiceNoteOption => '音声メモ';

  @override
  String get deleteNoteButton => 'メモを削除';

  @override
  String get deleteNoteConfirmTitle => 'このメモを削除しますか?';

  @override
  String get deleteNoteConfirmBody =>
      'この操作は元に戻せません。このメモが同期されていた場合、リレーからも削除されます。';

  @override
  String deleteNotesConfirmTitle(int count) {
    return '$count件のメモを削除しますか?';
  }

  @override
  String get deleteNotesConfirmBody =>
      'この操作は元に戻せません。これらのメモの一部が同期されていた場合、リレーからも削除されます。';

  @override
  String selectionCount(int count) {
    return '$count件選択中';
  }

  @override
  String get untitledNote => '（無題）';

  @override
  String errorLoadingNotes(String error) {
    return 'メモの読み込みエラー: $error';
  }

  @override
  String get timeJustNow => 'たった今';

  @override
  String timeMinutesAgo(int count) {
    return '$count分前';
  }

  @override
  String timeHoursAgo(int count) {
    return '$count時間前';
  }

  @override
  String timeDaysAgo(int count) {
    return '$count日前';
  }

  @override
  String get notesLockedTitle => 'メモはパスワードで保護されています';

  @override
  String get unlockButton => 'ロック解除';

  @override
  String get newNoteTitle => '新しいメモ';

  @override
  String get editNoteTitle => 'メモを編集';

  @override
  String get newDiaryEntryTitle => 'New diary entry';

  @override
  String get editDiaryEntryTitle => 'Edit diary entry';

  @override
  String get saveTooltip => '保存';

  @override
  String get titleFieldLabel => 'タイトル';

  @override
  String get checklistLabel => 'チェックリスト';

  @override
  String get bodyFieldHint => 'ここに入力...（markdown対応）';

  @override
  String get checklistItemHint => 'チェックリスト項目';

  @override
  String get addItemButton => '項目を追加';

  @override
  String get addImageButton => '画像を追加';

  @override
  String get recordVoiceNoteTooltip => '音声メモを録音';

  @override
  String get stopRecordingTooltip => '録音を停止';

  @override
  String get cancelRecordingTooltip => '録音をキャンセル';

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
  String get imageSizeFull => '全幅';

  @override
  String get removeImageButton => '画像を削除';

  @override
  String get relayUrlHint => 'wss://relay.example.com';

  @override
  String get noRelaysMessage => 'リレーがまだ設定されていません。';

  @override
  String relaysCount(int count) {
    return '$count 件のリレー';
  }

  @override
  String get settingsTitle => '設定';

  @override
  String get sectionSecurity => 'セキュリティ';

  @override
  String get loadingLabel => '読み込み中…';

  @override
  String get encryptionLoadError => '暗号化設定を読み込めませんでした';

  @override
  String get encryptionToggleTitle => 'パスワードでメモを保護する';

  @override
  String get encryptionToggleSubtitle =>
      'パスワードから導出した鍵で保存済みメモを暗号化します（AES-256-GCM）。パスワードは保存されません — 忘れるとメモは復元できません。';

  @override
  String get lockNotesNowTitle => '今すぐメモをロック';

  @override
  String get lockNotesNowSubtitle => 'メモを表示するには再度パスワードが必要です';

  @override
  String get setPasswordDialogTitle => 'パスワードを設定';

  @override
  String get passwordTooShortError => '8文字以上で入力してください';

  @override
  String get confirmPasswordLabel => 'パスワードの確認';

  @override
  String get passwordsDoNotMatchError => 'パスワードが一致しません';

  @override
  String enableEncryptionError(String error) {
    return '暗号化を有効にできませんでした: $error';
  }

  @override
  String get enableButton => '有効にする';

  @override
  String get disablePasswordDialogTitle => '暗号化を無効にするにはパスワードを入力してください';

  @override
  String get disableButton => '無効にする';

  @override
  String get sectionAppearance => '外観';

  @override
  String get lightThemeToggleTitle => 'ライトテーマ';

  @override
  String get lightThemeToggleSubtitle => 'ダークの代わりにライトカラーを使用します';

  @override
  String get noteLayoutToggleTitle => 'メモリストのレイアウト';

  @override
  String get noteLayoutToggleSubtitle => 'リスト表示とグリッド表示を切り替えます';

  @override
  String get manageRelaysTitle => 'リレーを管理';

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
  String get confirmButton => '確認';

  @override
  String get sectionLanguage => '言語';

  @override
  String get langSystem => 'システムのデフォルト';

  @override
  String get sectionAccount => 'アカウント';

  @override
  String get accountLocalOnlyMessage => 'Echoesをローカルで使用中 — Nostrとは同期していません';

  @override
  String get accountSignInButton => 'サインイン';

  @override
  String accountSignedInAs(String npub) {
    return '$npub としてサインイン中';
  }

  @override
  String get accountSignOutButton => 'サインアウト';

  @override
  String get accountSignOutConfirmTitle => 'サインアウトしますか？';

  @override
  String get accountSignOutConfirmBody => 'メモはこの端末に残ります。いつでも再度サインインできます。';

  @override
  String get onboardingWelcomeTitle => 'Echoesへようこそ';

  @override
  String get onboardingIntroLocalTitle => 'あなたのメモは、常に端末上に';

  @override
  String get onboardingIntroLocalBody =>
      'すべてのメモはまずローカルに保存されるため、アプリは完全にオフラインでも動作します。同期を選択しない限り、データが端末から出ることはありません。';

  @override
  String get onboardingIntroSyncTitle => 'Nostrによる任意の同期';

  @override
  String get onboardingIntroSyncBody =>
      '同期をオンにすると、オープンなNostrプロトコルと選択したリレーを使って、メモをバックアップし他の端末で読むことができます。';

  @override
  String get onboardingIntroEncryptionTitle => '常に暗号化';

  @override
  String get onboardingIntroEncryptionBody =>
      'Nostrに同期されたメモはエンドツーエンドで暗号化されているため、リレー運営者を含め誰もその内容を読むことはできません。';

  @override
  String get onboardingIntroAmberTitle => '鍵を公開せずにサインイン';

  @override
  String get onboardingIntroAmberBody =>
      'Amberを使ってサインインすれば、秘密鍵はAmber内に保持され、Echoesと共有されることはありません。';

  @override
  String get onboardingIntroSecurityTitle => '設計段階からのセキュリティ';

  @override
  String get onboardingIntroSecurityBody =>
      '秘密鍵はデバイスの暗号化されたキーストアに保存されます — Amberを使用する場合はEchoesに一切触れません。写真と音声メモはデバイスを離れる前に暗号化されます。メモはパスワードでロックでき、これらは電話のバックアップに含まれることは決してありません。';

  @override
  String get onboardingNextButton => '次へ';

  @override
  String get onboardingBackButton => '戻る';

  @override
  String get onboardingSkipButton => 'スキップ — Echoesをローカルのみで使用';

  @override
  String get onboardingRelayTitle => '同期用のリレーを選択';

  @override
  String get onboardingRelayBody =>
      'リレーは同期時に暗号化されたメモが保存される場所です。1つ以上追加してください — 以下の人気リレーから始めるのがおすすめです：';

  @override
  String get onboardingFinishButton => 'はじめる';

  @override
  String get syncNoteTooltip => 'このメモを同期';

  @override
  String get unsyncNoteTooltip => 'リレーから削除';

  @override
  String get syncSelectedTooltip => '選択したメモを同期';

  @override
  String get exportSelectedTooltip => '選択したメモをエクスポート';

  @override
  String get deleteSelectedTooltip => '選択したメモを削除';

  @override
  String syncNoteError(String error) {
    return 'メモを同期できませんでした: $error';
  }

  @override
  String unsyncNoteError(String error) {
    return 'リレーからメモを削除できませんでした: $error';
  }

  @override
  String deleteNoteRelayError(String error) {
    return 'メモはローカルで削除されましたが、リレーからは削除できませんでした: $error';
  }

  @override
  String deleteNotesRelayError(int count) {
    return '$count件のメモはローカルで削除されましたが、リレーからは削除できませんでした';
  }

  @override
  String get deletingNotesTitle => 'メモを削除中…';

  @override
  String deletingNotesProgress(int completed, int total) {
    return '$completed/$total を削除中';
  }

  @override
  String get syncSelectedSuccess => 'メモを同期しました';

  @override
  String syncSelectedPartialError(int count) {
    return '$count件のメモを同期できませんでした';
  }

  @override
  String get exportConfirmTitle => 'メモをエクスポート';

  @override
  String get exportConfirmBody =>
      'メモのバックアップファイルを作成します。添付された画像や音声メモの復号鍵も含まれます — 暗号化されていない限り、ファイルを持つ人は誰でもそれらを読むことができます。';

  @override
  String get exportEncryptToggleLabel => 'このファイルを暗号化';

  @override
  String get exportEncryptToggleSubtitle => '推奨 — パスワードでバックアップを保護します';

  @override
  String get exportPasswordDialogTitle => 'パスワードを入力';

  @override
  String get exportSetPasswordDialogTitle => 'このエクスポート用のパスワードを設定';

  @override
  String get importPasswordDialogTitle => 'エクスポートのパスワードを入力';

  @override
  String get sectionData => 'データ';

  @override
  String get exportNotesButton => 'メモをエクスポート';

  @override
  String get exportNotesSubtitle => 'すべてのメモをファイルに保存し、後で再度インポートできます';

  @override
  String get importNotesButton => 'メモをインポート';

  @override
  String get importNotesSubtitle => '以前にエクスポートしたファイルからメモを復元します';

  @override
  String get exportNotesSuccess => 'メモをエクスポートしました';

  @override
  String exportNotesError(Object error) {
    return 'メモをエクスポートできませんでした: $error';
  }

  @override
  String importNotesSuccess(int count) {
    return '$count 件のメモをインポートしました';
  }

  @override
  String importNotesError(Object error) {
    return 'メモをインポートできませんでした: $error';
  }

  @override
  String get sectionAttachments => '添付ファイル';

  @override
  String get attachmentProviderSubtitle => '同期時に暗号化された画像や音声メモがアップロードされる場所';

  @override
  String get attachmentProviderCustom => 'カスタム…';

  @override
  String get attachmentCustomUrlLabel => 'サーバーURL';

  @override
  String get attachmentProviderHint =>
      'Some public hosts (e.g. Primal, nostr.build) reject encrypted uploads outright — they validate real image content, which ciphertext never is. Prefer a Blossom host that stores opaque blobs, or point Custom… at a self-hosted one.';

  @override
  String get sectionSupport => 'サポート';

  @override
  String get supportEchoesTitle => 'Echoesを応援する';

  @override
  String lightningAddressCopied(String address) {
    return '⚡ $address をクリップボードにコピーしました';
  }

  @override
  String get cancelButton => 'キャンセル';

  @override
  String get passwordLabel => 'パスワード';

  @override
  String get invalidPrivateKeyError => '秘密鍵が無効です。有効な nsec または hex キーを入力してください。';

  @override
  String get wrongPasswordError => 'パスワードが違います';

  @override
  String genericErrorPrefix(String error) {
    return 'エラー: $error';
  }
}
