import 'package:flutter/material.dart';
import 'package:sinhala_dictionary_app/core/constants/string_constants.dart';

class CustomNavigationDrawer extends StatelessWidget {
  final int currentViewIndex;
  final Function(int) onNavigate;
  const CustomNavigationDrawer({
    super.key,
    required this.currentViewIndex,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header
          const _DrawerHeader(),

          const SizedBox(height: 8),

          // --- DRAWER NAVIGATION OPTIONS ---
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text(AppStrings.dictionary),
            selected: currentViewIndex == 0,
            onTap: () => onNavigate(0),
          ),

          ListTile(
            leading: const Icon(Icons.history),
            title: const Text(AppStrings.history),
            selected: currentViewIndex == 1,
            onTap: () => onNavigate(1),
          ),

          ListTile(
            leading: const Icon(Icons.star),
            title: const Text(AppStrings.favourites),
            selected: currentViewIndex == 2,
            onTap: () => onNavigate(2),
          ),

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text(AppStrings.settings),
            selected: currentViewIndex == 3,
            onTap: () => onNavigate(3),
          ),

          const Spacer(),

          const _DrawerFooter(),
        ],
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 60.0,
        bottom: 24.0,
        left: 16.0,
        right: 16.0,
      ),
      decoration: BoxDecoration(color: theme.primaryContainer.withAlpha(100)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: theme.primary,
            child: Icon(Icons.translate, size: 36, color: theme.onPrimary),
          ),
          const SizedBox(height: 16),
          Text(
            'හෙළ ශබ්දකෝෂය',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: theme.onSurface,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '122k+ Words Offline Engine',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.onSurfaceVariant.withAlpha(180),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerFooter extends StatelessWidget {
  const _DrawerFooter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'v1.2.0',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(120),
          fontSize: 12,
        ),
      ),
    );
  }
}
