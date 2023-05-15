import 'dart:async';

import 'package:disposable_container/src/disposable_container.dart';
import 'package:flutter/widgets.dart';

/// Mixin that provides a [DisposableContainer]
mixin DisposableContainerMixin {
  final DisposableContainer disposableContainer = DisposableContainer();

  bool get disposed => disposableContainer.disposed;

  @mustCallSuper
  Future<void> dispose() async {
    await disposableContainer.dispose();
  }
}

/// [State] mixin that provides a [DisposableContainer]
mixin WidgetDisposableContainerMixin<T extends StatefulWidget> on State<T> {
  final DisposableContainer disposableContainer = DisposableContainer();

  bool get disposed => disposableContainer.disposed;

  @override
  @mustCallSuper
  void dispose() {
    unawaited(disposableContainer.dispose());
    super.dispose();
  }
}
