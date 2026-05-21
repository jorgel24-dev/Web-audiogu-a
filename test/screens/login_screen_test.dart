import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:audioguia_web/screens/login_screen.dart';

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

    testWidgets('muestra el campo de usuario', (tester) async {
      await tester.pumpWidget(_buildApp());
      expect(find.text('Usuario'), findsOneWidget);
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
    testWidgets('se puede escribir en el campo de usuario', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.enterText(find.byType(TextField).first, 'admin');
      expect(find.text('admin'), findsOneWidget);
    });

    testWidgets('se puede escribir en el campo de contraseña', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.enterText(find.byType(TextField).last, 'admin123');
      expect(find.text('admin123'), findsOneWidget);
    });

    testWidgets('credenciales incorrectas muestran mensaje de error', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.enterText(find.byType(TextField).first, 'usuario_incorrecto');
      await tester.enterText(find.byType(TextField).last, 'contrasena_incorrecta');
      await tester.tap(find.text('Iniciar sesión'));
      await tester.pumpAndSettle();
      expect(find.text('Usuario o contraseña incorrectos.'), findsOneWidget);
    });
  });
}