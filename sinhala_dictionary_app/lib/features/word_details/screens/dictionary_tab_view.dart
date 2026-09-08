import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DictionaryTabView extends StatelessWidget {
  final List<String> definitionsList;

  const DictionaryTabView({super.key, required this.definitionsList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: definitionsList.length,
      itemBuilder: (context, index) {
        final String currentMeaning = definitionsList[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: 6.0),
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            title: Text(
              currentMeaning,
              style: const TextStyle(fontSize: 18, height: 1.3),
            ),
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              onSelected: (String choice) {
                if (choice == 'copy') {
                  Clipboard.setData(ClipboardData(text: currentMeaning));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied to clipboard!')),
                  );
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'copy',
                  child: Row(
                    children: [
                      Icon(Icons.copy, size: 18),
                      SizedBox(width: 10),
                      Text('Copy Meaning'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
