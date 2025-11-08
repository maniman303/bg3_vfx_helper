import 'package:flutter/material.dart';

class SaveDialog extends StatelessWidget {
  const SaveDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Saving'),
      content: SizedBox(
        height: 56,
        child: Center(
          child: SizedBox(
            width: 44,
            height: 44,
            child: CircularProgressIndicator(strokeWidth: 6, color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
    );
  }
}
