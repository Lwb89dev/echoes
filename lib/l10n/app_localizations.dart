import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bg.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_et.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ga.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_lt.dart';
import 'app_localizations_lv.dart';
import 'app_localizations_mt.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sk.dart';
import 'app_localizations_sl.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bg'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('et'),
    Locale('fi'),
    Locale('fr'),
    Locale('ga'),
    Locale('hr'),
    Locale('hu'),
    Locale('it'),
    Locale('ja'),
    Locale('lt'),
    Locale('lv'),
    Locale('mt'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('ro'),
    Locale('ru'),
    Locale('sk'),
    Locale('sl'),
    Locale('sv'),
    Locale('zh'),
  ];

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your Nostr account'**
  String get loginSubtitle;

  /// No description provided for @loginWithAmberButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Amber'**
  String get loginWithAmberButton;

  /// No description provided for @importAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Import Nostr account'**
  String get importAccountButton;

  /// No description provided for @importAccountFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Private key (nsec) of your Nostr account'**
  String get importAccountFieldLabel;

  /// No description provided for @importButton.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get importButton;

  /// No description provided for @bunkerLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Connect a remote signer (bunker)'**
  String get bunkerLoginButton;

  /// No description provided for @bunkerFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Paste your bunker:// connection token'**
  String get bunkerFieldLabel;

  /// No description provided for @bunkerConnectButton.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get bunkerConnectButton;

  /// No description provided for @bunkerAuthPrompt.
  ///
  /// In en, this message translates to:
  /// **'Approve the connection in your signer, then come back'**
  String get bunkerAuthPrompt;

  /// No description provided for @relaysTitle.
  ///
  /// In en, this message translates to:
  /// **'Relays'**
  String get relaysTitle;

  /// No description provided for @settingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTooltip;

  /// No description provided for @searchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTooltip;

  /// No description provided for @closeSearchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Close search'**
  String get closeSearchTooltip;

  /// No description provided for @searchNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Search notes'**
  String get searchNotesHint;

  /// No description provided for @noSearchResultsMessage.
  ///
  /// In en, this message translates to:
  /// **'No matches.'**
  String get noSearchResultsMessage;

  /// No description provided for @emptyNotesMessage.
  ///
  /// In en, this message translates to:
  /// **'No notes yet. Tap + to create one.'**
  String get emptyNotesMessage;

  /// No description provided for @notesTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesTabLabel;

  /// No description provided for @diaryTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Diary'**
  String get diaryTabLabel;

  /// No description provided for @emptyDiaryMessage.
  ///
  /// In en, this message translates to:
  /// **'No diary entries yet. Tap + to write one.'**
  String get emptyDiaryMessage;

  /// No description provided for @diaryToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get diaryToday;

  /// No description provided for @diaryYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get diaryYesterday;

  /// No description provided for @newPlainNoteOption.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get newPlainNoteOption;

  /// No description provided for @newChecklistOption.
  ///
  /// In en, this message translates to:
  /// **'Checklist'**
  String get newChecklistOption;

  /// No description provided for @newVoiceNoteOption.
  ///
  /// In en, this message translates to:
  /// **'Voice note'**
  String get newVoiceNoteOption;

  /// No description provided for @deleteNoteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete note'**
  String get deleteNoteButton;

  /// No description provided for @deleteNoteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this note?'**
  String get deleteNoteConfirmTitle;

  /// No description provided for @deleteNoteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This can\'t be undone. If this note was synced, it will also be removed from your relays.'**
  String get deleteNoteConfirmBody;

  /// No description provided for @deleteNotesConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {count} notes?'**
  String deleteNotesConfirmTitle(int count);

  /// No description provided for @deleteNotesConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This can\'t be undone. If any of these notes were synced, they will also be removed from your relays.'**
  String get deleteNotesConfirmBody;

  /// No description provided for @selectionCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectionCount(int count);

  /// No description provided for @untitledNote.
  ///
  /// In en, this message translates to:
  /// **'(untitled)'**
  String get untitledNote;

  /// No description provided for @errorLoadingNotes.
  ///
  /// In en, this message translates to:
  /// **'Error loading notes: {error}'**
  String errorLoadingNotes(String error);

  /// No description provided for @timeJustNow.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get timeJustNow;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String timeMinutesAgo(int count);

  /// No description provided for @timeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String timeHoursAgo(int count);

  /// No description provided for @timeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String timeDaysAgo(int count);

  /// No description provided for @notesLockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Notes are protected with a password'**
  String get notesLockedTitle;

  /// No description provided for @unlockButton.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlockButton;

  /// No description provided for @saveTooltip.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveTooltip;

  /// No description provided for @titleFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleFieldLabel;

  /// No description provided for @bodyFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Write here... (markdown supported)'**
  String get bodyFieldHint;

  /// No description provided for @checklistItemHint.
  ///
  /// In en, this message translates to:
  /// **'Checklist item'**
  String get checklistItemHint;

  /// No description provided for @addItemButton.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get addItemButton;

  /// No description provided for @checklistProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} done'**
  String checklistProgress(int done, int total);

  /// No description provided for @showCompletedItemsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Show completed items'**
  String get showCompletedItemsTooltip;

  /// No description provided for @hideCompletedItemsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Hide completed items'**
  String get hideCompletedItemsTooltip;

  /// No description provided for @allChecklistItemsCompletedHidden.
  ///
  /// In en, this message translates to:
  /// **'All items are completed and hidden.'**
  String get allChecklistItemsCompletedHidden;

  /// No description provided for @deleteCompletedItemsButton.
  ///
  /// In en, this message translates to:
  /// **'Delete completed items'**
  String get deleteCompletedItemsButton;

  /// No description provided for @deleteCompletedItemsConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete completed items?'**
  String get deleteCompletedItemsConfirmTitle;

  /// No description provided for @deleteCompletedItemsConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This removes {count} checked-off item(s) from this checklist. This can\'t be undone.'**
  String deleteCompletedItemsConfirmBody(int count);

  /// No description provided for @addImageButton.
  ///
  /// In en, this message translates to:
  /// **'Add image'**
  String get addImageButton;

  /// No description provided for @noteColorButton.
  ///
  /// In en, this message translates to:
  /// **'Note color'**
  String get noteColorButton;

  /// No description provided for @noteColorDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get noteColorDefault;

  /// No description provided for @noteColorYellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get noteColorYellow;

  /// No description provided for @noteColorRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get noteColorRed;

  /// No description provided for @noteColorPurple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get noteColorPurple;

  /// No description provided for @noteColorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get noteColorBlue;

  /// No description provided for @noteColorGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get noteColorGreen;

  /// No description provided for @noteColorOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get noteColorOrange;

  /// No description provided for @noteColorWhite.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get noteColorWhite;

  /// No description provided for @recordVoiceNoteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Record a voice note'**
  String get recordVoiceNoteTooltip;

  /// No description provided for @recordVoiceNoteInstructions.
  ///
  /// In en, this message translates to:
  /// **'Tap the red button to start recording, or ✕ to cancel.'**
  String get recordVoiceNoteInstructions;

  /// No description provided for @stopRecordingTooltip.
  ///
  /// In en, this message translates to:
  /// **'Stop recording'**
  String get stopRecordingTooltip;

  /// No description provided for @cancelRecordingTooltip.
  ///
  /// In en, this message translates to:
  /// **'Cancel recording'**
  String get cancelRecordingTooltip;

  /// No description provided for @addVoiceTimestampButton.
  ///
  /// In en, this message translates to:
  /// **'Add timestamp'**
  String get addVoiceTimestampButton;

  /// No description provided for @editVoiceTimestampButton.
  ///
  /// In en, this message translates to:
  /// **'Edit timestamp'**
  String get editVoiceTimestampButton;

  /// No description provided for @voiceNoteUnsupportedOnPlatform.
  ///
  /// In en, this message translates to:
  /// **'Voice notes aren\'t supported on this device'**
  String get voiceNoteUnsupportedOnPlatform;

  /// No description provided for @formatBoldTooltip.
  ///
  /// In en, this message translates to:
  /// **'Bold'**
  String get formatBoldTooltip;

  /// No description provided for @formatItalicTooltip.
  ///
  /// In en, this message translates to:
  /// **'Italic'**
  String get formatItalicTooltip;

  /// No description provided for @formatHeadingTooltip.
  ///
  /// In en, this message translates to:
  /// **'Heading'**
  String get formatHeadingTooltip;

  /// No description provided for @formatListTooltip.
  ///
  /// In en, this message translates to:
  /// **'Bulleted list'**
  String get formatListTooltip;

  /// No description provided for @formatLinkTooltip.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get formatLinkTooltip;

  /// No description provided for @imageSizeSmall.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get imageSizeSmall;

  /// No description provided for @imageSizeMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get imageSizeMedium;

  /// No description provided for @imageSizeFull.
  ///
  /// In en, this message translates to:
  /// **'Full width'**
  String get imageSizeFull;

  /// No description provided for @removeImageButton.
  ///
  /// In en, this message translates to:
  /// **'Remove image'**
  String get removeImageButton;

  /// No description provided for @relayUrlHint.
  ///
  /// In en, this message translates to:
  /// **'wss://relay.example.com'**
  String get relayUrlHint;

  /// No description provided for @noRelaysMessage.
  ///
  /// In en, this message translates to:
  /// **'No relay configured yet.'**
  String get noRelaysMessage;

  /// No description provided for @relaysCount.
  ///
  /// In en, this message translates to:
  /// **'{count} relays'**
  String relaysCount(int count);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @sectionSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get sectionSecurity;

  /// No description provided for @loadingLabel.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loadingLabel;

  /// No description provided for @encryptionLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load encryption settings'**
  String get encryptionLoadError;

  /// No description provided for @encryptionToggleTitle.
  ///
  /// In en, this message translates to:
  /// **'Protect notes with a password'**
  String get encryptionToggleTitle;

  /// No description provided for @encryptionToggleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Encrypts notes at rest (AES-256-GCM) with a key derived from your password. The password is never stored — forgetting it means the notes cannot be recovered.'**
  String get encryptionToggleSubtitle;

  /// No description provided for @lockNotesNowTitle.
  ///
  /// In en, this message translates to:
  /// **'Lock notes now'**
  String get lockNotesNowTitle;

  /// No description provided for @lockNotesNowSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Requires the password again to view notes'**
  String get lockNotesNowSubtitle;

  /// No description provided for @setPasswordDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Set a password'**
  String get setPasswordDialogTitle;

  /// No description provided for @passwordTooShortError.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get passwordTooShortError;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordLabel;

  /// No description provided for @passwordsDoNotMatchError.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatchError;

  /// No description provided for @enableEncryptionError.
  ///
  /// In en, this message translates to:
  /// **'Could not enable encryption: {error}'**
  String enableEncryptionError(String error);

  /// No description provided for @enableButton.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enableButton;

  /// No description provided for @disablePasswordDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your password to disable encryption'**
  String get disablePasswordDialogTitle;

  /// No description provided for @disableButton.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get disableButton;

  /// No description provided for @sectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get sectionAppearance;

  /// No description provided for @lightThemeToggleTitle.
  ///
  /// In en, this message translates to:
  /// **'Light theme'**
  String get lightThemeToggleTitle;

  /// No description provided for @lightThemeToggleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use a light color scheme instead of dark'**
  String get lightThemeToggleSubtitle;

  /// No description provided for @noteLayoutToggleTitle.
  ///
  /// In en, this message translates to:
  /// **'Switch between list and grid view'**
  String get noteLayoutToggleTitle;

  /// No description provided for @manageRelaysTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage relays'**
  String get manageRelaysTitle;

  /// No description provided for @republishAllNotesButton.
  ///
  /// In en, this message translates to:
  /// **'Republish all synced notes'**
  String get republishAllNotesButton;

  /// No description provided for @republishAllNotesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Backfills every relay above with notes already shared elsewhere — useful right after adding one, e.g. a self-hosted backup relay'**
  String get republishAllNotesSubtitle;

  /// No description provided for @republishAllNotesSuccess.
  ///
  /// In en, this message translates to:
  /// **'Republished {count} note(s)'**
  String republishAllNotesSuccess(int count);

  /// No description provided for @republishAllNotesError.
  ///
  /// In en, this message translates to:
  /// **'Could not republish notes: {error}'**
  String republishAllNotesError(String error);

  /// No description provided for @forceFullResyncButton.
  ///
  /// In en, this message translates to:
  /// **'Force full resync'**
  String get forceFullResyncButton;

  /// No description provided for @forceFullResyncSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Re-checks relays for a note\'s entire history instead of just what\'s new — useful if syncing seems stuck skipping older notes, e.g. after fixing an unreachable relay'**
  String get forceFullResyncSubtitle;

  /// No description provided for @forceFullResyncSuccess.
  ///
  /// In en, this message translates to:
  /// **'Notes refreshed from relays'**
  String get forceFullResyncSuccess;

  /// No description provided for @forceFullResyncError.
  ///
  /// In en, this message translates to:
  /// **'Could not resync notes: {error}'**
  String forceFullResyncError(String error);

  /// No description provided for @confirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmButton;

  /// No description provided for @sectionLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get sectionLanguage;

  /// No description provided for @langSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get langSystem;

  /// No description provided for @sectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get sectionAccount;

  /// No description provided for @accountLocalOnlyMessage.
  ///
  /// In en, this message translates to:
  /// **'Using Echoes locally — not synced to Nostr'**
  String get accountLocalOnlyMessage;

  /// No description provided for @accountSignInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get accountSignInButton;

  /// No description provided for @accountSignedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {npub}'**
  String accountSignedInAs(String npub);

  /// No description provided for @accountSignOutButton.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get accountSignOutButton;

  /// No description provided for @accountSignOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get accountSignOutConfirmTitle;

  /// No description provided for @accountSignOutConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Your notes stay on this device. You can sign in again anytime.'**
  String get accountSignOutConfirmBody;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Echoes'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingIntroLocalTitle.
  ///
  /// In en, this message translates to:
  /// **'Your notes, always on your device'**
  String get onboardingIntroLocalTitle;

  /// No description provided for @onboardingIntroLocalBody.
  ///
  /// In en, this message translates to:
  /// **'Every note is saved locally first, so the app works fully offline. Nothing leaves your device unless you choose to sync it.'**
  String get onboardingIntroLocalBody;

  /// No description provided for @onboardingIntroSyncTitle.
  ///
  /// In en, this message translates to:
  /// **'Optional sync over Nostr'**
  String get onboardingIntroSyncTitle;

  /// No description provided for @onboardingIntroSyncBody.
  ///
  /// In en, this message translates to:
  /// **'Turn on sync to back up your notes and read them on other devices, using the open Nostr protocol and relays of your choice.'**
  String get onboardingIntroSyncBody;

  /// No description provided for @onboardingIntroEncryptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Always encrypted'**
  String get onboardingIntroEncryptionTitle;

  /// No description provided for @onboardingIntroEncryptionBody.
  ///
  /// In en, this message translates to:
  /// **'Notes synced to Nostr are end-to-end encrypted, so relay operators — and everyone else — can never read their content.'**
  String get onboardingIntroEncryptionBody;

  /// No description provided for @onboardingIntroAmberTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in without exposing your key'**
  String get onboardingIntroAmberTitle;

  /// No description provided for @onboardingIntroAmberBody.
  ///
  /// In en, this message translates to:
  /// **'Use Amber to sign in: your private key stays in Amber and is never shared with Echoes.'**
  String get onboardingIntroAmberBody;

  /// No description provided for @onboardingIntroSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Security by design'**
  String get onboardingIntroSecurityTitle;

  /// No description provided for @onboardingIntroSecurityBody.
  ///
  /// In en, this message translates to:
  /// **'Your private key lives in your device\'s encrypted keystore — or, with Amber, never touches Echoes at all. Photos and voice notes are encrypted before they ever leave your device. Notes can be locked with a password, and none of it is ever included in phone backups.'**
  String get onboardingIntroSecurityBody;

  /// No description provided for @onboardingNextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNextButton;

  /// No description provided for @onboardingBackButton.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get onboardingBackButton;

  /// No description provided for @onboardingSkipButton.
  ///
  /// In en, this message translates to:
  /// **'Skip — use Echoes locally only'**
  String get onboardingSkipButton;

  /// No description provided for @onboardingRelayTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose relays for syncing'**
  String get onboardingRelayTitle;

  /// No description provided for @onboardingRelayBody.
  ///
  /// In en, this message translates to:
  /// **'Relays are where your encrypted notes get stored when you sync. Add one or more — these popular ones are a good start:'**
  String get onboardingRelayBody;

  /// No description provided for @onboardingFinishButton.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingFinishButton;

  /// No description provided for @syncNoteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sync this note'**
  String get syncNoteTooltip;

  /// No description provided for @unsyncNoteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove from relays'**
  String get unsyncNoteTooltip;

  /// No description provided for @syncSelectedTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sync selected notes'**
  String get syncSelectedTooltip;

  /// No description provided for @exportSelectedTooltip.
  ///
  /// In en, this message translates to:
  /// **'Export selected notes'**
  String get exportSelectedTooltip;

  /// No description provided for @deleteSelectedTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete selected notes'**
  String get deleteSelectedTooltip;

  /// No description provided for @syncNoteError.
  ///
  /// In en, this message translates to:
  /// **'Could not sync note: {error}'**
  String syncNoteError(String error);

  /// No description provided for @unsyncNoteError.
  ///
  /// In en, this message translates to:
  /// **'Could not remove note from relays: {error}'**
  String unsyncNoteError(String error);

  /// No description provided for @deleteNoteRelayError.
  ///
  /// In en, this message translates to:
  /// **'Note deleted locally, but could not remove it from relays: {error}'**
  String deleteNoteRelayError(String error);

  /// No description provided for @deleteNotesRelayError.
  ///
  /// In en, this message translates to:
  /// **'{count} note(s) deleted locally, but could not be removed from relays'**
  String deleteNotesRelayError(int count);

  /// No description provided for @deletingNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Deleting notes…'**
  String get deletingNotesTitle;

  /// No description provided for @deletingNotesProgress.
  ///
  /// In en, this message translates to:
  /// **'Deleting {completed} of {total}'**
  String deletingNotesProgress(int completed, int total);

  /// No description provided for @syncSelectedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Notes synced'**
  String get syncSelectedSuccess;

  /// No description provided for @syncSelectedPartialError.
  ///
  /// In en, this message translates to:
  /// **'Could not sync {count} note(s)'**
  String syncSelectedPartialError(int count);

  /// No description provided for @exportConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Export notes'**
  String get exportConfirmTitle;

  /// No description provided for @exportConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Creates a backup file of your notes. It also includes the decryption keys for any attached images or voice notes — anyone with the file could read them unless it\'s encrypted.'**
  String get exportConfirmBody;

  /// No description provided for @exportEncryptToggleLabel.
  ///
  /// In en, this message translates to:
  /// **'Encrypt this file'**
  String get exportEncryptToggleLabel;

  /// No description provided for @exportEncryptToggleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recommended — protects the backup with a password'**
  String get exportEncryptToggleSubtitle;

  /// No description provided for @exportPasswordDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get exportPasswordDialogTitle;

  /// No description provided for @exportSetPasswordDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Set a password for this export'**
  String get exportSetPasswordDialogTitle;

  /// No description provided for @importPasswordDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the export\'s password'**
  String get importPasswordDialogTitle;

  /// No description provided for @sectionData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get sectionData;

  /// No description provided for @exportNotesButton.
  ///
  /// In en, this message translates to:
  /// **'Export notes'**
  String get exportNotesButton;

  /// No description provided for @exportNotesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save all your notes to a file you can import again later'**
  String get exportNotesSubtitle;

  /// No description provided for @importNotesButton.
  ///
  /// In en, this message translates to:
  /// **'Import notes'**
  String get importNotesButton;

  /// No description provided for @importNotesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Restore notes from a file exported earlier'**
  String get importNotesSubtitle;

  /// No description provided for @exportNotesSuccess.
  ///
  /// In en, this message translates to:
  /// **'Notes exported'**
  String get exportNotesSuccess;

  /// No description provided for @exportNotesError.
  ///
  /// In en, this message translates to:
  /// **'Could not export notes: {error}'**
  String exportNotesError(Object error);

  /// No description provided for @importNotesSuccess.
  ///
  /// In en, this message translates to:
  /// **'Imported {count} note(s)'**
  String importNotesSuccess(int count);

  /// No description provided for @importNotesError.
  ///
  /// In en, this message translates to:
  /// **'Could not import notes: {error}'**
  String importNotesError(Object error);

  /// No description provided for @sectionAttachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get sectionAttachments;

  /// No description provided for @attachmentProviderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Where encrypted images and voice notes are uploaded when you sync'**
  String get attachmentProviderSubtitle;

  /// No description provided for @attachmentProviderCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom…'**
  String get attachmentProviderCustom;

  /// No description provided for @attachmentCustomUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Server URL'**
  String get attachmentCustomUrlLabel;

  /// No description provided for @attachmentProviderHint.
  ///
  /// In en, this message translates to:
  /// **'Some public hosts (e.g. Primal, nostr.build) reject encrypted uploads outright — they validate real image content, which ciphertext never is. Prefer a Blossom host that stores opaque blobs, or point Custom… at a self-hosted one.'**
  String get attachmentProviderHint;

  /// No description provided for @sectionSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get sectionSupport;

  /// No description provided for @supportEchoesTitle.
  ///
  /// In en, this message translates to:
  /// **'Support Echoes'**
  String get supportEchoesTitle;

  /// No description provided for @lightningAddressCopied.
  ///
  /// In en, this message translates to:
  /// **'⚡ {address} copied to clipboard'**
  String lightningAddressCopied(String address);

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @invalidPrivateKeyError.
  ///
  /// In en, this message translates to:
  /// **'The private key is not valid. Enter a valid nsec or hex key.'**
  String get invalidPrivateKeyError;

  /// No description provided for @wrongPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Wrong password'**
  String get wrongPasswordError;

  /// No description provided for @genericErrorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String genericErrorPrefix(String error);

  /// No description provided for @shareNoteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareNoteTooltip;

  /// No description provided for @shareNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Share note'**
  String get shareNoteTitle;

  /// No description provided for @shareRecipientFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Recipient npub or public key'**
  String get shareRecipientFieldLabel;

  /// No description provided for @shareAddRecipientButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get shareAddRecipientButton;

  /// No description provided for @shareInvalidRecipientError.
  ///
  /// In en, this message translates to:
  /// **'That\'s not a valid npub or public key'**
  String get shareInvalidRecipientError;

  /// No description provided for @shareRecipientNotFoundError.
  ///
  /// In en, this message translates to:
  /// **'No Nostr account found for that name'**
  String get shareRecipientNotFoundError;

  /// No description provided for @shareConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Share this note?'**
  String get shareConfirmTitle;

  /// No description provided for @shareConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareConfirmButton;

  /// No description provided for @shareAlreadyRecipientError.
  ///
  /// In en, this message translates to:
  /// **'Already shared with this person'**
  String get shareAlreadyRecipientError;

  /// No description provided for @shareCannotShareWithSelfError.
  ///
  /// In en, this message translates to:
  /// **'You can\'t share a note with yourself'**
  String get shareCannotShareWithSelfError;

  /// No description provided for @shareRecipientsHeader.
  ///
  /// In en, this message translates to:
  /// **'Shared with'**
  String get shareRecipientsHeader;

  /// No description provided for @shareNoRecipientsMessage.
  ///
  /// In en, this message translates to:
  /// **'Not shared with anyone yet.'**
  String get shareNoRecipientsMessage;

  /// No description provided for @stopSharingTooltip.
  ///
  /// In en, this message translates to:
  /// **'Stop sharing with this person'**
  String get stopSharingTooltip;

  /// No description provided for @shareRevocationNote.
  ///
  /// In en, this message translates to:
  /// **'Anyone you share with can read this note on their device. Removing someone stops future updates reaching them, but can\'t erase what they already received.'**
  String get shareRevocationNote;

  /// No description provided for @shareError.
  ///
  /// In en, this message translates to:
  /// **'Could not update sharing: {error}'**
  String shareError(String error);

  /// No description provided for @sharedWithMeHeader.
  ///
  /// In en, this message translates to:
  /// **'Shared with you'**
  String get sharedWithMeHeader;

  /// No description provided for @sharedByLabel.
  ///
  /// In en, this message translates to:
  /// **'Shared by {npub}'**
  String sharedByLabel(String npub);

  /// No description provided for @sharedNoteEditableNote.
  ///
  /// In en, this message translates to:
  /// **'You can edit this note; your changes sync back to the owner, who merges them.'**
  String get sharedNoteEditableNote;

  /// No description provided for @abandonSharedNoteButton.
  ///
  /// In en, this message translates to:
  /// **'Leave this shared note'**
  String get abandonSharedNoteButton;

  /// No description provided for @abandonSharedNoteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave this shared note?'**
  String get abandonSharedNoteConfirmTitle;

  /// No description provided for @abandonSharedNoteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'It\'ll be removed from this device and you\'ll stop receiving updates. This can\'t be undone — you won\'t be able to rejoin it later.'**
  String get abandonSharedNoteConfirmBody;

  /// No description provided for @abandonSharedNoteError.
  ///
  /// In en, this message translates to:
  /// **'Could not leave: {error}'**
  String abandonSharedNoteError(String error);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'bg',
    'cs',
    'da',
    'de',
    'el',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'ga',
    'hr',
    'hu',
    'it',
    'ja',
    'lt',
    'lv',
    'mt',
    'nl',
    'pl',
    'pt',
    'ro',
    'ru',
    'sk',
    'sl',
    'sv',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bg':
      return AppLocalizationsBg();
    case 'cs':
      return AppLocalizationsCs();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'et':
      return AppLocalizationsEt();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'ga':
      return AppLocalizationsGa();
    case 'hr':
      return AppLocalizationsHr();
    case 'hu':
      return AppLocalizationsHu();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'lt':
      return AppLocalizationsLt();
    case 'lv':
      return AppLocalizationsLv();
    case 'mt':
      return AppLocalizationsMt();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'sk':
      return AppLocalizationsSk();
    case 'sl':
      return AppLocalizationsSl();
    case 'sv':
      return AppLocalizationsSv();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
