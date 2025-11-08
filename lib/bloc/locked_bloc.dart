import 'package:async_locks/async_locks.dart';
import 'package:bg3_vfx_helper/helpers/canceler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class LockedBloc<T, S> extends Bloc<T, S> {
  LockedBloc(super.initialState);

  final _lock = Lock();
  final _cancelerController = CancelerController();

  // If event is in the middle of processing, send cancelation on enqueue
  @protected
  void lockedRun<F extends T>(
    F event,
    Emitter<S> emit,
    Future<void> Function(F, S, Emitter<S>, Canceler) fun, {
    String? type,
  }) async {
    final useType = type ?? event.runtimeType.toString();

    final canceler = _cancelerController.cancel(type: useType);

    await _lock.acquire();

    await fun(event, state, emit, canceler);

    _lock.release();
  }

  // If event is in the middle of processing, don't queue
  @protected
  void lockedLimitedRun<F extends T>(
    F event,
    Emitter<S> emit,
    Future<void> Function(F, S, Emitter<S>, Canceler) fun, {
    String? type,
  }) async {
    if (_lock.locked) {
      return;
    }

    final useType = type ?? event.runtimeType.toString();

    final canceler = _cancelerController.cancel(type: useType);

    await _lock.acquire();

    await fun(event, state, emit, canceler);

    _lock.release();
  }
}
