// ============================================================================
//  main.dart
//  Punto de entrada de la aplicación "Artesanías Andinas"
//
//  SIS048 – Desarrollo de Software II | Unidad II
//  Universidad Andina del Cusco
//
//  CONCEPTO CLAVE: Aquí se inicializa el contenedor de IoC (get_it) ANTES
//  de lanzar la UI, garantizando que todas las dependencias estén disponibles.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/di/injection_container.dart' as di;
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

void main() async {
  // 1. Asegurar que Flutter esté listo antes de inicializar plugins/BD
  WidgetsFlutterBinding.ensureInitialized();

  // 2. ── INVERSIÓN DE CONTROL ──────────────────────────────────────────────
  //    Registrar TODAS las dependencias en el contenedor get_it.
  //    Desde este momento, cualquier parte de la app puede obtener
  //    instancias sin crearlas manualmente.
  await di.init();

  // 3. Lanzar la app envuelta en ProviderScope (Riverpod)
  runApp(
    const ProviderScope(
      child: ArtesaniasApp(),
    ),
  );
}

class ArtesaniasApp extends StatelessWidget {
  const ArtesaniasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Artesanías Andinas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
