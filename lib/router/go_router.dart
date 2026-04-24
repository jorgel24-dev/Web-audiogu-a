import 'package:audioguia_web/presentation/screens/crear_noticia_screen.dart';
import 'package:go_router/go_router.dart';


final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const PantallaPrincipal(),
    ),
  ],
);