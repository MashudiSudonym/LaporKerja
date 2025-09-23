import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lapor_kerja/core/constants/constants.dart';
import 'package:lapor_kerja/core/utils/my_observer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum Flavors { dev, prod }

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  // Add cross-flavor configuration here

  WidgetsFlutterBinding.ensureInitialized();

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
