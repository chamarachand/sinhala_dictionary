import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sinhala_dictionary_app/features/theme/cubit/theme_cubit.dart';

class ThemeSelectDialog extends StatefulWidget {
  final ThemeMode currentThemeMode;
  const ThemeSelectDialog({super.key, required this.currentThemeMode});

  @override
  State<ThemeSelectDialog> createState() => _ThemeSelectDialogState();
}

class _ThemeSelectDialogState extends State<ThemeSelectDialog> {
  late ThemeMode _selectedThemeMode;

  @override
  void initState() {
    super.initState();
    _selectedThemeMode = widget.currentThemeMode;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose Theme'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioGroup(
            groupValue: _selectedThemeMode,
            onChanged: (selectedMode) {
              if (selectedMode != null) {
                context.read<ThemeCubit>().changeTheme(selectedMode);
                setState(() {
                  _selectedThemeMode = selectedMode;
                });
              }
              // Navigator.pop(context);
            },
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: const Text('System Default'),
                  value: ThemeMode.system,
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Light Mode'),
                  value: ThemeMode.light,
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Dark Mode'),
                  value: ThemeMode.dark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
