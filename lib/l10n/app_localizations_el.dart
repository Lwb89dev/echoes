// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get loginSubtitle => 'Συνδεθείτε με τον λογαριασμό σας Nostr';

  @override
  String get loginWithAmberButton => 'Σύνδεση με Amber';

  @override
  String get importAccountButton => 'Εισαγωγή λογαριασμού Nostr';

  @override
  String get importAccountFieldLabel => 'Ιδιωτικό κλειδί (nsec) του λογαριασμού σας Nostr';

  @override
  String get importButton => 'Εισαγωγή';

  @override
  String get bunkerLoginButton => 'Σύνδεση απομακρυσμένου υπογράφοντα (bunker)';

  @override
  String get bunkerFieldLabel => 'Επικόλλησε το token σύνδεσης bunker://';

  @override
  String get bunkerConnectButton => 'Σύνδεση';

  @override
  String get bunkerAuthPrompt => 'Ενέκρινε τη σύνδεση στον υπογράφοντά σου και επίστρεψε';

  @override
  String get relaysTitle => 'Relays';

  @override
  String get settingsTooltip => 'Ρυθμίσεις';

  @override
  String get searchTooltip => 'Αναζήτηση';

  @override
  String get closeSearchTooltip => 'Κλείσιμο αναζήτησης';

  @override
  String get searchNotesHint => 'Αναζήτηση στις σημειώσεις';

  @override
  String get noSearchResultsMessage => 'Δεν βρέθηκαν αποτελέσματα.';

  @override
  String get emptyNotesMessage =>
      'Δεν υπάρχουν ακόμη σημειώσεις. Πατήστε + για να δημιουργήσετε μία.';

  @override
  String get notesTabLabel => 'Σημειώσεις';

  @override
  String get diaryTabLabel => 'Ημερολόγιο';

  @override
  String get emptyDiaryMessage => 'Δεν υπάρχουν ακόμη καταχωρήσεις. Πατήστε + για να γράψετε μία.';

  @override
  String get diaryToday => 'Σήμερα';

  @override
  String get diaryYesterday => 'Χθες';

  @override
  String get newPlainNoteOption => 'Σημείωση';

  @override
  String get newChecklistOption => 'Λίστα ελέγχου';

  @override
  String get newVoiceNoteOption => 'Φωνητική σημείωση';

  @override
  String get deleteNoteButton => 'Διαγραφή σημείωσης';

  @override
  String get deleteNoteConfirmTitle => 'Διαγραφή αυτής της σημείωσης;';

  @override
  String get deleteNoteConfirmBody =>
      'Αυτό δεν μπορεί να αναιρεθεί. Αν αυτή η σημείωση ήταν συγχρονισμένη, θα αφαιρεθεί και από τα relay σας.';

  @override
  String deleteNotesConfirmTitle(int count) {
    return 'Διαγραφή $count σημειώσεων;';
  }

  @override
  String get deleteNotesConfirmBody =>
      'Αυτό δεν μπορεί να αναιρεθεί. Αν κάποια από αυτές τις σημειώσεις ήταν συγχρονισμένη, θα αφαιρεθεί και από τα relay σας.';

  @override
  String selectionCount(int count) {
    return '$count επιλεγμένες';
  }

  @override
  String get untitledNote => '(χωρίς τίτλο)';

  @override
  String errorLoadingNotes(String error) {
    return 'Σφάλμα κατά τη φόρτωση των σημειώσεων: $error';
  }

  @override
  String get timeJustNow => 'τώρα';

  @override
  String timeMinutesAgo(int count) {
    return 'πριν $count λ';
  }

  @override
  String timeHoursAgo(int count) {
    return 'πριν $count ώ';
  }

  @override
  String timeDaysAgo(int count) {
    return 'πριν $count η';
  }

  @override
  String get notesLockedTitle => 'Οι σημειώσεις προστατεύονται με κωδικό πρόσβασης';

  @override
  String get unlockButton => 'Ξεκλείδωμα';

  @override
  String get saveTooltip => 'Αποθήκευση';

  @override
  String get titleFieldLabel => 'Τίτλος';

  @override
  String get bodyFieldHint => 'Γράψτε εδώ... (υποστηρίζεται markdown)';

  @override
  String get checklistItemHint => 'Στοιχείο λίστας';

  @override
  String get addItemButton => 'Προσθήκη στοιχείου';

  @override
  String checklistProgress(int done, int total) {
    return '$done από $total ολοκληρώθηκαν';
  }

  @override
  String get showCompletedItemsTooltip => 'Εμφάνιση ολοκληρωμένων στοιχείων';

  @override
  String get hideCompletedItemsTooltip => 'Απόκρυψη ολοκληρωμένων στοιχείων';

  @override
  String get allChecklistItemsCompletedHidden =>
      'Όλα τα στοιχεία έχουν ολοκληρωθεί και είναι κρυμμένα.';

  @override
  String get deleteCompletedItemsButton => 'Διαγραφή ολοκληρωμένων στοιχείων';

  @override
  String get deleteCompletedItemsConfirmTitle => 'Διαγραφή ολοκληρωμένων στοιχείων;';

  @override
  String deleteCompletedItemsConfirmBody(int count) {
    return 'Θα αφαιρεθούν $count επιλεγμένα στοιχεία από αυτή τη λίστα. Δεν μπορεί να αναιρεθεί.';
  }

  @override
  String get addImageButton => 'Προσθήκη εικόνας';

  @override
  String get noteColorButton => 'Χρώμα σημείωσης';

  @override
  String get noteColorDefault => 'Προεπιλογή';

  @override
  String get noteColorYellow => 'Κίτρινο';

  @override
  String get noteColorRed => 'Κόκκινο';

  @override
  String get noteColorPurple => 'Μοβ';

  @override
  String get noteColorBlue => 'Μπλε';

  @override
  String get noteColorGreen => 'Πράσινο';

  @override
  String get noteColorOrange => 'Πορτοκαλί';

  @override
  String get noteColorWhite => 'Λευκό';

  @override
  String get recordVoiceNoteTooltip => 'Ηχογράφηση φωνητικής σημείωσης';

  @override
  String get recordVoiceNoteInstructions =>
      'Πατήστε το κόκκινο κουμπί για έναρξη εγγραφής ή ✕ για ακύρωση.';

  @override
  String get stopRecordingTooltip => 'Διακοπή ηχογράφησης';

  @override
  String get cancelRecordingTooltip => 'Ακύρωση ηχογράφησης';

  @override
  String get addVoiceTimestampButton => 'Προσθήκη χρονικής σήμανσης';

  @override
  String get editVoiceTimestampButton => 'Επεξεργασία χρονικής σήμανσης';

  @override
  String get voiceNoteUnsupportedOnPlatform =>
      'Οι φωνητικές σημειώσεις δεν υποστηρίζονται σε αυτή τη συσκευή';

  @override
  String get formatBoldTooltip => 'Έντονα';

  @override
  String get formatItalicTooltip => 'Πλάγια';

  @override
  String get formatHeadingTooltip => 'Επικεφαλίδα';

  @override
  String get formatListTooltip => 'Λίστα με κουκκίδες';

  @override
  String get formatLinkTooltip => 'Σύνδεσμος';

  @override
  String get imageSizeSmall => 'Μικρό';

  @override
  String get imageSizeMedium => 'Μεσαίο';

  @override
  String get imageSizeFull => 'Πλήρες πλάτος';

  @override
  String get removeImageButton => 'Αφαίρεση εικόνας';

  @override
  String get relayUrlHint => 'wss://relay.example.com';

  @override
  String get noRelaysMessage => 'Δεν έχει διαμορφωθεί ακόμη κανένα relay.';

  @override
  String relaysCount(int count) {
    return '$count relay';
  }

  @override
  String get settingsTitle => 'Ρυθμίσεις';

  @override
  String get sectionSecurity => 'Ασφάλεια';

  @override
  String get loadingLabel => 'Φόρτωση…';

  @override
  String get encryptionLoadError => 'Δεν ήταν δυνατή η φόρτωση των ρυθμίσεων κρυπτογράφησης';

  @override
  String get encryptionToggleTitle => 'Προστασία σημειώσεων με κωδικό πρόσβασης';

  @override
  String get encryptionToggleSubtitle =>
      'Κρυπτογραφεί τις αποθηκευμένες σημειώσεις (AES-256-GCM) με κλειδί που προκύπτει από τον κωδικό σας. Ο κωδικός δεν αποθηκεύεται ποτέ — αν τον ξεχάσετε, οι σημειώσεις δεν μπορούν να ανακτηθούν.';

  @override
  String get lockNotesNowTitle => 'Κλείδωμα σημειώσεων τώρα';

  @override
  String get lockNotesNowSubtitle =>
      'Απαιτείται ξανά ο κωδικός πρόσβασης για προβολή των σημειώσεων';

  @override
  String get setPasswordDialogTitle => 'Ορισμός κωδικού πρόσβασης';

  @override
  String get passwordTooShortError => 'Τουλάχιστον 8 χαρακτήρες';

  @override
  String get confirmPasswordLabel => 'Επιβεβαίωση κωδικού πρόσβασης';

  @override
  String get passwordsDoNotMatchError => 'Οι κωδικοί πρόσβασης δεν ταιριάζουν';

  @override
  String enableEncryptionError(String error) {
    return 'Δεν ήταν δυνατή η ενεργοποίηση της κρυπτογράφησης: $error';
  }

  @override
  String get enableButton => 'Ενεργοποίηση';

  @override
  String get disablePasswordDialogTitle =>
      'Εισαγάγετε τον κωδικό σας για να απενεργοποιήσετε την κρυπτογράφηση';

  @override
  String get disableButton => 'Απενεργοποίηση';

  @override
  String get sectionAppearance => 'Εμφάνιση';

  @override
  String get lightThemeToggleTitle => 'Ανοιχτόχρωμο θέμα';

  @override
  String get lightThemeToggleSubtitle => 'Χρήση ανοιχτόχρωμου συνδυασμού χρωμάτων αντί για σκούρο';

  @override
  String get noteLayoutToggleTitle => 'Εναλλαγή μεταξύ προβολής λίστας και πλέγματος';

  @override
  String get manageRelaysTitle => 'Διαχείριση relay';

  @override
  String get republishAllNotesButton => 'Αναδημοσίευση όλων των συγχρονισμένων σημειώσεων';

  @override
  String get republishAllNotesSubtitle =>
      'Συμπληρώνει κάθε relay παραπάνω με σημειώσεις ήδη κοινοποιημένες αλλού — χρήσιμο αμέσως μετά την προσθήκη ενός, π.χ. ενός self-hosted εφεδρικού relay';

  @override
  String republishAllNotesSuccess(int count) {
    return 'Αναδημοσιεύτηκαν $count σημειώσεις';
  }

  @override
  String republishAllNotesError(String error) {
    return 'Αδυναμία αναδημοσίευσης σημειώσεων: $error';
  }

  @override
  String get forceFullResyncButton => 'Εξαναγκασμός πλήρους επανασυγχρονισμού';

  @override
  String get forceFullResyncSubtitle =>
      'Ελέγχει ξανά τους relay για ολόκληρο το ιστορικό μιας σημείωσης αντί μόνο για ό,τι είναι νέο — χρήσιμο αν ο συγχρονισμός φαίνεται κολλημένος και παραλείπει παλαιότερες σημειώσεις, π.χ. μετά την επιδιόρθωση ενός μη προσβάσιμου relay';

  @override
  String get forceFullResyncSuccess => 'Οι σημειώσεις ανανεώθηκαν από τους relay';

  @override
  String forceFullResyncError(String error) {
    return 'Δεν ήταν δυνατός ο επανασυγχρονισμός των σημειώσεων: $error';
  }

  @override
  String get confirmButton => 'Επιβεβαίωση';

  @override
  String get sectionLanguage => 'Γλώσσα';

  @override
  String get langSystem => 'Προεπιλογή συστήματος';

  @override
  String get sectionAccount => 'Λογαριασμός';

  @override
  String get accountLocalOnlyMessage => 'Χρήση του Echoes τοπικά — χωρίς συγχρονισμό με το Nostr';

  @override
  String get accountSignInButton => 'Σύνδεση';

  @override
  String accountSignedInAs(String npub) {
    return 'Συνδεδεμένος ως $npub';
  }

  @override
  String get accountSignOutButton => 'Αποσύνδεση';

  @override
  String get accountSignOutConfirmTitle => 'Αποσύνδεση;';

  @override
  String get accountSignOutConfirmBody =>
      'Οι σημειώσεις σας παραμένουν σε αυτή τη συσκευή. Μπορείτε να συνδεθείτε ξανά όποτε θέλετε.';

  @override
  String get onboardingWelcomeTitle => 'Καλώς ήρθατε στο Echoes';

  @override
  String get onboardingIntroLocalTitle => 'Οι σημειώσεις σας, πάντα στη συσκευή σας';

  @override
  String get onboardingIntroLocalBody =>
      'Κάθε σημείωση αποθηκεύεται πρώτα τοπικά, ώστε η εφαρμογή να λειτουργεί πλήρως εκτός σύνδεσης. Τίποτα δεν φεύγει από τη συσκευή σας εκτός αν επιλέξετε να το συγχρονίσετε.';

  @override
  String get onboardingIntroSyncTitle => 'Προαιρετικός συγχρονισμός μέσω Nostr';

  @override
  String get onboardingIntroSyncBody =>
      'Ενεργοποιήστε τον συγχρονισμό για να δημιουργήσετε αντίγραφα ασφαλείας των σημειώσεών σας και να τις διαβάζετε σε άλλες συσκευές, χρησιμοποιώντας το ανοιχτό πρωτόκολλο Nostr και relays της επιλογής σας.';

  @override
  String get onboardingIntroEncryptionTitle => 'Πάντα κρυπτογραφημένες';

  @override
  String get onboardingIntroEncryptionBody =>
      'Οι σημειώσεις που συγχρονίζονται στο Nostr είναι κρυπτογραφημένες από άκρο σε άκρο, οπότε οι διαχειριστές των relays — και όλοι οι άλλοι — δεν μπορούν ποτέ να διαβάσουν το περιεχόμενό τους.';

  @override
  String get onboardingIntroAmberTitle => 'Σύνδεση χωρίς αποκάλυψη του κλειδιού σας';

  @override
  String get onboardingIntroAmberBody =>
      'Χρησιμοποιήστε το Amber για σύνδεση: το ιδιωτικό σας κλειδί παραμένει στο Amber και δεν κοινοποιείται ποτέ στο Echoes.';

  @override
  String get onboardingIntroSecurityTitle => 'Ασφάλεια εκ σχεδιασμού';

  @override
  String get onboardingIntroSecurityBody =>
      'Το ιδιωτικό σας κλειδί βρίσκεται στο κρυπτογραφημένο keystore της συσκευής σας — ή, με το Amber, δεν αγγίζει καθόλου το Echoes. Οι φωτογραφίες και οι φωνητικές σημειώσεις κρυπτογραφούνται πριν φύγουν ποτέ από τη συσκευή σας. Οι σημειώσεις μπορούν να κλειδωθούν με κωδικό πρόσβασης, και τίποτα από αυτά δεν περιλαμβάνεται ποτέ σε αντίγραφα ασφαλείας του τηλεφώνου.';

  @override
  String get onboardingNextButton => 'Επόμενο';

  @override
  String get onboardingBackButton => 'Πίσω';

  @override
  String get onboardingSkipButton => 'Παράλειψη — χρήση του Echoes μόνο τοπικά';

  @override
  String get onboardingRelayTitle => 'Επιλέξτε relays για συγχρονισμό';

  @override
  String get onboardingRelayBody =>
      'Τα relays είναι το σημείο όπου αποθηκεύονται οι κρυπτογραφημένες σημειώσεις σας κατά τον συγχρονισμό. Προσθέστε ένα ή περισσότερα — αυτά τα δημοφιλή είναι ένα καλό ξεκίνημα:';

  @override
  String get onboardingFinishButton => 'Ξεκινήστε';

  @override
  String get syncNoteTooltip => 'Συγχρονισμός αυτής της σημείωσης';

  @override
  String get unsyncNoteTooltip => 'Αφαίρεση από τα relay';

  @override
  String get syncSelectedTooltip => 'Συγχρονισμός επιλεγμένων σημειώσεων';

  @override
  String get exportSelectedTooltip => 'Εξαγωγή επιλεγμένων σημειώσεων';

  @override
  String get deleteSelectedTooltip => 'Διαγραφή επιλεγμένων σημειώσεων';

  @override
  String syncNoteError(String error) {
    return 'Δεν ήταν δυνατός ο συγχρονισμός της σημείωσης: $error';
  }

  @override
  String unsyncNoteError(String error) {
    return 'Δεν ήταν δυνατή η αφαίρεση της σημείωσης από τα relay: $error';
  }

  @override
  String deleteNoteRelayError(String error) {
    return 'Η σημείωση διαγράφηκε τοπικά, αλλά δεν ήταν δυνατή η αφαίρεσή της από τα relay: $error';
  }

  @override
  String deleteNotesRelayError(int count) {
    return '$count σημειώσεις διαγράφηκαν τοπικά, αλλά δεν ήταν δυνατή η αφαίρεσή τους από τα relay';
  }

  @override
  String get deletingNotesTitle => 'Διαγραφή σημειώσεων…';

  @override
  String deletingNotesProgress(int completed, int total) {
    return 'Διαγραφή $completed από $total';
  }

  @override
  String get syncSelectedSuccess => 'Οι σημειώσεις συγχρονίστηκαν';

  @override
  String syncSelectedPartialError(int count) {
    return 'Δεν ήταν δυνατός ο συγχρονισμός $count σημειώσεων';
  }

  @override
  String get exportConfirmTitle => 'Εξαγωγή σημειώσεων';

  @override
  String get exportConfirmBody =>
      'Δημιουργεί ένα αρχείο αντιγράφου ασφαλείας των σημειώσεών σας. Περιλαμβάνει επίσης τα κλειδιά αποκρυπτογράφησης για τυχόν συνημμένες εικόνες ή φωνητικές σημειώσεις — οποιοσδήποτε έχει το αρχείο θα μπορούσε να τις διαβάσει εκτός αν είναι κρυπτογραφημένο.';

  @override
  String get exportEncryptToggleLabel => 'Κρυπτογράφηση αυτού του αρχείου';

  @override
  String get exportEncryptToggleSubtitle =>
      'Συνιστάται — προστατεύει το αντίγραφο ασφαλείας με κωδικό πρόσβασης';

  @override
  String get exportPasswordDialogTitle => 'Εισαγάγετε τον κωδικό πρόσβασής σας';

  @override
  String get exportSetPasswordDialogTitle => 'Ορίστε κωδικό πρόσβασης για αυτήν την εξαγωγή';

  @override
  String get importPasswordDialogTitle => 'Εισαγάγετε τον κωδικό πρόσβασης της εξαγωγής';

  @override
  String get sectionData => 'Δεδομένα';

  @override
  String get exportNotesButton => 'Εξαγωγή σημειώσεων';

  @override
  String get exportNotesSubtitle =>
      'Αποθηκεύστε όλες τις σημειώσεις σας σε ένα αρχείο που μπορείτε να εισαγάγετε ξανά αργότερα';

  @override
  String get importNotesButton => 'Εισαγωγή σημειώσεων';

  @override
  String get importNotesSubtitle => 'Επαναφέρετε σημειώσεις από ένα αρχείο που εξήχθη νωρίτερα';

  @override
  String get exportNotesSuccess => 'Οι σημειώσεις εξήχθησαν';

  @override
  String exportNotesError(Object error) {
    return 'Δεν ήταν δυνατή η εξαγωγή των σημειώσεων: $error';
  }

  @override
  String importNotesSuccess(int count) {
    return 'Εισήχθησαν $count σημειώσεις';
  }

  @override
  String importNotesError(Object error) {
    return 'Δεν ήταν δυνατή η εισαγωγή των σημειώσεων: $error';
  }

  @override
  String get sectionAttachments => 'Συνημμένα';

  @override
  String get attachmentProviderSubtitle =>
      'Πού μεταφορτώνονται οι κρυπτογραφημένες εικόνες και οι φωνητικές σημειώσεις κατά τον συγχρονισμό';

  @override
  String get attachmentProviderCustom => 'Προσαρμοσμένο…';

  @override
  String get attachmentCustomUrlLabel => 'URL διακομιστή';

  @override
  String get attachmentProviderHint =>
      'Ορισμένοι δημόσιοι διακομιστές (π.χ. Primal, nostr.build) απορρίπτουν τα κρυπτογραφημένα ανεβάσματα — ελέγχουν για πραγματικό περιεχόμενο εικόνας, κάτι που τα κρυπτογραφημένα δεδομένα δεν είναι ποτέ. Προτιμήστε έναν διακομιστή Blossom που αποθηκεύει αδιαφανή δεδομένα ή ορίστε το «Προσαρμοσμένο…» σε έναν δικό σας.';

  @override
  String get sectionSupport => 'Υποστήριξη';

  @override
  String get supportEchoesTitle => 'Υποστηρίξτε το Echoes';

  @override
  String lightningAddressCopied(String address) {
    return '⚡ Το $address αντιγράφηκε στο πρόχειρο';
  }

  @override
  String get cancelButton => 'Άκυρο';

  @override
  String get passwordLabel => 'Κωδικός πρόσβασης';

  @override
  String get invalidPrivateKeyError =>
      'Το ιδιωτικό κλειδί δεν είναι έγκυρο. Εισαγάγετε έγκυρο κλειδί nsec ή hex.';

  @override
  String get wrongPasswordError => 'Λανθασμένος κωδικός πρόσβασης';

  @override
  String genericErrorPrefix(String error) {
    return 'Σφάλμα: $error';
  }

  @override
  String get shareNoteTooltip => 'Κοινή χρήση';

  @override
  String get shareNoteTitle => 'Κοινή χρήση σημείωσης';

  @override
  String get shareRecipientFieldLabel => 'npub ή δημόσιο κλειδί παραλήπτη';

  @override
  String get shareAddRecipientButton => 'Προσθήκη';

  @override
  String get shareInvalidRecipientError => 'Δεν είναι έγκυρο npub ή δημόσιο κλειδί';

  @override
  String get shareRecipientNotFoundError => 'Δεν βρέθηκε λογαριασμός Nostr για αυτό το όνομα';

  @override
  String get shareConfirmTitle => 'Κοινοποίηση αυτής της σημείωσης;';

  @override
  String get shareConfirmButton => 'Κοινοποίηση';

  @override
  String get shareAlreadyRecipientError => 'Έχει ήδη κοινοποιηθεί σε αυτό το άτομο';

  @override
  String get shareCannotShareWithSelfError =>
      'Δεν μπορείτε να μοιραστείτε μια σημείωση με τον εαυτό σας';

  @override
  String get shareRecipientsHeader => 'Κοινοποιήθηκε σε';

  @override
  String get shareNoRecipientsMessage => 'Δεν έχει κοινοποιηθεί ακόμη σε κανέναν.';

  @override
  String get stopSharingTooltip => 'Διακοπή κοινής χρήσης με αυτό το άτομο';

  @override
  String get shareRevocationNote =>
      'Όποιος λαμβάνει την κοινή χρήση μπορεί να διαβάσει αυτή τη σημείωση στη συσκευή του. Η αφαίρεση κάποιου σταματά τις μελλοντικές ενημερώσεις, αλλά δεν μπορεί να σβήσει ό,τι έχει ήδη λάβει.';

  @override
  String shareError(String error) {
    return 'Δεν ήταν δυνατή η ενημέρωση της κοινής χρήσης: $error';
  }

  @override
  String get sharedWithMeHeader => 'Κοινοποιήθηκε σε εσάς';

  @override
  String sharedByLabel(String npub) {
    return 'Κοινοποιήθηκε από $npub';
  }

  @override
  String get sharedNoteEditableNote =>
      'Μπορείτε να επεξεργαστείτε αυτή τη σημείωση· οι αλλαγές σας συγχρονίζονται πίσω στον ιδιοκτήτη, ο οποίος τις συγχωνεύει.';

  @override
  String get abandonSharedNoteButton => 'Αποχώρηση από αυτή την κοινόχρηστη σημείωση';

  @override
  String get abandonSharedNoteConfirmTitle => 'Αποχώρηση από αυτή την κοινόχρηστη σημείωση;';

  @override
  String get abandonSharedNoteConfirmBody =>
      'Θα αφαιρεθεί από αυτή τη συσκευή και θα σταματήσετε να λαμβάνετε ενημερώσεις. Δεν αναιρείται — δεν θα μπορείτε να επανασυνδεθείτε αργότερα.';

  @override
  String abandonSharedNoteError(String error) {
    return 'Δεν ήταν δυνατή η αποχώρηση: $error';
  }
}
