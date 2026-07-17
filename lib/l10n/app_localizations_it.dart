// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get loginSubtitle => 'Accedi con il tuo account Nostr';

  @override
  String get loginWithAmberButton => 'Accedi con Amber';

  @override
  String get importAccountButton => 'Importa account Nostr';

  @override
  String get importAccountFieldLabel =>
      'Chiave privata (nsec) del tuo account Nostr';

  @override
  String get importButton => 'Importa';

  @override
  String get relaysTitle => 'Relay';

  @override
  String get settingsTooltip => 'Impostazioni';

  @override
  String get searchTooltip => 'Cerca';

  @override
  String get closeSearchTooltip => 'Chiudi ricerca';

  @override
  String get searchNotesHint => 'Cerca nelle note';

  @override
  String get noSearchResultsMessage => 'Nessun risultato.';

  @override
  String get emptyNotesMessage => 'Nessuna nota. Tocca + per crearne una.';

  @override
  String get notesTabLabel => 'Note';

  @override
  String get diaryTabLabel => 'Diario';

  @override
  String get emptyDiaryMessage =>
      'Nessuna voce di diario. Tocca + per scriverne una.';

  @override
  String get diaryToday => 'Oggi';

  @override
  String get diaryYesterday => 'Ieri';

  @override
  String get newPlainNoteOption => 'Nota';

  @override
  String get newChecklistOption => 'Checklist';

  @override
  String get newVoiceNoteOption => 'Nota vocale';

  @override
  String get deleteNoteButton => 'Elimina nota';

  @override
  String get deleteNoteConfirmTitle => 'Eliminare questa nota?';

  @override
  String get deleteNoteConfirmBody =>
      'Non può essere annullato. Se questa nota era sincronizzata, verrà rimossa anche dai tuoi relay.';

  @override
  String deleteNotesConfirmTitle(int count) {
    return 'Eliminare $count note?';
  }

  @override
  String get deleteNotesConfirmBody =>
      'Non può essere annullato. Se una di queste note era sincronizzata, verrà rimossa anche dai tuoi relay.';

  @override
  String selectionCount(int count) {
    return '$count selezionate';
  }

  @override
  String get untitledNote => '(senza titolo)';

  @override
  String errorLoadingNotes(String error) {
    return 'Errore nel caricamento delle note: $error';
  }

  @override
  String get timeJustNow => 'ora';

  @override
  String timeMinutesAgo(int count) {
    return '${count}m fa';
  }

  @override
  String timeHoursAgo(int count) {
    return '${count}h fa';
  }

  @override
  String timeDaysAgo(int count) {
    return '${count}g fa';
  }

  @override
  String get notesLockedTitle => 'Le note sono protette da una password';

  @override
  String get unlockButton => 'Sblocca';

  @override
  String get saveTooltip => 'Salva';

  @override
  String get titleFieldLabel => 'Titolo';

  @override
  String get bodyFieldHint => 'Scrivi qui... (markdown supportato)';

  @override
  String get checklistItemHint => 'Elemento checklist';

  @override
  String get addItemButton => 'Aggiungi elemento';

  @override
  String checklistProgress(int done, int total) {
    return '$done di $total completati';
  }

  @override
  String get showCompletedItemsTooltip => 'Mostra elementi completati';

  @override
  String get hideCompletedItemsTooltip => 'Nascondi elementi completati';

  @override
  String get allChecklistItemsCompletedHidden =>
      'Tutti gli elementi sono completati e nascosti.';

  @override
  String get deleteCompletedItemsButton => 'Elimina elementi completati';

  @override
  String get deleteCompletedItemsConfirmTitle =>
      'Eliminare gli elementi completati?';

  @override
  String deleteCompletedItemsConfirmBody(int count) {
    return 'Verranno rimossi $count elemento/i spuntati da questa checklist. Non può essere annullato.';
  }

  @override
  String get addImageButton => 'Aggiungi immagine';

  @override
  String get noteColorButton => 'Colore nota';

  @override
  String get noteColorDefault => 'Predefinito';

  @override
  String get noteColorYellow => 'Giallo';

  @override
  String get noteColorRed => 'Rosso';

  @override
  String get noteColorPurple => 'Viola';

  @override
  String get noteColorBlue => 'Blu';

  @override
  String get noteColorGreen => 'Verde';

  @override
  String get noteColorOrange => 'Arancione';

  @override
  String get noteColorWhite => 'Bianco';

  @override
  String get recordVoiceNoteTooltip => 'Registra una nota vocale';

  @override
  String get recordVoiceNoteInstructions =>
      'Tocca il pulsante rosso per iniziare a registrare, oppure ✕ per annullare.';

  @override
  String get stopRecordingTooltip => 'Interrompi registrazione';

  @override
  String get cancelRecordingTooltip => 'Annulla registrazione';

  @override
  String get addVoiceTimestampButton => 'Aggiungi timestamp';

  @override
  String get editVoiceTimestampButton => 'Modifica timestamp';

  @override
  String get voiceNoteUnsupportedOnPlatform =>
      'Le note vocali non sono supportate su questo dispositivo';

  @override
  String get formatBoldTooltip => 'Grassetto';

  @override
  String get formatItalicTooltip => 'Corsivo';

  @override
  String get formatHeadingTooltip => 'Titolo';

  @override
  String get formatListTooltip => 'Elenco puntato';

  @override
  String get formatLinkTooltip => 'Link';

  @override
  String get imageSizeSmall => 'Piccola';

  @override
  String get imageSizeMedium => 'Media';

  @override
  String get imageSizeFull => 'Larghezza intera';

  @override
  String get removeImageButton => 'Rimuovi immagine';

  @override
  String get relayUrlHint => 'wss://relay.example.com';

  @override
  String get noRelaysMessage => 'Nessun relay configurato.';

  @override
  String relaysCount(int count) {
    return '$count relay';
  }

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get sectionSecurity => 'Sicurezza';

  @override
  String get loadingLabel => 'Caricamento…';

  @override
  String get encryptionLoadError =>
      'Impossibile caricare le impostazioni di cifratura';

  @override
  String get encryptionToggleTitle => 'Proteggi le note con una password';

  @override
  String get encryptionToggleSubtitle =>
      'Cifra le note salvate (AES-256-GCM) con una chiave derivata dalla tua password. La password non viene mai salvata — se la dimentichi, le note non potranno essere recuperate.';

  @override
  String get lockNotesNowTitle => 'Blocca le note ora';

  @override
  String get lockNotesNowSubtitle =>
      'Per vedere le note servirà di nuovo la password';

  @override
  String get setPasswordDialogTitle => 'Imposta una password';

  @override
  String get passwordTooShortError => 'Almeno 8 caratteri';

  @override
  String get confirmPasswordLabel => 'Conferma password';

  @override
  String get passwordsDoNotMatchError => 'Le password non coincidono';

  @override
  String enableEncryptionError(String error) {
    return 'Impossibile attivare la cifratura: $error';
  }

  @override
  String get enableButton => 'Attiva';

  @override
  String get disablePasswordDialogTitle =>
      'Inserisci la password per disattivare la cifratura';

  @override
  String get disableButton => 'Disattiva';

  @override
  String get sectionAppearance => 'Aspetto';

  @override
  String get lightThemeToggleTitle => 'Tema chiaro';

  @override
  String get lightThemeToggleSubtitle =>
      'Usa una combinazione di colori chiara invece che scura';

  @override
  String get noteLayoutToggleTitle =>
      'Passa dalla vista elenco alla vista griglia';

  @override
  String get manageRelaysTitle => 'Gestisci relay';

  @override
  String get republishAllNotesButton =>
      'Ripubblica tutte le note sincronizzate';

  @override
  String get republishAllNotesSubtitle =>
      'Aggiorna ogni relay qui sopra con le note già condivise altrove — utile subito dopo averne aggiunto uno, ad esempio un relay di backup self-hosted';

  @override
  String republishAllNotesSuccess(int count) {
    return 'Ripubblicate $count nota/e';
  }

  @override
  String republishAllNotesError(String error) {
    return 'Impossibile ripubblicare le note: $error';
  }

  @override
  String get forceFullResyncButton => 'Forza risincronizzazione completa';

  @override
  String get forceFullResyncSubtitle =>
      'Ricontrolla i relay per l\'intera cronologia di una nota invece di ciò che è nuovo — utile se la sincronizzazione sembra bloccata e salta note più vecchie, ad esempio dopo aver risolto un relay irraggiungibile';

  @override
  String get forceFullResyncSuccess => 'Note aggiornate dai relay';

  @override
  String forceFullResyncError(String error) {
    return 'Impossibile risincronizzare le note: $error';
  }

  @override
  String get confirmButton => 'Conferma';

  @override
  String get sectionLanguage => 'Lingua';

  @override
  String get langSystem => 'Predefinita di sistema';

  @override
  String get sectionAccount => 'Account';

  @override
  String get accountLocalOnlyMessage =>
      'Echoes in uso in locale — non sincronizzato con Nostr';

  @override
  String get accountSignInButton => 'Accedi';

  @override
  String accountSignedInAs(String npub) {
    return 'Accesso effettuato come $npub';
  }

  @override
  String get accountSignOutButton => 'Esci';

  @override
  String get accountSignOutConfirmTitle => 'Uscire dall\'account?';

  @override
  String get accountSignOutConfirmBody =>
      'Le tue note restano su questo dispositivo. Puoi accedere di nuovo quando vuoi.';

  @override
  String get onboardingWelcomeTitle => 'Benvenuto in Echoes';

  @override
  String get onboardingIntroLocalTitle =>
      'Le tue note, sempre sul tuo dispositivo';

  @override
  String get onboardingIntroLocalBody =>
      'Ogni nota viene salvata prima in locale, quindi l\'app funziona completamente offline. Niente lascia il tuo dispositivo a meno che tu non scelga di sincronizzarlo.';

  @override
  String get onboardingIntroSyncTitle =>
      'Sincronizzazione facoltativa su Nostr';

  @override
  String get onboardingIntroSyncBody =>
      'Attiva la sincronizzazione per fare il backup delle tue note e leggerle su altri dispositivi, usando il protocollo aperto Nostr e i relay che preferisci.';

  @override
  String get onboardingIntroEncryptionTitle => 'Sempre cifrate';

  @override
  String get onboardingIntroEncryptionBody =>
      'Le note sincronizzate su Nostr sono cifrate end-to-end, quindi chi gestisce i relay — e chiunque altro — non può mai leggerne il contenuto.';

  @override
  String get onboardingIntroAmberTitle => 'Accedi senza esporre la tua chiave';

  @override
  String get onboardingIntroAmberBody =>
      'Usa Amber per accedere: la tua chiave privata resta in Amber e non viene mai condivisa con Echoes.';

  @override
  String get onboardingIntroSecurityTitle => 'Sicurezza per progettazione';

  @override
  String get onboardingIntroSecurityBody =>
      'La tua chiave privata risiede nel keystore cifrato del dispositivo — oppure, con Amber, non tocca mai Echoes. Le immagini e le note vocali vengono cifrate prima ancora di lasciare il dispositivo. Le note possono essere protette con una password, e nulla di tutto ciò viene mai incluso nei backup del telefono.';

  @override
  String get onboardingNextButton => 'Avanti';

  @override
  String get onboardingBackButton => 'Indietro';

  @override
  String get onboardingSkipButton => 'Salta — usa Echoes solo in locale';

  @override
  String get onboardingRelayTitle => 'Scegli i relay per la sincronizzazione';

  @override
  String get onboardingRelayBody =>
      'I relay sono dove vengono salvate le tue note cifrate quando sincronizzi. Aggiungine uno o più — questi, tra i più diffusi, sono un buon punto di partenza:';

  @override
  String get onboardingFinishButton => 'Inizia';

  @override
  String get syncNoteTooltip => 'Sincronizza questa nota';

  @override
  String get unsyncNoteTooltip => 'Rimuovi dai relay';

  @override
  String get syncSelectedTooltip => 'Sincronizza le note selezionate';

  @override
  String get exportSelectedTooltip => 'Esporta le note selezionate';

  @override
  String get deleteSelectedTooltip => 'Elimina le note selezionate';

  @override
  String syncNoteError(String error) {
    return 'Impossibile sincronizzare la nota: $error';
  }

  @override
  String unsyncNoteError(String error) {
    return 'Impossibile rimuovere la nota dai relay: $error';
  }

  @override
  String deleteNoteRelayError(String error) {
    return 'Nota eliminata localmente, ma non è stato possibile rimuoverla dai relay: $error';
  }

  @override
  String deleteNotesRelayError(int count) {
    return '$count note eliminate localmente, ma non è stato possibile rimuoverle dai relay';
  }

  @override
  String get deletingNotesTitle => 'Eliminazione note…';

  @override
  String deletingNotesProgress(int completed, int total) {
    return 'Eliminazione $completed di $total';
  }

  @override
  String get syncSelectedSuccess => 'Note sincronizzate';

  @override
  String syncSelectedPartialError(int count) {
    return 'Impossibile sincronizzare $count note';
  }

  @override
  String get exportConfirmTitle => 'Esporta note';

  @override
  String get exportConfirmBody =>
      'Crea un file di backup delle tue note. Include anche le chiavi di decrittazione di eventuali immagini o note vocali allegate — chiunque abbia il file potrebbe leggerle a meno che non sia cifrato.';

  @override
  String get exportEncryptToggleLabel => 'Cifra questo file';

  @override
  String get exportEncryptToggleSubtitle =>
      'Consigliato — protegge il backup con una password';

  @override
  String get exportPasswordDialogTitle => 'Inserisci la tua password';

  @override
  String get exportSetPasswordDialogTitle =>
      'Imposta una password per questa esportazione';

  @override
  String get importPasswordDialogTitle =>
      'Inserisci la password dell\'esportazione';

  @override
  String get sectionData => 'Dati';

  @override
  String get exportNotesButton => 'Esporta note';

  @override
  String get exportNotesSubtitle =>
      'Salva tutte le tue note in un file che potrai importare di nuovo in seguito';

  @override
  String get importNotesButton => 'Importa note';

  @override
  String get importNotesSubtitle =>
      'Ripristina le note da un file esportato in precedenza';

  @override
  String get exportNotesSuccess => 'Note esportate';

  @override
  String exportNotesError(Object error) {
    return 'Impossibile esportare le note: $error';
  }

  @override
  String importNotesSuccess(int count) {
    return 'Importate $count note';
  }

  @override
  String importNotesError(Object error) {
    return 'Impossibile importare le note: $error';
  }

  @override
  String get sectionAttachments => 'Allegati';

  @override
  String get attachmentProviderSubtitle =>
      'Dove vengono caricate le immagini e le note vocali cifrate quando sincronizzi';

  @override
  String get attachmentProviderCustom => 'Personalizzato…';

  @override
  String get attachmentCustomUrlLabel => 'URL del server';

  @override
  String get attachmentProviderHint =>
      'Alcuni host pubblici (es. Primal, nostr.build) rifiutano del tutto i caricamenti cifrati — validano il contenuto reale delle immagini, cosa che i dati cifrati non sono mai. Preferisci un host Blossom che memorizza blob opachi, oppure imposta Personalizzato… su uno self-hosted.';

  @override
  String get sectionSupport => 'Supporto';

  @override
  String get supportEchoesTitle => 'Sostieni Echoes';

  @override
  String lightningAddressCopied(String address) {
    return '⚡ $address copiato negli appunti';
  }

  @override
  String get cancelButton => 'Annulla';

  @override
  String get passwordLabel => 'Password';

  @override
  String get invalidPrivateKeyError =>
      'La chiave privata non è valida. Inserisci una chiave nsec o hex valida.';

  @override
  String get wrongPasswordError => 'Password errata';

  @override
  String genericErrorPrefix(String error) {
    return 'Errore: $error';
  }
}
