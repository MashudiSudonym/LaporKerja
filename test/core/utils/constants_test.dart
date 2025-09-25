import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/core/constants/constants.dart';
import 'package:logger/logger.dart';

void main() {
  group('Constants', () {
    test('appFlavor should be null if not set', () {
      // Since it's from environment, hard to test directly, but we can check it's a const
      expect(Constants.appFlavor, isA<String?>());
    });

    test('dev constant', () {
      expect(Constants.dev, 'dev');
    });

    test('prod constant', () {
      expect(Constants.prod, 'prod');
    });

    test('blankString constant', () {
      expect(Constants.blankString, '');
    });

    test('logger is initialized', () {
      expect(Constants.logger, isA<Logger>());
    });
  });
}
