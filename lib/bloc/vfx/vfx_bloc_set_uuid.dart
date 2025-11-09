import 'package:bg3_vfx_helper/bloc/vfx/vfx_bloc.dart';
import 'package:bg3_vfx_helper/helpers/canceler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VfxEventSetVanillaUUID extends VfxEvent {
  final String id;
  final String uuid;

  const VfxEventSetVanillaUUID({required this.id, required this.uuid});
}

class VfxEventSetCustomUUID extends VfxEvent {
  final String id;
  final String uuid;

  const VfxEventSetCustomUUID({required this.id, required this.uuid});
}

class VfxStateSetModelUUID extends VfxState {
  const VfxStateSetModelUUID({required super.lsxPath, required super.models});
}

class VfxHandlerSetModelUUID {
  static Future<void> onSetVanillaUUID(
    VfxEventSetVanillaUUID event,
    VfxState state,
    Emitter<VfxState> emit,
    Canceler canceler,
  ) async {
    final model = state.models.where((m) => m.id == event.id).firstOrNull;

    if (model == null || model.vanillaUUID == event.uuid) {
      return;
    }

    model.vanillaUUID = event.uuid;
    model.vanillaError = null;

    emit(VfxStateSetModelUUID(lsxPath: state.lsxPath, models: state.models));
  }

  static Future<void> onSetCustomUUID(
    VfxEventSetCustomUUID event,
    VfxState state,
    Emitter<VfxState> emit,
    Canceler canceler,
  ) async {
    final model = state.models.where((m) => m.id == event.id).firstOrNull;

    if (model == null || model.customUUID == event.uuid) {
      return;
    }

    model.customUUID = event.uuid;
    model.customError = null;

    emit(VfxStateSetModelUUID(lsxPath: state.lsxPath, models: state.models));
  }
}
