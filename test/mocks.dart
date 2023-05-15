library mocks;

import 'package:mockito/annotations.dart';

@GenerateNiceMocks(<MockSpec<dynamic>>[MockSpec<SimpleCallable>()])
class SimpleCallable {
  void call() {}
}
