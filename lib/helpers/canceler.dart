import 'package:flutter/material.dart';

class CancelerController {
  final _set = <Canceler>{};

  Canceler cancel({String? type}) {
    type = type ?? "";

    for (final old in _set) {
      if (old.type == type) {
        old.markCanceled();
      }
    }

    _set.removeWhere((c) => c.canceled);

    final canceler = Canceler(type: type);

    _set.add(canceler);

    return canceler;
  }
}

class Canceler {
  final String type;

  Canceler({required this.type});

  bool _canceled = false;

  bool get canceled => _canceled;

  @protected
  void markCanceled() {
    _canceled = true;
  }
}
