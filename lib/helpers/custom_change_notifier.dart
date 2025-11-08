import 'package:flutter/material.dart';

class CustomChangeNotifier<T> extends ChangeNotifier {
  final _asyncListeners = <Future<void> Function()>{};

  CustomChangeNotifier(T value) : _value = value;

  T _value;
  T get value => _value;

  void set(T value) {
    _value = value;

    notifyListeners();
  }

  Future<void> setAsync(T value, {bool notifySync = false}) async {
    _value = value;

    if (notifySync) {
      notifyListeners();
    }

    await notifyAsyncListeners();
  }

  void addAsyncListener(Future<void> Function() fun) {
    _asyncListeners.add(fun);
  }

  void removeAsyncListener(Future<void> Function() fun) {
    _asyncListeners.remove(fun);
  }

  @protected
  Future<void> notifyAsyncListeners() async {
    for (var fun in _asyncListeners) {
      await fun();
    }
  }

  @override
  void dispose() {
    _asyncListeners.clear();
    super.dispose();
  }
}
