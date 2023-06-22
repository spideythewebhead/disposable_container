import 'dart:async';

import 'package:flutter/widgets.dart';

typedef DisposableCallback = FutureOr<void> Function();
typedef OnDisposeError = void Function(Object error, StackTrace stackTrace);

class DisposableContainer {
  DisposableContainer();

  /// Set a callback that is called when a disposable is getting disposed and crashes
  ///
  /// This callback reports the error and stacktrace from a try/catch block
  ///
  /// You **must** ensure that this function doesn't crash itself.
  OnDisposeError? onDisposeError;

  final List<DisposableCallback> _disposables = <DisposableCallback>[];

  bool _disposed = false;

  /// Returns if the container is disposed and unusable
  bool get disposed => _disposed;

  @pragma('vm:prefer-line')
  void _assertNotDisposed() {
    assert(!_disposed, 'Disposable container is disposed');
  }

  /// Adds a single [DisposableCallback].
  void addDisposable(DisposableCallback disposable) {
    _assertNotDisposed();
    _disposables.add(disposable);
  }

  /// Adds a list of [DisposableCallback]s.
  void addDisposables(List<DisposableCallback> disposables) {
    _assertNotDisposed();
    _disposables.addAll(disposables);
  }

  /// Adds a single [StreamSubscription].
  void addSubscription(StreamSubscription<dynamic> subscription) {
    _assertNotDisposed();
    _disposables.add(subscription.cancel);
  }

  /// Adds a list of [StreamSubscription]s.
  void addSubscriptions(List<StreamSubscription<dynamic>> subscriptions) {
    for (final StreamSubscription<dynamic> subscription in subscriptions) {
      addSubscription(subscription);
    }
  }

  /// Disposes the current available [DisposableCallback]s and clears the container.
  ///
  /// The [DisposableContainer] can be used again after that.
  Future<void> clear() async {
    // Creates a snapshot of the current disposables in case the list changes
    final List<DisposableCallback> disposables = <DisposableCallback>[
      ..._disposables
    ];
    for (final DisposableCallback disposable in disposables) {
      try {
        await disposable();
      } catch (exception, stackTrace) {
        onDisposeError?.call(exception, stackTrace);
      }
    }
    _disposables.clear();
  }

  /// Disposes the available [DisposableCallback]s.
  ///
  /// The container is marked as [disposed] and further calls to [addDisposable], [addDisposables], [addSubscription] are ignored.
  @mustCallSuper
  Future<void> dispose() async {
    _assertNotDisposed();
    if (_disposed) {
      return;
    }
    _disposed = true;
    await clear();
  }
}
