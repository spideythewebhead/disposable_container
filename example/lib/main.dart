import 'package:disposable_container/disposable_container.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const DisposableContainerScreen()),
                  );
                },
                child: const Text('Push screen with disposable container'),
              );
            },
          ),
        ),
      ),
    );
  }
}

class DisposableContainerScreen extends StatefulWidget {
  const DisposableContainerScreen({super.key});

  @override
  State<DisposableContainerScreen> createState() =>
      _DisposableContainerScreenState();
}

class _DisposableContainerScreenState extends State<DisposableContainerScreen>
    with
        // Use [WidgetDisposableContainerMixin] that exposes a `disposableContainer` getter
        WidgetDisposableContainerMixin {
  final TextEditingController _textEditingController =
      TextEditingController(text: 'Initial text');

  // Use [autoDisposeWith] extension to dispose with a diposableContainer
  late final FocusNode focusNode =
      FocusNode().autoDisposeWith(disposableContainer);

  int _counter = 0;

  @override
  void initState() {
    super.initState();

    disposableContainer.addDisposable(_textEditingController.dispose);

    Stream.periodic(const Duration(seconds: 1))
        .listen((event) => _incrementCounter())
        // or use disposableContainer.addSubscription(Stream.listen(..))
        .autoCancelWith(disposableContainer);

    disposableContainer
        .addDisposable(() => debugPrint('I am being disposed.. bye!'));
  }

  void _incrementCounter() {
    debugPrint('Incrementing counter to ${_counter + 1}');
    setState(() {
      _counter += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _textEditingController,
          ),
          const SizedBox(height: 12),
          Text('$_counter'),
        ],
      ),
    );
  }
}
