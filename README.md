A flutter package that manages dispose callbacks and subscriptions cancellations.

## Features

This package provides helpful classes/mixins and extensions to dispose different flutter resources like

1. Sync or Async callbacks
1. StreamControllers
1. StreamSubscriptions
1. TextEditingController
1. FocusNode

## Getting started

Add the dependency on thep project's pubspec.yaml

```yaml
dependencies:
  disposable_container: ^0.0.1
```

## Usage

```dart
import 'package:disposable_container/disposable_container.dart';

void main() {
  final DisposableContainer disposableContainer = DisposableContainer();

  disposableContainer.addDisposable(() => print('I will be disposed'));

  await disposableContainer.dispose();
}
```

Find more [examples](https://github.com/spideythewebhead/disposable_container/tree/main/example)
