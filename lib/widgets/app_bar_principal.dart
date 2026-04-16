import 'package:flutter/material.dart';

class AppBarPrincipal extends StatelessWidget implements PreferredSizeWidget {
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;
  final IconData icono;
  final String? titulo;
  final List<Widget> acciones;

  const AppBarPrincipal({
    Key? key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
    required this.icono,
    this.titulo,
    this.acciones = const [],
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final cardColor = isDarkMode ? const Color(0xFF1E2A3A) : Colors.white;
    final iconColor = isDarkMode ? Colors.grey[400]! : Colors.grey[700]!;

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: cardColor,
        border: Border(
          bottom: BorderSide(
            color: isDarkMode ? Colors.white10 : Colors.grey[200]!,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(icono, size: 20, color: const Color(0xFF2D6A4F)),
          if (titulo != null && titulo!.isNotEmpty) ...[
            const SizedBox(width: 8),
            Text(
              titulo!,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ],
          const Spacer(),
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              size: 20,
              color: iconColor,
            ),
            onPressed: onToggleDarkMode,
            tooltip: isDarkMode ? 'Modo claro' : 'Modo oscuro',
          ),
          ...acciones,
        ],
      ),
    );
  }
}
