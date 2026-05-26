import 'package:flutter/material.dart';

class ChipFiltro extends StatelessWidget {
  final String label;
  final String valor;
  final String filtroActivo;
  final VoidCallback onSelected;

  const ChipFiltro({
    super.key,
    required this.label,
    required this.valor,
    required this.filtroActivo,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final estaActivo = filtroActivo == valor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ChoiceChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      selected: estaActivo,
      onSelected: (_) => onSelected(),
      selectedColor: const Color(0xFF2D6A4F),
      labelStyle: TextStyle(
        color: estaActivo
            ? Colors.white
            : (isDark ? Colors.grey[300] : Colors.grey[700]),
        fontWeight: estaActivo ? FontWeight.w600 : FontWeight.normal,
      ),
      backgroundColor: isDark ? const Color(0xFF263040) : Colors.grey[100],
      padding: const EdgeInsets.symmetric(horizontal: 8),
      visualDensity: VisualDensity.compact,
    );
  }
}
