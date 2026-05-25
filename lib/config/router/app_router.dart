import 'package:go_router/go_router.dart';
import 'package:audioguia_web/presentation/screens/noticias_screen.dart';
import 'package:audioguia_web/presentation/screens/config_screen.dart';
import 'package:audioguia_web/presentation/screens/agrega_monumento_screen.dart';
import 'package:audioguia_web/presentation/screens/rendimiento_screen.dart';
import 'package:audioguia_web/presentation/screens/edita_monumento_screen.dart';

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
      path: '/monumentos/editar',
      name: 'editar_monumento',
      builder: (context, state) {
        final monumento = state.extra as String; 
        return EditaMonumentoScreen(monumentoId: monumento);
      },
    ),
  ],
);
