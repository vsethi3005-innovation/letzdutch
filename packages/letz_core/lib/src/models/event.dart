import '../money.dart';

enum RsvpStatus { invited, going, maybe, declined }

/// When guests pay their share of an event.
enum PaymentDeadline { beforeEvent, afterEvent }

class EventGuest {
  const EventGuest({
    required this.userId,
    required this.name,
    this.status = RsvpStatus.invited,
    this.hasPaid = false,
  });

  final String userId;
  final String name;
  final RsvpStatus status;
  final bool hasPaid;
}

/// A gathering organised in the app, with a closed guest list and a
/// budget shared evenly among the guests who are going.
class LetzEvent {
  const LetzEvent({
    required this.id,
    required this.title,
    required this.hostId,
    required this.startsAt,
    required this.budget,
    this.venueId,
    this.guests = const [],
    this.deadline = PaymentDeadline.beforeEvent,
    this.isPrivate = true,
  });

  final String id;
  final String title;
  final String hostId;
  final DateTime startsAt;
  final Money budget;
  final String? venueId;
  final List<EventGuest> guests;
  final PaymentDeadline deadline;
  final bool isPrivate;

  List<EventGuest> get going =>
      guests.where((g) => g.status == RsvpStatus.going).toList();

  bool isPast(DateTime now) => startsAt.isBefore(now);
}
