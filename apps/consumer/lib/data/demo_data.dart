import 'package:letz_core/letz_core.dart';

/// Sample Dubai venues used until the Supabase project is connected.
const demoVenues = <Venue>[
  Venue(
    id: 'v1',
    name: 'Saffron Terrace',
    type: VenueType.restaurant,
    area: 'Dubai Marina',
    cuisine: ['Indian', 'Grill'],
    rating: 4.6,
    waitMinutes: 15,
    hasValet: true,
    happyHour: '5 to 8 pm, 30% off mocktails',
  ),
  Venue(
    id: 'v2',
    name: 'Bean & Dune',
    type: VenueType.cafe,
    area: 'Jumeirah',
    cuisine: ['Coffee', 'Brunch'],
    rating: 4.4,
    waitMinutes: 5,
  ),
  Venue(
    id: 'v3',
    name: 'Skyline Lounge',
    type: VenueType.bar,
    area: 'Downtown',
    cuisine: ['Tapas'],
    rating: 4.7,
    waitMinutes: 25,
    hasValet: true,
    happyHour: '6 to 9 pm, two for one',
  ),
  Venue(
    id: 'v4',
    name: 'Neon Desert',
    type: VenueType.nightclub,
    area: 'Business Bay',
    rating: 4.2,
    isOpen: false,
    hasValet: true,
  ),
];

MenuItem _item(
  String id,
  String venue,
  String name,
  num aed,
  String category, {
  int prep = 15,
  bool special = false,
  String description = '',
}) => MenuItem(
  id: id,
  venueId: venue,
  name: name,
  price: Money.fromMajor(aed),
  category: category,
  prepMinutes: prep,
  isSpecial: special,
  description: description,
);

final demoMenu = <MenuItem>[
  _item('m1', 'v1', 'Butter chicken', 68, 'Mains', prep: 20),
  _item('m2', 'v1', 'Paneer tikka', 52, 'Starters', prep: 15),
  _item(
    'm3',
    'v1',
    'Lamb biryani',
    79,
    'Mains',
    prep: 25,
    special: true,
    description: 'Slow cooked, served with raita',
  ),
  _item('m4', 'v1', 'Garlic naan', 12, 'Sides', prep: 8),
  _item('m5', 'v1', 'Mango lassi', 22, 'Drinks', prep: 5),
  _item('m6', 'v2', 'Flat white', 21, 'Coffee', prep: 4),
  _item('m7', 'v2', 'Shakshuka', 48, 'Brunch', prep: 15, special: true),
  _item('m8', 'v2', 'Avocado toast', 42, 'Brunch', prep: 10),
  _item('m9', 'v3', 'Patatas bravas', 38, 'Tapas', prep: 12),
  _item('m10', 'v3', 'Gambas al ajillo', 64, 'Tapas', prep: 15, special: true),
  _item('m11', 'v3', 'Virgin mojito', 34, 'Drinks', prep: 4),
];

/// Friends used to demo group ordering and splitting.
const demoMe = 'me';
const demoFriends = {
  'me': 'You',
  'sara': 'Sara',
  'omar': 'Omar',
  'priya': 'Priya',
};

final demoEvents = <LetzEvent>[
  LetzEvent(
    id: 'e1',
    title: "Sara's birthday dinner",
    hostId: 'sara',
    venueId: 'v1',
    startsAt: DateTime.now().add(const Duration(days: 3, hours: 4)),
    budget: Money.fromMajor(1200),
    guests: const [
      EventGuest(userId: 'me', name: 'You', status: RsvpStatus.going),
      EventGuest(userId: 'omar', name: 'Omar', status: RsvpStatus.going),
      EventGuest(userId: 'priya', name: 'Priya', status: RsvpStatus.maybe),
      EventGuest(userId: 'sara', name: 'Sara', status: RsvpStatus.going),
    ],
  ),
  LetzEvent(
    id: 'e2',
    title: 'Friday brunch',
    hostId: 'me',
    venueId: 'v2',
    startsAt: DateTime.now().subtract(const Duration(days: 6)),
    budget: Money.fromMajor(400),
    deadline: PaymentDeadline.afterEvent,
    guests: const [
      EventGuest(
        userId: 'me',
        name: 'You',
        status: RsvpStatus.going,
        hasPaid: true,
      ),
      EventGuest(userId: 'omar', name: 'Omar', status: RsvpStatus.going),
    ],
  ),
];
