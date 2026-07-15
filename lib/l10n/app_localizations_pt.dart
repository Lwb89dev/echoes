// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get loginSubtitle => 'Inicia sessão com a tua conta Nostr';

  @override
  String get loginWithAmberButton => 'Iniciar sessão com Amber';

  @override
  String get importAccountButton => 'Importar conta Nostr';

  @override
  String get importAccountFieldLabel =>
      'Chave privada (nsec) da tua conta Nostr';

  @override
  String get importButton => 'Importar';

  @override
  String get relaysTitle => 'Relays';

  @override
  String get settingsTooltip => 'Definições';

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
      'Ainda não há notas. Toca em + para criar uma.';

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
  String get newPlainNoteOption => 'Nota';

  @override
  String get newChecklistOption => 'Lista de verificação';

  @override
  String get newVoiceNoteOption => 'Nota de voz';

  @override
  String get deleteNoteButton => 'Eliminar nota';

  @override
  String get deleteNoteConfirmTitle => 'Eliminar esta nota?';

  @override
  String get deleteNoteConfirmBody =>
      'Esta ação não pode ser desfeita. Se esta nota estava sincronizada, também será removida dos seus relés.';

  @override
  String deleteNotesConfirmTitle(int count) {
    return 'Eliminar $count notas?';
  }

  @override
  String get deleteNotesConfirmBody =>
      'Esta ação não pode ser desfeita. Se alguma destas notas estava sincronizada, também será removida dos seus relés.';

  @override
  String selectionCount(int count) {
    return '$count selecionadas';
  }

  @override
  String get untitledNote => '(sem título)';

  @override
  String errorLoadingNotes(String error) {
    return 'Erro ao carregar as notas: $error';
  }

  @override
  String get timeJustNow => 'agora';

  @override
  String timeMinutesAgo(int count) {
    return 'há $count min';
  }

  @override
  String timeHoursAgo(int count) {
    return 'há $count h';
  }

  @override
  String timeDaysAgo(int count) {
    return 'há $count d';
  }

  @override
  String get notesLockedTitle => 'As notas estão protegidas por palavra-passe';

  @override
  String get unlockButton => 'Desbloquear';

  @override
  String get saveTooltip => 'Guardar';

  @override
  String get titleFieldLabel => 'Título';

  @override
  String get checklistLabel => 'Lista de verificação';

  @override
  String get bodyFieldHint => 'Escreve aqui... (markdown suportado)';

  @override
  String get checklistItemHint => 'Item da lista';

  @override
  String get addItemButton => 'Adicionar item';

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
  String get addImageButton => 'Adicionar imagem';

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
  String get recordVoiceNoteTooltip => 'Gravar uma nota de voz';

  @override
  String get recordVoiceNoteInstructions =>
      'Tap the red button to start recording, or ✕ to cancel.';

  @override
  String get stopRecordingTooltip => 'Parar gravação';

  @override
  String get cancelRecordingTooltip => 'Cancelar gravação';

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
  String get imageSizeSmall => 'Pequena';

  @override
  String get imageSizeMedium => 'Média';

  @override
  String get imageSizeFull => 'Largura total';

  @override
  String get removeImageButton => 'Remover imagem';

  @override
  String get relayUrlHint => 'wss://relay.example.com';

  @override
  String get noRelaysMessage => 'Ainda não há nenhum relay configurado.';

  @override
  String relaysCount(int count) {
    return '$count relés';
  }

  @override
  String get settingsTitle => 'Definições';

  @override
  String get sectionSecurity => 'Segurança';

  @override
  String get loadingLabel => 'A carregar…';

  @override
  String get encryptionLoadError =>
      'Não foi possível carregar as definições de encriptação';

  @override
  String get encryptionToggleTitle => 'Proteger notas com palavra-passe';

  @override
  String get encryptionToggleSubtitle =>
      'Encripta as notas guardadas (AES-256-GCM) com uma chave derivada da tua palavra-passe. A palavra-passe nunca é guardada — se a esqueceres, as notas não poderão ser recuperadas.';

  @override
  String get lockNotesNowTitle => 'Bloquear notas agora';

  @override
  String get lockNotesNowSubtitle =>
      'Será necessário voltar a introduzir a palavra-passe para ver as notas';

  @override
  String get setPasswordDialogTitle => 'Definir uma palavra-passe';

  @override
  String get passwordTooShortError => 'Pelo menos 8 caracteres';

  @override
  String get confirmPasswordLabel => 'Confirmar palavra-passe';

  @override
  String get passwordsDoNotMatchError => 'As palavras-passe não coincidem';

  @override
  String enableEncryptionError(String error) {
    return 'Não foi possível ativar a encriptação: $error';
  }

  @override
  String get enableButton => 'Ativar';

  @override
  String get disablePasswordDialogTitle =>
      'Introduz a tua palavra-passe para desativar a encriptação';

  @override
  String get disableButton => 'Desativar';

  @override
  String get sectionAppearance => 'Aparência';

  @override
  String get lightThemeToggleTitle => 'Tema claro';

  @override
  String get lightThemeToggleSubtitle =>
      'Usar um esquema de cores claro em vez de escuro';

  @override
  String get noteLayoutToggleTitle => 'Esquema da lista de notas';

  @override
  String get manageRelaysTitle => 'Gerir relés';

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
  String get confirmButton => 'Confirmar';

  @override
  String get sectionLanguage => 'Idioma';

  @override
  String get langSystem => 'Predefinição do sistema';

  @override
  String get sectionAccount => 'Conta';

  @override
  String get accountLocalOnlyMessage =>
      'A usar o Echoes localmente — não sincronizado com o Nostr';

  @override
  String get accountSignInButton => 'Iniciar sessão';

  @override
  String accountSignedInAs(String npub) {
    return 'Sessão iniciada como $npub';
  }

  @override
  String get accountSignOutButton => 'Terminar sessão';

  @override
  String get accountSignOutConfirmTitle => 'Terminar sessão?';

  @override
  String get accountSignOutConfirmBody =>
      'As tuas notas permanecem neste dispositivo. Podes iniciar sessão novamente a qualquer momento.';

  @override
  String get onboardingWelcomeTitle => 'Bem-vindo ao Echoes';

  @override
  String get onboardingIntroLocalTitle =>
      'As tuas notas, sempre no teu dispositivo';

  @override
  String get onboardingIntroLocalBody =>
      'Cada nota é guardada primeiro localmente, pelo que a app funciona totalmente offline. Nada sai do teu dispositivo, a menos que escolhas sincronizar.';

  @override
  String get onboardingIntroSyncTitle => 'Sincronização opcional via Nostr';

  @override
  String get onboardingIntroSyncBody =>
      'Ativa a sincronização para fazer cópia de segurança das tuas notas e lê-las noutros dispositivos, usando o protocolo aberto Nostr e os relays à tua escolha.';

  @override
  String get onboardingIntroEncryptionTitle => 'Sempre encriptadas';

  @override
  String get onboardingIntroEncryptionBody =>
      'As notas sincronizadas com o Nostr são encriptadas de ponta a ponta, pelo que os operadores de relay — e mais ninguém — podem alguma vez ler o seu conteúdo.';

  @override
  String get onboardingIntroAmberTitle => 'Inicia sessão sem expor a tua chave';

  @override
  String get onboardingIntroAmberBody =>
      'Usa o Amber para iniciar sessão: a tua chave privada permanece no Amber e nunca é partilhada com o Echoes.';

  @override
  String get onboardingIntroSecurityTitle => 'Segurança desde a conceção';

  @override
  String get onboardingIntroSecurityBody =>
      'A sua chave privada reside no armazenamento de chaves encriptado do seu dispositivo — ou, com o Amber, nunca chega a tocar no Echoes. As fotos e notas de voz são encriptadas antes de saírem do seu dispositivo. As notas podem ser bloqueadas com uma palavra-passe, e nada disto é incluído nas cópias de segurança do telemóvel.';

  @override
  String get onboardingNextButton => 'Seguinte';

  @override
  String get onboardingBackButton => 'Anterior';

  @override
  String get onboardingSkipButton => 'Saltar — usar o Echoes apenas localmente';

  @override
  String get onboardingRelayTitle => 'Escolhe relays para sincronização';

  @override
  String get onboardingRelayBody =>
      'Os relays são onde as tuas notas encriptadas são guardadas quando sincronizas. Adiciona um ou mais — estes populares são um bom começo:';

  @override
  String get onboardingFinishButton => 'Começar';

  @override
  String get syncNoteTooltip => 'Sincronizar esta nota';

  @override
  String get unsyncNoteTooltip => 'Remover dos relés';

  @override
  String get syncSelectedTooltip => 'Sincronizar notas selecionadas';

  @override
  String get exportSelectedTooltip => 'Exportar notas selecionadas';

  @override
  String get deleteSelectedTooltip => 'Eliminar notas selecionadas';

  @override
  String syncNoteError(String error) {
    return 'Não foi possível sincronizar a nota: $error';
  }

  @override
  String unsyncNoteError(String error) {
    return 'Não foi possível remover a nota dos relés: $error';
  }

  @override
  String deleteNoteRelayError(String error) {
    return 'Nota eliminada localmente, mas não foi possível removê-la dos relés: $error';
  }

  @override
  String deleteNotesRelayError(int count) {
    return '$count notas eliminadas localmente, mas não foi possível removê-las dos relés';
  }

  @override
  String get deletingNotesTitle => 'Excluindo notas…';

  @override
  String deletingNotesProgress(int completed, int total) {
    return 'Excluindo $completed de $total';
  }

  @override
  String get syncSelectedSuccess => 'Notas sincronizadas';

  @override
  String syncSelectedPartialError(int count) {
    return 'Não foi possível sincronizar $count notas';
  }

  @override
  String get exportConfirmTitle => 'Exportar notas';

  @override
  String get exportConfirmBody =>
      'Cria um ficheiro de cópia de segurança das suas notas. Também inclui as chaves de desencriptação de quaisquer imagens ou notas de voz anexadas — qualquer pessoa com o ficheiro poderia lê-las, a menos que esteja encriptado.';

  @override
  String get exportEncryptToggleLabel => 'Encriptar este ficheiro';

  @override
  String get exportEncryptToggleSubtitle =>
      'Recomendado — protege a cópia de segurança com uma palavra-passe';

  @override
  String get exportPasswordDialogTitle => 'Introduza a sua palavra-passe';

  @override
  String get exportSetPasswordDialogTitle =>
      'Defina uma palavra-passe para esta exportação';

  @override
  String get importPasswordDialogTitle =>
      'Introduza a palavra-passe da exportação';

  @override
  String get sectionData => 'Dados';

  @override
  String get exportNotesButton => 'Exportar notas';

  @override
  String get exportNotesSubtitle =>
      'Guarda todas as tuas notas num ficheiro que podes importar novamente mais tarde';

  @override
  String get importNotesButton => 'Importar notas';

  @override
  String get importNotesSubtitle =>
      'Restaura notas a partir de um ficheiro exportado anteriormente';

  @override
  String get exportNotesSuccess => 'Notas exportadas';

  @override
  String exportNotesError(Object error) {
    return 'Não foi possível exportar as notas: $error';
  }

  @override
  String importNotesSuccess(int count) {
    return '$count notas importadas';
  }

  @override
  String importNotesError(Object error) {
    return 'Não foi possível importar as notas: $error';
  }

  @override
  String get sectionAttachments => 'Anexos';

  @override
  String get attachmentProviderSubtitle =>
      'Onde as imagens e notas de voz cifradas são carregadas ao sincronizar';

  @override
  String get attachmentProviderCustom => 'Personalizado…';

  @override
  String get attachmentCustomUrlLabel => 'URL do servidor';

  @override
  String get attachmentProviderHint =>
      'Some public hosts (e.g. Primal, nostr.build) reject encrypted uploads outright — they validate real image content, which ciphertext never is. Prefer a Blossom host that stores opaque blobs, or point Custom… at a self-hosted one.';

  @override
  String get sectionSupport => 'Apoio';

  @override
  String get supportEchoesTitle => 'Apoiar o Echoes';

  @override
  String lightningAddressCopied(String address) {
    return '⚡ $address copiado para a área de transferência';
  }

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get passwordLabel => 'Palavra-passe';

  @override
  String get invalidPrivateKeyError =>
      'A chave privada não é válida. Introduza uma chave nsec ou hex válida.';

  @override
  String get wrongPasswordError => 'Palavra-passe incorreta';

  @override
  String genericErrorPrefix(String error) {
    return 'Erro: $error';
  }
}
