import 'package:flutter/material.dart';
import 'package:sinhala_dictionary_app/core/enums/history_sort_options.dart';

class SortPopupMenuButton extends StatelessWidget {
  final void Function(SortOptions) onSelected;
  final SortOptions value;
  final bool enableSortByViewCount;
  const SortPopupMenuButton({
    super.key,
    required this.value,
    required this.onSelected,
    this.enableSortByViewCount = true,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortOptions>(
      icon: const Icon(Icons.sort),
      initialValue: value,
      onSelected: onSelected,
      itemBuilder: (context) {
        return <PopupMenuEntry<SortOptions>>[
          SortPopupMenuItem(
            value: SortOptions.latest,
            icon: Icons.history,
            label: 'Last searched',
          ),
          SortPopupMenuItem(
            value: SortOptions.alphabeticalAZ,
            icon: Icons.sort_by_alpha,
            label: 'A to Z',
          ),
          SortPopupMenuItem(
            value: SortOptions.alphabeticalZA,
            icon: Icons.sort_by_alpha_outlined,
            label: 'Z to A',
          ),
          if (enableSortByViewCount)
            SortPopupMenuItem(
              value: SortOptions.mostViewed,
              icon: Icons.visibility,
              label: 'Most viewed',
            ),
        ];
      },
    );
  }
}

class SortPopupMenuItem extends PopupMenuItem<SortOptions> {
  SortPopupMenuItem({
    super.key,
    required SortOptions value,
    required IconData icon,
    required String label,
  }) : super(
         value: value,
         child: Row(
           children: [
             Icon(icon, size: 20),
             const SizedBox(width: 12),
             Text(label),
           ],
         ),
       );
}
