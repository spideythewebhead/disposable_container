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

/// [DisposableContainer] extensions for [TextEditingController].
extension DisposableContainerTextEditingControllerExtension
    on TextEditingController {
  /// Automatically disposes this [TextEditingController] when [disposableContainer] is disposed.
  TextEditingController autoDisposeWith(
    DisposableContainer disposableContainer,
  ) {
    disposableContainer.addDisposable(dispose);
    return this;
  }
}

/// [DisposableContainer] extensions for [FocusNode].
extension DisposableContainerFocusNodeExtension on FocusNode {
  /// Automatically disposes this [FocusNode] when [disposableContainer] is disposed.
  FocusNode autoDisposeWith(DisposableContainer disposableContainer) {
    disposableContainer.addDisposable(dispose);
    return this;
  }
}
