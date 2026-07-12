// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get loginSubtitle => 'Conectează-te cu contul tău Nostr';

  @override
  String get loginWithAmberButton => 'Conectare cu Amber';

  @override
  String get importAccountButton => 'Importă cont Nostr';

  @override
  String get importAccountFieldLabel =>
      'Cheia privată (nsec) a contului tău Nostr';

  @override
  String get importButton => 'Importă';

  @override
  String get relaysTitle => 'Relee';

  @override
  String get settingsTooltip => 'Setări';

  @override
  String get emptyNotesMessage =>
      'Încă nu ai notițe. Atinge + pentru a crea una.';

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
  String get newPlainNoteOption => 'Notiță';

  @override
  String get newChecklistOption => 'Listă de verificare';

  @override
  String get newVoiceNoteOption => 'Notiță vocală';

  @override
  String get deleteNoteButton => 'Șterge nota';

  @override
  String get deleteNoteConfirmTitle => 'Ștergeți această notă?';

  @override
  String get deleteNoteConfirmBody =>
      'Această acțiune nu poate fi anulată. Dacă această notă a fost sincronizată, va fi eliminată și de pe releele tale.';

  @override
  String deleteNotesConfirmTitle(int count) {
    return 'Ștergeți $count note?';
  }

  @override
  String get deleteNotesConfirmBody =>
      'Această acțiune nu poate fi anulată. Dacă oricare dintre aceste note a fost sincronizată, va fi eliminată și de pe releele tale.';

  @override
  String selectionCount(int count) {
    return '$count selectate';
  }

  @override
  String get untitledNote => '(fără titlu)';

  @override
  String errorLoadingNotes(String error) {
    return 'Eroare la încărcarea notițelor: $error';
  }

  @override
  String get timeJustNow => 'acum';

  @override
  String timeMinutesAgo(int count) {
    return 'acum $count min';
  }

  @override
  String timeHoursAgo(int count) {
    return 'acum $count h';
  }

  @override
  String timeDaysAgo(int count) {
    return 'acum $count zile';
  }

  @override
  String get notesLockedTitle => 'Notițele sunt protejate cu o parolă';

  @override
  String get unlockButton => 'Deblochează';

  @override
  String get newNoteTitle => 'Notiță nouă';

  @override
  String get editNoteTitle => 'Editează notița';

  @override
  String get newDiaryEntryTitle => 'New diary entry';

  @override
  String get editDiaryEntryTitle => 'Edit diary entry';

  @override
  String get saveTooltip => 'Salvează';

  @override
  String get titleFieldLabel => 'Titlu';

  @override
  String get checklistLabel => 'Listă de verificare';

  @override
  String get bodyFieldHint => 'Scrie aici... (markdown acceptat)';

  @override
  String get checklistItemHint => 'Element din listă';

  @override
  String get addItemButton => 'Adaugă element';

  @override
  String get addImageButton => 'Adaugă imagine';

  @override
  String get recordVoiceNoteTooltip => 'Înregistrează o notiță vocală';

  @override
  String get stopRecordingTooltip => 'Oprește înregistrarea';

  @override
  String get cancelRecordingTooltip => 'Anulează înregistrarea';

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
  String get imageSizeSmall => 'Mică';

  @override
  String get imageSizeMedium => 'Medie';

  @override
  String get imageSizeFull => 'Lățime completă';

  @override
  String get removeImageButton => 'Elimină imaginea';

  @override
  String get relayUrlHint => 'wss://relay.example.com';

  @override
  String get noRelaysMessage => 'Niciun releu configurat încă.';

  @override
  String relaysCount(int count) {
    return '$count relee';
  }

  @override
  String get settingsTitle => 'Setări';

  @override
  String get sectionSecurity => 'Securitate';

  @override
  String get loadingLabel => 'Se încarcă…';

  @override
  String get encryptionLoadError =>
      'Setările de criptare nu au putut fi încărcate';

  @override
  String get encryptionToggleTitle => 'Protejează notițele cu o parolă';

  @override
  String get encryptionToggleSubtitle =>
      'Criptează notițele stocate (AES-256-GCM) cu o cheie derivată din parola ta. Parola nu este niciodată stocată — dacă o uiți, notițele nu pot fi recuperate.';

  @override
  String get lockNotesNowTitle => 'Blochează notițele acum';

  @override
  String get lockNotesNowSubtitle =>
      'Va fi necesară din nou parola pentru a vedea notițele';

  @override
  String get setPasswordDialogTitle => 'Setează o parolă';

  @override
  String get passwordTooShortError => 'Cel puțin 8 caractere';

  @override
  String get confirmPasswordLabel => 'Confirmă parola';

  @override
  String get passwordsDoNotMatchError => 'Parolele nu coincid';

  @override
  String enableEncryptionError(String error) {
    return 'Criptarea nu a putut fi activată: $error';
  }

  @override
  String get enableButton => 'Activează';

  @override
  String get disablePasswordDialogTitle =>
      'Introdu parola pentru a dezactiva criptarea';

  @override
  String get disableButton => 'Dezactivează';

  @override
  String get sectionAppearance => 'Aspect';

  @override
  String get lightThemeToggleTitle => 'Temă deschisă';

  @override
  String get lightThemeToggleSubtitle =>
      'Utilizează o schemă de culori deschisă în loc de întunecată';

  @override
  String get noteLayoutToggleTitle => 'Aspectul listei de notițe';

  @override
  String get noteLayoutToggleSubtitle =>
      'Comută între vizualizarea listă și grilă';

  @override
  String get manageRelaysTitle => 'Gestionează releele';

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
  String get confirmButton => 'Confirmă';

  @override
  String get sectionLanguage => 'Limbă';

  @override
  String get langSystem => 'Implicit sistem';

  @override
  String get sectionAccount => 'Cont';

  @override
  String get accountLocalOnlyMessage =>
      'Echoes este folosit local — nesincronizat cu Nostr';

  @override
  String get accountSignInButton => 'Conectare';

  @override
  String accountSignedInAs(String npub) {
    return 'Conectat ca $npub';
  }

  @override
  String get accountSignOutButton => 'Deconectare';

  @override
  String get accountSignOutConfirmTitle => 'Te deconectezi?';

  @override
  String get accountSignOutConfirmBody =>
      'Notițele tale rămân pe acest dispozitiv. Te poți conecta din nou oricând.';

  @override
  String get onboardingWelcomeTitle => 'Bine ai venit în Echoes';

  @override
  String get onboardingIntroLocalTitle =>
      'Notițele tale, mereu pe dispozitivul tău';

  @override
  String get onboardingIntroLocalBody =>
      'Fiecare notiță este salvată mai întâi local, astfel încât aplicația funcționează complet offline. Nimic nu părăsește dispozitivul tău decât dacă alegi să sincronizezi.';

  @override
  String get onboardingIntroSyncTitle => 'Sincronizare opțională prin Nostr';

  @override
  String get onboardingIntroSyncBody =>
      'Activează sincronizarea pentru a face copii de rezervă ale notițelor tale și a le citi pe alte dispozitive, folosind protocolul deschis Nostr și releele alese de tine.';

  @override
  String get onboardingIntroEncryptionTitle => 'Întotdeauna criptate';

  @override
  String get onboardingIntroEncryptionBody =>
      'Notițele sincronizate cu Nostr sunt criptate integral, astfel încât operatorii releelor — și oricine altcineva — nu pot citi niciodată conținutul lor.';

  @override
  String get onboardingIntroAmberTitle =>
      'Conectează-te fără a-ți expune cheia';

  @override
  String get onboardingIntroAmberBody =>
      'Folosește Amber pentru conectare: cheia ta privată rămâne în Amber și nu este niciodată partajată cu Echoes.';

  @override
  String get onboardingIntroSecurityTitle => 'Securitate prin design';

  @override
  String get onboardingIntroSecurityBody =>
      'Cheia ta privată se află în depozitul de chei criptat al dispozitivului — sau, cu Amber, nu atinge niciodată Echoes. Fotografiile și notițele vocale sunt criptate înainte de a părăsi dispozitivul. Notițele pot fi blocate cu o parolă, iar nimic din toate acestea nu este inclus vreodată în copiile de rezervă ale telefonului.';

  @override
  String get onboardingNextButton => 'Înainte';

  @override
  String get onboardingBackButton => 'Înapoi';

  @override
  String get onboardingSkipButton => 'Omite — folosește Echoes doar local';

  @override
  String get onboardingRelayTitle => 'Alege relee pentru sincronizare';

  @override
  String get onboardingRelayBody =>
      'Releele sunt locul unde sunt stocate notițele tale criptate atunci când sincronizezi. Adaugă unul sau mai multe — acestea populare sunt un bun început:';

  @override
  String get onboardingFinishButton => 'Începe';

  @override
  String get syncNoteTooltip => 'Sincronizează această notiță';

  @override
  String get unsyncNoteTooltip => 'Elimină de pe relee';

  @override
  String get syncSelectedTooltip => 'Sincronizează notele selectate';

  @override
  String get exportSelectedTooltip => 'Exportă notele selectate';

  @override
  String get deleteSelectedTooltip => 'Șterge notele selectate';

  @override
  String syncNoteError(String error) {
    return 'Notița nu a putut fi sincronizată: $error';
  }

  @override
  String unsyncNoteError(String error) {
    return 'Nota nu a putut fi eliminată de pe relee: $error';
  }

  @override
  String deleteNoteRelayError(String error) {
    return 'Nota a fost ștearsă local, dar nu a putut fi eliminată de pe relee: $error';
  }

  @override
  String deleteNotesRelayError(int count) {
    return '$count note șterse local, dar nu au putut fi eliminate de pe relee';
  }

  @override
  String get deletingNotesTitle => 'Se șterg notițele…';

  @override
  String deletingNotesProgress(int completed, int total) {
    return 'Se șterge $completed din $total';
  }

  @override
  String get syncSelectedSuccess => 'Note sincronizate';

  @override
  String syncSelectedPartialError(int count) {
    return 'Nu s-au putut sincroniza $count note';
  }

  @override
  String get exportConfirmTitle => 'Exportă notițele';

  @override
  String get exportConfirmBody =>
      'Creează un fișier de rezervă al notițelor tale. Include, de asemenea, cheile de decriptare pentru orice imagini sau notițe vocale atașate — oricine are fișierul le-ar putea citi, cu excepția cazului în care este criptat.';

  @override
  String get exportEncryptToggleLabel => 'Criptează acest fișier';

  @override
  String get exportEncryptToggleSubtitle =>
      'Recomandat — protejează copia de rezervă cu o parolă';

  @override
  String get exportPasswordDialogTitle => 'Introdu parola ta';

  @override
  String get exportSetPasswordDialogTitle =>
      'Setează o parolă pentru această exportare';

  @override
  String get importPasswordDialogTitle => 'Introdu parola exportului';

  @override
  String get sectionData => 'Date';

  @override
  String get exportNotesButton => 'Exportă notițele';

  @override
  String get exportNotesSubtitle =>
      'Salvează toate notițele într-un fișier pe care îl poți importa din nou mai târziu';

  @override
  String get importNotesButton => 'Importă notițe';

  @override
  String get importNotesSubtitle =>
      'Restaurează notițe dintr-un fișier exportat anterior';

  @override
  String get exportNotesSuccess => 'Notițe exportate';

  @override
  String exportNotesError(Object error) {
    return 'Notițele nu au putut fi exportate: $error';
  }

  @override
  String importNotesSuccess(int count) {
    return 'S-au importat $count notițe';
  }

  @override
  String importNotesError(Object error) {
    return 'Notițele nu au putut fi importate: $error';
  }

  @override
  String get sectionAttachments => 'Atașamente';

  @override
  String get attachmentProviderSubtitle =>
      'Unde sunt încărcate imaginile și notele vocale criptate la sincronizare';

  @override
  String get attachmentProviderCustom => 'Personalizat…';

  @override
  String get attachmentCustomUrlLabel => 'URL server';

  @override
  String get attachmentProviderHint =>
      'Some public hosts (e.g. Primal, nostr.build) reject encrypted uploads outright — they validate real image content, which ciphertext never is. Prefer a Blossom host that stores opaque blobs, or point Custom… at a self-hosted one.';

  @override
  String get sectionSupport => 'Susținere';

  @override
  String get supportEchoesTitle => 'Susține Echoes';

  @override
  String lightningAddressCopied(String address) {
    return '⚡ $address copiat în clipboard';
  }

  @override
  String get cancelButton => 'Anulează';

  @override
  String get passwordLabel => 'Parolă';

  @override
  String get invalidPrivateKeyError =>
      'Cheia privată nu este validă. Introduceți o cheie nsec sau hex validă.';

  @override
  String get wrongPasswordError => 'Parolă greșită';

  @override
  String genericErrorPrefix(String error) {
    return 'Eroare: $error';
  }
}
