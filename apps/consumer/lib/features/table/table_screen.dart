import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letz_core/letz_core.dart';

import '../../data/demo_data.dart';
import '../../format.dart';
import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';

/// The group's live order at a table, and the bill split.
class TableScreen extends ConsumerStatefulWidget {
  const TableScreen({super.key});

  @override
  ConsumerState<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends ConsumerState<TableScreen> {
  static const _splitter = BillSplitter();
  SplitMode _mode = SplitMode.even;
  int _tipPercent = 10;
  final Map<String, int> _weights = {for (final id in demoFriends.keys) id: 1};

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final order = ref.watch(tableProvider);
    final text = Theme.of(context).textTheme;

    if (order == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(t.emptyOrder)),
      );
    }

    final subtotal = order.subtotal;
    final tip = subtotal.percent(_tipPercent);
    final vat = (subtotal).percent(_splitter.vatPercent);
    final total = _splitter.totalFor(subtotal, tip: tip);
    final shares = order.lines.isEmpty
        ? <String, Money>{}
        : _shares(order, tip);

    return Scaffold(
      appBar: AppBar(title: Text(t.tableLabel(order.tableLabel))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (order.lines.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(t.emptyOrder, textAlign: TextAlign.center),
            )
          else ...[
            Text(t.readyIn(order.estimatedMinutes), style: text.bodySmall),
            for (var i = 0; i < order.lines.length; i++)
              _LineTile(index: i, line: order.lines[i], mode: _mode),
            const Divider(height: 32),
            _Row(t.subtotal, fmtMoney(context, subtotal)),
            _Row(t.vat, fmtMoney(context, vat)),
            Row(
              children: [
                Expanded(child: Text(t.tip)),
                SegmentedButton<int>(
                  showSelectedIcon: false,
                  segments: [
                    for (final p in const [0, 10, 15, 20])
                      ButtonSegment(value: p, label: Text('$p%')),
                  ],
                  selected: {_tipPercent},
                  onSelectionChanged: (s) =>
                      setState(() => _tipPercent = s.first),
                ),
              ],
            ),
            _Row(t.total, fmtMoney(context, total), bold: true),
            const SizedBox(height: 24),
            Text(t.splitBill, style: text.titleMedium),
            const SizedBox(height: 8),
            SegmentedButton<SplitMode>(
              segments: [
                ButtonSegment(value: SplitMode.even, label: Text(t.splitEven)),
                ButtonSegment(
                  value: SplitMode.byItem,
                  label: Text(t.splitByItem),
                ),
                ButtonSegment(
                  value: SplitMode.custom,
                  label: Text(t.splitCustom),
                ),
              ],
              selected: {_mode},
              onSelectionChanged: (s) => setState(() => _mode = s.first),
            ),
            const SizedBox(height: 8),
            for (final p in order.participants)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(child: Text(demoFriends[p]![0])),
                title: Text(demoFriends[p]!),
                subtitle: _mode == SplitMode.custom
                    ? Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: _weights[p]! > 0
                                ? () => setState(
                                    () => _weights[p] = _weights[p]! - 1,
                                  )
                                : null,
                          ),
                          Text('×${_weights[p]}'),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () =>
                                setState(() => _weights[p] = _weights[p]! + 1),
                          ),
                        ],
                      )
                    : null,
                trailing: Text(
                  fmtMoney(context, shares[p] ?? Money.zero()),
                  style: text.titleMedium,
                ),
              ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Payments arrive with Stripe in the next step.',
                  ),
                ),
              ),
              child: Text(t.payMyShare),
            ),
          ],
        ],
      ),
    );
  }

  Map<String, Money> _shares(TableOrder order, Money tip) {
    switch (_mode) {
      case SplitMode.even:
        return _splitter.even(
          participants: order.participants,
          subtotal: order.subtotal,
          tip: tip,
        );
      case SplitMode.byItem:
        return _splitter.byItem(
          participants: order.participants,
          lines: [
            for (final l in order.lines)
              BillLine(name: l.item.name, amount: l.total, sharedBy: l.payers),
          ],
          tip: tip,
        );
      case SplitMode.custom:
        final weights = {
          for (final p in order.participants) p: _weights[p] ?? 1,
        };
        if (weights.values.every((w) => w == 0)) return {};
        return _splitter.custom(
          weights: weights,
          subtotal: order.subtotal,
          tip: tip,
        );
    }
  }
}

class _LineTile extends ConsumerWidget {
  const _LineTile({
    required this.index,
    required this.line,
    required this.mode,
  });

  final int index;
  final OrderLine line;
  final SplitMode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final notifier = ref.read(tableProvider.notifier);
    final payers = line.payers;
    final everyone = payers.length == demoFriends.length;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: IconButton(
        icon: const Icon(Icons.remove_circle_outline),
        onPressed: () => notifier.remove(index),
      ),
      title: Text('${line.quantity}× ${line.item.name}'),
      subtitle: mode == SplitMode.byItem
          ? Wrap(
              spacing: 4,
              children: [
                for (final entry in demoFriends.entries)
                  FilterChip(
                    visualDensity: VisualDensity.compact,
                    label: Text(entry.value),
                    selected: payers.contains(entry.key),
                    onSelected: (on) {
                      final next = {...payers};
                      on ? next.add(entry.key) : next.remove(entry.key);
                      if (next.isNotEmpty) {
                        notifier.setSharedBy(index, next.toList());
                      }
                    },
                  ),
              ],
            )
          : Text(
              everyone
                  ? t.everyone
                  : payers.map((p) => demoFriends[p]).join(', '),
            ),
      trailing: Text(fmtMoney(context, line.total)),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value, {this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = bold
        ? Theme.of(context).textTheme.titleMedium
        : Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(value, style: style),
        ],
      ),
    );
  }
}
