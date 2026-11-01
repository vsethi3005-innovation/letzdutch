import '../money.dart';

/// A dish or drink on a venue's menu.
class MenuItem {
  const MenuItem({
    required this.id,
    required this.venueId,
    required this.name,
    required this.price,
    required this.category,
    this.description = '',
    this.prepMinutes = 15,
    this.isSpecial = false,
    this.isAvailable = true,
  });

  final String id;
  final String venueId;
  final String name;
  final Money price;
  final String category;
  final String description;

  /// Estimated preparation time, shown as the order processing estimate.
  final int prepMinutes;

  /// Today's special.
  final bool isSpecial;
  final bool isAvailable;

  factory MenuItem.fromJson(Map<String, dynamic> j) => MenuItem(
    id: j['id'] as String,
    venueId: j['venue_id'] as String,
    name: j['name'] as String,
    price: Money(j['price_minor'] as int, currency: j['currency'] as String),
    category: j['category'] as String,
    description: j['description'] as String? ?? '',
    prepMinutes: j['prep_minutes'] as int? ?? 15,
    isSpecial: j['is_special'] as bool? ?? false,
    isAvailable: j['is_available'] as bool? ?? true,
  );
}
