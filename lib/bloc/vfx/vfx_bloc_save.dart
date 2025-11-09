import 'dart:io';

import 'package:bg3_vfx_helper/bloc/vfx/vfx_bloc.dart';
import 'package:bg3_vfx_helper/helpers/canceler.dart';
import 'package:bg3_vfx_helper/logic/vfx_entry_controller.dart';
import 'package:bg3_vfx_helper/logic/vfx_entry_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VfxEventSave extends VfxEvent {}

class VfxStateFailedValidation extends VfxState {
  final String? lsxPathError;

  const VfxStateFailedValidation({
    required super.lsxPath,
    required super.comment,
    required super.models,
    required this.lsxPathError,
  });
}

class VfxStateEmptyModels extends VfxState {
  const VfxStateEmptyModels({required super.lsxPath, required super.comment, required super.models});
}

class VfxStateSavingInProgress extends VfxState {
  const VfxStateSavingInProgress({required super.lsxPath, required super.comment, required super.models});
}

class VfxStateSaveCompleted extends VfxState {
  final int filesSaved;

  const VfxStateSaveCompleted({
    required super.lsxPath,
    required super.comment,
    required super.models,
    required this.filesSaved,
  });
}

class VfxHandlerSave {
  static Future<void> onSave(
    VfxEventSave event,
    VfxState state,
    Emitter<VfxState> emit,
    Canceler canceler,
  ) async {
    String? lsxPathError;

    final lsxPath = state.lsxPath;
    final lsxDirectory = Directory(lsxPath);
    if (!await lsxDirectory.exists()) {
      lsxPathError = "Invalid path to lsx directory.";
    }

    final models = List<VfxEntryModel>.from(state.models);
    final validateRes = VfxEntryController.validateModels(models);

    if (lsxPathError != null || !validateRes) {
      emit(
        VfxStateFailedValidation(
          lsxPath: lsxPath,
          comment: state.comment,
          models: List.unmodifiable(models),
          lsxPathError: lsxPathError,
        ),
      );

      return;
    }

    if (models.isEmpty) {
      emit(VfxStateEmptyModels(lsxPath: lsxPath, comment: state.comment, models: List.unmodifiable(models)));

      return;
    }

    emit(
      VfxStateSavingInProgress(lsxPath: lsxPath, comment: state.comment, models: List.unmodifiable(models)),
    );

    final saveRes = await VfxEntryController.saveModels(models, lsxDirectory);

    emit(
      VfxStateSaveCompleted(
        lsxPath: lsxPath,
        comment: state.comment,
        models: List.unmodifiable(models),
        filesSaved: saveRes,
      ),
    );
  }
}
