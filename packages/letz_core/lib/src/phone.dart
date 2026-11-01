/// Normalises a UAE mobile number to E.164 (`+9715XXXXXXXX`).
///
/// Accepts `050 123 4567`, `50-123-4567`, `+971 50 123 4567`,
/// `00971501234567` and similar. Returns null if it is not a UAE mobile.
String? normalizeUaeMobile(String input) {
  var digits = input.replaceAll(RegExp(r'[^0-9+]'), '');
  if (digits.startsWith('+')) {
    digits = digits.substring(1);
  } else if (digits.startsWith('00')) {
    digits = digits.substring(2);
  }
  if (digits.startsWith('971')) {
    digits = digits.substring(3);
  }
  if (digits.startsWith('0')) {
    digits = digits.substring(1);
  }
  // UAE mobiles: 5X followed by 7 digits.
  if (!RegExp(r'^5[0-9]{8}$').hasMatch(digits)) return null;
  return '+971$digits';
}
