import 'package:flutter_test/flutter_test.dart';
import 'package:christbaumloben/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('PersonServiceTest -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
