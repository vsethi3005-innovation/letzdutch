import 'package:letz_core/letz_core.dart';
import 'package:test/test.dart';

Money aed(num v) => Money.fromMajor(v);

void main() {
  group('Money', () {
    test('formats minor units', () {
      expect(aed(12.5).toString(), 'AED 12.50');
      expect(const Money(-5).toString(), 'AED -0.05');
    });

    test('rejects mixed currencies', () {
      expect(
        () => aed(1) + Money.fromMajor(1, currency: 'INR'),
        throwsArgumentError,
      );
    });
  });

  group('allocate', () {
    test('parts always sum to the total', () {
      final parts = allocate(const Money(100), [1, 1, 1]);
      expect(parts.map((m) => m.minor), [34, 33, 33]);
    });

    test('is proportional to weights', () {
      final parts = allocate(const Money(1000), [2, 1, 1]);
      expect(parts.map((m) => m.minor), [500, 250, 250]);
    });

    test('rejects all-zero weights', () {
      expect(() => allocate(const Money(100), [0, 0]), throwsArgumentError);
    });
  });

  group('BillSplitter', () {
    const noTax = BillSplitter(vatPercent: 0);

    test('adds 5% UAE VAT by default', () {
      expect(const BillSplitter().totalFor(aed(100)), aed(105));
    });

    test('VAT applies on top of service charge', () {
      const s = BillSplitter(serviceChargePercent: 10);
      // 100 + 10 service + 5.50 VAT
      expect(s.totalFor(aed(100)), aed(115.5));
    });

    test('even split of an odd amount', () {
      final r = noTax.even(participants: ['a', 'b', 'c'], subtotal: aed(100));
      expect(r.values.fold(const Money(0), (a, b) => a + b), aed(100));
      expect(r['a'], const Money(3334));
      expect(r['b'], const Money(3333));
    });

    test('by item, with a shared starter', () {
      final r = noTax.byItem(
        participants: ['a', 'b'],
        lines: [
          BillLine(name: 'Burger', amount: aed(60), sharedBy: ['a']),
          BillLine(name: 'Salad', amount: aed(40), sharedBy: ['b']),
          BillLine(name: 'Hummus', amount: aed(30)), // everyone
        ],
      );
      expect(r['a'], aed(75));
      expect(r['b'], aed(55));
    });

    test('by item spreads VAT and tip in proportion', () {
      final r = const BillSplitter().byItem(
        participants: ['a', 'b'],
        lines: [
          BillLine(name: 'Steak', amount: aed(300), sharedBy: ['a']),
          BillLine(name: 'Soup', amount: aed(100), sharedBy: ['b']),
        ],
        tip: aed(20),
      );
      // Total 400 + 20 VAT + 20 tip = 440, split 3:1.
      expect(r['a'], aed(330));
      expect(r['b'], aed(110));
    });

    test('custom weights, host pays double', () {
      final r = noTax.custom(weights: {'host': 2, 'g': 1}, subtotal: aed(90));
      expect(r['host'], aed(60));
      expect(r['g'], aed(30));
    });

    test('rejects unknown participant on an item', () {
      expect(
        () => noTax.byItem(
          participants: ['a'],
          lines: [
            BillLine(name: 'x', amount: aed(1), sharedBy: ['z']),
          ],
        ),
        throwsArgumentError,
      );
    });
  });
}
