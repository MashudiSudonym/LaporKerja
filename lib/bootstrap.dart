import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lapor_kerja/core/constants/constants.dart';
import 'package:lapor_kerja/core/utils/my_observer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum Flavors { dev, prod }

Future<void> _requestPermissions() async {
  // Request notification permission for background sync
  await Permission.notification.request();

  // Request ignore battery optimizations for background tasks
  await Permission.ignoreBatteryOptimizations.request();
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  // Add cross-flavor configuration here

  WidgetsFlutterBinding.ensureInitialized();

  // Request permissions
  await _requestPermissions();

  // init basic configuration
  switch (Constants.appFlavor) {
    case Constants.DEV:
      await dotenv.load(fileName: "assets/${Constants.DEV}/.env");
    case Constants.PROD:
      await dotenv.load(fileName: "assets/${Constants.PROD}/.env");
    default:
      await dotenv.load(fileName: "assets/${Constants.DEV}/.env");
  }

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(ProviderScope(observers: [MyObserver()], child: await builder()));
}
