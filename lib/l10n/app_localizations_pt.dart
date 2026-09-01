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
  String get importAccountFieldLabel => 'Chave privada (nsec) da tua conta Nostr';

  @override
  String get importButton => 'Importar';

  @override
  String get bunkerLoginButton => 'Ligar um assinador remoto (bunker)';

  @override
  String get bunkerFieldLabel => 'Cola o teu token de ligação bunker://';

  @override
  String get bunkerConnectButton => 'Ligar';

  @override
  String get bunkerAuthPrompt => 'Aprova a ligação no teu assinador e volta';

  @override
  String get relaysTitle => 'Relays';

  @override
  String get settingsTooltip => 'Definições';

  @override
  String get searchTooltip => 'Pesquisar';

  @override
  String get closeSearchTooltip => 'Fechar pesquisa';

  @override
  String get searchNotesHint => 'Pesquisar nas notas';

  @override
  String get noSearchResultsMessage => 'Sem resultados.';

  @override
  String get emptyNotesMessage => 'Ainda não há notas. Toca em + para criar uma.';

  @override
  String get notesTabLabel => 'Notas';

  @override
  String get diaryTabLabel => 'Diário';

  @override
  String get emptyDiaryMessage => 'Ainda não há entradas no diário. Toque em + para escrever uma.';

  @override
  String get diaryToday => 'Hoje';

  @override
  String get diaryYesterday => 'Ontem';

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
  String get bodyFieldHint => 'Escreve aqui... (markdown suportado)';

  @override
  String get checklistItemHint => 'Item da lista';

  @override
  String get addItemButton => 'Adicionar item';

  @override
  String completedItemsSection(int count) {
    return 'Concluídos ($count)';
  }

  @override
  String get duplicateChecklistItemMessage => 'Já nesta lista, concluído';

  @override
  String get restoreChecklistItemButton => 'Restaurar';

  @override
  String get noteSyncedMessage => 'Nota sincronizada';

  @override
  String get noteSyncedFirstTimeMessage => 'Nota sincronizada pela primeira vez';

  @override
  String notePartiallySyncedMessage(int accepted, int total) {
    return 'Sincronizada em $accepted de $total relés';
  }

  @override
  String checklistProgress(int done, int total) {
    return '$done de $total concluídos';
  }

  @override
  String get showCompletedItemsTooltip => 'Mostrar itens concluídos';

  @override
  String get hideCompletedItemsTooltip => 'Ocultar itens concluídos';

  @override
  String get allChecklistItemsCompletedHidden => 'Todos os itens estão concluídos e ocultos.';

  @override
  String get deleteCompletedItemsButton => 'Eliminar itens concluídos';

  @override
  String get deleteCompletedItemsConfirmTitle => 'Eliminar os itens concluídos?';

  @override
  String deleteCompletedItemsConfirmBody(int count) {
    return 'Isto remove $count itens marcados desta lista. Não pode ser anulado.';
  }

  @override
  String get addImageButton => 'Adicionar imagem';

  @override
  String get noteColorButton => 'Cor da nota';

  @override
  String get noteColorDefault => 'Predefinição';

  @override
  String get noteColorYellow => 'Amarelo';

  @override
  String get noteColorRed => 'Vermelho';

  @override
  String get noteColorPurple => 'Roxo';

  @override
  String get noteColorBlue => 'Azul';

  @override
  String get noteColorGreen => 'Verde';

  @override
  String get noteColorOrange => 'Laranja';

  @override
  String get noteColorWhite => 'Branco';

  @override
  String get noteColorPink => 'Rosa';

  @override
  String get noteColorTeal => 'Turquesa';

  @override
  String get noteColorIndigo => 'Índigo';

  @override
  String get noteColorBrown => 'Marrom';

  @override
  String get noteColorLime => 'Verde-limão';

  @override
  String get recordVoiceNoteTooltip => 'Gravar uma nota de voz';

  @override
  String get recordVoiceNoteInstructions =>
      'Toque no botão vermelho para começar a gravar, ou em ✕ para cancelar.';

  @override
  String get stopRecordingTooltip => 'Parar gravação';

  @override
  String get cancelRecordingTooltip => 'Cancelar gravação';

  @override
  String get addVoiceTimestampButton => 'Adicionar carimbo de hora';

  @override
  String get editVoiceTimestampButton => 'Editar carimbo de hora';

  @override
  String get voiceNoteUnsupportedOnPlatform =>
      'As notas de voz não são suportadas neste dispositivo';

  @override
  String get formatBoldTooltip => 'Negrito';

  @override
  String get formatItalicTooltip => 'Itálico';

  @override
  String get formatStrikethroughTooltip => 'Rasurado';

  @override
  String get formatUnderlineTooltip => 'Sublinhado';

  @override
  String get formatHeadingTooltip => 'Título';

  @override
  String get formatListTooltip => 'Lista com marcadores';

  @override
  String get formatLinkTooltip => 'Ligação';

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
  String get encryptionLoadError => 'Não foi possível carregar as definições de encriptação';

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
  String get lightThemeToggleSubtitle => 'Usar um esquema de cores claro em vez de escuro';

  @override
  String get noteLayoutToggleTitle => 'Alternar entre vista de lista e grelha';

  @override
  String get manageRelaysTitle => 'Gerir relés';

  @override
  String get autoSyncOnSaveTitle => 'Publicar ao guardar';

  @override
  String get autoSyncOnSaveSubtitle =>
      'As notas que já sincronizas são republicadas assim que as guardas. As notas só locais nunca são publicadas.';

  @override
  String get noteBackgroundPhoto => 'Foto';

  @override
  String get noteBackgroundRemove => 'Remover foto';

  @override
  String get republishAllNotesButton => 'Republicar todas as notas sincronizadas';

  @override
  String get republishAllNotesSubtitle =>
      'Preenche cada relé acima com notas já partilhadas noutros — útil logo após adicionar um novo, p. ex. um relé de cópia de segurança auto-hospedado';

  @override
  String republishAllNotesSuccess(int count) {
    return '$count notas republicadas';
  }

  @override
  String republishAllNotesError(String error) {
    return 'Não foi possível republicar as notas: $error';
  }

  @override
  String get forceFullResyncButton => 'Forçar ressincronização completa';

  @override
  String get forceFullResyncSubtitle =>
      'Verifica novamente os relays em busca de todo o histórico de uma nota, e não apenas o que é novo — útil se a sincronização parecer travada e ignorar notas mais antigas, por exemplo após corrigir um relay inacessível';

  @override
  String get forceFullResyncSuccess => 'Notas atualizadas a partir dos relays';

  @override
  String forceFullResyncError(String error) {
    return 'Não foi possível ressincronizar as notas: $error';
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
  String get accountLocalOnlyMessage => 'A usar o Echoes localmente — não sincronizado com o Nostr';

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
  String get onboardingIntroLocalTitle => 'As tuas notas, sempre no teu dispositivo';

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
  String get exportSetPasswordDialogTitle => 'Defina uma palavra-passe para esta exportação';

  @override
  String get importPasswordDialogTitle => 'Introduza a palavra-passe da exportação';

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
      'Alguns servidores públicos (p. ex. Primal, nostr.build) rejeitam envios cifrados — validam conteúdo de imagem real, o que dados cifrados nunca são. Prefira um servidor Blossom que guarde dados opacos, ou aponte Personalizado… para um auto-hospedado.';

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

  @override
  String get shareNoteTooltip => 'Partilhar';

  @override
  String get shareNoteTitle => 'Partilhar nota';

  @override
  String get shareRecipientFieldLabel => 'npub ou chave pública do destinatário';

  @override
  String get shareAddRecipientButton => 'Adicionar';

  @override
  String get shareInvalidRecipientError => 'Não é um npub nem uma chave pública válida';

  @override
  String get shareRecipientNotFoundError => 'Nenhuma conta Nostr encontrada para esse nome';

  @override
  String get shareConfirmTitle => 'Partilhar esta nota?';

  @override
  String get shareConfirmButton => 'Partilhar';

  @override
  String get shareAlreadyRecipientError => 'Já partilhada com esta pessoa';

  @override
  String get shareCannotShareWithSelfError => 'Não pode partilhar uma nota consigo mesmo';

  @override
  String get shareRecipientsHeader => 'Partilhada com';

  @override
  String get shareNoRecipientsMessage => 'Ainda não partilhada com ninguém.';

  @override
  String get stopSharingTooltip => 'Parar de partilhar com esta pessoa';

  @override
  String get shareRevocationNote =>
      'Qualquer pessoa com quem partilhar pode ler esta nota no seu dispositivo. Remover alguém interrompe as atualizações futuras, mas não pode apagar o que já recebeu.';

  @override
  String shareError(String error) {
    return 'Não foi possível atualizar a partilha: $error';
  }

  @override
  String get sharedWithMeHeader => 'Partilhada consigo';

  @override
  String sharedByLabel(String npub) {
    return 'Partilhada por $npub';
  }

  @override
  String get sharedNoteEditableNote =>
      'Pode editar esta nota; as suas alterações são sincronizadas de volta com o proprietário, que as combina.';

  @override
  String get abandonSharedNoteButton => 'Sair desta nota partilhada';

  @override
  String get abandonSharedNoteConfirmTitle => 'Sair desta nota partilhada?';

  @override
  String get abandonSharedNoteConfirmBody =>
      'Será removida deste dispositivo e deixará de receber atualizações. Isto não pode ser anulado — não poderá voltar a juntar-se mais tarde.';

  @override
  String abandonSharedNoteError(String error) {
    return 'Não foi possível sair: $error';
  }
}
