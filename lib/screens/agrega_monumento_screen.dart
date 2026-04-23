import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tema_provider.dart';
import '../widgets/app_bar_principal.dart';
import '../widgets/menu_lateral.dart';
import '../widgets/label_campo.dart';

/// Formulario para añadir un nuevo monumento al sistema.
/// Integrado desde feature/dev_jl. Usa [LabelCampo] del sistema
/// compartido en lugar del antiguo método privado _buildLabel.
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
                _buildFooter(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Color(0xFFDEE2E6)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Cancelar', style: TextStyle(color: Color(0xFF495057))),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008F68),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: const Text('Guardar Monumento', style: TextStyle(color: Colors.white)),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Imagen principal
        LabelCampo(label: 'Imagen Principal'),
        const SizedBox(height: 8),
        _buildUploadBox(icon: Icons.image_outlined,
            label: 'Subir un archivo o arrastrar y soltar',
            sublabel: 'PNG, JPG, GIF hasta 10MB'),
        const SizedBox(height: 20),

        // Nombre
        LabelCampo(label: 'Nombre del Monumento'),
        const SizedBox(height: 8),
        _buildTextField(textoGuia: 'Ej: Castillo de la Peña'),
        const SizedBox(height: 20),

        // Categoría y estado
        Row(
          children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              LabelCampo(label: 'Categoría'),
              const SizedBox(height: 8),
              _buildDropdown(hint: 'Seleccionar...'),
            ])),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              LabelCampo(label: 'Estado'),
              const SizedBox(height: 8),
              _buildDropdown(hint: 'Publicado', value: 'Publicado'),
            ])),
          ],
        ),
        const SizedBox(height: 20),

        // Descripción
        LabelCampo(label: 'Descripción'),
        const SizedBox(height: 8),
        _buildTextField(
            textoGuia: 'Descripción detallada del monumento...', maxLines: 4),
        const Text('Breve historia y detalles arquitectónicos.',
            style: TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 24),

        // Archivos de audio
        LabelCampo(label: 'Archivos de Audio'),
        const SizedBox(height: 8),
        _buildUploadBox(
            icon: Icons.mic_none_outlined,
            label: 'Subir audios o notas de voz',
            sublabel: 'MP3, WAV hasta 20MB'),
        const SizedBox(height: 24),

        // Ubicación
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
              color: const Color(0xFFE9ECEF),
              borderRadius: BorderRadius.circular(8)),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.map_outlined, color: Color(0xFF6C757D), size: 30),
              SizedBox(height: 8),
              Text('Vista previa del mapa',
                  style: TextStyle(color: Color(0xFF6C757D))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({required String textoGuia, int maxLines = 1, String? prefix}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: TextFormField(
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: prefix != null
              ? Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(prefix, style: const TextStyle(color: Colors.grey)),
                )
              : null,
          hintText: textoGuia,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          filled: true,
          fillColor: const Color(0xFFF8F9FA),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFDEE2E6))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF008F68))),
        ),
      ),
    );
  }

  Widget _buildDropdown({required String hint, String? value}) {
    return DropdownButtonFormField<String>(
      items: value != null ? [DropdownMenuItem(value: value, child: Text(value))] : [],
      onChanged: (val) {},
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFDEE2E6))),
      ),
    );
  }

  Widget _buildUploadBox({required IconData icon, required String label, required String sublabel}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDEE2E6)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.grey, size: 40),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                    text: 'Subir un archivo ',
                    style: TextStyle(color: Color(0xFF008F68), fontWeight: FontWeight.bold)),
                TextSpan(
                    text: label.replaceFirst('Subir un archivo', ''),
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(sublabel, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
