import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letz_core/letz_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config.dart';
import '../data/demo_data.dart';
import '../data/repository.dart';

final repositoryProvider = Provider<LetzRepository>((ref) {
  if (AppConfig.hasBackend) {
    return SupabaseRepository(Supabase.instance.client);
  }
  return DemoRepository();
});

final venuesProvider = FutureProvider<List<Venue>>(
  (ref) => ref.watch(repositoryProvider).venues(),
);

final venueProvider = FutureProvider.family<Venue, String>((ref, id) async {
  final venues = await ref.watch(venuesProvider.future);
  return venues.firstWhere((v) => v.id == id);
});

final menuProvider = FutureProvider.family<List<MenuItem>, String>(
  (ref, venueId) => ref.watch(repositoryProvider).menu(venueId),
);

final eventsProvider = FutureProvider<List<LetzEvent>>(
  (ref) => ref.watch(repositoryProvider).events(),
);

/// App language; null follows the device.
class LocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() => null;

  void set(Locale? locale) => state = locale;
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(
  LocaleNotifier.new,
);

/// The group order at the table the user has open.
class TableNotifier extends Notifier<TableOrder?> {
  @override
  TableOrder? build() => null;

  void start(String venueId) {
    if (state?.venueId == venueId) return;
    state = TableOrder(
      id: 't-${DateTime.now().millisecondsSinceEpoch}',
      venueId: venueId,
      tableLabel: '12',
      participants: demoFriends.keys.toList(),
    );
  }

  void add(MenuItem item, {String by = demoMe}) {
    final order = state;
    if (order == null) return;
    final lines = [...order.lines];
    final i = lines.indexWhere(
      (l) => l.item.id == item.id && l.orderedBy == by,
    );
    if (i >= 0) {
      lines[i] = lines[i].copyWith(quantity: lines[i].quantity + 1);
    } else {
      lines.add(OrderLine(item: item, orderedBy: by));
    }
    state = _copy(order, lines);
  }

  void remove(int index) {
    final order = state;
    if (order == null) return;
    final lines = [...order.lines];
    final line = lines[index];
    if (line.quantity > 1) {
      lines[index] = line.copyWith(quantity: line.quantity - 1);
    } else {
      lines.removeAt(index);
    }
    state = _copy(order, lines);
  }

  /// Sets who shares a line. An empty list means everyone at the table.
  void setSharedBy(int index, List<String> who) {
    final order = state;
    if (order == null) return;
    final lines = [...order.lines];
    lines[index] = lines[index].copyWith(sharedBy: who);
    state = _copy(order, lines);
  }

  void clear() => state = null;

  TableOrder _copy(TableOrder o, List<OrderLine> lines) => TableOrder(
    id: o.id,
    venueId: o.venueId,
    tableLabel: o.tableLabel,
    participants: o.participants,
    lines: lines,
    status: o.status,
  );
}

final tableProvider = NotifierProvider<TableNotifier, TableOrder?>(
  TableNotifier.new,
);
