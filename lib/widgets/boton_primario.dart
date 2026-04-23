import 'package:flutter/material.dart';

/// Botón primario reutilizable con estilo consistente en toda la app.
/// Ocupa todo el ancho disponible. Originalmente de feature/login.
class BotonPrimario extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;

  const BotonPrimario({
    super.key,
    required this.texto,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2D6A4F),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          texto,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
