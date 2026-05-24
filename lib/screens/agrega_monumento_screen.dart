import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/tema_provider.dart';
import '../providers/monumentos_provider.dart';
import '../models/monumento_model.dart';      
import '../widgets/app_bar_principal.dart';
import '../widgets/menu_lateral.dart';
import '../widgets/label_campo.dart';

class AgregaMonumentoPage extends StatefulWidget {
  const AgregaMonumentoPage({super.key});

  @override
  State<AgregaMonumentoPage> createState() => _AgregaMonumentoPageState();
}

class _AgregaMonumentoPageState extends State<AgregaMonumentoPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores de texto persistentes en el Estado
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _latController = TextEditingController();
  final _lonController = TextEditingController();

  // Estados de los Selectores desplegables
  String _categoriaSeleccionada = 'Monumentos Históricos';
  String _estadoSeleccionado = 'Publicado';

  @override
  void dispose() {
    // Evitamos fugas de memoria limpiando los controladores
    _nombreController.dispose();
    _descripcionController.dispose();
    _latController.dispose();
    _lonController.dispose();
    super.dispose();
  }

  Future<void> _ejecutarGuardado() async {
    // Validación segura sin lanzar excepciones controlando el nulo
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final double lat = double.tryParse(_latController.text) ?? 37.7214;
    final double lon = double.tryParse(_lonController.text) ?? -4.0321;

    // Estructuramos el modelo con los datos recolectados
    final nuevoMonumento = Monumento(
      nombre: _nombreController.text,
      descripcion: _descripcionController.text,
      categoria: _categoriaSeleccionada,
      estado: _estadoSeleccionado,
      latitud: lat,
      longitud: lon,
    );

    // Despachamos la petición HTTP mediante el Provider de monumentos
    final monumentosProv = context.read<MonumentosProvider>();
    final exito = await monumentosProv.guardarMonumento(nuevoMonumento);

    if (mounted) {
      if (exito) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Monumento guardado correctamente'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✗ Error al guardar el monumento en el servidor'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<TemaProvider>().isDarkMode;
    final monumentosProv = context.watch<MonumentosProvider>();
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
            child: Form(
              key: _formKey, // Asignación de la llave global al Formulario contenedor
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: _FormularioMonumento(
                        isDarkMode: isDarkMode,
                        nombreController: _nombreController,
                        descripcionController: _descripcionController,
                        latController: _latController,
                        lonController: _lonController,
                        categoria: _categoriaSeleccionada,
                        estado: _estadoSeleccionado,
                        onCategoriaChanged: (val) {
                          if (val != null) setState(() => _categoriaSeleccionada = val);
                        },
                        onEstadoChanged: (val) {
                          if (val != null) setState(() => _estadoSeleccionado = val);
                        },
                      ),
                    ),
                  ),
                  _buildFooter(context, isDarkMode, monumentosProv.isSaving),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isDarkMode, bool isSaving) {
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
              onPressed: isSaving ? null : () => context.go('/dashboard'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: cancelBorderColor),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Cancelar', style: TextStyle(color: cancelTextColor)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: isSaving ? null : _ejecutarGuardado,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008F68),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Guardar Monumento', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormularioMonumento extends StatelessWidget {
  final bool isDarkMode;
  final TextEditingController nombreController;
  final TextEditingController descripcionController;
  final TextEditingController latController;
  final TextEditingController lonController;
  final String categoria;
  final String estado;
  final ValueChanged<String?> onCategoriaChanged;
  final ValueChanged<String?> onEstadoChanged;

  const _FormularioMonumento({
    required this.isDarkMode,
    required this.nombreController,
    required this.descripcionController,
    required this.latController,
    required this.lonController,
    required this.categoria,
    required this.estado,
    required this.onCategoriaChanged,
    required this.onEstadoChanged,
  });

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
        const LabelCampo(label: 'Imagen Principal'),
        const SizedBox(height: 8),
        _buildUploadBox(
          icon: Icons.image_outlined,
          label: 'Subir un archivo o arrastrar y soltar',
          sublabel: 'PNG, JPG, GIF hasta 10MB',
        ),
        const SizedBox(height: 20),

        const LabelCampo(label: 'Nombre del Monumento'),
        const SizedBox(height: 8),
        _buildTextField(textoGuia: 'Ej: Castillo de la Peña', controller: nombreController),
        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LabelCampo(label: 'Categoría'),
                  const SizedBox(height: 8),
                  _buildDropdown(
                    value: categoria,
                    items: ['Monumentos Históricos', 'Iglesias', 'Fuentes', 'Parques'],
                    onChanged: onCategoriaChanged,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LabelCampo(label: 'Estado'),
                  const SizedBox(height: 8),
                  _buildDropdown(
                    value: estado,
                    items: ['Publicado', 'Borrador', 'Archivado'],
                    onChanged: onEstadoChanged,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        const LabelCampo(label: 'Descripción'),
        const SizedBox(height: 8),
        _buildTextField(
          textoGuia: 'Descripción detallada del monumento...',
          maxLines: 4,
          controller: descripcionController,
        ),
        Text('Breve historia y detalles arquitectónicos.', style: TextStyle(color: _subtextColor, fontSize: 12)),
        const SizedBox(height: 24),

        const LabelCampo(label: 'Archivos de Audio'),
        const SizedBox(height: 8),
        _buildUploadBox(
          icon: Icons.mic_none_outlined,
          label: 'Subir audios o notas de voz',
          sublabel: 'MP3, WAV hasta 20MB',
        ),
        const SizedBox(height: 24),

        const LabelCampo(label: 'Ubicación'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildTextField(textoGuia: '37.7214', prefix: 'Lat', controller: latController)),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField(textoGuia: '-4.0321', prefix: 'Lon', controller: lonController)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(color: _mapBg, borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.map_outlined, color: _mapIconColor, size: 30),
              const SizedBox(height: 8),
              Text('Vista previa del mapa', style: TextStyle(color: _mapIconColor)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String textoGuia,
    required TextEditingController controller,
    int maxLines = 1,
    String? prefix,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
      validator: (value) => value == null || value.isEmpty ? 'Este campo es obligatorio' : null,
      decoration: InputDecoration(
        prefixIcon: prefix != null
            ? Padding(padding: const EdgeInsets.all(12), child: Text(prefix, style: TextStyle(color: _hintColor)))
            : null,
        hintText: textoGuia,
        hintStyle: TextStyle(color: _hintColor, fontSize: 14),
        filled: true,
        fillColor: _fieldFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: _fieldBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF008F68))),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.redAccent)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.redAccent, width: 2)),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: isDarkMode ? const Color(0xFF1E2A3A) : Colors.white,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: _fieldFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: _fieldBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF008F68))),
      ),
    );
  }

  Widget _buildUploadBox({required IconData icon, required String label, required String sublabel}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(color: _uploadBoxBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: _fieldBorder)),
      child: Column(
        children: [
          Icon(icon, color: _hintColor, size: 40),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(text: 'Subir un archivo ', style: TextStyle(color: Color(0xFF008F68), fontWeight: FontWeight.bold)),
                TextSpan(text: label.replaceFirst('Subir un archivo', ''), style: TextStyle(color: _hintColor)),
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