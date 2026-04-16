import 'package:go_router/go_router.dart';
import 'package:audioguia_web/screens/noticias_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/noticias',
  routes: [
    GoRoute(
      path: '/noticias',
      name: 'noticias',
      builder: (context, state) => const NoticiasPage(),
    ),
  ],
);