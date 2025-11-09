import 'package:bg3_vfx_helper/bloc/vfx/vfx_bloc.dart';
import 'package:bg3_vfx_helper/helpers/canceler.dart';
import 'package:bg3_vfx_helper/logic/vfx_entry_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VfxEventAddModel extends VfxEvent {}

class VfxStateAddModel extends VfxState {
  VfxStateAddModel({required super.lsxPath, required super.models});
}

class VfxHandlerAddModel {
  static Future<void> onAddModel(
    VfxEventAddModel event,
    VfxState state,
    Emitter<VfxState> emit,
    Canceler canceler,
  ) async {
    final models = List<VfxEntryModel>.from(state.models);
    models.add(VfxEntryModel());

    emit(VfxStateAddModel(lsxPath: state.lsxPath, models: List.unmodifiable(models)));
  }
}
