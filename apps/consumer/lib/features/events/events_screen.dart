import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letz_core/letz_core.dart';

import '../../format.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';

/// Upcoming and past events, the calendar log from the brief.
class EventsScreen extends ConsumerWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final events = ref.watch(eventsProvider);
    final now = DateTime.now();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.tabEvents),
          bottom: TabBar(
            tabs: [
              Tab(text: t.upcoming),
              Tab(text: t.past),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (_) => const _CreateEventSheet(),
          ),
          icon: const Icon(Icons.add),
          label: Text(t.createEvent),
        ),
        body: events.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (all) {
            final upcoming = all.where((e) => !e.isPast(now)).toList()
              ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
            final past = all.where((e) => e.isPast(now)).toList()
              ..sort((a, b) => b.startsAt.compareTo(a.startsAt));
            return TabBarView(
              children: [_EventList(upcoming), _EventList(past)],
            );
          },
        ),
      ),
    );
  }
}

class _EventList extends StatelessWidget {
  const _EventList(this.events);

  final List<LetzEvent> events;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final e in events)
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: ListTile(
              title: Text(e.title),
              subtitle: Text(
                '${fmtDate(context, e.startsAt)}\n'
                '${t.guestsGoing(e.going.length)} · '
                '${t.perGuest(fmtMoney(context, _perGuest(e)))}',
              ),
              isThreeLine: true,
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
      ],
    );
  }

  Money _perGuest(LetzEvent e) {
    final n = e.going.isEmpty ? 1 : e.going.length;
    return allocate(e.budget, List.filled(n, 1)).first;
  }
}

class _CreateEventSheet extends StatefulWidget {
  const _CreateEventSheet();

  @override
  State<_CreateEventSheet> createState() => _CreateEventSheetState();
}

class _CreateEventSheetState extends State<_CreateEventSheet> {
  final _title = TextEditingController();
  final _budget = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _budget.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(t.createEvent, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextField(
            controller: _title,
            decoration: InputDecoration(labelText: t.eventTitle),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _budget,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: t.budget, suffixText: 'AED'),
          ),
          const SizedBox(height: 16),
          FilledButton(
            // Saving and inviting guests is wired to Supabase next.
            onPressed: () => Navigator.pop(context),
            child: Text(t.save),
          ),
        ],
      ),
    );
  }
}
