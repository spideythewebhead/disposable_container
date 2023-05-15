import 'dart:async';

import 'package:disposable_container/disposable_container.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks.mocks.dart';

void main() {
  test('verify that StreamController is disposed', () async {
    final DisposableContainer disposableContainer = DisposableContainer();
    final StreamController<int> streamController =
        StreamController<int>.broadcast()..autoCloseWith(disposableContainer);

    await disposableContainer.dispose();

    expect(streamController.isClosed, isTrue);
  });

  test('verify that FocusNode is disposed', () async {
    final DisposableContainer disposableContainer = DisposableContainer();
    final FocusNode focusNode = FocusNode()
      ..autoDisposeWith(disposableContainer);

    await disposableContainer.dispose();

    expect(() => focusNode.dispose(), throwsAssertionError);
  });

  test('verify that TextEditingController is disposed', () async {
    final DisposableContainer disposableContainer = DisposableContainer();
    final TextEditingController textEditingController = TextEditingController()
      ..autoDisposeWith(disposableContainer);

    await disposableContainer.dispose();

    expect(() => textEditingController.dispose(), throwsAssertionError);
  });

  test('verify that StreamSubscription is canceled', () async {
    final DisposableContainer disposableContainer = DisposableContainer();
    final StreamController<void> streamController = StreamController<void>();
    final MockSimpleCallable callable = MockSimpleCallable();

    streamController.stream
        .listen((_) => callable())
        .autoCancelWith(disposableContainer);

    streamController.add(null);
    await null;

    await disposableContainer.dispose();

    streamController.add(null);
    await null;

    verify(callable()).called(1);
  });
}
