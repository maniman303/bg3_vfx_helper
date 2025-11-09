import 'package:bg3_vfx_helper/bloc/vfx/vfx_bloc.dart';
import 'package:bg3_vfx_helper/components/lockable_buttons.dart';
import 'package:bg3_vfx_helper/components/mako_text_field.dart';
import 'package:bg3_vfx_helper/logic/vfx_entry_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VfxEntryField extends StatefulWidget {
  final VfxEntryModel model;

  const VfxEntryField({super.key, required this.model});

  @override
  State<VfxEntryField> createState() => _VfxEntryFieldState();
}

class _VfxEntryFieldState extends State<VfxEntryField> {
  final _vanillaController = TextEditingController();
  final _customController = TextEditingController();
  String? _vanillaError;
  String? _customError;

  void _onVanillaChanged() {
    context.read<VfxBloc>().setVanillaUUID(widget.model.id, _vanillaController.text);
  }

  void _onCustomChanged() {
    context.read<VfxBloc>().setCustomUUID(widget.model.id, _customController.text);
  }

  void _listener(BuildContext context, VfxState state) {
    final stateModel = state.models.where((m) => m.id == widget.model.id).firstOrNull;

    if (stateModel == null) {
      return;
    }

    if (_vanillaController.text != stateModel.vanillaUUID ||
        _customController.text != stateModel.customUUID) {
      _vanillaController.text = stateModel.vanillaUUID;
      _customController.text = stateModel.customUUID;
    }

    if (_vanillaError != stateModel.vanillaError || _customError != stateModel.customError) {
      setState(() {
        _vanillaError = stateModel.vanillaError;
        _customError = stateModel.customError;
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
    return BlocListener<VfxBloc, VfxState>(
      listener: _listener,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: MakoTextField(
                controller: _vanillaController,
                labelText: "Vanilla head UUID",
                hintText: "________-____-____-__________",
                errorText: _vanillaError,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: MakoTextField(
                controller: _customController,
                labelText: "Custom head UUID",
                hintText: "________-____-____-__________",
                errorText: _customError,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: LockableFilledIconButton(
                onPressed: () async {
                  context.read<VfxBloc>().removeModel(widget.model.id);
                },
                icon: Icon(Icons.delete_outline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
