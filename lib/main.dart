import 'dart:io';

import 'package:bg3_vfx_helper/bloc/theme/theme_bloc.dart';
import 'package:bg3_vfx_helper/bloc/vfx/vfx_bloc.dart';
import 'package:bg3_vfx_helper/logic/logger.dart';
import 'package:bg3_vfx_helper/looks/no_transition_builder.dart';
import 'package:bg3_vfx_helper/screens/home.dart';
import 'package:bg3_vfx_helper/screens/licenses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Logger.initialize("bg3_vfx_helper");
  Logger.info("BG3 VFX Helper");

  if (Platform.isWindows) {
    await windowManager.ensureInitialized();

    final windowOptions = WindowOptions(
      title: "BG3 VFX Helper",
      minimumSize: Size(570, 470),
      size: Size(900, 550),
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(lazy: false, create: (_) => ThemeBloc()),
        BlocProvider<VfxBloc>(create: (_) => VfxBloc()),
      ],
      child: const MainApp(),
    ),
  );
}

final routeObserver = RouteObserver<PageRoute>();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeBloc>();
    final lightColorScheme = ColorScheme.fromSeed(seedColor: Colors.blueAccent);
    final darkColorScheme = ColorScheme.fromSeed(seedColor: Colors.blueAccent, brightness: Brightness.dark);

    return MaterialApp(
      title: 'BG3 VFX Helper',
      navigatorObservers: [routeObserver],
      theme: ThemeData(
        colorScheme: lightColorScheme,
        snackBarTheme: SnackBarThemeData(
          showCloseIcon: true,
          behavior: SnackBarBehavior.floating,
          width: 400,
          insetPadding: const EdgeInsets.all(12.0),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          floatingLabelStyle: TextStyle(fontWeight: FontWeight.w500),
          filled: true,
          fillColor: lightColorScheme.surface,
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          ),
        ),
        dividerColor: Colors.transparent,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {TargetPlatform.windows: const NoTransitionsBuilder()},
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        snackBarTheme: SnackBarThemeData(
          showCloseIcon: true,
          behavior: SnackBarBehavior.floating,
          width: 400,
          insetPadding: const EdgeInsets.all(12.0),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          floatingLabelStyle: TextStyle(fontWeight: FontWeight.w500),
          filled: true,
          fillColor: darkColorScheme.surface,
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          ),
        ),
        dividerColor: Colors.transparent,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {TargetPlatform.windows: const NoTransitionsBuilder()},
        ),
      ),
      scrollBehavior: const MaterialScrollBehavior().copyWith(scrollbars: false),
      themeMode: themeNotifier.state.selectedTheme,
      routes: {Home.routeName: (context) => const Home(), Licenses.routeName: (context) => const Licenses()},
      initialRoute: Home.routeName,
    );
  }
}
