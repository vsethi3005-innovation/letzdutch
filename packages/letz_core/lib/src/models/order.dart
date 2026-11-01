import '../money.dart';
import 'menu_item.dart';

enum OrderStatus { draft, placed, preparing, served, paid, cancelled }

/// One item in a table order, with who ordered it and who shares it.
class OrderLine {
  const OrderLine({
    required this.item,
    required this.orderedBy,
    this.quantity = 1,
    this.sharedBy = const [],
    this.note,
  });

  final MenuItem item;
  final String orderedBy;
  final int quantity;

  /// Empty means only [orderedBy] had it.
  final List<String> sharedBy;
  final String? note;

  Money get total => item.price * quantity;

  List<String> get payers => sharedBy.isEmpty ? [orderedBy] : sharedBy;

  OrderLine copyWith({int? quantity, List<String>? sharedBy}) => OrderLine(
    item: item,
    orderedBy: orderedBy,
    quantity: quantity ?? this.quantity,
    sharedBy: sharedBy ?? this.sharedBy,
    note: note,
  );
}

/// A group's order at one table.
class TableOrder {
  const TableOrder({
    required this.id,
    required this.venueId,
    required this.tableLabel,
    required this.participants,
    this.lines = const [],
    this.status = OrderStatus.draft,
  });

  final String id;
  final String venueId;
  final String tableLabel;
  final List<String> participants;
  final List<OrderLine> lines;
  final OrderStatus status;

  Money get subtotal => lines.fold(
    Money.zero(currency: lines.isEmpty ? 'AED' : lines.first.total.currency),
    (sum, l) => sum + l.total,
  );

  /// Longest prep time among ordered items, as the ready estimate.
  int get estimatedMinutes =>
      lines.fold(0, (m, l) => l.item.prepMinutes > m ? l.item.prepMinutes : m);
}
