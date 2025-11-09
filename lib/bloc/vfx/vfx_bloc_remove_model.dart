import 'package:bg3_vfx_helper/bloc/vfx/vfx_bloc.dart';
import 'package:bg3_vfx_helper/helpers/canceler.dart';
import 'package:bg3_vfx_helper/logic/vfx_entry_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VfxEventRemoveModel extends VfxEvent {
  final String id;

  const VfxEventRemoveModel({required this.id});
}

class VfxStateRemoveModel extends VfxState {
  VfxStateRemoveModel({required super.lsxPath, required super.comment, required super.models});
}

class VfxHandlerRemoveModel {
  static Future<void> onRemoveModel(
    VfxEventRemoveModel event,
    VfxState state,
    Emitter<VfxState> emit,
    Canceler canceler,
  ) async {
    final models = List<VfxEntryModel>.from(state.models);

    if (!models.any((m) => m.id == event.id)) {
      return;
    }

    models.removeWhere((m) => m.id == event.id);

    emit(
      VfxStateRemoveModel(lsxPath: state.lsxPath, comment: state.comment, models: List.unmodifiable(models)),
    );
  }
}
