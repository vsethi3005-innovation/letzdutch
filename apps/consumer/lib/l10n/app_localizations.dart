import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Letzdutch'**
  String get appTitle;

  /// No description provided for @tabDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get tabDiscover;

  /// No description provided for @tabEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get tabEvents;

  /// No description provided for @tabWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get tabWallet;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search restaurants, cafes, clubs'**
  String get searchHint;

  /// No description provided for @openNow.
  ///
  /// In en, this message translates to:
  /// **'Open now'**
  String get openNow;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @waitMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min wait'**
  String waitMinutes(int minutes);

  /// No description provided for @valet.
  ///
  /// In en, this message translates to:
  /// **'Valet'**
  String get valet;

  /// No description provided for @happyHour.
  ///
  /// In en, this message translates to:
  /// **'Happy hour'**
  String get happyHour;

  /// No description provided for @todaysSpecials.
  ///
  /// In en, this message translates to:
  /// **'Today\'s specials'**
  String get todaysSpecials;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @startTable.
  ///
  /// In en, this message translates to:
  /// **'Start a table'**
  String get startTable;

  /// No description provided for @yourTable.
  ///
  /// In en, this message translates to:
  /// **'Your table'**
  String get yourTable;

  /// No description provided for @tableLabel.
  ///
  /// In en, this message translates to:
  /// **'Table {label}'**
  String tableLabel(String label);

  /// No description provided for @readyIn.
  ///
  /// In en, this message translates to:
  /// **'Ready in about {minutes} min'**
  String readyIn(int minutes);

  /// No description provided for @emptyOrder.
  ///
  /// In en, this message translates to:
  /// **'Nothing ordered yet. Add items from the menu.'**
  String get emptyOrder;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @vat.
  ///
  /// In en, this message translates to:
  /// **'VAT (5%)'**
  String get vat;

  /// No description provided for @tip.
  ///
  /// In en, this message translates to:
  /// **'Tip'**
  String get tip;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @splitBill.
  ///
  /// In en, this message translates to:
  /// **'Split the bill'**
  String get splitBill;

  /// No description provided for @splitEven.
  ///
  /// In en, this message translates to:
  /// **'Evenly'**
  String get splitEven;

  /// No description provided for @splitByItem.
  ///
  /// In en, this message translates to:
  /// **'By item'**
  String get splitByItem;

  /// No description provided for @splitCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get splitCustom;

  /// No description provided for @sharedWith.
  ///
  /// In en, this message translates to:
  /// **'Shared by'**
  String get sharedWith;

  /// No description provided for @everyone.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get everyone;

  /// No description provided for @owes.
  ///
  /// In en, this message translates to:
  /// **'owes'**
  String get owes;

  /// No description provided for @payMyShare.
  ///
  /// In en, this message translates to:
  /// **'Pay my share'**
  String get payMyShare;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @createEvent.
  ///
  /// In en, this message translates to:
  /// **'Create event'**
  String get createEvent;

  /// No description provided for @eventTitle.
  ///
  /// In en, this message translates to:
  /// **'Event name'**
  String get eventTitle;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @perGuest.
  ///
  /// In en, this message translates to:
  /// **'{amount} per guest'**
  String perGuest(String amount);

  /// No description provided for @guestsGoing.
  ///
  /// In en, this message translates to:
  /// **'{count} going'**
  String guestsGoing(int count);

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @youOwe.
  ///
  /// In en, this message translates to:
  /// **'You owe'**
  String get youOwe;

  /// No description provided for @owedToYou.
  ///
  /// In en, this message translates to:
  /// **'Owed to you'**
  String get owedToYou;

  /// No description provided for @monthlySavings.
  ///
  /// In en, this message translates to:
  /// **'Saved this month'**
  String get monthlySavings;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get recentActivity;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @membership.
  ///
  /// In en, this message translates to:
  /// **'Membership'**
  String get membership;

  /// No description provided for @demoMode.
  ///
  /// In en, this message translates to:
  /// **'Demo data: connect Supabase to go live'**
  String get demoMode;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
