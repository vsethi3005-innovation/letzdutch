/// The kinds of venue Letzdutch serves.
enum VenueType { restaurant, cafe, bar, club, nightclub }

/// A participating venue.
class Venue {
  const Venue({
    required this.id,
    required this.name,
    required this.type,
    required this.area,
    this.cuisine = const [],
    this.imageUrl,
    this.rating = 0,
    this.isOpen = true,
    this.waitMinutes = 0,
    this.hasValet = false,
    this.happyHour,
  });

  final String id;
  final String name;
  final VenueType type;

  /// Neighbourhood, e.g. "Dubai Marina".
  final String area;
  final List<String> cuisine;
  final String? imageUrl;
  final double rating;
  final bool isOpen;

  /// Current estimated wait for a table, in minutes.
  final int waitMinutes;
  final bool hasValet;

  /// Free text such as "5-8pm, 30% off drinks".
  final String? happyHour;

  factory Venue.fromJson(Map<String, dynamic> j) => Venue(
    id: j['id'] as String,
    name: j['name'] as String,
    type: VenueType.values.byName(j['type'] as String),
    area: j['area'] as String,
    cuisine: (j['cuisine'] as List?)?.cast<String>() ?? const [],
    imageUrl: j['image_url'] as String?,
    rating: (j['rating'] as num?)?.toDouble() ?? 0,
    isOpen: j['is_open'] as bool? ?? true,
    waitMinutes: j['wait_minutes'] as int? ?? 0,
    hasValet: j['has_valet'] as bool? ?? false,
    happyHour: j['happy_hour'] as String?,
  );
}
