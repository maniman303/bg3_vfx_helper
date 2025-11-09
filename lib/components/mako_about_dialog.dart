import 'package:bg3_vfx_helper/components/lockable_buttons.dart';
import 'package:bg3_vfx_helper/helpers/navigator_extension.dart';
import 'package:bg3_vfx_helper/screens/licenses.dart';
import 'package:flutter/material.dart';

class MakoAboutDialog extends StatelessWidget {
  const MakoAboutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('About'),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500),
        child: const Text(
          'The tool loads all .lsx files from the selected Material Group directory.\nFor any file that already contains entries with vanilla head UUIDs, it inserts the custom head entries if they are not already present.\nIf comment is filled, it will be added before new entries.',
        ),
      ),
      actions: [
        LockableTextButton(
          onPressed: () async {
            Navigator.of(context).popAllPopups();
            Navigator.of(context).pushNamed(Licenses.routeName);
          },
          label: Text("Licenses"),
        ),
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Ok')),
      ],
    );
  }
}
