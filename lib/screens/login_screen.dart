import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/boton_primario.dart';
import '../widgets/input_campo.dart';

/// Pantalla de inicio de sesión del panel de administración.
/// Usa widgets compartidos [BotonPrimario] e [InputCampo]
/// y navega al dashboard tras autenticación.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void dispose() {
    // Liberamos los controllers para evitar fugas de memoria
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: Center(
        child: Container(
          width: 380,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF2D6A4F),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.travel_explore,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Martos Guía',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1C29),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Panel de Administración',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 32),
              InputCampo(
                texto: 'Correo electrónico',
                controller: _emailController,
                icono: Icons.email_outlined,
              ),
              const SizedBox(height: 14),
              InputCampo(
                texto: 'Contraseña',
                controller: _passController,
                icono: Icons.lock_outline,
                password: true,
              ),
              const SizedBox(height: 28),
              BotonPrimario(
                texto: 'Iniciar sesión',
                onPressed: () {
                  // TODO: integrar autenticación real
                  context.go('/dashboard');
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {},
                child: const Text(
                  '¿Olvidaste la contraseña?',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
