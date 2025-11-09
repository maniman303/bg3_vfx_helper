import 'package:bg3_vfx_helper/bloc/vfx/vfx_bloc.dart';
import 'package:bg3_vfx_helper/helpers/canceler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VfxEventSetComment extends VfxEvent {
  final String comment;

  const VfxEventSetComment({required this.comment});
}

class VfxStateSetComment extends VfxState {
  VfxStateSetComment({required super.lsxPath, required super.comment, required super.models});
}

class VfxHandlerSetComment {
  static Future<void> onSetComment(
    VfxEventSetComment event,
    VfxState state,
    Emitter<VfxState> emit,
    Canceler canceler,
  ) async {
    if (event.comment == state.comment) {
      return;
    }

    if (canceler.canceled) {
      return;
    }

    emit(
      VfxStateSetComment(
        lsxPath: state.lsxPath,
        comment: event.comment,
        models: List.unmodifiable(state.models),
      ),
    );
  }
}
