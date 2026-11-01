// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Letzdutch';

  @override
  String get tabDiscover => 'Discover';

  @override
  String get tabEvents => 'Events';

  @override
  String get tabWallet => 'Wallet';

  @override
  String get tabProfile => 'Profile';

  @override
  String get searchHint => 'Search restaurants, cafes, clubs';

  @override
  String get openNow => 'Open now';

  @override
  String get closed => 'Closed';

  @override
  String waitMinutes(int minutes) {
    return '$minutes min wait';
  }

  @override
  String get valet => 'Valet';

  @override
  String get happyHour => 'Happy hour';

  @override
  String get todaysSpecials => 'Today\'s specials';

  @override
  String get menu => 'Menu';

  @override
  String get add => 'Add';

  @override
  String get startTable => 'Start a table';

  @override
  String get yourTable => 'Your table';

  @override
  String tableLabel(String label) {
    return 'Table $label';
  }

  @override
  String readyIn(int minutes) {
    return 'Ready in about $minutes min';
  }

  @override
  String get emptyOrder => 'Nothing ordered yet. Add items from the menu.';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get vat => 'VAT (5%)';

  @override
  String get tip => 'Tip';

  @override
  String get total => 'Total';

  @override
  String get splitBill => 'Split the bill';

  @override
  String get splitEven => 'Evenly';

  @override
  String get splitByItem => 'By item';

  @override
  String get splitCustom => 'Custom';

  @override
  String get sharedWith => 'Shared by';

  @override
  String get everyone => 'Everyone';

  @override
  String get owes => 'owes';

  @override
  String get payMyShare => 'Pay my share';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get past => 'Past';

  @override
  String get createEvent => 'Create event';

  @override
  String get eventTitle => 'Event name';

  @override
  String get budget => 'Budget';

  @override
  String perGuest(String amount) {
    return '$amount per guest';
  }

  @override
  String guestsGoing(int count) {
    return '$count going';
  }

  @override
  String get save => 'Save';

  @override
  String get youOwe => 'You owe';

  @override
  String get owedToYou => 'Owed to you';

  @override
  String get monthlySavings => 'Saved this month';

  @override
  String get recentActivity => 'Recent activity';

  @override
  String get language => 'Language';

  @override
  String get membership => 'Membership';

  @override
  String get demoMode => 'Demo data: connect Supabase to go live';
}
