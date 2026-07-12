// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get loginSubtitle => 'Log in met je Nostr-account';

  @override
  String get loginWithAmberButton => 'Inloggen met Amber';

  @override
  String get importAccountButton => 'Nostr-account importeren';

  @override
  String get importAccountFieldLabel =>
      'Privésleutel (nsec) van je Nostr-account';

  @override
  String get importButton => 'Importeren';

  @override
  String get relaysTitle => 'Relays';

  @override
  String get settingsTooltip => 'Instellingen';

  @override
  String get emptyNotesMessage =>
      'Nog geen notities. Tik op + om er een te maken.';

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
  String get newPlainNoteOption => 'Notitie';

  @override
  String get newChecklistOption => 'Checklist';

  @override
  String get newVoiceNoteOption => 'Spraaknotitie';

  @override
  String get deleteNoteButton => 'Notitie verwijderen';

  @override
  String get deleteNoteConfirmTitle => 'Deze notitie verwijderen?';

  @override
  String get deleteNoteConfirmBody =>
      'Dit kan niet ongedaan worden gemaakt. Als deze notitie gesynchroniseerd was, wordt deze ook van je relays verwijderd.';

  @override
  String deleteNotesConfirmTitle(int count) {
    return '$count notities verwijderen?';
  }

  @override
  String get deleteNotesConfirmBody =>
      'Dit kan niet ongedaan worden gemaakt. Als een van deze notities gesynchroniseerd was, wordt deze ook van je relays verwijderd.';

  @override
  String selectionCount(int count) {
    return '$count geselecteerd';
  }

  @override
  String get untitledNote => '(zonder titel)';

  @override
  String errorLoadingNotes(String error) {
    return 'Fout bij het laden van notities: $error';
  }

  @override
  String get timeJustNow => 'nu';

  @override
  String timeMinutesAgo(int count) {
    return '${count}m geleden';
  }

  @override
  String timeHoursAgo(int count) {
    return '${count}u geleden';
  }

  @override
  String timeDaysAgo(int count) {
    return '${count}d geleden';
  }

  @override
  String get notesLockedTitle => 'Notities zijn beveiligd met een wachtwoord';

  @override
  String get unlockButton => 'Ontgrendelen';

  @override
  String get newNoteTitle => 'Nieuwe notitie';

  @override
  String get editNoteTitle => 'Notitie bewerken';

  @override
  String get newDiaryEntryTitle => 'New diary entry';

  @override
  String get editDiaryEntryTitle => 'Edit diary entry';

  @override
  String get saveTooltip => 'Opslaan';

  @override
  String get titleFieldLabel => 'Titel';

  @override
  String get checklistLabel => 'Checklist';

  @override
  String get bodyFieldHint => 'Schrijf hier... (markdown wordt ondersteund)';

  @override
  String get checklistItemHint => 'Checklistitem';

  @override
  String get addItemButton => 'Item toevoegen';

  @override
  String get addImageButton => 'Afbeelding toevoegen';

  @override
  String get recordVoiceNoteTooltip => 'Spraaknotitie opnemen';

  @override
  String get stopRecordingTooltip => 'Opname stoppen';

  @override
  String get cancelRecordingTooltip => 'Opname annuleren';

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
  String get imageSizeSmall => 'Klein';

  @override
  String get imageSizeMedium => 'Middel';

  @override
  String get imageSizeFull => 'Volledige breedte';

  @override
  String get removeImageButton => 'Afbeelding verwijderen';

  @override
  String get relayUrlHint => 'wss://relay.example.com';

  @override
  String get noRelaysMessage => 'Nog geen relay geconfigureerd.';

  @override
  String relaysCount(int count) {
    return '$count relays';
  }

  @override
  String get settingsTitle => 'Instellingen';

  @override
  String get sectionSecurity => 'Beveiliging';

  @override
  String get loadingLabel => 'Bezig met laden…';

  @override
  String get encryptionLoadError =>
      'Versleutelingsinstellingen konden niet worden geladen';

  @override
  String get encryptionToggleTitle => 'Notities beveiligen met een wachtwoord';

  @override
  String get encryptionToggleSubtitle =>
      'Versleutelt opgeslagen notities (AES-256-GCM) met een sleutel afgeleid van je wachtwoord. Het wachtwoord wordt nooit opgeslagen — als je het vergeet, kunnen de notities niet worden hersteld.';

  @override
  String get lockNotesNowTitle => 'Notities nu vergrendelen';

  @override
  String get lockNotesNowSubtitle =>
      'Vereist het wachtwoord opnieuw om notities te bekijken';

  @override
  String get setPasswordDialogTitle => 'Wachtwoord instellen';

  @override
  String get passwordTooShortError => 'Minstens 8 tekens';

  @override
  String get confirmPasswordLabel => 'Wachtwoord bevestigen';

  @override
  String get passwordsDoNotMatchError => 'Wachtwoorden komen niet overeen';

  @override
  String enableEncryptionError(String error) {
    return 'Versleuteling kon niet worden ingeschakeld: $error';
  }

  @override
  String get enableButton => 'Inschakelen';

  @override
  String get disablePasswordDialogTitle =>
      'Voer je wachtwoord in om versleuteling uit te schakelen';

  @override
  String get disableButton => 'Uitschakelen';

  @override
  String get sectionAppearance => 'Weergave';

  @override
  String get lightThemeToggleTitle => 'Licht thema';

  @override
  String get lightThemeToggleSubtitle =>
      'Gebruik een licht kleurenschema in plaats van donker';

  @override
  String get noteLayoutToggleTitle => 'Indeling notitielijst';

  @override
  String get noteLayoutToggleSubtitle =>
      'Schakel tussen lijst- en rasterweergave';

  @override
  String get manageRelaysTitle => 'Relays beheren';

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
  String get confirmButton => 'Bevestigen';

  @override
  String get sectionLanguage => 'Taal';

  @override
  String get langSystem => 'Systeemstandaard';

  @override
  String get sectionAccount => 'Account';

  @override
  String get accountLocalOnlyMessage =>
      'Echoes wordt lokaal gebruikt — niet gesynchroniseerd met Nostr';

  @override
  String get accountSignInButton => 'Inloggen';

  @override
  String accountSignedInAs(String npub) {
    return 'Ingelogd als $npub';
  }

  @override
  String get accountSignOutButton => 'Uitloggen';

  @override
  String get accountSignOutConfirmTitle => 'Uitloggen?';

  @override
  String get accountSignOutConfirmBody =>
      'Je notities blijven op dit apparaat staan. Je kunt altijd opnieuw inloggen.';

  @override
  String get onboardingWelcomeTitle => 'Welkom bij Echoes';

  @override
  String get onboardingIntroLocalTitle => 'Je notities, altijd op je apparaat';

  @override
  String get onboardingIntroLocalBody =>
      'Elke notitie wordt eerst lokaal opgeslagen, zodat de app volledig offline werkt. Er verlaat niets je apparaat, tenzij je ervoor kiest om te synchroniseren.';

  @override
  String get onboardingIntroSyncTitle => 'Optionele synchronisatie via Nostr';

  @override
  String get onboardingIntroSyncBody =>
      'Schakel synchronisatie in om je notities te back-uppen en op andere apparaten te lezen, met behulp van het open Nostr-protocol en relays naar keuze.';

  @override
  String get onboardingIntroEncryptionTitle => 'Altijd versleuteld';

  @override
  String get onboardingIntroEncryptionBody =>
      'Notities die naar Nostr worden gesynchroniseerd zijn end-to-end versleuteld, zodat relay-beheerders — en verder niemand — de inhoud ooit kunnen lezen.';

  @override
  String get onboardingIntroAmberTitle =>
      'Inloggen zonder je sleutel bloot te geven';

  @override
  String get onboardingIntroAmberBody =>
      'Gebruik Amber om in te loggen: je privésleutel blijft in Amber en wordt nooit met Echoes gedeeld.';

  @override
  String get onboardingIntroSecurityTitle => 'Beveiliging vanaf het ontwerp';

  @override
  String get onboardingIntroSecurityBody =>
      'Je privésleutel bevindt zich in de versleutelde keystore van je apparaat — of komt met Amber helemaal nooit in aanraking met Echoes. Foto\'s en spraakmemo\'s worden versleuteld voordat ze je apparaat verlaten. Notities kunnen worden vergrendeld met een wachtwoord, en niets hiervan wordt ooit opgenomen in telefoonback-ups.';

  @override
  String get onboardingNextButton => 'Volgende';

  @override
  String get onboardingBackButton => 'Terug';

  @override
  String get onboardingSkipButton =>
      'Overslaan — Echoes alleen lokaal gebruiken';

  @override
  String get onboardingRelayTitle => 'Kies relays om te synchroniseren';

  @override
  String get onboardingRelayBody =>
      'Relays zijn waar je versleutelde notities worden opgeslagen bij synchronisatie. Voeg er een of meer toe — deze populaire zijn een goed begin:';

  @override
  String get onboardingFinishButton => 'Aan de slag';

  @override
  String get syncNoteTooltip => 'Deze notitie synchroniseren';

  @override
  String get unsyncNoteTooltip => 'Verwijderen van relays';

  @override
  String get syncSelectedTooltip => 'Geselecteerde notities synchroniseren';

  @override
  String get exportSelectedTooltip => 'Geselecteerde notities exporteren';

  @override
  String get deleteSelectedTooltip => 'Geselecteerde notities verwijderen';

  @override
  String syncNoteError(String error) {
    return 'Kon notitie niet synchroniseren: $error';
  }

  @override
  String unsyncNoteError(String error) {
    return 'Kon notitie niet van de relays verwijderen: $error';
  }

  @override
  String deleteNoteRelayError(String error) {
    return 'Notitie lokaal verwijderd, maar kon niet van de relays worden verwijderd: $error';
  }

  @override
  String deleteNotesRelayError(int count) {
    return '$count notities lokaal verwijderd, maar konden niet van de relays worden verwijderd';
  }

  @override
  String get deletingNotesTitle => 'Notities verwijderen…';

  @override
  String deletingNotesProgress(int completed, int total) {
    return 'Bezig met verwijderen van $completed van $total';
  }

  @override
  String get syncSelectedSuccess => 'Notities gesynchroniseerd';

  @override
  String syncSelectedPartialError(int count) {
    return 'Kon $count notities niet synchroniseren';
  }

  @override
  String get exportConfirmTitle => 'Notities exporteren';

  @override
  String get exportConfirmBody =>
      'Maakt een back-upbestand van je notities. Dit bevat ook de decoderingssleutels voor bijgevoegde afbeeldingen of spraakmemo\'s — iedereen met het bestand zou ze kunnen lezen, tenzij het versleuteld is.';

  @override
  String get exportEncryptToggleLabel => 'Dit bestand versleutelen';

  @override
  String get exportEncryptToggleSubtitle =>
      'Aanbevolen — beschermt de back-up met een wachtwoord';

  @override
  String get exportPasswordDialogTitle => 'Voer je wachtwoord in';

  @override
  String get exportSetPasswordDialogTitle =>
      'Stel een wachtwoord in voor deze export';

  @override
  String get importPasswordDialogTitle =>
      'Voer het wachtwoord van de export in';

  @override
  String get sectionData => 'Gegevens';

  @override
  String get exportNotesButton => 'Notities exporteren';

  @override
  String get exportNotesSubtitle =>
      'Sla al je notities op in een bestand dat je later opnieuw kunt importeren';

  @override
  String get importNotesButton => 'Notities importeren';

  @override
  String get importNotesSubtitle =>
      'Herstel notities uit een eerder geëxporteerd bestand';

  @override
  String get exportNotesSuccess => 'Notities geëxporteerd';

  @override
  String exportNotesError(Object error) {
    return 'Kon notities niet exporteren: $error';
  }

  @override
  String importNotesSuccess(int count) {
    return '$count notities geïmporteerd';
  }

  @override
  String importNotesError(Object error) {
    return 'Kon notities niet importeren: $error';
  }

  @override
  String get sectionAttachments => 'Bijlagen';

  @override
  String get attachmentProviderSubtitle =>
      'Waar versleutelde afbeeldingen en spraaknotities worden geüpload bij synchroniseren';

  @override
  String get attachmentProviderCustom => 'Aangepast…';

  @override
  String get attachmentCustomUrlLabel => 'Server-URL';

  @override
  String get attachmentProviderHint =>
      'Some public hosts (e.g. Primal, nostr.build) reject encrypted uploads outright — they validate real image content, which ciphertext never is. Prefer a Blossom host that stores opaque blobs, or point Custom… at a self-hosted one.';

  @override
  String get sectionSupport => 'Ondersteuning';

  @override
  String get supportEchoesTitle => 'Steun Echoes';

  @override
  String lightningAddressCopied(String address) {
    return '⚡ $address gekopieerd naar klembord';
  }

  @override
  String get cancelButton => 'Annuleren';

  @override
  String get passwordLabel => 'Wachtwoord';

  @override
  String get invalidPrivateKeyError =>
      'De privésleutel is ongeldig. Voer een geldige nsec- of hex-sleutel in.';

  @override
  String get wrongPasswordError => 'Onjuist wachtwoord';

  @override
  String genericErrorPrefix(String error) {
    return 'Fout: $error';
  }
}
