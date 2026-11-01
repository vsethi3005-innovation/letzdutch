import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../state/providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider);
    final current =
        locale?.languageCode ?? Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(t.tabProfile)),
      body: ListView(
        children: [
          const ListTile(
            leading: CircleAvatar(radius: 28, child: Icon(Icons.person)),
            title: Text('Guest'),
            subtitle: Text('Sign in with your phone number'),
          ),
          ListTile(
            leading: const Icon(Icons.workspace_premium),
            title: Text(t.membership),
            trailing: const Text('Normal'),
          ),
          ListTile(
            leading: const Icon(Icons.translate),
            title: Text(t.language),
            trailing: SegmentedButton<String>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: 'en', label: Text('EN')),
                ButtonSegment(value: 'ar', label: Text('عربي')),
              ],
              selected: {current},
              onSelectionChanged: (s) =>
                  ref.read(localeProvider.notifier).set(Locale(s.first)),
            ),
          ),
        ],
      ),
    );
  }
}
