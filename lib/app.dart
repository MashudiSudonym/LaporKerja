import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lapor_kerja/presentation/providers/router/router_provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ShadApp.custom(
      themeMode: ThemeMode.system,
      theme: ShadThemeData(
        brightness: Brightness.light,
        colorScheme: ShadOrangeColorScheme.light(),
      ),
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: ShadOrangeColorScheme.dark(),
      ),
      appBuilder: (context) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: Theme.of(context),
          routeInformationParser: ref.watch(routerProvider).routeInformationParser,
          routeInformationProvider: ref.watch(routerProvider).routeInformationProvider,
          routerDelegate: ref.watch(routerProvider).routerDelegate,
          builder: (context, child) {
            return ShadAppBuilder(child: child!);
          },
        );
      },
    );
  }
}
