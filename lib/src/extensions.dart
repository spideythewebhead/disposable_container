import 'dart:async';

import 'package:disposable_container/src/disposable_container.dart';
import 'package:flutter/widgets.dart';

/// [DisposableContainer] extensions for [StreamController].
extension DisposableContainerStreamControllerExtension<T>
    on StreamController<T> {
  /// Automatically closes this [StreamController] when [disposableContainer] is disposed.
  void autoCloseWith(DisposableContainer disposableContainer) =>
      disposableContainer.addDisposable(close);
}

/// [DisposableContainer] extensions for [StreamSubscription].
extension DisposableContainerStreamSubscriptionExtension<T>
    on StreamSubscription<T> {
  /// Automatically cancels this [StreamSubscription] when [disposableContainer] is disposed.
  StreamSubscription<T> autoCancelWith(
    DisposableContainer disposableContainer,
  ) {
    disposableContainer.addSubscription(this);
    return this;
  }
}

/// [DisposableContainer] extensions for [ChangeNotifier]
extension DisposableContainerChangeNotifier<T extends ChangeNotifier> on T {
  T autoDisposeWith(DisposableContainer disposableContainer) {
    disposableContainer.addDisposable(dispose);
    return this;
  }
}
