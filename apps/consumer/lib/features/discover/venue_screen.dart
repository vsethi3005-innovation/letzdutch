import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:letz_core/letz_core.dart';

import '../../format.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';

class VenueScreen extends ConsumerWidget {
  const VenueScreen({super.key, required this.venueId});

  final String venueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final venue = ref.watch(venueProvider(venueId));
    final menu = ref.watch(menuProvider(venueId));
    final table = ref.watch(tableProvider);
    final atThisTable = table?.venueId == venueId;
    final count = atThisTable
        ? table!.lines.fold(0, (n, l) => n + l.quantity)
        : 0;

    return Scaffold(
      appBar: AppBar(title: Text(venue.value?.name ?? '')),
      floatingActionButton: atThisTable && count > 0
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/table'),
              icon: Badge(
                label: Text('$count'),
                child: const Icon(Icons.receipt_long),
              ),
              label: Text(t.yourTable),
            )
          : null,
      body: menu.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (items) {
          final v = venue.value;
          final specials = items.where((i) => i.isSpecial).toList();
          final byCategory = groupBy(items, (MenuItem i) => i.category);
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            children: [
              if (v != null) _Header(venue: v),
              const SizedBox(height: 12),
              if (v != null && v.isOpen && !atThisTable)
                FilledButton.icon(
                  onPressed: () =>
                      ref.read(tableProvider.notifier).start(venueId),
                  icon: const Icon(Icons.table_restaurant),
                  label: Text(t.startTable),
                ),
              if (specials.isNotEmpty) ...[
                _SectionTitle(t.todaysSpecials),
                for (final i in specials)
                  _ItemTile(item: i, canAdd: atThisTable),
              ],
              for (final entry in byCategory.entries) ...[
                _SectionTitle(entry.key),
                for (final i in entry.value)
                  _ItemTile(item: i, canAdd: atThisTable),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.venue});

  final Venue venue;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          [venue.area, ...venue.cuisine].join(' · '),
          style: text.bodyMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            Chip(
              avatar: const Icon(Icons.schedule, size: 18),
              label: Text(
                venue.isOpen ? t.waitMinutes(venue.waitMinutes) : t.closed,
              ),
            ),
            if (venue.hasValet)
              Chip(
                avatar: const Icon(Icons.local_parking, size: 18),
                label: Text(t.valet),
              ),
          ],
        ),
        if (venue.happyHour != null)
          Card(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            child: ListTile(
              leading: const Icon(Icons.local_offer),
              title: Text(t.happyHour),
              subtitle: Text(venue.happyHour!),
            ),
          ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 4),
    child: Text(title, style: Theme.of(context).textTheme.titleMedium),
  );
}

class _ItemTile extends ConsumerWidget {
  const _ItemTile({required this.item, required this.canAdd});

  final MenuItem item;
  final bool canAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(item.name),
      subtitle: Text(
        [
          if (item.description.isNotEmpty) item.description,
          fmtMoney(context, item.price),
        ].join('\n'),
      ),
      isThreeLine: item.description.isNotEmpty,
      trailing: canAdd
          ? OutlinedButton(
              onPressed: () => ref.read(tableProvider.notifier).add(item),
              child: Text(t.add),
            )
          : null,
    );
  }
}
