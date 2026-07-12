// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get loginSubtitle => 'Connectez-vous avec votre compte Nostr';

  @override
  String get loginWithAmberButton => 'Se connecter avec Amber';

  @override
  String get importAccountButton => 'Importer un compte Nostr';

  @override
  String get importAccountFieldLabel =>
      'Clé privée (nsec) de votre compte Nostr';

  @override
  String get importButton => 'Importer';

  @override
  String get relaysTitle => 'Relais';

  @override
  String get settingsTooltip => 'Paramètres';

  @override
  String get emptyNotesMessage =>
      'Aucune note pour l\'instant. Appuyez sur + pour en créer une.';

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
  String get newPlainNoteOption => 'Note';

  @override
  String get newChecklistOption => 'Liste de contrôle';

  @override
  String get newVoiceNoteOption => 'Note vocale';

  @override
  String get deleteNoteButton => 'Supprimer la note';

  @override
  String get deleteNoteConfirmTitle => 'Supprimer cette note ?';

  @override
  String get deleteNoteConfirmBody =>
      'Cette action est irréversible. Si cette note était synchronisée, elle sera également retirée de vos relais.';

  @override
  String deleteNotesConfirmTitle(int count) {
    return 'Supprimer $count notes ?';
  }

  @override
  String get deleteNotesConfirmBody =>
      'Cette action est irréversible. Si l\'une de ces notes était synchronisée, elle sera également retirée de vos relais.';

  @override
  String selectionCount(int count) {
    return '$count sélectionnée(s)';
  }

  @override
  String get untitledNote => '(sans titre)';

  @override
  String errorLoadingNotes(String error) {
    return 'Erreur lors du chargement des notes : $error';
  }

  @override
  String get timeJustNow => 'à l\'instant';

  @override
  String timeMinutesAgo(int count) {
    return 'il y a $count min';
  }

  @override
  String timeHoursAgo(int count) {
    return 'il y a $count h';
  }

  @override
  String timeDaysAgo(int count) {
    return 'il y a $count j';
  }

  @override
  String get notesLockedTitle => 'Les notes sont protégées par un mot de passe';

  @override
  String get unlockButton => 'Déverrouiller';

  @override
  String get newNoteTitle => 'Nouvelle note';

  @override
  String get editNoteTitle => 'Modifier la note';

  @override
  String get newDiaryEntryTitle => 'New diary entry';

  @override
  String get editDiaryEntryTitle => 'Edit diary entry';

  @override
  String get saveTooltip => 'Enregistrer';

  @override
  String get titleFieldLabel => 'Titre';

  @override
  String get checklistLabel => 'Liste de contrôle';

  @override
  String get bodyFieldHint => 'Écrivez ici... (markdown pris en charge)';

  @override
  String get checklistItemHint => 'Élément de la liste';

  @override
  String get addItemButton => 'Ajouter un élément';

  @override
  String get addImageButton => 'Ajouter une image';

  @override
  String get recordVoiceNoteTooltip => 'Enregistrer une note vocale';

  @override
  String get stopRecordingTooltip => 'Arrêter l\'enregistrement';

  @override
  String get cancelRecordingTooltip => 'Annuler l\'enregistrement';

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
  String get imageSizeSmall => 'Petite';

  @override
  String get imageSizeMedium => 'Moyenne';

  @override
  String get imageSizeFull => 'Pleine largeur';

  @override
  String get removeImageButton => 'Supprimer l\'image';

  @override
  String get relayUrlHint => 'wss://relay.example.com';

  @override
  String get noRelaysMessage => 'Aucun relais configuré pour l\'instant.';

  @override
  String relaysCount(int count) {
    return '$count relais';
  }

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get sectionSecurity => 'Sécurité';

  @override
  String get loadingLabel => 'Chargement…';

  @override
  String get encryptionLoadError =>
      'Impossible de charger les paramètres de chiffrement';

  @override
  String get encryptionToggleTitle => 'Protéger les notes par un mot de passe';

  @override
  String get encryptionToggleSubtitle =>
      'Chiffre les notes stockées (AES-256-GCM) avec une clé dérivée de votre mot de passe. Le mot de passe n\'est jamais enregistré — si vous l\'oubliez, les notes ne pourront pas être récupérées.';

  @override
  String get lockNotesNowTitle => 'Verrouiller les notes maintenant';

  @override
  String get lockNotesNowSubtitle =>
      'Le mot de passe sera à nouveau requis pour voir les notes';

  @override
  String get setPasswordDialogTitle => 'Définir un mot de passe';

  @override
  String get passwordTooShortError => 'Au moins 8 caractères';

  @override
  String get confirmPasswordLabel => 'Confirmer le mot de passe';

  @override
  String get passwordsDoNotMatchError =>
      'Les mots de passe ne correspondent pas';

  @override
  String enableEncryptionError(String error) {
    return 'Impossible d\'activer le chiffrement : $error';
  }

  @override
  String get enableButton => 'Activer';

  @override
  String get disablePasswordDialogTitle =>
      'Entrez votre mot de passe pour désactiver le chiffrement';

  @override
  String get disableButton => 'Désactiver';

  @override
  String get sectionAppearance => 'Apparence';

  @override
  String get lightThemeToggleTitle => 'Thème clair';

  @override
  String get lightThemeToggleSubtitle =>
      'Utiliser un thème clair plutôt que sombre';

  @override
  String get noteLayoutToggleTitle => 'Disposition de la liste de notes';

  @override
  String get noteLayoutToggleSubtitle =>
      'Basculer entre l\'affichage en liste et en grille';

  @override
  String get manageRelaysTitle => 'Gérer les relais';

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
  String get confirmButton => 'Confirmer';

  @override
  String get sectionLanguage => 'Langue';

  @override
  String get langSystem => 'Langue du système';

  @override
  String get sectionAccount => 'Compte';

  @override
  String get accountLocalOnlyMessage =>
      'Utilisation d\'Echoes en local — non synchronisé avec Nostr';

  @override
  String get accountSignInButton => 'Se connecter';

  @override
  String accountSignedInAs(String npub) {
    return 'Connecté en tant que $npub';
  }

  @override
  String get accountSignOutButton => 'Se déconnecter';

  @override
  String get accountSignOutConfirmTitle => 'Se déconnecter ?';

  @override
  String get accountSignOutConfirmBody =>
      'Vos notes restent sur cet appareil. Vous pouvez vous reconnecter à tout moment.';

  @override
  String get onboardingWelcomeTitle => 'Bienvenue sur Echoes';

  @override
  String get onboardingIntroLocalTitle =>
      'Vos notes, toujours sur votre appareil';

  @override
  String get onboardingIntroLocalBody =>
      'Chaque note est d\'abord enregistrée localement, l\'application fonctionne donc entièrement hors ligne. Rien ne quitte votre appareil, sauf si vous choisissez de synchroniser.';

  @override
  String get onboardingIntroSyncTitle =>
      'Synchronisation facultative via Nostr';

  @override
  String get onboardingIntroSyncBody =>
      'Activez la synchronisation pour sauvegarder vos notes et les lire sur d\'autres appareils, grâce au protocole ouvert Nostr et aux relais de votre choix.';

  @override
  String get onboardingIntroEncryptionTitle => 'Toujours chiffrées';

  @override
  String get onboardingIntroEncryptionBody =>
      'Les notes synchronisées vers Nostr sont chiffrées de bout en bout : les opérateurs de relais — et tous les autres — ne peuvent jamais lire leur contenu.';

  @override
  String get onboardingIntroAmberTitle =>
      'Connectez-vous sans exposer votre clé';

  @override
  String get onboardingIntroAmberBody =>
      'Utilisez Amber pour vous connecter : votre clé privée reste dans Amber et n\'est jamais partagée avec Echoes.';

  @override
  String get onboardingIntroSecurityTitle => 'Sécurité par conception';

  @override
  String get onboardingIntroSecurityBody =>
      'Votre clé privée réside dans le trousseau chiffré de votre appareil — ou, avec Amber, ne touche jamais Echoes. Les photos et notes vocales sont chiffrées avant de quitter votre appareil. Les notes peuvent être verrouillées par un mot de passe, et rien de tout cela n\'est jamais inclus dans les sauvegardes du téléphone.';

  @override
  String get onboardingNextButton => 'Suivant';

  @override
  String get onboardingBackButton => 'Retour';

  @override
  String get onboardingSkipButton =>
      'Ignorer — utiliser Echoes en local uniquement';

  @override
  String get onboardingRelayTitle =>
      'Choisissez des relais pour la synchronisation';

  @override
  String get onboardingRelayBody =>
      'Les relais sont l\'endroit où vos notes chiffrées sont stockées lors de la synchronisation. Ajoutez-en un ou plusieurs — ceux-ci, très utilisés, sont un bon début :';

  @override
  String get onboardingFinishButton => 'Commencer';

  @override
  String get syncNoteTooltip => 'Synchroniser cette note';

  @override
  String get unsyncNoteTooltip => 'Retirer des relais';

  @override
  String get syncSelectedTooltip => 'Synchroniser les notes sélectionnées';

  @override
  String get exportSelectedTooltip => 'Exporter les notes sélectionnées';

  @override
  String get deleteSelectedTooltip => 'Supprimer les notes sélectionnées';

  @override
  String syncNoteError(String error) {
    return 'Impossible de synchroniser la note : $error';
  }

  @override
  String unsyncNoteError(String error) {
    return 'Impossible de retirer la note des relais : $error';
  }

  @override
  String deleteNoteRelayError(String error) {
    return 'Note supprimée localement, mais impossible de la retirer des relais : $error';
  }

  @override
  String deleteNotesRelayError(int count) {
    return '$count notes supprimées localement, mais impossible de les retirer des relais';
  }

  @override
  String get deletingNotesTitle => 'Suppression des notes…';

  @override
  String deletingNotesProgress(int completed, int total) {
    return 'Suppression de $completed sur $total';
  }

  @override
  String get syncSelectedSuccess => 'Notes synchronisées';

  @override
  String syncSelectedPartialError(int count) {
    return 'Impossible de synchroniser $count notes';
  }

  @override
  String get exportConfirmTitle => 'Exporter les notes';

  @override
  String get exportConfirmBody =>
      'Crée un fichier de sauvegarde de vos notes. Il inclut aussi les clés de déchiffrement des images ou notes vocales jointes — quiconque possède le fichier pourrait les lire, sauf s\'il est chiffré.';

  @override
  String get exportEncryptToggleLabel => 'Chiffrer ce fichier';

  @override
  String get exportEncryptToggleSubtitle =>
      'Recommandé — protège la sauvegarde par un mot de passe';

  @override
  String get exportPasswordDialogTitle => 'Saisissez votre mot de passe';

  @override
  String get exportSetPasswordDialogTitle =>
      'Définissez un mot de passe pour cet export';

  @override
  String get importPasswordDialogTitle =>
      'Saisissez le mot de passe de l\'export';

  @override
  String get sectionData => 'Données';

  @override
  String get exportNotesButton => 'Exporter les notes';

  @override
  String get exportNotesSubtitle =>
      'Enregistrez toutes vos notes dans un fichier que vous pourrez réimporter plus tard';

  @override
  String get importNotesButton => 'Importer des notes';

  @override
  String get importNotesSubtitle =>
      'Restaurez des notes à partir d\'un fichier exporté précédemment';

  @override
  String get exportNotesSuccess => 'Notes exportées';

  @override
  String exportNotesError(Object error) {
    return 'Impossible d\'exporter les notes : $error';
  }

  @override
  String importNotesSuccess(int count) {
    return '$count notes importées';
  }

  @override
  String importNotesError(Object error) {
    return 'Impossible d\'importer les notes : $error';
  }

  @override
  String get sectionAttachments => 'Pièces jointes';

  @override
  String get attachmentProviderSubtitle =>
      'Où les images et notes vocales chiffrées sont téléversées lors de la synchronisation';

  @override
  String get attachmentProviderCustom => 'Personnalisé…';

  @override
  String get attachmentCustomUrlLabel => 'URL du serveur';

  @override
  String get attachmentProviderHint =>
      'Some public hosts (e.g. Primal, nostr.build) reject encrypted uploads outright — they validate real image content, which ciphertext never is. Prefer a Blossom host that stores opaque blobs, or point Custom… at a self-hosted one.';

  @override
  String get sectionSupport => 'Soutien';

  @override
  String get supportEchoesTitle => 'Soutenir Echoes';

  @override
  String lightningAddressCopied(String address) {
    return '⚡ $address copiée dans le presse-papiers';
  }

  @override
  String get cancelButton => 'Annuler';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get invalidPrivateKeyError =>
      'La clé privée n\'est pas valide. Saisissez une clé nsec ou hex valide.';

  @override
  String get wrongPasswordError => 'Mot de passe incorrect';

  @override
  String genericErrorPrefix(String error) {
    return 'Erreur : $error';
  }
}
