import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:audioguia_web/screens/login_screen.dart';

/// Helper que envuelve el widget en un GoRouter mínimo,
/// necesario porque LoginScreen usa context.go()
Widget _buildApp() {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const Scaffold(body: Text('Dashboard')),
      ),
    ],
  );
  return MaterialApp.router(routerConfig: router);
}

void main() {
  group('LoginScreen - UI', () {
    testWidgets('muestra el título Martos Guía', (tester) async {
      await tester.pumpWidget(_buildApp());
      expect(find.text('Martos Guía'), findsOneWidget);
    });

    testWidgets('muestra el subtítulo Panel de Administración', (tester) async {
      await tester.pumpWidget(_buildApp());
      expect(find.text('Panel de Administración'), findsOneWidget);
    });

    testWidgets('muestra el campo de correo electrónico', (tester) async {
      await tester.pumpWidget(_buildApp());
      expect(find.text('Correo electrónico'), findsOneWidget);
    });

    testWidgets('muestra el campo de contraseña', (tester) async {
      await tester.pumpWidget(_buildApp());
      expect(find.text('Contraseña'), findsOneWidget);
    });

    testWidgets('muestra el botón Iniciar sesión', (tester) async {
      await tester.pumpWidget(_buildApp());
      expect(find.text('Iniciar sesión'), findsOneWidget);
    });

    testWidgets('muestra el enlace ¿Olvidaste la contraseña?', (tester) async {
      await tester.pumpWidget(_buildApp());
      expect(find.text('¿Olvidaste la contraseña?'), findsOneWidget);
    });

    testWidgets('muestra el icono del logo', (tester) async {
      await tester.pumpWidget(_buildApp());
      expect(find.byIcon(Icons.travel_explore), findsOneWidget);
    });
  });

  group('LoginScreen - Interacción', () {
    testWidgets('se puede escribir en el campo de correo', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.enterText(find.byType(TextField).first, 'admin@martos.es');
      expect(find.text('admin@martos.es'), findsOneWidget);
    });

    testWidgets('se puede escribir en el campo de contraseña', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.enterText(find.byType(TextField).last, '123456');
      expect(find.text('123456'), findsOneWidget);
    });

    testWidgets('el botón Iniciar sesión navega al dashboard', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.tap(find.text('Iniciar sesión'));
      await tester.pumpAndSettle();
      expect(find.text('Dashboard'), findsOneWidget);
    });
  });
}