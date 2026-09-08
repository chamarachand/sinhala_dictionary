import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String text;
  const DeleteConfirmationDialog({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Item'),
      content: const Text(
        'Are you sure you want to delete the history? This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),

        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text("Delete"),
        ),
      ],
    );
  }
}
