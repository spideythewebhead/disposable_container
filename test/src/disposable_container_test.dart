import 'dart:async';

import 'package:disposable_container/disposable_container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks.mocks.dart';

void main() {
  test('verify that dispose callback has been called', () async {
    final DisposableContainer disposableContainer = DisposableContainer();
    final MockSimpleCallable disposable = MockSimpleCallable();

    disposableContainer.addDisposable(disposable.call);
    await disposableContainer.dispose();

    verify(disposable()).called(1);
    expect(disposableContainer.disposed, isTrue);
  });

  test(
    'verify that a disposed DisposableContainer can not be altered',
    () async {
      final DisposableContainer disposableContainer = DisposableContainer();
      await disposableContainer.dispose();

      expect(
        () => disposableContainer.addDisposable(() => null),
        throwsAssertionError,
      );

      expect(
        () => disposableContainer
            .addDisposables(<DisposableCallback>[() => null]),
        throwsAssertionError,
      );

      expect(
        () => disposableContainer
            .addSubscription(const Stream<void>.empty().listen((_) {})),
        throwsAssertionError,
      );

      expect(
        () => disposableContainer.dispose(),
        throwsAssertionError,
      );
    },
  );

  test('verify that stream listener has been canceled', () async {
    final DisposableContainer disposableContainer = DisposableContainer();
    final StreamController<int> streamController = StreamController<int>();
    final MockSimpleCallable callable = MockSimpleCallable();

    disposableContainer.addSubscription(
        streamController.stream.listen((int event) => callable()));
    streamController.add(1);
    await null;
    await disposableContainer.dispose();
    streamController.add(2);

    verify(callable()).called(1);
    expect(disposableContainer.disposed, isTrue);
  });

  test(
    'verify that clear disposes DisposableCallbacks and DisposableContainer is still usable',
    () async {
      final DisposableContainer disposableContainer = DisposableContainer();
      final MockSimpleCallable callable = MockSimpleCallable();

      disposableContainer.addDisposable(callable.call);
      await disposableContainer.clear();
      expect(disposableContainer.disposed, isFalse);

      disposableContainer.addDisposable(callable.call);
      await disposableContainer.dispose();

      verify(callable()).called(2);
      expect(disposableContainer.disposed, isTrue);
    },
  );

  test(
    'verify that onDisposeError is called',
    () {
      final DisposableContainer disposableContainer = DisposableContainer()
        ..onDisposeError = (Object exception, StackTrace stackTrace) =>
            debugPrint('caught exception');

      disposableContainer.addDisposable(() => throw Exception());

      expect(
        () => disposableContainer.dispose(),
        prints('caught exception\n'),
      );
    },
  );
}
