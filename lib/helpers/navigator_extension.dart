import 'package:flutter/widgets.dart';

extension UntilNamed on NavigatorState {
  void pushNamedUntilNamed(String routeName, {required String replaceRouteName, Object? arguments}) {
    pushNamedAndRemoveUntil(routeName, (r) => r.settings.name == replaceRouteName, arguments: arguments);
  }

  void popUntilNamed({required String replaceRouteName}) {
    popUntil((r) => r.settings.name == replaceRouteName);
  }

  void popAllPopups() {
    popUntil((route) {
      return route is! PopupRoute;
    });
  }
}
