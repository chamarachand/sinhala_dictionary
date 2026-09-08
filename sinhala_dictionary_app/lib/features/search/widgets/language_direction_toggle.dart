import 'package:flutter/material.dart';

class LanguageDirectionToggle extends StatelessWidget {
  final bool isEnglishToSinhala;
  final VoidCallback onTap;

  const LanguageDirectionToggle({
    super.key,
    required this.isEnglishToSinhala,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isEnglishToSinhala ? 'English' : 'Sinhala',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: colorScheme.onPrimaryContainer.withOpacity(0.8),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Icon(
                Icons.swap_horiz,
                size: 15,
                color: colorScheme.onPrimaryContainer.withOpacity(0.6),
              ),
            ),
            Text(
              isEnglishToSinhala ? 'Sinhala' : 'English',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: colorScheme.onPrimaryContainer.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
