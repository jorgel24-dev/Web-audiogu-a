import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/tema_provider.dart';
import '../widgets/app_bar_principal.dart';
import '../widgets/menu_lateral.dart';
import '../widgets/label_campo.dart';

class AgregaMonumentoPage extends StatelessWidget {
  const AgregaMonumentoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<TemaProvider>().isDarkMode;
    final dividerColor = isDarkMode ? Colors.white12 : Colors.grey[200]!;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBarPrincipal(
        isDarkMode: isDarkMode,
        onToggleDarkMode: () => context.read<TemaProvider>().toggleDarkMode(),
        icono: Icons.account_balance_outlined,
        titulo: 'Añadir Nuevo Monumento',
      ),
      body: Row(
        children: [
          MenuLateral(rutaActual: '/monumentos/agregar', isDarkMode: isDarkMode),
          VerticalDivider(width: 1, color: dividerColor),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: _FormularioMonumento(isDarkMode: isDarkMode),
                  ),
                ),
                _buildFooter(context, isDarkMode),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isDarkMode) {
    final footerBg = isDarkMode ? const Color(0xFF1E2A3A) : Colors.white;
    final footerBorder = isDarkMode ? Colors.white12 : Colors.grey[200]!;
    final cancelTextColor = isDarkMode ? Colors.grey[300]! : const Color(0xFF495057);
    final cancelBorderColor = isDarkMode ? Colors.white24 : const Color(0xFFDEE2E6);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: footerBg,
        border: Border(top: BorderSide(color: footerBorder)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => context.go('/dashboard'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: cancelBorderColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Cancelar', style: TextStyle(color: cancelTextColor)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008F68),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Guardar Monumento',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormularioMonumento extends StatelessWidget {
  final bool isDarkMode;
  const _FormularioMonumento({required this.isDarkMode});

  Color get _fieldFill => isDarkMode ? const Color(0xFF1E2A3A) : const Color(0xFFF8F9FA);
  Color get _fieldBorder => isDarkMode ? Colors.white24 : const Color(0xFFDEE2E6);
  Color get _uploadBoxBg => isDarkMode ? const Color(0xFF1E2A3A) : Colors.white;
  Color get _mapBg => isDarkMode ? const Color(0xFF263040) : const Color(0xFFE9ECEF);
  Color get _mapIconColor => isDarkMode ? Colors.grey[500]! : const Color(0xFF6C757D);
  Color get _hintColor => isDarkMode ? Colors.grey[500]! : Colors.grey;
  Color get _subtextColor => isDarkMode ? Colors.grey[500]! : Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelCampo(label: 'Imagen Principal'),
        const SizedBox(height: 8),
        _buildUploadBox(
          icon: Icons.image_outlined,
          label: 'Subir un archivo o arrastrar y soltar',
          sublabel: 'PNG, JPG, GIF hasta 10MB',
        ),
        const SizedBox(height: 20),

        LabelCampo(label: 'Nombre del Monumento'),
        const SizedBox(height: 8),
        _buildTextField(textoGuia: 'Ej: Castillo de la Peña'),
        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelCampo(label: 'Categoría'),
                  const SizedBox(height: 8),
                  _buildDropdown(hint: 'Seleccionar...'),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelCampo(label: 'Estado'),
                  const SizedBox(height: 8),
                  _buildDropdown(hint: 'Publicado', value: 'Publicado'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        LabelCampo(label: 'Descripción'),
        const SizedBox(height: 8),
        _buildTextField(
          textoGuia: 'Descripción detallada del monumento...',
          maxLines: 4,
        ),
        Text(
          'Breve historia y detalles arquitectónicos.',
          style: TextStyle(color: _subtextColor, fontSize: 12),
        ),
        const SizedBox(height: 24),

        LabelCampo(label: 'Archivos de Audio'),
        const SizedBox(height: 8),
        _buildUploadBox(
          icon: Icons.mic_none_outlined,
          label: 'Subir audios o notas de voz',
          sublabel: 'MP3, WAV hasta 20MB',
        ),
        const SizedBox(height: 24),

        LabelCampo(label: 'Ubicación'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildTextField(textoGuia: '37.7214', prefix: 'Lat')),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField(textoGuia: '-4.0321', prefix: 'Lon')),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: _mapBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.map_outlined, color: _mapIconColor, size: 30),
              const SizedBox(height: 8),
              Text(
                'Vista previa del mapa',
                style: TextStyle(color: _mapIconColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String textoGuia,
    int maxLines = 1,
    String? prefix,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: TextFormField(
        maxLines: maxLines,
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
        decoration: InputDecoration(
          prefixIcon: prefix != null
              ? Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    prefix,
                    style: TextStyle(color: _hintColor),
                  ),
                )
              : null,
          hintText: textoGuia,
          hintStyle: TextStyle(color: _hintColor, fontSize: 14),
          filled: true,
          fillColor: _fieldFill,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: _fieldBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF008F68)),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({required String hint, String? value}) {
    return DropdownButtonFormField<String>(
      dropdownColor: isDarkMode ? const Color(0xFF1E2A3A) : Colors.white,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
      items: value != null
          ? [DropdownMenuItem(value: value, child: Text(value))]
          : [
              'Castillo',
              'Iglesia',
              'Plaza',
              'Monumento',
              'Museo',
              'Parque',
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: (val) {},
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: _hintColor, fontSize: 14),
        filled: true,
        fillColor: _fieldFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _fieldBorder),
        ),
      ),
    );
  }

  Widget _buildUploadBox({
    required IconData icon,
    required String label,
    required String sublabel,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: _uploadBoxBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _fieldBorder),
      ),
      child: Column(
        children: [
          Icon(icon, color: _hintColor, size: 40),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'Subir un archivo ',
                  style: TextStyle(
                    color: Color(0xFF008F68),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: label.replaceFirst('Subir un archivo', ''),
                  style: TextStyle(color: _hintColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(sublabel, style: TextStyle(color: _subtextColor, fontSize: 12)),
        ],
      ),
    );
  }
}