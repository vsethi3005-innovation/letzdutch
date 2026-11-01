import 'package:letz_core/letz_core.dart';
import 'package:test/test.dart';

void main() {
  test('normalises common UAE mobile formats', () {
    for (final input in [
      '050 123 4567',
      '50-123-4567',
      '+971 50 123 4567',
      '00971501234567',
      '971501234567',
    ]) {
      expect(normalizeUaeMobile(input), '+971501234567', reason: input);
    }
  });

  test('rejects landlines, short and foreign numbers', () {
    expect(normalizeUaeMobile('04 123 4567'), isNull);
    expect(normalizeUaeMobile('050 123'), isNull);
    expect(normalizeUaeMobile('+91 98765 43210'), isNull);
    expect(normalizeUaeMobile(''), isNull);
  });
}
