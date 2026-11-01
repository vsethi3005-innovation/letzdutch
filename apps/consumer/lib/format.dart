import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:letz_core/letz_core.dart';

/// Formats money for the current locale, e.g. "AED 68.00" or "68.00 د.إ".
String fmtMoney(BuildContext context, Money m) {
  final locale = Localizations.localeOf(context);
  final symbol = locale.languageCode == 'ar' && m.currency == 'AED'
      ? 'د.إ'
      : '${m.currency} ';
  return NumberFormat.currency(
    locale: locale.toLanguageTag(),
    name: m.currency,
    symbol: symbol,
    decimalDigits: 2,
  ).format(m.major);
}

String fmtDate(BuildContext context, DateTime d) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  return DateFormat.MMMEd(locale).add_jm().format(d);
}
