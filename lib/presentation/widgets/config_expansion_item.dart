import 'package:flutter/material.dart';

class ConfigExpansionItem extends StatelessWidget {
  final bool isDarkMode;
  final Color color;
  final IconData icono;
  final String titulo;
  final String descripcion;
  final bool value;
  final ValueChanged<bool> onChanged;
  final List<Widget> children;

  const ConfigExpansionItem({
    super.key,
    required this.isDarkMode,
    required this.color,
    required this.icono,
    required this.titulo,
    required this.descripcion,
    required this.value,
    required this.onChanged,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDarkMode ? Colors.white : Colors.black87;
    final descColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Row(
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
          ],
        ),
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.white.withValues(alpha: 0.02)
                  : Colors.black.withValues(alpha: 0.02),
              border: Border(
                top: BorderSide(
                  color: isDarkMode ? Colors.white10 : Colors.black12,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(
                    'Activar $titulo',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                      fontSize: 13,
                    ),
                  ),
                  subtitle: Text(
                    'Habilita o deshabilita este módulo por completo en la app',
                    style: TextStyle(fontSize: 11, color: descColor),
                  ),
                  value: value,
                  onChanged: onChanged,
                  activeThumbColor: color,
                  contentPadding: const EdgeInsets.only(left: 70, right: 24),
                ),
                Divider(
                  height: 1,
                  indent: 70,
                  color: isDarkMode ? Colors.white10 : Colors.black12,
                ),
                if (children.isNotEmpty)
                  ...children
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange[400],
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'No se han podido cargar los elementos desde el servidor. Comprueba la conexión o la configuración.',
                            style: TextStyle(
                              color: isDarkMode
                                  ? Colors.white70
                                  : Colors.black54,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
