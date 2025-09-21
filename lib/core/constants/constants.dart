import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class Constants {
  // App Flavors
  static const String? appFlavor =
      String.fromEnvironment('FLUTTER_APP_FLAVOR') != ''
      ? String.fromEnvironment('FLUTTER_APP_FLAVOR')
      : null;
  static const DEV = 'dev';
  static const PROD = 'prod';

  // logger
  static final logger = Logger(level: _getLogLevel());

  // others
  static const BLANK_STRING = '';

  static Level _getLogLevel() {
    // In test environment, only show warnings and errors
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return Level.warning;
    }
    // In debug mode, show all logs
    if (kDebugMode) {
      return Level.debug;
    }
    // In release mode, only show warnings and errors
    return Level.warning;
  }
}
