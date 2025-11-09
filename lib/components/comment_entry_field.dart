import 'package:bg3_vfx_helper/bloc/vfx/vfx_bloc.dart';
import 'package:bg3_vfx_helper/components/mako_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentEntryField extends StatefulWidget {
  const CommentEntryField({super.key});

  @override
  State<CommentEntryField> createState() => _CommentEntryFieldState();
}

class _CommentEntryFieldState extends State<CommentEntryField> {
  final _controller = TextEditingController();

  void _onChanged() {
    context.read<VfxBloc>().setComment(_controller.text);
  }

  @override
  void initState() {
    super.initState();

    _controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
      child: MakoTextField(
        controller: _controller,
        labelText: "Comment",
        hintText: "Comment added before new .lsx entries",
      ),
    );
  }
}
