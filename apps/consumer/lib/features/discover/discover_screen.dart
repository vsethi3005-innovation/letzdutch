import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:letz_core/letz_core.dart';

import '../../config.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  String _query = '';
  VenueType? _type;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final venues = ref.watch(venuesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.appTitle)),
      body: venues.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (all) {
          final q = _query.toLowerCase();
          final list = all.where((v) {
            final matchesType = _type == null || v.type == _type;
            final matchesQuery =
                q.isEmpty ||
                v.name.toLowerCase().contains(q) ||
                v.area.toLowerCase().contains(q) ||
                v.cuisine.any((c) => c.toLowerCase().contains(q));
            return matchesType && matchesQuery;
          }).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (!AppConfig.hasBackend)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    t.demoMode,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              TextField(
                decoration: InputDecoration(
                  hintText: t.searchHint,
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final type in VenueType.values)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 8),
                        child: FilterChip(
                          label: Text(_typeLabel(type)),
                          selected: _type == type,
                          onSelected: (s) =>
                              setState(() => _type = s ? type : null),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              for (final v in list) VenueCard(venue: v),
            ],
          );
        },
      ),
    );
  }
}

String _typeLabel(VenueType t) => switch (t) {
  VenueType.restaurant => 'Restaurants',
  VenueType.cafe => 'Cafes',
  VenueType.bar => 'Bars',
  VenueType.club => 'Clubs',
  VenueType.nightclub => 'Nightclubs',
};

class VenueCard extends StatelessWidget {
  const VenueCard({super.key, required this.venue});

  final Venue venue;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Card(
      color: scheme.surfaceContainerHighest,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.go('/discover/venue/${venue.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: scheme.primaryContainer,
                child: Text(
                  venue.name.characters.first,
                  style: text.titleLarge,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(venue.name, style: text.titleMedium),
                    Text(
                      [venue.area, ...venue.cuisine].join(' · '),
                      style: text.bodySmall,
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _Tag(
                          venue.isOpen
                              ? t.waitMinutes(venue.waitMinutes)
                              : t.closed,
                          color: venue.isOpen ? null : scheme.errorContainer,
                        ),
                        if (venue.hasValet) _Tag(t.valet),
                        if (venue.happyHour != null)
                          _Tag(t.happyHour, color: scheme.tertiaryContainer),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Icon(Icons.star, color: scheme.tertiary, size: 18),
                  Text(venue.rating.toStringAsFixed(1), style: text.labelLarge),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.label, {this.color});

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}
