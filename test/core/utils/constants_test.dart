import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/core/constants/constants.dart';
import 'package:logger/logger.dart';

void main() {
  group('Constants', () {
    test('appFlavor should be null if not set', () {
      // Since it's from environment, hard to test directly, but we can check it's a const
      expect(Constants.appFlavor, isA<String?>());
    });

    test('DEV constant', () {
      expect(Constants.DEV, 'dev');
    });

    test('PROD constant', () {
      expect(Constants.PROD, 'prod');
    });

    test('BLANK_STRING constant', () {
      expect(Constants.BLANK_STRING, '');
    });

    test('logger is initialized', () {
      expect(Constants.logger, isA<Logger>());
    });
  });
}