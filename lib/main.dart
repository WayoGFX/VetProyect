import 'package:flutter/material.dart';
import 'package:vet_smart_ids/config/router/app_router.dart';
import 'package:vet_smart_ids/core/app_theme.dart';

void
main() {
  runApp(
    const MyApp(),
  );
}

class MyApp
    extends
        StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      // importar el tema
      theme: lightTheme,
      themeMode: ThemeMode.light,
      routerConfig: appRouter, // Trabajamos con appRouter
    );
  }
}
