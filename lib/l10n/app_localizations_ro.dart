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
  String get importAccountFieldLabel => 'Cheia privată (nsec) a contului tău Nostr';

  @override
  String get importButton => 'Importă';

  @override
  String get bunkerLoginButton => 'Conectează un semnatar la distanță (bunker)';

  @override
  String get bunkerFieldLabel => 'Lipește tokenul tău de conexiune bunker://';

  @override
  String get bunkerConnectButton => 'Conectează';

  @override
  String get bunkerAuthPrompt => 'Aprobă conexiunea în semnatarul tău, apoi revino';

  @override
  String get relaysTitle => 'Relee';

  @override
  String get settingsTooltip => 'Setări';

  @override
  String get searchTooltip => 'Caută';

  @override
  String get closeSearchTooltip => 'Închide căutarea';

  @override
  String get searchNotesHint => 'Caută în notițe';

  @override
  String get noSearchResultsMessage => 'Nicio potrivire.';

  @override
  String get emptyNotesMessage => 'Încă nu ai notițe. Atinge + pentru a crea una.';

  @override
  String get notesTabLabel => 'Notițe';

  @override
  String get diaryTabLabel => 'Jurnal';

  @override
  String get emptyDiaryMessage => 'Încă nu există intrări în jurnal. Atinge + pentru a scrie una.';

  @override
  String get diaryToday => 'Azi';

  @override
  String get diaryYesterday => 'Ieri';

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
  String get saveTooltip => 'Salvează';

  @override
  String get titleFieldLabel => 'Titlu';

  @override
  String get bodyFieldHint => 'Scrie aici... (markdown acceptat)';

  @override
  String get checklistItemHint => 'Element din listă';

  @override
  String get addItemButton => 'Adaugă element';

  @override
  String completedItemsSection(int count) {
    return 'Finalizate ($count)';
  }

  @override
  String get duplicateChecklistItemMessage => 'Deja pe listă, finalizat';

  @override
  String get restoreChecklistItemButton => 'Restaurează';

  @override
  String get noteSyncedMessage => 'Notiță sincronizată';

  @override
  String get noteSyncedFirstTimeMessage => 'Notiță sincronizată pentru prima dată';

  @override
  String notePartiallySyncedMessage(int accepted, int total) {
    return 'Sincronizată pe $accepted din $total relee';
  }

  @override
  String checklistProgress(int done, int total) {
    return '$done din $total finalizate';
  }

  @override
  String get showCompletedItemsTooltip => 'Arată elementele finalizate';

  @override
  String get hideCompletedItemsTooltip => 'Ascunde elementele finalizate';

  @override
  String get allChecklistItemsCompletedHidden => 'Toate elementele sunt finalizate și ascunse.';

  @override
  String get deleteCompletedItemsButton => 'Șterge elementele finalizate';

  @override
  String get deleteCompletedItemsConfirmTitle => 'Ștergi elementele finalizate?';

  @override
  String deleteCompletedItemsConfirmBody(int count) {
    return 'Se vor elimina $count elemente bifate din această listă. Nu se poate anula.';
  }

  @override
  String get addImageButton => 'Adaugă imagine';

  @override
  String get noteColorButton => 'Culoarea notiței';

  @override
  String get noteColorDefault => 'Implicit';

  @override
  String get noteColorYellow => 'Galben';

  @override
  String get noteColorRed => 'Roșu';

  @override
  String get noteColorPurple => 'Mov';

  @override
  String get noteColorBlue => 'Albastru';

  @override
  String get noteColorGreen => 'Verde';

  @override
  String get noteColorOrange => 'Portocaliu';

  @override
  String get noteColorWhite => 'Alb';

  @override
  String get recordVoiceNoteTooltip => 'Înregistrează o notiță vocală';

  @override
  String get recordVoiceNoteInstructions =>
      'Atinge butonul roșu pentru a începe înregistrarea, sau ✕ pentru a anula.';

  @override
  String get stopRecordingTooltip => 'Oprește înregistrarea';

  @override
  String get cancelRecordingTooltip => 'Anulează înregistrarea';

  @override
  String get addVoiceTimestampButton => 'Adaugă marcaj de timp';

  @override
  String get editVoiceTimestampButton => 'Editează marcajul de timp';

  @override
  String get voiceNoteUnsupportedOnPlatform =>
      'Notele vocale nu sunt acceptate pe acest dispozitiv';

  @override
  String get formatBoldTooltip => 'Aldin';

  @override
  String get formatItalicTooltip => 'Cursiv';

  @override
  String get formatHeadingTooltip => 'Titlu';

  @override
  String get formatListTooltip => 'Listă cu marcatori';

  @override
  String get formatLinkTooltip => 'Legătură';

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
  String get encryptionLoadError => 'Setările de criptare nu au putut fi încărcate';

  @override
  String get encryptionToggleTitle => 'Protejează notițele cu o parolă';

  @override
  String get encryptionToggleSubtitle =>
      'Criptează notițele stocate (AES-256-GCM) cu o cheie derivată din parola ta. Parola nu este niciodată stocată — dacă o uiți, notițele nu pot fi recuperate.';

  @override
  String get lockNotesNowTitle => 'Blochează notițele acum';

  @override
  String get lockNotesNowSubtitle => 'Va fi necesară din nou parola pentru a vedea notițele';

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
  String get disablePasswordDialogTitle => 'Introdu parola pentru a dezactiva criptarea';

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
  String get noteLayoutToggleTitle => 'Comută între vizualizarea listă și grilă';

  @override
  String get manageRelaysTitle => 'Gestionează releele';

  @override
  String get republishAllNotesButton => 'Republică toate notițele sincronizate';

  @override
  String get republishAllNotesSubtitle =>
      'Completează fiecare releu de mai sus cu notițe deja partajate în altă parte — util imediat după adăugarea unuia nou, de ex. un releu de rezervă auto-găzduit';

  @override
  String republishAllNotesSuccess(int count) {
    return '$count notițe republicate';
  }

  @override
  String republishAllNotesError(String error) {
    return 'Notițele nu au putut fi republicate: $error';
  }

  @override
  String get forceFullResyncButton => 'Forțează resincronizarea completă';

  @override
  String get forceFullResyncSubtitle =>
      'Reverifică releele pentru întregul istoric al unei notițe, nu doar ce e nou — util dacă sincronizarea pare blocată și omite notițe mai vechi, de exemplu după rezolvarea unui releu inaccesibil';

  @override
  String get forceFullResyncSuccess => 'Notițe actualizate din relee';

  @override
  String forceFullResyncError(String error) {
    return 'Notițele nu au putut fi resincronizate: $error';
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
  String get accountLocalOnlyMessage => 'Echoes este folosit local — nesincronizat cu Nostr';

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
  String get onboardingIntroLocalTitle => 'Notițele tale, mereu pe dispozitivul tău';

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
  String get onboardingIntroAmberTitle => 'Conectează-te fără a-ți expune cheia';

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
  String get exportEncryptToggleSubtitle => 'Recomandat — protejează copia de rezervă cu o parolă';

  @override
  String get exportPasswordDialogTitle => 'Introdu parola ta';

  @override
  String get exportSetPasswordDialogTitle => 'Setează o parolă pentru această exportare';

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
  String get importNotesSubtitle => 'Restaurează notițe dintr-un fișier exportat anterior';

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
      'Unele servere publice (de ex. Primal, nostr.build) resping încărcările criptate — verifică conținut real de imagine, ceea ce datele criptate nu sunt niciodată. Preferă un server Blossom care stochează date opace, sau indică Personalizat… către unul auto-găzduit.';

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

  @override
  String get shareNoteTooltip => 'Partajează';

  @override
  String get shareNoteTitle => 'Partajează nota';

  @override
  String get shareRecipientFieldLabel => 'npub sau cheia publică a destinatarului';

  @override
  String get shareAddRecipientButton => 'Adaugă';

  @override
  String get shareInvalidRecipientError => 'Nu este un npub sau o cheie publică validă';

  @override
  String get shareRecipientNotFoundError => 'Niciun cont Nostr găsit pentru acest nume';

  @override
  String get shareConfirmTitle => 'Distribui această notiță?';

  @override
  String get shareConfirmButton => 'Distribuie';

  @override
  String get shareAlreadyRecipientError => 'Deja partajată cu această persoană';

  @override
  String get shareCannotShareWithSelfError => 'Nu poți partaja o notă cu tine însuți';

  @override
  String get shareRecipientsHeader => 'Partajată cu';

  @override
  String get shareNoRecipientsMessage => 'Încă nepartajată cu nimeni.';

  @override
  String get stopSharingTooltip => 'Oprește partajarea cu această persoană';

  @override
  String get shareRevocationNote =>
      'Oricine cu care partajezi poate citi această notă pe dispozitivul său. Eliminarea cuiva oprește actualizările viitoare, dar nu poate șterge ce a primit deja.';

  @override
  String shareError(String error) {
    return 'Partajarea nu a putut fi actualizată: $error';
  }

  @override
  String get sharedWithMeHeader => 'Partajată cu tine';

  @override
  String sharedByLabel(String npub) {
    return 'Partajată de $npub';
  }

  @override
  String get sharedNoteEditableNote =>
      'Poți edita această notă; modificările tale se sincronizează înapoi la proprietar, care le îmbină.';

  @override
  String get abandonSharedNoteButton => 'Părăsește această notă partajată';

  @override
  String get abandonSharedNoteConfirmTitle => 'Părăsești această notă partajată?';

  @override
  String get abandonSharedNoteConfirmBody =>
      'Va fi eliminată de pe acest dispozitiv și nu vei mai primi actualizări. Acțiunea nu poate fi anulată — nu te vei mai putea alătura ulterior.';

  @override
  String abandonSharedNoteError(String error) {
    return 'Nu s-a putut părăsi: $error';
  }
}
