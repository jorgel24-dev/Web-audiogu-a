import 'package:flutter/material.dart';

/// Campo de texto reutilizable con icono prefijo y soporte opcional
/// para ocultar/mostrar contraseña. Originalmente de feature/login.
class InputCampo extends StatefulWidget {
  final String texto;
  final IconData icono;
  final TextEditingController controller;
  final bool password;

  const InputCampo({
    super.key,
    required this.texto,
    required this.controller,
    required this.icono,
    this.password = false,
  });

  @override
  State<InputCampo> createState() => _InputCampoState();
}

class _InputCampoState extends State<InputCampo> {
  bool _oculto = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.password ? _oculto : false,
      decoration: InputDecoration(
        hintText: widget.texto,
        filled: true,
        fillColor: const Color(0xFFF5F6F8),
        prefixIcon: Icon(widget.icono, color: Colors.grey),
        suffixIcon: widget.password
            ? IconButton(
                icon: Icon(
                  _oculto ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () => setState(() => _oculto = !_oculto),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
