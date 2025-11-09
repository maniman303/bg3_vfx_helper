import 'package:bg3_vfx_helper/bloc/theme/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  void _onThemeSwitch(BuildContext context, bool value) {
    final themeBloc = context.read<ThemeBloc>();
    final expectedTheme = Theme.brightnessOf(context) == Brightness.dark ? ThemeMode.light : ThemeMode.dark;

    if (themeBloc.state.selectedTheme == ThemeMode.system) {
      themeBloc.changeTheme(expectedTheme);
    } else {
      final systemBrightness = MediaQuery.of(context).platformBrightness;

      if ((systemBrightness == Brightness.light && expectedTheme == ThemeMode.light) ||
          (systemBrightness == Brightness.dark && expectedTheme == ThemeMode.dark)) {
        themeBloc.changeTheme(ThemeMode.system);
      } else {
        themeBloc.changeTheme(expectedTheme);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
              onChanged: (value) => _onThemeSwitch(context, value),
            ),
          ),
        ),
      ],
    );
  }
}
