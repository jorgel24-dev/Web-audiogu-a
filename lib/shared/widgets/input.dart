import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  final String texto;
  final IconData icono;
  final TextEditingController controller;
  final bool password;

  const Input({
    super.key,
    required this.texto,
    required this.controller,
    required this.icono,
    this.password = false,
  });

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  bool oculto = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.password ? oculto : false,
      decoration: InputDecoration(
        hintText: widget.texto,
        filled: true,
        fillColor: const Color(0xFFF5F6F8),
        prefixIcon: Icon(widget.icono, color: Colors.grey),
        suffixIcon: widget.password
            ? IconButton(
                icon: Icon(
                  oculto ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    oculto = !oculto;
                  });
                },
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