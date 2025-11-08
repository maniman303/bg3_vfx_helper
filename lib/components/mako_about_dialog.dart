import 'package:flutter/material.dart';

class MakoAboutDialog extends StatelessWidget {
  const MakoAboutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('About'),
      content: const Text(
        'The tool loads all .lsx files from the selected Material Group directory.\nFor any file that already contains entries with vanilla head UUIDs, it inserts the custom head entries if they are not already present.',
      ),
      actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Ok'))],
    );
  }
}
