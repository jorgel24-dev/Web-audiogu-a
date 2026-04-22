import 'package:audioguia_web/presentation/pages/agrega_monumento_page.dart';
import 'package:audioguia_web/presentation/pages/rendimiento_page.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/rendimiento',
  routes: [
    GoRoute(
      path: '/agrega_monumento',
      builder: (context, state) => const AgregaMonumento(),
    ),
    GoRoute(
      path: '/rendimiento',
      builder: (context, state) => const RendimientoPage(),
    ),
  ],
);