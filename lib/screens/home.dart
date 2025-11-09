import 'package:bg3_vfx_helper/bloc/theme/theme_bloc.dart';
import 'package:bg3_vfx_helper/bloc/vfx/vfx_bloc.dart';
import 'package:bg3_vfx_helper/components/button_separator.dart';
import 'package:bg3_vfx_helper/components/last_wrap.dart';
import 'package:bg3_vfx_helper/components/list_header.dart';
import 'package:bg3_vfx_helper/components/lockable_buttons.dart';
import 'package:bg3_vfx_helper/components/mako_about_dialog.dart';
import 'package:bg3_vfx_helper/components/material_path_field.dart';
import 'package:bg3_vfx_helper/components/vfx_entry_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  static const String routeName = "/";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scrollController = ScrollController();

  void _onThemeSwitch(bool value) {
    final themeBloc = context.read<ThemeBloc>();

    if (themeBloc.state.selectedTheme == ThemeMode.system) {
      themeBloc.changeTheme(
        Theme.brightnessOf(context) == Brightness.dark ? ThemeMode.light : ThemeMode.dark,
      );
    } else {
      themeBloc.changeTheme(ThemeMode.system);
    }
  }

  void _addEntry() {
    context.read<VfxBloc>().addModel();
  }

  Future<void> _onAbout() async {
    await showDialog(context: context, builder: (context) => MakoAboutDialog());
  }

  Future<void> _onSave() async {
    context.read<VfxBloc>().save();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: _addEntry, child: Icon(Icons.add)),
      body: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
          child: Column(
            children: [
              LastWrap(
                children: [
                  LockableFilledButton(onPressed: _onSave, label: Text("Save"), icon: Icon(Icons.save)),
                  ButtonSeparator(),
                  LockableOutlinedButton(
                    onPressed: _onAbout,
                    label: Text("About"),
                    icon: Icon(Icons.info_outline_rounded),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Dark mode:",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 10),
                      SizedBox(
                        height: 32,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Switch(
                            value: Theme.brightnessOf(context) == Brightness.dark,
                            onChanged: _onThemeSwitch,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 730),
                    child: VfxEntryList(
                      scrollController: _scrollController,
                      headers: [ListHeader("Settings"), MaterialPathField(), ListHeader("Entries")],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
