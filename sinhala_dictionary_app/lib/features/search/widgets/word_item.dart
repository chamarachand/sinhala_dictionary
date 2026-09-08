import 'package:flutter/material.dart';
import 'package:sinhala_dictionary_app/features/search/data/word_definition.dart';

class WordItem extends StatelessWidget {
  final WordDefinition item;
  final VoidCallback onTap;
  const WordItem({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(
          item.word,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          item.definition,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: onTap,
      ),
    );
  }
}
