import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:audioguia_web/screens/login_screen.dart';
import 'package:audioguia_web/screens/dashboard_screen.dart';
import 'package:audioguia_web/screens/noticias_screen.dart';
import 'package:audioguia_web/screens/config_screen.dart';
import 'package:audioguia_web/screens/agrega_monumento_screen.dart';
import 'package:audioguia_web/screens/rendimiento_screen.dart';
import 'package:audioguia_web/providers/noticias_provider.dart';
import 'package:audioguia_web/providers/config_provider.dart';

/// Configuración de rutas de la aplicación.
/// Ruta inicial: /login → LoginScreen
final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    // Autenticación
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),

    // Panel principal
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),

    // Editor de noticias — carga las noticias del backend al entrar
    GoRoute(
      path: '/noticias',
      name: 'noticias',
      builder: (context, state) {
        // Capturamos el provider antes de cualquier gap asíncrono
        final noticiasProvider =
            Provider.of<NoticiasProvider>(context, listen: false);
        WidgetsBinding.instance
            .addPostFrameCallback((_) => noticiasProvider.cargarNoticias());
        return const NoticiasPage();
      },
    ),

    // Gestión de monumentos
    GoRoute(
      path: '/monumentos/agregar',
      name: 'agregar_monumento',
      builder: (context, state) => const AgregaMonumentoPage(),
    ),

    // Analítica y rendimiento
    GoRoute(
      path: '/rendimiento',
      name: 'rendimiento',
      builder: (context, state) => const RendimientoPage(),
    ),

    // Configuración — carga los controles del backend al entrar
    GoRoute(
      path: '/configuracion',
      name: 'configuracion',
      builder: (context, state) {
        // Capturamos el provider antes de cualquier gap asíncrono
        final configProvider =
            Provider.of<ConfiguracionProvider>(context, listen: false);
        WidgetsBinding.instance
            .addPostFrameCallback((_) => configProvider.cargarConfiguracion());
        return const ConfiguracionPage();
      },
    ),
  ],
);