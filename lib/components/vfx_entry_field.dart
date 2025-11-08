import 'package:bg3_vfx_helper/components/lockable_buttons.dart';
import 'package:bg3_vfx_helper/components/mako_text_field.dart';
import 'package:bg3_vfx_helper/logic/vfx_entry_model.dart';
import 'package:flutter/material.dart';

class VfxEntryField extends StatefulWidget {
  final VfxEntryModel model;
  final void Function() onDelete;

  const VfxEntryField({super.key, required this.model, required this.onDelete});

  @override
  State<VfxEntryField> createState() => _VfxEntryFieldState();
}

class _VfxEntryFieldState extends State<VfxEntryField> {
  final _vanillaController = TextEditingController();
  final _customController = TextEditingController();

  void _onVanillaChanged() {
    final differs = widget.model.vanillaUUID != _vanillaController.text;

    widget.model.vanillaUUID = _vanillaController.text;

    if (widget.model.vanillaError != null && differs) {
      setState(() {
        widget.model.vanillaError = null;
      });
    }
  }

  void _onCustomChanged() {
    final differs = widget.model.customUUID != _customController.text;

    widget.model.customUUID = _customController.text;

    if (widget.model.customError != null && differs) {
      setState(() {
        widget.model.customError = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _vanillaController.addListener(_onVanillaChanged);
    _customController.addListener(_onCustomChanged);
  }

  @override
  void dispose() {
    _vanillaController.dispose();
    _customController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: MakoTextField(
              controller: _vanillaController,
              labelText: "Vanilla head UUID",
              hintText: "________-____-____-__________",
              errorText: widget.model.vanillaError,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: MakoTextField(
              controller: _customController,
              labelText: "Custom head UUID",
              hintText: "________-____-____-__________",
              errorText: widget.model.customError,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: LockableFilledIconButton(
              onPressed: () async {
                widget.onDelete();
              },
              icon: Icon(Icons.delete_outline),
            ),
          ),
        ],
      ),
    );
  }
}
