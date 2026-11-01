import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/discover/discover_screen.dart';
import 'features/discover/venue_screen.dart';
import 'features/events/events_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/table/table_screen.dart';
import 'features/wallet/wallet_screen.dart';
import 'l10n/app_localizations.dart';

final appRouter = GoRouter(
  initialLocation: '/discover',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => _HomeShell(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/discover',
              builder: (_, _) => const DiscoverScreen(),
              routes: [
                GoRoute(
                  path: 'venue/:id',
                  builder: (_, s) =>
                      VenueScreen(venueId: s.pathParameters['id']!),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/events', builder: (_, _) => const EventsScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/wallet', builder: (_, _) => const WalletScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
          ],
        ),
      ],
    ),
    GoRoute(path: '/table', builder: (_, _) => const TableScreen()),
  ],
);

class _HomeShell extends StatelessWidget {
  const _HomeShell({required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) =>
            shell.goBranch(i, initialLocation: i == shell.currentIndex),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.explore_outlined),
            selectedIcon: const Icon(Icons.explore),
            label: t.tabDiscover,
          ),
          NavigationDestination(
            icon: const Icon(Icons.celebration_outlined),
            selectedIcon: const Icon(Icons.celebration),
            label: t.tabEvents,
          ),
          NavigationDestination(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: const Icon(Icons.account_balance_wallet),
            label: t.tabWallet,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: t.tabProfile,
          ),
        ],
      ),
    );
  }
}
