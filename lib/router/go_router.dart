import 'package:go_router/go_router.dart';
import 'package:audioguia_web/pages/noticias_page.dart';

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