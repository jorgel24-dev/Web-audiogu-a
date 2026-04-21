import 'package:audioguia_web/shared/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:audioguia_web/shared/widgets/boton.dart';
import 'package:audioguia_web/shared/widgets/input.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: Center(
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Bienvenido",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Inicia sesión",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 30),

              Input(
                texto: "Email",
                controller: email,
                icono: Icons.email_outlined,
              ),

              const SizedBox(height: 15),

              Input(
                texto: "Contraseña",
                controller: pass,
                icono: Icons.lock_outline,
                password: true,
              ),

              const SizedBox(height: 25),

              Boton(
                texto: "Entrar",
                onPressed: () {
                  print(email.text);
                  print(pass.text);
                },
              ),

              const SizedBox(height: 15),

              TextButton(
                onPressed: () {},
                child: const Text(
                  "¿Olvidaste la contraseña?",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}