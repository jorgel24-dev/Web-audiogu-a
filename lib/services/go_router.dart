import 'package:go_router/go_router.dart';
import 'package:audioguia_web/screens/login_screen.dart';
import 'package:audioguia_web/screens/dashboard_screen.dart';
import 'package:audioguia_web/screens/noticias_screen.dart';
import 'package:audioguia_web/screens/config_screen.dart';
import 'package:audioguia_web/screens/agrega_monumento_screen.dart';
import 'package:audioguia_web/screens/rendimiento_screen.dart';

/// Configuración de rutas de la aplicación.
/// Ruta inicial: /login → LoginScreen
final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    // Autenticación
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => LoginScreen(),
    ),

    // Panel principal
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),

    // Editor de noticias
    GoRoute(
      path: '/noticias',
      name: 'noticias',
      builder: (context, state) => const NoticiasPage(),
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

    // Configuración de módulos
    GoRoute(
      path: '/configuracion',
      name: 'configuracion',
      builder: (context, state) => const ConfiguracionPage(),
    ),
  ],
);