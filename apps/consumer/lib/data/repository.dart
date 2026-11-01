import 'package:letz_core/letz_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'demo_data.dart';

/// Where the app reads venues, menus and events from.
abstract class LetzRepository {
  Future<List<Venue>> venues();
  Future<List<MenuItem>> menu(String venueId);
  Future<List<LetzEvent>> events();
}

/// In-memory sample data, used when no Supabase keys are configured.
class DemoRepository implements LetzRepository {
  @override
  Future<List<Venue>> venues() async => demoVenues;

  @override
  Future<List<MenuItem>> menu(String venueId) async =>
      demoMenu.where((m) => m.venueId == venueId).toList();

  @override
  Future<List<LetzEvent>> events() async => demoEvents;
}

/// Reads from the Supabase tables in `supabase/migrations`.
class SupabaseRepository implements LetzRepository {
  SupabaseRepository(this._db);

  final SupabaseClient _db;

  @override
  Future<List<Venue>> venues() async {
    final rows = await _db.from('venues').select().order('name');
    return rows.map(Venue.fromJson).toList();
  }

  @override
  Future<List<MenuItem>> menu(String venueId) async {
    final rows = await _db
        .from('menu_items')
        .select()
        .eq('venue_id', venueId)
        .order('category');
    return rows.map(MenuItem.fromJson).toList();
  }

  @override
  Future<List<LetzEvent>> events() async {
    // Events need the signed-in user; wired up with auth in the next step.
    return const [];
  }
}
