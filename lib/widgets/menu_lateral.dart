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

  const MenuLateral({Key? key, required this.rutaActual}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Colors.white,
      child: Column(
        children: [
          Container(
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
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Martos Guía',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'Panel de Administración',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),
          const SizedBox(height: 8),

          ..._itemsMenu.map(
            (item) => _ItemMenuLateral(
              icon: item.icon,
              label: item.label,
              seleccionado: rutaActual == item.ruta,
              onTap: () => context.go(item.ruta),
            ),
          ),

          const Spacer(),

          const Divider(height: 1),
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
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Administrador',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'admin@martosguia.com',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.logout, size: 16, color: Colors.grey[400]),
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

  const _ItemMenuLateral({
    required this.icon,
    required this.label,
    required this.seleccionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        size: 18,
        color: seleccionado ? const Color(0xFF2D6A4F) : Colors.grey[600],
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: seleccionado ? FontWeight.w600 : FontWeight.normal,
          color: seleccionado ? const Color(0xFF2D6A4F) : Colors.grey[800],
        ),
      ),
      selected: seleccionado,
      selectedTileColor: const Color(0xFF2D6A4F).withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      dense: true,
      onTap: onTap,
    );
  }
}
