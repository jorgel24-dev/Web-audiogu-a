import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import '../widgets/boton_primario.dart';
import '../widgets/input_campo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usuarioController = TextEditingController(); 
  final TextEditingController passController = TextEditingController();

  @override
  void dispose() {
    usuarioController.dispose();
    passController.dispose();
    super.dispose();
  }

  Future<void> handleLogin(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final ok = await auth.login(
      usuarioController.text.trim(),
      passController.text.trim(),
    );
    if (ok && context.mounted) {
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

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
                texto: 'Nombre de usuario',
                controller: usuarioController, 
                icono: Icons.person_outline,
              ),
              const SizedBox(height: 14),
              InputCampo(
                texto: 'Contraseña',
                controller: passController,
                icono: Icons.lock_outline,
                password: true,
              ),

              if (auth.error != null) ...[
                const SizedBox(height: 14),
                Text(
                  auth.error!,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                ),
              ],

              const SizedBox(height: 28),

              auth.cargando
                  ? const CircularProgressIndicator(color: Color(0xFF2D6A4F))
                  : BotonPrimario(
                      texto: 'Iniciar sesión',
                      onPressed: () => handleLogin(context),
                    ),

            ],
          ),
        ),
      ),
    );
  }
}
