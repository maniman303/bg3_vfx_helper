import 'package:bg3_vfx_helper/bloc/vfx/vfx_bloc.dart';
import 'package:bg3_vfx_helper/bloc/vfx/vfx_save.dart';
import 'package:bg3_vfx_helper/components/lockable_buttons.dart';
import 'package:bg3_vfx_helper/components/mako_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaterialPathField extends StatefulWidget {
  const MaterialPathField({super.key});

  @override
  State<MaterialPathField> createState() => _MaterialPathFieldState();
}

class _MaterialPathFieldState extends State<MaterialPathField> {
  final _controller = TextEditingController();
  String? _errorText;

  Future<void> _onFolderPicker() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory == null) {
      return;
    }

    _controller.text = selectedDirectory;
  }

  void _listener(BuildContext context, VfxState state) {
    if (state is VfxStateFailedValidation) {
      setState(() {
        _errorText = state.lsxPathError;
      });

      return;
    }

    if (_errorText != null && state.lsxPath != _controller.text) {
      _controller.text = state.lsxPath;
    }
  }

  void _onTextChange() {
    if (_errorText != null) {
      setState(() {
        _errorText = null;
      });
    }

    context.read<VfxBloc>().setLsxPath(_controller.text);
  }

  @override
  void initState() {
    _controller.addListener(_onTextChange);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VfxBloc, VfxState>(
      listener: _listener,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: MakoTextField(
                controller: _controller,
                labelText: "Material Groups path",
                hintText: "Path to folder containing VFX .lsx files",
                errorText: _errorText,
              ),
            ),
            SizedBox(width: 8),
            LockableFilledIconButton(onPressed: _onFolderPicker, icon: Icon(Icons.folder_open)),
          ],
        ),
      ),
    );
  }
}
