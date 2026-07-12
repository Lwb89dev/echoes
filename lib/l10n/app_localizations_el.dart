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
  String get importAccountFieldLabel =>
      'Ιδιωτικό κλειδί (nsec) του λογαριασμού σας Nostr';

  @override
  String get importButton => 'Εισαγωγή';

  @override
  String get relaysTitle => 'Relays';

  @override
  String get settingsTooltip => 'Ρυθμίσεις';

  @override
  String get emptyNotesMessage =>
      'Δεν υπάρχουν ακόμη σημειώσεις. Πατήστε + για να δημιουργήσετε μία.';

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
  String get notesLockedTitle =>
      'Οι σημειώσεις προστατεύονται με κωδικό πρόσβασης';

  @override
  String get unlockButton => 'Ξεκλείδωμα';

  @override
  String get newNoteTitle => 'Νέα σημείωση';

  @override
  String get editNoteTitle => 'Επεξεργασία σημείωσης';

  @override
  String get newDiaryEntryTitle => 'New diary entry';

  @override
  String get editDiaryEntryTitle => 'Edit diary entry';

  @override
  String get saveTooltip => 'Αποθήκευση';

  @override
  String get titleFieldLabel => 'Τίτλος';

  @override
  String get checklistLabel => 'Λίστα ελέγχου';

  @override
  String get bodyFieldHint => 'Γράψτε εδώ... (υποστηρίζεται markdown)';

  @override
  String get checklistItemHint => 'Στοιχείο λίστας';

  @override
  String get addItemButton => 'Προσθήκη στοιχείου';

  @override
  String get addImageButton => 'Προσθήκη εικόνας';

  @override
  String get recordVoiceNoteTooltip => 'Ηχογράφηση φωνητικής σημείωσης';

  @override
  String get stopRecordingTooltip => 'Διακοπή ηχογράφησης';

  @override
  String get cancelRecordingTooltip => 'Ακύρωση ηχογράφησης';

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
  String get encryptionLoadError =>
      'Δεν ήταν δυνατή η φόρτωση των ρυθμίσεων κρυπτογράφησης';

  @override
  String get encryptionToggleTitle =>
      'Προστασία σημειώσεων με κωδικό πρόσβασης';

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
  String get lightThemeToggleSubtitle =>
      'Χρήση ανοιχτόχρωμου συνδυασμού χρωμάτων αντί για σκούρο';

  @override
  String get noteLayoutToggleTitle => 'Διάταξη λίστας σημειώσεων';

  @override
  String get noteLayoutToggleSubtitle =>
      'Εναλλαγή μεταξύ προβολής λίστας και πλέγματος';

  @override
  String get manageRelaysTitle => 'Διαχείριση relay';

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
  String get confirmButton => 'Επιβεβαίωση';

  @override
  String get sectionLanguage => 'Γλώσσα';

  @override
  String get langSystem => 'Προεπιλογή συστήματος';

  @override
  String get sectionAccount => 'Λογαριασμός';

  @override
  String get accountLocalOnlyMessage =>
      'Χρήση του Echoes τοπικά — χωρίς συγχρονισμό με το Nostr';

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
  String get onboardingIntroLocalTitle =>
      'Οι σημειώσεις σας, πάντα στη συσκευή σας';

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
  String get onboardingIntroAmberTitle =>
      'Σύνδεση χωρίς αποκάλυψη του κλειδιού σας';

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
  String get exportSetPasswordDialogTitle =>
      'Ορίστε κωδικό πρόσβασης για αυτήν την εξαγωγή';

  @override
  String get importPasswordDialogTitle =>
      'Εισαγάγετε τον κωδικό πρόσβασης της εξαγωγής';

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
  String get importNotesSubtitle =>
      'Επαναφέρετε σημειώσεις από ένα αρχείο που εξήχθη νωρίτερα';

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
      'Some public hosts (e.g. Primal, nostr.build) reject encrypted uploads outright — they validate real image content, which ciphertext never is. Prefer a Blossom host that stores opaque blobs, or point Custom… at a self-hosted one.';

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
}
