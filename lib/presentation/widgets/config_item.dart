import 'package:flutter/material.dart';

class ConfigItem extends StatelessWidget {
  final bool isDarkMode;
  final Color color;
  final IconData icono;
  final String titulo;
  final String descripcion;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ConfigItem({
    super.key,
    required this.isDarkMode,
    required this.color,
    required this.icono,
    required this.titulo,
    required this.descripcion,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDarkMode ? Colors.white : Colors.black87;
    final descColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(icono, size: 20, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  descripcion,
                  style: TextStyle(fontSize: 12, color: descColor),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF2D6A4F),
          ),
        ],
      ),
    );
  }
}
