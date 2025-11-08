import 'package:bg3_vfx_helper/components/lockable_buttons.dart';
import 'package:bg3_vfx_helper/components/mako_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class MaterialPathField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;

  const MaterialPathField({super.key, required this.controller, this.errorText});

  Future<void> _onFolderPicker() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory == null) {
      return;
    }

    controller.text = selectedDirectory;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: MakoTextField(
              controller: controller,
              labelText: "Material Groups path",
              hintText: "Path to folder containing VFX .lsx files",
              errorText: errorText,
            ),
          ),
          SizedBox(width: 8),
          LockableFilledIconButton(onPressed: _onFolderPicker, icon: Icon(Icons.folder_open)),
        ],
      ),
    );
  }
}
