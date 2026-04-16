import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class _ItemMenu {
  final IconData icon;
  final String label;
  final String ruta;

  const _ItemMenu({
    required this.icon,
    required this.label,
    required this.ruta,
  });
}

const _itemsMenu = [
  _ItemMenu(icon: Icons.grid_view,       label: 'Panel Principal', ruta: '/'),
  _ItemMenu(icon: Icons.account_balance, label: 'Monumentos',      ruta: '/monumentos'),
  _ItemMenu(icon: Icons.article,         label: 'Noticias',        ruta: '/noticias'),
  _ItemMenu(icon: Icons.settings,        label: 'Configuración',   ruta: '/configuracion'),
];

class MenuLateral extends StatelessWidget {
  final String rutaActual;
  final bool isDarkMode;

  const MenuLateral({
    Key? key,
    required this.rutaActual,
    this.isDarkMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final dividerColor = isDarkMode ? Colors.white12 : Colors.grey[200]!;
    final titleColor = isDarkMode ? Colors.white : Colors.black87;
    final subColor = isDarkMode ? Colors.grey[500]! : Colors.grey;
    final logoutColor = isDarkMode ? Colors.grey[600]! : Colors.grey[400]!;

    return Container(
      width: 200,
      color: bgColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D6A4F),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.travel_explore,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Martos Guía',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: titleColor,
                      ),
                    ),
                    Text(
                      'Panel de Administración',
                      style: TextStyle(fontSize: 10, color: subColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 1, color: dividerColor),
          const SizedBox(height: 8),
          ..._itemsMenu.map(
            (item) => _ItemMenuLateral(
              icon: item.icon,
              label: item.label,
              seleccionado: rutaActual == item.ruta,
              onTap: () => context.go(item.ruta),
              isDarkMode: isDarkMode,
            ),
          ),
          const Spacer(),
          Divider(height: 1, color: dividerColor),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFF2D6A4F),
                  child: Text(
                    'A',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Administrador',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: titleColor,
                        ),
                      ),
                      Text(
                        'admin@martosguia.com',
                        style: TextStyle(fontSize: 10, color: subColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.logout, size: 16, color: logoutColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemMenuLateral extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool seleccionado;
  final VoidCallback onTap;
  final bool isDarkMode;

  const _ItemMenuLateral({
    required this.icon,
    required this.label,
    required this.seleccionado,
    required this.onTap,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF2D6A4F);
    final inactiveIconColor = isDarkMode ? Colors.grey[500] : Colors.grey[600];
    final inactiveTextColor = isDarkMode ? Colors.grey[300] : Colors.grey[800];

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
          fontWeight: seleccionado ? FontWeight.w600 : FontWeight.normal,
          color: seleccionado ? activeColor : inactiveTextColor,
        ),
      ),
      selected: seleccionado,
      selectedTileColor: activeColor.withValues(
        alpha: isDarkMode ? 0.15 : 0.08,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      dense: true,
      onTap: onTap,
    );
  }
}
