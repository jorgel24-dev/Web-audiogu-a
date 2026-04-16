import 'package:flutter/material.dart';

class BarraLateral extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final bool estaSeleccionado;
  final VoidCallback alPulsar;
  final bool isDarkMode;

  const BarraLateral({
    super.key,
    required this.icono,
    required this.titulo,
    this.estaSeleccionado = false,
    required this.alPulsar,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final selectedBg = isDarkMode
        ? const Color(0xFF00796B).withValues(alpha: 0.18)
        : const Color(0xFFE8F5E9);
    final selectedColor =
        isDarkMode ? const Color(0xFF4DB6AC) : const Color(0xFF2E7D32);
    final normalColor = isDarkMode ? Colors.grey[500] : Colors.grey[600];
    final textColor = isDarkMode ? Colors.grey[300] : Colors.black87;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      decoration: BoxDecoration(
        color: estaSeleccionado ? selectedBg : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          icono,
          color: estaSeleccionado ? selectedColor : normalColor,
          size: 20,
        ),
        title: Text(
          titulo,
          style: TextStyle(
            color: estaSeleccionado ? selectedColor : textColor,
            fontWeight:
                estaSeleccionado ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        onTap: alPulsar,
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
