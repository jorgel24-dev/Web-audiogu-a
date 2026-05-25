import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:audioguia_web/providers/auth_provider.dart';
import 'package:audioguia_web/screens/login_screen.dart';
import 'package:audioguia_web/screens/dashboard_screen.dart';
import 'package:audioguia_web/screens/noticias_screen.dart';
import 'package:audioguia_web/screens/config_screen.dart';
import 'package:audioguia_web/screens/agrega_monumento_screen.dart';
import 'package:audioguia_web/screens/rendimiento_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    final auth = context.read<AuthProvider>();
    final estaEnLogin = state.matchedLocation == '/login';

    // Si no está autenticado y no está en login → manda al login
    if (!auth.autenticado && !estaEnLogin) return '/login';

    // Si está autenticado y está en login → manda al dashboard
    if (auth.autenticado && estaEnLogin) return '/dashboard';

    return null; // sin redirección
  },
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/noticias',
      name: 'noticias',
      builder: (context, state) => const NoticiasPage(),
    ),
    GoRoute(
      path: '/monumentos/agregar',
      name: 'agregar_monumento',
      builder: (context, state) => const AgregaMonumentoPage(),
    ),
    GoRoute(
      path: '/rendimiento',
      name: 'rendimiento',
      builder: (context, state) => const RendimientoPage(),
    ),
    GoRoute(
      path: '/configuracion',
      name: 'configuracion',
      builder: (context, state) => const ConfiguracionPage(),
    ),
  ],
);
