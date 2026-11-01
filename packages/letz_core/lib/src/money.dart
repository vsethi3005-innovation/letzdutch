/// An amount of money in minor units (fils for AED, paise for INR).
///
/// Integers avoid floating point rounding errors when splitting bills.
class Money implements Comparable<Money> {
  const Money(this.minor, {this.currency = 'AED'});

  /// Builds a value from major units, e.g. `Money.fromMajor(12.5)` = AED 12.50.
  factory Money.fromMajor(num major, {String currency = 'AED'}) =>
      Money((major * 100).round(), currency: currency);

  const Money.zero({this.currency = 'AED'}) : minor = 0;

  final int minor;
  final String currency;

  double get major => minor / 100;

  Money operator +(Money other) {
    _check(other);
    return Money(minor + other.minor, currency: currency);
  }

  Money operator -(Money other) {
    _check(other);
    return Money(minor - other.minor, currency: currency);
  }

  Money operator *(num factor) =>
      Money((minor * factor).round(), currency: currency);

  /// Applies a percentage, e.g. `percent(5)` for 5% VAT. Rounds half up.
  Money percent(num pct) =>
      Money((minor * pct / 100).round(), currency: currency);

  bool get isZero => minor == 0;
  bool get isNegative => minor < 0;

  void _check(Money other) {
    if (other.currency != currency) {
      throw ArgumentError('Currency mismatch: $currency vs ${other.currency}');
    }
  }

  @override
  int compareTo(Money other) {
    _check(other);
    return minor.compareTo(other.minor);
  }

  @override
  bool operator ==(Object other) =>
      other is Money && other.minor == minor && other.currency == currency;

  @override
  int get hashCode => Object.hash(minor, currency);

  /// Plain formatting; apps use `intl` for localized display.
  @override
  String toString() {
    final sign = minor < 0 ? '-' : '';
    final abs = minor.abs();
    final fraction = (abs % 100).toString().padLeft(2, '0');
    return '$currency $sign${abs ~/ 100}.$fraction';
  }

  Map<String, dynamic> toJson() => {'minor': minor, 'currency': currency};

  factory Money.fromJson(Map<String, dynamic> json) => Money(
    json['minor'] as int,
    currency: json['currency'] as String? ?? 'AED',
  );
}
