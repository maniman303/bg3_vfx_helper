import 'package:bg3_vfx_helper/bloc/vfx/vfx_bloc.dart';
import 'package:bg3_vfx_helper/bloc/vfx/vfx_bloc_save.dart';
import 'package:bg3_vfx_helper/components/save_dialog.dart';
import 'package:bg3_vfx_helper/helpers/navigator_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SaveHandler extends StatelessWidget {
  final Widget child;

  const SaveHandler({super.key, required this.child});

  void _listener(BuildContext context, VfxState state) {
    final messenger = ScaffoldMessenger.of(context);

    if (state is VfxStateFailedValidation) {
      messenger.showSnackBar(SnackBar(content: Text("Setup is invalid.")));

      return;
    }

    if (state is VfxStateEmptyModels) {
      messenger.showSnackBar(SnackBar(content: Text("No entries to enter.")));

      return;
    }

    if (state is VfxStateSavingInProgress) {
      showDialog(context: context, barrierDismissible: false, builder: (_) => SaveDialog());

      return;
    }

    if (state is VfxStateSaveCompleted) {
      Navigator.of(context).popAllPopups();

      final filesSaved = state.filesSaved;

      if (filesSaved > 0) {
        messenger.showSnackBar(SnackBar(content: Text("Saved $filesSaved files.")));
      } else if (filesSaved == 0) {
        messenger.showSnackBar(SnackBar(content: Text("No changes required.")));
      } else {
        messenger.showSnackBar(SnackBar(content: Text("Save failed.")));
      }

      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VfxBloc, VfxState>(listener: _listener, child: child);
  }
}
