import 'package:flutter/material.dart';

class EditorToolbar extends StatelessWidget {
  const EditorToolbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          _ToolbarButton(
            icon: Icons.format_bold,
            tooltip: 'Negrita',
            onPressed: () {},
          ),
          _ToolbarButton(
            icon: Icons.format_italic,
            tooltip: 'Cursiva',
            onPressed: () {},
          ),
          _ToolbarButton(
            icon: Icons.format_underline,
            tooltip: 'Subrayado',
            onPressed: () {},
          ),
          const _Separador(),
          _ToolbarButton(
            icon: Icons.format_align_left,
            tooltip: 'Alinear izquierda',
            onPressed: () {},
          ),
          _ToolbarButton(
            icon: Icons.format_align_center,
            tooltip: 'Centrar',
            onPressed: () {},
          ),
          _ToolbarButton(
            icon: Icons.format_align_right,
            tooltip: 'Alinear derecha',
            onPressed: () {},
          ),
          const _Separador(),
          _ToolbarButton(
            icon: Icons.format_list_bulleted,
            tooltip: 'Lista',
            onPressed: () {},
          ),
          _ToolbarButton(
            icon: Icons.format_list_numbered,
            tooltip: 'Lista numerada',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _ToolbarButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, size: 18),
        onPressed: onPressed,
        visualDensity: VisualDensity.compact,
        color: Colors.grey[700],
        splashRadius: 16,
      ),
    );
  }
}

class _Separador extends StatelessWidget {
  const _Separador();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 1,
      color: Colors.grey[300],
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}
