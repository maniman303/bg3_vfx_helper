import 'package:bg3_vfx_helper/bloc/locked_bloc.dart';
import 'package:bg3_vfx_helper/bloc/vfx/vfx_bloc_add_model.dart';
import 'package:bg3_vfx_helper/bloc/vfx/vfx_bloc_remove_model.dart';
import 'package:bg3_vfx_helper/bloc/vfx/vfx_bloc_save.dart';
import 'package:bg3_vfx_helper/bloc/vfx/vfx_bloc_set_lsx_path.dart';
import 'package:bg3_vfx_helper/bloc/vfx/vfx_bloc_set_uuid.dart';
import 'package:bg3_vfx_helper/logic/vfx_entry_model.dart';

class VfxEvent {
  const VfxEvent();
}

class VfxState {
  final String lsxPath;
  final List<VfxEntryModel> models;

  const VfxState({required this.lsxPath, required this.models});
}

class VfxBloc extends LockedBloc<VfxEvent, VfxState> {
  VfxBloc() : super(VfxState(lsxPath: "", models: [VfxEntryModel()])) {
    on<VfxEventAddModel>(
      (event, emit) => lockedRun(event, emit, VfxHandlerAddModel.onAddModel, type: "models"),
    );

    on<VfxEventRemoveModel>(
      (event, emit) => lockedRun(event, emit, VfxHandlerRemoveModel.onRemoveModel, type: "models"),
    );

    on<VfxEventSetLsxPath>((event, emit) => lockedRun(event, emit, VfxHandlerSetLsxPath.onSetLsxPath));

    on<VfxEventSetVanillaUUID>(
      (event, emit) => lockedRun(event, emit, VfxHandlerSetModelUUID.onSetVanillaUUID),
    );

    on<VfxEventSetCustomUUID>(
      (event, emit) => lockedRun(event, emit, VfxHandlerSetModelUUID.onSetCustomUUID),
    );

    on<VfxEventSave>((event, emit) => lockedLimitedRun(event, emit, VfxHandlerSave.onSave));
  }

  void addModel() {
    add(VfxEventAddModel());
  }

  void removeModel(String id) {
    add(VfxEventRemoveModel(id: id));
  }

  void setLsxPath(String lsxPath) {
    add(VfxEventSetLsxPath(lsxPath: lsxPath));
  }

  void setVanillaUUID(String id, String uuid) {
    add(VfxEventSetVanillaUUID(id: id, uuid: uuid));
  }

  void setCustomUUID(String id, String uuid) {
    add(VfxEventSetCustomUUID(id: id, uuid: uuid));
  }

  void save() {
    add(VfxEventSave());
  }
}
