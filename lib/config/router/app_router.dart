import 'package:go_router/go_router.dart';
import 'package:audioguia_web/presentation/screens/noticias_screen.dart';
import 'package:audioguia_web/presentation/screens/config_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/noticias',
  routes: [
    GoRoute(
      path: '/noticias',
      name: 'noticias',
      builder: (context, state) => const NoticiasPage(),
    ),
    GoRoute(
      path: '/configuracion',
      name: 'configuracion',
      builder: (context, state) => const ConfiguracionPage(),
    ),
  ],
);
