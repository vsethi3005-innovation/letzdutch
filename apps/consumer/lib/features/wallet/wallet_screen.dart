import 'package:flutter/material.dart';
import 'package:letz_core/letz_core.dart';

import '../../format.dart';
import '../../l10n/app_localizations.dart';

/// Who owes whom. In the MVP this is a ledger settled through Stripe,
/// not a stored-value wallet (that needs a UAE licence).
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    Widget tile(String label, Money m, Color color) => Expanded(
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: text.labelLarge),
              const SizedBox(height: 4),
              Text(fmtMoney(context, m), style: text.headlineSmall),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(t.tabWallet)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              tile(t.youOwe, Money.fromMajor(185), scheme.errorContainer),
              tile(t.owedToYou, Money.fromMajor(240), scheme.primaryContainer),
            ],
          ),
          Card(
            color: scheme.tertiaryContainer,
            child: ListTile(
              leading: const Icon(Icons.savings),
              title: Text(t.monthlySavings),
              trailing: Text(
                fmtMoney(context, Money.fromMajor(96.5)),
                style: text.titleMedium,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(t.recentActivity, style: text.titleMedium),
          ListTile(
            leading: const CircleAvatar(child: Text('O')),
            title: const Text('Omar · Friday brunch'),
            trailing: Text('+ ${fmtMoney(context, Money.fromMajor(200))}'),
          ),
          ListTile(
            leading: const CircleAvatar(child: Text('S')),
            title: const Text('Saffron Terrace · Table 12'),
            trailing: Text('− ${fmtMoney(context, Money.fromMajor(185))}'),
          ),
        ],
      ),
    );
  }
}
