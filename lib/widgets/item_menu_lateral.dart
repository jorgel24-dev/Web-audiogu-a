import 'package:flutter/material.dart';

/// Ítem individual del menú lateral de navegación.
/// Reemplaza tanto a [BarraLateral] (feature/dashboard) como a la
/// antigua clase privada _ItemMenuLateral de menu_lateral.dart.
class ItemMenuLateral extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool seleccionado;
  final VoidCallback onTap;
  final bool isDarkMode;

  const ItemMenuLateral({
    super.key,
    required this.icon,
    required this.label,
    required this.seleccionado,
    required this.onTap,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF2D6A4F);
    final inactiveIconColor =
        isDarkMode ? Colors.grey[500] : Colors.grey[600];
    final inactiveTextColor =
        isDarkMode ? Colors.grey[300] : Colors.grey[800];

    return ListTile(
      leading: Icon(
        icon,
        size: 18,
        color: seleccionado ? activeColor : inactiveIconColor,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight:
              seleccionado ? FontWeight.w600 : FontWeight.normal,
          color: seleccionado ? activeColor : inactiveTextColor,
        ),
      ),
      selected: seleccionado,
      selectedTileColor: activeColor.withValues(
        alpha: isDarkMode ? 0.15 : 0.08,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      dense: true,
      onTap: onTap,
    );
  }
}
