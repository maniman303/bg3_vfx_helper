import 'package:bg3_vfx_helper/bloc/vfx/vfx_bloc.dart';
import 'package:bg3_vfx_helper/helpers/canceler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VfxEventSetLsxPath extends VfxEvent {
  final String lsxPath;

  const VfxEventSetLsxPath({required this.lsxPath});
}

class VfxStateSetLsxPath extends VfxState {
  VfxStateSetLsxPath({required super.lsxPath, required super.models});
}

class VfxHandlerSetLsxPath {
  static Future<void> onSetLsxPath(
    VfxEventSetLsxPath event,
    VfxState state,
    Emitter<VfxState> emit,
    Canceler canceler,
  ) async {
    if (event.lsxPath == state.lsxPath) {
      return;
    }

    if (canceler.canceled) {
      return;
    }

    emit(VfxStateSetLsxPath(lsxPath: event.lsxPath, models: state.models));
  }
}
