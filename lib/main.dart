import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet_smart_ids/config/router/app_router.dart';
import 'package:vet_smart_ids/core/app_theme.dart';

// Importar providers
import 'package:vet_smart_ids/providers/usuario_provider.dart';
import 'package:vet_smart_ids/providers/veterinario_provider.dart';
import 'package:vet_smart_ids/providers/mascota_provider.dart';
import 'package:vet_smart_ids/providers/cita_provider.dart';
import 'package:vet_smart_ids/providers/historial_medico_provider.dart';
import 'package:vet_smart_ids/providers/estadisticas_provider.dart';
import 'package:vet_smart_ids/providers/alertas_provider.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => UsuarioProvider(),
        ),
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => VeterinarioProvider(),
        ),
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => MascotaProvider(),
        ),
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => CitaProvider(),
        ),
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => HistorialMedicoProvider(),
        ),
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => EstadisticasProvider(),
        ),
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => AlertasProvider(),
        ),
      ],
      child: MaterialApp.router(
        title: 'VetSmart IDS',
        theme: lightTheme,
        themeMode: ThemeMode.light,
        routerConfig: appRouter,
      ),
    );
  }
}
