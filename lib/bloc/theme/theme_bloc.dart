import 'package:bg3_vfx_helper/bloc/locked_bloc.dart';
import 'package:bg3_vfx_helper/helpers/canceler.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeEvent {
  final ThemeMode newTheme;

  const ThemeEvent({required this.newTheme});
}

class ThemeState {
  final ThemeMode selectedTheme;

  const ThemeState({required this.selectedTheme});
}

class ThemeBloc extends LockedBloc<ThemeEvent, ThemeState> {
  static const String _prefsKey = "theme";
  SharedPreferencesWithCache? _prefs;

  ThemeBloc() : super(ThemeState(selectedTheme: ThemeMode.system)) {
    on<ThemeEvent>((event, emit) => lockedRun(event, emit, _onThemeChange));

    _initBlock();
  }

  void _initBlock() async {
    final prefs = await SharedPreferencesWithCache.create(cacheOptions: SharedPreferencesWithCacheOptions());

    _prefs = prefs;

    final savedThemeText = prefs.getString(_prefsKey);

    var savedTheme = ThemeMode.system;

    switch (savedThemeText) {
      case "light":
        savedTheme = ThemeMode.light;
        break;
      case "dark":
        savedTheme = ThemeMode.dark;
        break;
    }

    changeTheme(savedTheme);
  }

  Future<void> _onThemeChange(
    ThemeEvent event,
    ThemeState state,
    Emitter<ThemeState> emit,
    Canceler canceler,
  ) async {
    if (canceler.canceled) {
      return;
    }

    if (event.newTheme == state.selectedTheme) {
      return;
    }

    _prefs?.setString(_prefsKey, event.newTheme.name);

    emit(ThemeState(selectedTheme: event.newTheme));
  }

  void changeTheme(ThemeMode theme) {
    add(ThemeEvent(newTheme: theme));
  }
}
