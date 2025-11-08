import 'dart:io';

import 'package:bg3_vfx_helper/components/button_separator.dart';
import 'package:bg3_vfx_helper/components/last_wrap.dart';
import 'package:bg3_vfx_helper/components/list_header.dart';
import 'package:bg3_vfx_helper/components/lockable_buttons.dart';
import 'package:bg3_vfx_helper/components/mako_about_dialog.dart';
import 'package:bg3_vfx_helper/components/material_path_field.dart';
import 'package:bg3_vfx_helper/components/save_dialog.dart';
import 'package:bg3_vfx_helper/components/vfx_entry_field.dart';
import 'package:bg3_vfx_helper/helpers/custom_change_notifier.dart';
import 'package:bg3_vfx_helper/logic/vfx_entry_controller.dart';
import 'package:bg3_vfx_helper/logic/vfx_entry_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scrollController = ScrollController();
  final _lsxPathController = TextEditingController();
  final _entryList = <VfxEntryModel>[VfxEntryModel()];

  String? _lsxPathError;

  void _onThemeSwitch(bool value) {
    final themeNotifier = context.read<CustomChangeNotifier<ThemeMode>>();

    if (themeNotifier.value == ThemeMode.system) {
      themeNotifier.set(Theme.brightnessOf(context) == Brightness.dark ? ThemeMode.light : ThemeMode.dark);
    } else {
      themeNotifier.set(ThemeMode.system);
    }
  }

  void _addEntry() {
    setState(() {
      _entryList.add(VfxEntryModel());
    });
  }

  void _removeEntry(VfxEntryModel model) {
    setState(() {
      _entryList.remove(model);
    });
  }

  Future<void> _onAbout() async {
    await showDialog(context: context, builder: (context) => MakoAboutDialog());
  }

  void _onPathChanged() {
    setState(() {
      _lsxPathError = null;
    });
  }

  Future<void> _onSave() async {
    final lsxDirectory = Directory(_lsxPathController.text);
    if (!await lsxDirectory.exists()) {
      setState(() {
        _lsxPathError = "Invalid path to lsx directory.";
      });

      return;
    }

    setState(() {
      _lsxPathError = null;
    });

    if (!mounted) {
      return;
    }

    if (_entryList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No entries to enter.")));
      return;
    }

    final validateRes = VfxEntryController.validateModels(_entryList);

    setState(() {});

    if (!validateRes) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Errors in entries.")));
      return;
    }

    showDialog(context: context, barrierDismissible: false, builder: (context) => SaveDialog());

    final saveRes = await VfxEntryController.saveModelsOnIsolate(_entryList, lsxDirectory);

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();

    if (saveRes) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Save succeeded.")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Save failed.")));
    }
  }

  @override
  void initState() {
    super.initState();

    _lsxPathController.addListener(_onPathChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _lsxPathController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: _addEntry, child: Icon(Icons.add)),
      body: Scrollbar(
        controller: _scrollController,
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
                    child: ListView(
                      controller: _scrollController,
                      children: [
                        ListHeader("Settings"),
                        MaterialPathField(controller: _lsxPathController, errorText: _lsxPathError),
                        ListHeader("Entries"),
                        ..._entryList.map((e) => VfxEntryField(model: e, onDelete: () => _removeEntry(e))),
                        SizedBox(height: 70),
                      ],
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
