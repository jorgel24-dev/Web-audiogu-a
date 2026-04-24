import 'package:audioguia_web/screens/agrega_monumento_page.dart';
import 'package:audioguia_web/screens/rendimiento_page.dart';
import 'package:go_router/go_router.dart';
import 'package:audioguia_web/screens/dashboard_screen.dart';
import 'package:audioguia_web/screens/noticias_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/noticias',
      name: 'noticias',
      builder: (context, state) => const NoticiasPage(),
    ),
    GoRoute(
      path: '/rendimiento',
      name: 'rendimiento',
      builder: (context, state) => const RendimientoPage(),
    ),
    GoRoute(
      path: '/agrega_monumentos',
      name: 'agrega monumentos',
      builder: (context, state) => const AgregaMonumento(),
    ),
  ],
);