import 'package:flutter/material.dart';

class AgregaMonumento extends StatefulWidget {
  const AgregaMonumento({super.key});

  @override
  State<AgregaMonumento> createState() => _AddMonumentPageState();
}

class _AddMonumentPageState extends State<AgregaMonumento> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Añadir Nuevo Monumento',
          style: TextStyle(color: Color(0xFF1A1C29), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Imagen Principal'),
            _buildUploadBox(
              icon: Icons.image_outlined,
              label: 'Subir un archivo o arrastrar y soltar',
              sublabel: 'PNG, JPG, GIF hasta 10MB',
            ),
            const SizedBox(height: 20),
            
            _buildLabel('Nombre del Monumento'),
            _buildTextField(hint: 'Ej: Castillo de la Peña'),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Categoría'),
                      _buildDropdown(hint: 'Seleccionar...'),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Estado'),
                      _buildDropdown(hint: 'Publicado', value: 'Publicado'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildLabel('Descripción'),
            _buildTextField(hint: 'Descripción detallada del monumento...', maxLines: 4),
            const Text(
              'Breve historia y detalles arquitectónicos.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 24),

            // --- SECCIÓN DE AUDIOS ---
            _buildLabel('Archivos de Audio'),
            _buildUploadBox(
              icon: Icons.mic_none_outlined,
              label: 'Subir audios o notas de voz',
              sublabel: 'MP3, WAV hasta 20MB',
            ),
            const SizedBox(height: 24),

            _buildLabel('Ubicación'),
            Row(
              children: [
                Expanded(child: _buildTextField(hint: '37.7214', prefix: 'Lat')),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField(hint: '-4.0321', prefix: 'Lon')),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE9ECEF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map_outlined, color: Color(0xFF6C757D), size: 30),
                  SizedBox(height: 8),
                  Text('Vista previa del mapa', style: TextStyle(color: Color(0xFF6C757D))),
                ],
              ),
            ),
            const SizedBox(height: 80), // Espacio para el footer
          ],
        ),
      ),
      bottomNavigationBar: _buildFooter(),
    );
  }

  // --- WIDGETS DE SOPORTE PARA EL DISEÑO ---
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF343A40)),
      ),
    );
  }

  Widget _buildTextField({required String hint, int maxLines = 1, String? prefix}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: TextFormField(
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: prefix != null ? Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(prefix, style: const TextStyle(color: Colors.grey)),
          ) : null,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          filled: true,
          fillColor: const Color(0xFFF8F9FA),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFDEE2E6)),
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
          borderSide: const BorderSide(color: Color(0xFFDEE2E6)),
        ),
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
        border: Border.all(color: const Color(0xFFDEE2E6), style: BorderStyle.solid), // Simula el dashed
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.grey, size: 40),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(text: 'Subir un archivo ', style: TextStyle(color: Color(0xFF008F68), fontWeight: FontWeight.bold)),
                TextSpan(text: label.replaceFirst('Subir un archivo', ''), style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(sublabel, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1F3F5))),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
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