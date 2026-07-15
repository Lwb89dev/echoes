// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get loginSubtitle => 'Inicia sesión con tu cuenta de Nostr';

  @override
  String get loginWithAmberButton => 'Iniciar sesión con Amber';

  @override
  String get importAccountButton => 'Importar cuenta de Nostr';

  @override
  String get importAccountFieldLabel =>
      'Clave privada (nsec) de tu cuenta de Nostr';

  @override
  String get importButton => 'Importar';

  @override
  String get relaysTitle => 'Relays';

  @override
  String get settingsTooltip => 'Ajustes';

  @override
  String get searchTooltip => 'Search';

  @override
  String get closeSearchTooltip => 'Close search';

  @override
  String get searchNotesHint => 'Search notes';

  @override
  String get noSearchResultsMessage => 'No matches.';

  @override
  String get emptyNotesMessage => 'Aún no hay notas. Toca + para crear una.';

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
  String get newChecklistOption => 'Lista de tareas';

  @override
  String get newVoiceNoteOption => 'Nota de voz';

  @override
  String get deleteNoteButton => 'Eliminar nota';

  @override
  String get deleteNoteConfirmTitle => '¿Eliminar esta nota?';

  @override
  String get deleteNoteConfirmBody =>
      'Esto no se puede deshacer. Si esta nota estaba sincronizada, también se eliminará de tus relés.';

  @override
  String deleteNotesConfirmTitle(int count) {
    return '¿Eliminar $count notas?';
  }

  @override
  String get deleteNotesConfirmBody =>
      'Esto no se puede deshacer. Si alguna de estas notas estaba sincronizada, también se eliminará de tus relés.';

  @override
  String selectionCount(int count) {
    return '$count seleccionadas';
  }

  @override
  String get untitledNote => '(sin título)';

  @override
  String errorLoadingNotes(String error) {
    return 'Error al cargar las notas: $error';
  }

  @override
  String get timeJustNow => 'ahora';

  @override
  String timeMinutesAgo(int count) {
    return 'hace $count min';
  }

  @override
  String timeHoursAgo(int count) {
    return 'hace $count h';
  }

  @override
  String timeDaysAgo(int count) {
    return 'hace $count d';
  }

  @override
  String get notesLockedTitle =>
      'Las notas están protegidas con una contraseña';

  @override
  String get unlockButton => 'Desbloquear';

  @override
  String get saveTooltip => 'Guardar';

  @override
  String get titleFieldLabel => 'Título';

  @override
  String get checklistLabel => 'Lista de tareas';

  @override
  String get bodyFieldHint => 'Escribe aquí... (se admite markdown)';

  @override
  String get checklistItemHint => 'Elemento de la lista';

  @override
  String get addItemButton => 'Añadir elemento';

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
  String get addImageButton => 'Añadir imagen';

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
  String get recordVoiceNoteTooltip => 'Grabar una nota de voz';

  @override
  String get recordVoiceNoteInstructions =>
      'Tap the red button to start recording, or ✕ to cancel.';

  @override
  String get stopRecordingTooltip => 'Detener grabación';

  @override
  String get cancelRecordingTooltip => 'Cancelar grabación';

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
  String get imageSizeSmall => 'Pequeña';

  @override
  String get imageSizeMedium => 'Mediana';

  @override
  String get imageSizeFull => 'Ancho completo';

  @override
  String get removeImageButton => 'Eliminar imagen';

  @override
  String get relayUrlHint => 'wss://relay.example.com';

  @override
  String get noRelaysMessage => 'Aún no hay ningún relay configurado.';

  @override
  String relaysCount(int count) {
    return '$count relés';
  }

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get sectionSecurity => 'Seguridad';

  @override
  String get loadingLabel => 'Cargando…';

  @override
  String get encryptionLoadError =>
      'No se pudo cargar la configuración de cifrado';

  @override
  String get encryptionToggleTitle => 'Proteger notas con una contraseña';

  @override
  String get encryptionToggleSubtitle =>
      'Cifra las notas almacenadas (AES-256-GCM) con una clave derivada de tu contraseña. La contraseña nunca se guarda — si la olvidas, las notas no se podrán recuperar.';

  @override
  String get lockNotesNowTitle => 'Bloquear notas ahora';

  @override
  String get lockNotesNowSubtitle =>
      'Requiere la contraseña de nuevo para ver las notas';

  @override
  String get setPasswordDialogTitle => 'Establecer una contraseña';

  @override
  String get passwordTooShortError => 'Al menos 8 caracteres';

  @override
  String get confirmPasswordLabel => 'Confirmar contraseña';

  @override
  String get passwordsDoNotMatchError => 'Las contraseñas no coinciden';

  @override
  String enableEncryptionError(String error) {
    return 'No se pudo activar el cifrado: $error';
  }

  @override
  String get enableButton => 'Activar';

  @override
  String get disablePasswordDialogTitle =>
      'Introduce tu contraseña para desactivar el cifrado';

  @override
  String get disableButton => 'Desactivar';

  @override
  String get sectionAppearance => 'Apariencia';

  @override
  String get lightThemeToggleTitle => 'Tema claro';

  @override
  String get lightThemeToggleSubtitle =>
      'Usar un esquema de color claro en lugar de oscuro';

  @override
  String get noteLayoutToggleTitle => 'Diseño de la lista de notas';

  @override
  String get manageRelaysTitle => 'Gestionar relés';

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
  String get langSystem => 'Predeterminado del sistema';

  @override
  String get sectionAccount => 'Cuenta';

  @override
  String get accountLocalOnlyMessage =>
      'Usando Echoes localmente — sin sincronizar con Nostr';

  @override
  String get accountSignInButton => 'Iniciar sesión';

  @override
  String accountSignedInAs(String npub) {
    return 'Sesión iniciada como $npub';
  }

  @override
  String get accountSignOutButton => 'Cerrar sesión';

  @override
  String get accountSignOutConfirmTitle => '¿Cerrar sesión?';

  @override
  String get accountSignOutConfirmBody =>
      'Tus notas permanecerán en este dispositivo. Puedes volver a iniciar sesión en cualquier momento.';

  @override
  String get onboardingWelcomeTitle => 'Bienvenido a Echoes';

  @override
  String get onboardingIntroLocalTitle =>
      'Tus notas, siempre en tu dispositivo';

  @override
  String get onboardingIntroLocalBody =>
      'Cada nota se guarda primero localmente, así que la aplicación funciona totalmente sin conexión. Nada sale de tu dispositivo a menos que elijas sincronizarlo.';

  @override
  String get onboardingIntroSyncTitle =>
      'Sincronización opcional a través de Nostr';

  @override
  String get onboardingIntroSyncBody =>
      'Activa la sincronización para respaldar tus notas y leerlas en otros dispositivos, usando el protocolo abierto Nostr y los relays que elijas.';

  @override
  String get onboardingIntroEncryptionTitle => 'Siempre cifradas';

  @override
  String get onboardingIntroEncryptionBody =>
      'Las notas sincronizadas con Nostr están cifradas de extremo a extremo, de modo que los operadores de los relays — y cualquier otra persona — nunca pueden leer su contenido.';

  @override
  String get onboardingIntroAmberTitle => 'Inicia sesión sin exponer tu clave';

  @override
  String get onboardingIntroAmberBody =>
      'Usa Amber para iniciar sesión: tu clave privada permanece en Amber y nunca se comparte con Echoes.';

  @override
  String get onboardingIntroSecurityTitle => 'Seguridad desde el diseño';

  @override
  String get onboardingIntroSecurityBody =>
      'Tu clave privada vive en el almacén de claves cifrado de tu dispositivo — o, con Amber, nunca llega a tocar Echoes. Las fotos y notas de voz se cifran antes de salir de tu dispositivo. Las notas se pueden bloquear con una contraseña, y nada de esto se incluye nunca en las copias de seguridad del teléfono.';

  @override
  String get onboardingNextButton => 'Siguiente';

  @override
  String get onboardingBackButton => 'Atrás';

  @override
  String get onboardingSkipButton => 'Omitir — usar Echoes solo localmente';

  @override
  String get onboardingRelayTitle => 'Elige relays para sincronizar';

  @override
  String get onboardingRelayBody =>
      'Los relays son donde se almacenan tus notas cifradas al sincronizar. Añade uno o más — estos populares son un buen comienzo:';

  @override
  String get onboardingFinishButton => 'Empezar';

  @override
  String get syncNoteTooltip => 'Sincronizar esta nota';

  @override
  String get unsyncNoteTooltip => 'Quitar de los relés';

  @override
  String get syncSelectedTooltip => 'Sincronizar notas seleccionadas';

  @override
  String get exportSelectedTooltip => 'Exportar notas seleccionadas';

  @override
  String get deleteSelectedTooltip => 'Eliminar notas seleccionadas';

  @override
  String syncNoteError(String error) {
    return 'No se pudo sincronizar la nota: $error';
  }

  @override
  String unsyncNoteError(String error) {
    return 'No se pudo quitar la nota de los relés: $error';
  }

  @override
  String deleteNoteRelayError(String error) {
    return 'Nota eliminada localmente, pero no se pudo quitar de los relés: $error';
  }

  @override
  String deleteNotesRelayError(int count) {
    return '$count notas eliminadas localmente, pero no se pudieron quitar de los relés';
  }

  @override
  String get deletingNotesTitle => 'Eliminando notas…';

  @override
  String deletingNotesProgress(int completed, int total) {
    return 'Eliminando $completed de $total';
  }

  @override
  String get syncSelectedSuccess => 'Notas sincronizadas';

  @override
  String syncSelectedPartialError(int count) {
    return 'No se pudieron sincronizar $count notas';
  }

  @override
  String get exportConfirmTitle => 'Exportar notas';

  @override
  String get exportConfirmBody =>
      'Crea un archivo de copia de seguridad de tus notas. También incluye las claves de descifrado de cualquier imagen o nota de voz adjunta — cualquiera con el archivo podría leerlas a menos que esté cifrado.';

  @override
  String get exportEncryptToggleLabel => 'Cifrar este archivo';

  @override
  String get exportEncryptToggleSubtitle =>
      'Recomendado — protege la copia de seguridad con una contraseña';

  @override
  String get exportPasswordDialogTitle => 'Introduce tu contraseña';

  @override
  String get exportSetPasswordDialogTitle =>
      'Establece una contraseña para esta exportación';

  @override
  String get importPasswordDialogTitle =>
      'Introduce la contraseña de la exportación';

  @override
  String get sectionData => 'Datos';

  @override
  String get exportNotesButton => 'Exportar notas';

  @override
  String get exportNotesSubtitle =>
      'Guarda todas tus notas en un archivo que podrás volver a importar más tarde';

  @override
  String get importNotesButton => 'Importar notas';

  @override
  String get importNotesSubtitle =>
      'Restaura notas desde un archivo exportado anteriormente';

  @override
  String get exportNotesSuccess => 'Notas exportadas';

  @override
  String exportNotesError(Object error) {
    return 'No se pudieron exportar las notas: $error';
  }

  @override
  String importNotesSuccess(int count) {
    return 'Se importaron $count notas';
  }

  @override
  String importNotesError(Object error) {
    return 'No se pudieron importar las notas: $error';
  }

  @override
  String get sectionAttachments => 'Adjuntos';

  @override
  String get attachmentProviderSubtitle =>
      'Dónde se suben las imágenes y notas de voz cifradas al sincronizar';

  @override
  String get attachmentProviderCustom => 'Personalizado…';

  @override
  String get attachmentCustomUrlLabel => 'URL del servidor';

  @override
  String get attachmentProviderHint =>
      'Some public hosts (e.g. Primal, nostr.build) reject encrypted uploads outright — they validate real image content, which ciphertext never is. Prefer a Blossom host that stores opaque blobs, or point Custom… at a self-hosted one.';

  @override
  String get sectionSupport => 'Apoyo';

  @override
  String get supportEchoesTitle => 'Apoya a Echoes';

  @override
  String lightningAddressCopied(String address) {
    return '⚡ $address copiada al portapapeles';
  }

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get invalidPrivateKeyError =>
      'La clave privada no es válida. Introduce una clave nsec o hex válida.';

  @override
  String get wrongPasswordError => 'Contraseña incorrecta';

  @override
  String genericErrorPrefix(String error) {
    return 'Error: $error';
  }
}
