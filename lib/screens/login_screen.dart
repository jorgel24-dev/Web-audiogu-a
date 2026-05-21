import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import '../widgets/boton_primario.dart';
import '../widgets/input_campo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _cargando = false;
  String? _mensajeError;

  @override
  void dispose() {
    _usuarioController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    setState(() {
      _cargando = true;
      _mensajeError = null;
    });

    final resultado = await _authService.iniciarSesion(
      _usuarioController.text.trim(),
      _contrasenaController.text,
    );

    if (!mounted) return;

    switch (resultado) {
      case ResultadoLogin.exito:
        context.go('/dashboard');
      case ResultadoLogin.credencialesInvalidas:
        setState(() => _mensajeError = 'Usuario o contraseña incorrectos.');
      case ResultadoLogin.errorServidor:
        setState(() => _mensajeError = 'Error en el servidor. Inténtalo de nuevo.');
      case ResultadoLogin.errorConexion:
        setState(() => _mensajeError = 'No se pudo conectar con el servidor.');
    }

    setState(() => _cargando = false);
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
                texto: 'Usuario',
                controller: _usuarioController,
                icono: Icons.person_outline,
              ),
              const SizedBox(height: 14),
              InputCampo(
                texto: 'Contraseña',
                controller: _contrasenaController,
                icono: Icons.lock_outline,
                password: true,
              ),
              if (_mensajeError != null) ...[
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Text(
                    _mensajeError!,
                    style: TextStyle(color: Colors.red[700], fontSize: 13),
                  ),
                ),
              ],
              const SizedBox(height: 28),
              _cargando
                  ? const SizedBox(
                      height: 50,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF2D6A4F),
                          strokeWidth: 2.5,
                        ),
                      ),
                    )
                  : BotonPrimario(
                      texto: 'Iniciar sesión',
                      onPressed: _iniciarSesion,
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
