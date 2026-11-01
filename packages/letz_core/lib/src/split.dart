import 'money.dart';

/// A line on a shared bill. [sharedBy] lists the participant ids who
/// shared this item; an empty list means everyone at the table shared it.
class BillLine {
  const BillLine({
    required this.name,
    required this.amount,
    this.sharedBy = const [],
  });

  final String name;
  final Money amount;
  final List<String> sharedBy;
}

/// Splits [total] into parts proportional to [weights], so that the parts
/// always add up to exactly [total].
///
/// Leftover minor units from rounding go to the parts with the largest
/// remainders (largest remainder method), ties broken by order.
List<Money> allocate(Money total, List<int> weights) {
  if (weights.isEmpty) throw ArgumentError('weights must not be empty');
  if (weights.any((w) => w < 0)) throw ArgumentError('weights must be >= 0');
  if (total.isNegative) throw ArgumentError('total must be >= 0');
  final sum = weights.fold<int>(0, (a, b) => a + b);
  if (sum == 0) throw ArgumentError('weights must not all be zero');

  final base = <int>[];
  final remainders = <int>[];
  var allocated = 0;
  for (final w in weights) {
    final exact = total.minor * w;
    final share = exact ~/ sum;
    base.add(share);
    remainders.add(exact - share * sum);
    allocated += share;
  }

  var leftover = total.minor - allocated;
  final order = List<int>.generate(weights.length, (i) => i)
    ..sort((a, b) {
      final c = remainders[b].compareTo(remainders[a]);
      return c != 0 ? c : a.compareTo(b);
    });
  for (final i in order) {
    if (leftover <= 0) break;
    base[i] += 1;
    leftover -= 1;
  }
  return [for (final m in base) Money(m, currency: total.currency)];
}

/// Ways a group can split a bill.
enum SplitMode { even, byItem, custom }

/// Calculates what each participant owes.
class BillSplitter {
  const BillSplitter({this.vatPercent = 5, this.serviceChargePercent = 0});

  /// UAE VAT is 5%.
  final num vatPercent;
  final num serviceChargePercent;

  /// Everyone pays the same share of the total (subtotal + charges + tip).
  Map<String, Money> even({
    required List<String> participants,
    required Money subtotal,
    Money? tip,
  }) {
    if (participants.isEmpty) throw ArgumentError('no participants');
    final total = totalFor(subtotal, tip: tip);
    final parts = allocate(total, List.filled(participants.length, 1));
    return {
      for (var i = 0; i < participants.length; i++) participants[i]: parts[i],
    };
  }

  /// Each person pays for what they had; shared items are divided among
  /// those who shared them. Charges and tip are split in proportion to
  /// each person's item subtotal.
  Map<String, Money> byItem({
    required List<String> participants,
    required List<BillLine> lines,
    Money? tip,
  }) {
    if (participants.isEmpty) throw ArgumentError('no participants');
    final currency = lines.isEmpty ? 'AED' : lines.first.amount.currency;
    final owed = {
      for (final p in participants) p: Money.zero(currency: currency),
    };

    for (final line in lines) {
      final who = line.sharedBy.isEmpty ? participants : line.sharedBy;
      for (final p in who) {
        if (!owed.containsKey(p)) {
          throw ArgumentError('unknown participant $p');
        }
      }
      final parts = allocate(line.amount, List.filled(who.length, 1));
      for (var i = 0; i < who.length; i++) {
        owed[who[i]] = owed[who[i]]! + parts[i];
      }
    }

    final subtotal = owed.values.fold(
      Money.zero(currency: currency),
      (a, b) => a + b,
    );
    final extras = totalFor(subtotal, tip: tip) - subtotal;
    if (extras.isZero) return owed;
    final weights = subtotal.isZero
        ? List.filled(participants.length, 1)
        : [for (final p in participants) owed[p]!.minor];
    final extraParts = allocate(extras, weights);
    return {
      for (var i = 0; i < participants.length; i++)
        participants[i]: owed[participants[i]]! + extraParts[i],
    };
  }

  /// Custom weights, e.g. a host covering two shares: {'a': 2, 'b': 1}.
  Map<String, Money> custom({
    required Map<String, int> weights,
    required Money subtotal,
    Money? tip,
  }) {
    final total = totalFor(subtotal, tip: tip);
    final ids = weights.keys.toList();
    final parts = allocate(total, [for (final id in ids) weights[id]!]);
    return {for (var i = 0; i < ids.length; i++) ids[i]: parts[i]};
  }

  /// Subtotal plus service charge, VAT on (subtotal + service), plus tip.
  Money totalFor(Money subtotal, {Money? tip}) {
    final service = subtotal.percent(serviceChargePercent);
    final vat = (subtotal + service).percent(vatPercent);
    return subtotal +
        service +
        vat +
        (tip ?? Money.zero(currency: subtotal.currency));
  }
}
