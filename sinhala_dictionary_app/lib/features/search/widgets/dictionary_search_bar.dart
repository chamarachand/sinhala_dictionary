import 'package:flutter/material.dart';

class DictionarySearchBar extends StatefulWidget {
  final void Function(String) onChanged;
  final VoidCallback onReset;
  const DictionarySearchBar({
    super.key,
    required this.onChanged,
    required this.onReset,
  });

  @override
  State<DictionarySearchBar> createState() => _DictionarySearchBarState();
}

class _DictionarySearchBarState extends State<DictionarySearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        widget.onChanged(value);
        setState(() {});
      },
      decoration: InputDecoration(
        hintText: 'Search word...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                  });
                  widget.onReset();
                },
                icon: const Icon(Icons.close),
              )
            : const SizedBox.shrink(),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
