import 'package:disposable_container/disposable_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks.mocks.dart';

void main() {
  test(
    'verify that mixin disposes',
    () async {
      final MockSimpleCallable callable = MockSimpleCallable();
      final _ClassWithDisposableContainerMixin classWithMixin =
          _ClassWithDisposableContainerMixin(callable);
      await classWithMixin.dispose();

      verify(callable()).called(1);
      expect(classWithMixin.disposed, isTrue);
    },
  );

  testWidgets(
    'verify that dispose is called for StatefulWidget',
    (WidgetTester widgetTester) async {
      final MockSimpleCallable callable = MockSimpleCallable();

      await widgetTester.pumpWidget(_TestWidget(
        callable: callable,
      ));
      await widgetTester.pumpWidget(const SizedBox.shrink());
      await widgetTester.pumpAndSettle();

      verify(callable()).called(1);
    },
  );
}

class _ClassWithDisposableContainerMixin with DisposableContainerMixin {
  _ClassWithDisposableContainerMixin(MockSimpleCallable callable) {
    disposableContainer.addDisposable(callable);
  }
}

class _TestWidget extends StatefulWidget {
  const _TestWidget({
    required this.callable,
  });

  final MockSimpleCallable callable;

  @override
  State<_TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<_TestWidget>
    with WidgetDisposableContainerMixin<_TestWidget> {
  @override
  void initState() {
    super.initState();
    disposableContainer.addDisposable(widget.callable);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
