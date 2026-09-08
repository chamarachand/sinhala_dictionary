import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sinhala_dictionary_app/core/constants/string_constants.dart';
import 'package:sinhala_dictionary_app/core/extensions/extensions.dart';
import 'package:sinhala_dictionary_app/features/settings/widgets/theme_select_dialog.dart';
import 'package:sinhala_dictionary_app/features/theme/cubit/theme_cubit.dart';

class SettingsScreen extends StatelessWidget {
  final Widget drawer;
  const SettingsScreen({super.key, required this.drawer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      drawer: drawer,
      // backgroundColor: Colors.transparent, // Inherits background smoothly
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              AppStrings.appearanceStyles,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.grey,
              ),
            ),

            // Theme selection card
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, themeMode) {
                  return ListTile(
                    leading: Icon(
                      (themeMode == ThemeMode.light) ||
                              (themeMode == ThemeMode.system)
                          ? Icons.light_mode
                          : Icons.dark_mode,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: const Text(
                      'App Theme Mode',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(themeMode.displayName),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (context) =>
                            ThemeSelectDialog(currentThemeMode: themeMode),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
