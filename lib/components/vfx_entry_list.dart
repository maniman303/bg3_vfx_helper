import 'dart:collection';

import 'package:bg3_vfx_helper/bloc/vfx/vfx_bloc_add_model.dart';
import 'package:bg3_vfx_helper/bloc/vfx/vfx_bloc.dart';
import 'package:bg3_vfx_helper/bloc/vfx/vfx_bloc_remove_model.dart';
import 'package:bg3_vfx_helper/components/vfx_entry_field.dart';
import 'package:bg3_vfx_helper/logic/vfx_entry_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VfxEntryList extends StatefulWidget {
  final List<Widget>? headers;
  final ScrollController? scrollController;

  const VfxEntryList({super.key, this.headers, this.scrollController});

  @override
  State<VfxEntryList> createState() => _VfxEntryListState();
}

class _VfxEntryListState extends State<VfxEntryList> {
  final _models = <VfxEntryModel>[];

  bool _removeModels(VfxState state) {
    final idsToBeRemoved = HashSet<String>.from(_models.map((m) => m.id).toSet());

    for (final stateModel in state.models) {
      idsToBeRemoved.remove(stateModel.id);
    }

    for (final idToRemove in idsToBeRemoved) {
      _models.removeWhere((e) => e.id == idToRemove);
    }

    return idsToBeRemoved.isNotEmpty;
  }

  bool _addModels(VfxState state) {
    final idsToBeAdded = HashSet<String>.from(state.models.map((m) => m.id).toSet());

    for (final model in _models) {
      idsToBeAdded.remove(model.id);
    }

    for (final idToBeAdd in idsToBeAdded) {
      _models.add(state.models.firstWhere((m) => m.id == idToBeAdd));
    }

    return idsToBeAdded.isNotEmpty;
  }

  void _listener(BuildContext context, VfxState state) {
    if (state is! VfxStateAddModel && state is! VfxStateRemoveModel) {
      return;
    }

    final hasRemoved = _removeModels(state);
    final hasAdded = _addModels(state);

    if (hasRemoved || hasAdded) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _models.clear();

    setState(() {
      _models.addAll(context.read<VfxBloc>().state.models);
    });
  }

  @override
  Widget build(BuildContext context) {
    final headers = widget.headers;

    return BlocListener<VfxBloc, VfxState>(
      listener: _listener,
      child: ListView(
        controller: widget.scrollController,
        children: [
          if (headers != null) ...headers,
          ..._models.map((e) => VfxEntryField(model: e)),
          SizedBox(height: 70),
        ],
      ),
    );
  }
}
