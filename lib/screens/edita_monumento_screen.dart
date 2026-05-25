import 'package:audioguia_web/models/monumento_model.dart';
import 'package:audioguia_web/providers/monumentos_provider.dart';
import 'package:audioguia_web/providers/tema_provider.dart';
import 'package:audioguia_web/widgets/app_bar_principal.dart';
import 'package:audioguia_web/widgets/label_campo.dart';
import 'package:audioguia_web/widgets/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:audioguia_web/services/api_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EditaMonumentoScreen extends StatefulWidget {
  final String monumentoId;

  const EditaMonumentoScreen({super.key, required this.monumentoId});

  @override
  State<EditaMonumentoScreen> createState() => _EditaMonumentoScreenState();
}

class _EditaMonumentoScreenState extends State<EditaMonumentoScreen> {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  
  Monumento? _monumento; // Almacena el monumento cargado del backend
  bool _isLoading = true;
  String _categoriaSeleccionada = 'Monumentos Históricos';
  String _estadoSeleccionado = 'Publicado';

  // Controladores de texto vinculados a los campos del formulario
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _latController = TextEditingController();
  final _lonController = TextEditingController();

  // Mapa para transformar los nombres legibles a los ID de tags que espera Spring Boot
  final Map<String, String> _categoriasMap = {
    'Monumentos Históricos': '1',
    'Iglesias': '2',
    'Fuentes': '3',
    'Parques': '4',
  };

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _latController.dispose();
    _lonController.dispose();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    try {
      final data = await _apiService.obtenerMonumentoPorId(widget.monumentoId);
      setState(() {
        _monumento = data;
        // Rellenar controladores automáticamente con los datos reales
        _nombreController.text = data.nombre;
        _descripcionController.text = data.descripcion;
        _latController.text = data.latitud.toString();
        _lonController.text = data.longitud.toString();
        _categoriaSeleccionada = _obtenerNombreCategoria(data.categoria);
        _estadoSeleccionado = data.activo ? 'Publicado' : 'Borrador';
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✗ Error al cargar monumento: $e'), backgroundColor: Colors.red),
        );
        context.go('/rendimiento');
      }
    }
  }

  // Helper para traducir el ID numérico al nombre legible del Dropdown
  String _obtenerNombreCategoria(String id) {
    return _categoriasMap.entries
        .firstWhere((element) => element.value == id, orElse: () => const MapEntry('Monumentos Históricos', '1'))
        .key;
  }

  Future<void> _ejecutarActualizacion() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate() || _monumento == null) return;

    setState(() => _isLoading = true);

    final double lat = double.tryParse(_latController.text) ?? 37.7214;
    final double lon = double.tryParse(_lonController.text) ?? -4.0321;
    final String tagId = _categoriasMap[_categoriaSeleccionada] ?? '1';

    // Construimos el modelo combinando el ID original con las actualizaciones del formulario
    final monumentoActualizado = Monumento(
      id: _monumento!.id,
      nombre: _nombreController.text,
      descripcion: _descripcionController.text,
      categoria: tagId,
      accesible: _monumento!.accesible, 
      activo: _estadoSeleccionado == 'Publicado',
      latitud: lat,
      longitud: lon,
    );

    try {
      // Usamos directamente tu ApiService para actualizar el monumento existente
      await _apiService.editarMonumento(monumentoActualizado);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Monumento actualizado correctamente'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/rendimiento');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✗ Error al actualizar en el servidor: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _eliminar() async {
    if (_monumento == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar eliminación"),
        content: Text("¿Estás seguro de que deseas eliminar permanentemente '${_monumento?.nombre}'? Esta acción no se puede deshacer."),
        actions: [
          TextButton(onPressed: () => context.pop(false), child: const Text("Cancelar")),
          TextButton(
            onPressed: () => context.pop(true), 
            child: const Text("Eliminar", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        await _apiService.eliminarMonumento(widget.monumentoId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✓ Monumento eliminado con éxito'), backgroundColor: Colors.green),
          );
          context.go('/rendimiento');
        }
      } catch (e) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('✗ Error al eliminar: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

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
        titulo: 'Editar Monumento',
      ),
      body: Row(
        children: [
          MenuLateral(rutaActual: '/rendimiento', isDarkMode: isDarkMode),
          VerticalDivider(width: 1, color: dividerColor),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF008F68)))
                : Form(
                    key: _formKey,
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
                        _buildFooter(context, isDarkMode),
                      ],
                    ),
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
          // Botón Cancelar
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                context.read<NuevoMonumentoProvider>().limpiarArchivos();
                context.go('/rendimiento');
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: cancelBorderColor),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Cancelar', style: TextStyle(color: cancelTextColor)),
            ),
          ),
          const SizedBox(width: 16),
          
          // Botón Eliminar (Rojo Peligro)
          Expanded(
            child: OutlinedButton(
              onPressed: _eliminar,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.redAccent),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Eliminar Monumento', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 16),
          
          // Botón Guardar Cambios
          Expanded(
            child: ElevatedButton(
              onPressed: _ejecutarActualizacion,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008F68),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: const Text('Guardar Cambios', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
  Color get _hintColor => isDarkMode ? Colors.grey[500]! : Colors.grey;
  Color get _subtextColor => isDarkMode ? Colors.grey[500]! : Colors.grey;

  @override
  Widget build(BuildContext context) {
    final nuevoMonumentoProv = context.watch<NuevoMonumentoProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LabelCampo(label: 'Imagen Principal'),
        const SizedBox(height: 8),
        _buildUploadBox(
          icon: Icons.image_outlined,
          label: nuevoMonumentoProv.imagenNombre ?? 'Subir un archivo o arrastrar y soltar',
          sublabel: 'PNG, JPG, GIF hasta 10MB',
          onTap: () => nuevoMonumentoProv.seleccionarImagen(),
          hasFile: nuevoMonumentoProv.imagenNombre != null,
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
                    items: const ['Monumentos Históricos', 'Iglesias', 'Fuentes', 'Parques'],
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
                    items: const ['Publicado', 'Borrador', 'Archivado'],
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
          label: nuevoMonumentoProv.audioNombre ?? 'Subir audios o notas de voz',
          sublabel: 'MP3, WAV hasta 20MB',
          onTap: () => nuevoMonumentoProv.seleccionarAudio(),
          hasFile: nuevoMonumentoProv.audioNombre != null,
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

  Widget _buildUploadBox({
    required IconData icon, 
    required String label, 
    required String sublabel,
    required VoidCallback onTap,
    required bool hasFile,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
        decoration: BoxDecoration(
          color: _uploadBoxBg, 
          borderRadius: BorderRadius.circular(12), 
          border: Border.all(color: hasFile ? const Color(0xFF008F68) : _fieldBorder, width: hasFile ? 2 : 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: hasFile ? const Color(0xFF008F68) : _hintColor, size: 40),
            const SizedBox(height: 12),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: hasFile ? 'Archivo seleccionado: ' : 'Subir un archivo ', 
                    style: const TextStyle(color: Color(0xFF008F68), fontWeight: FontWeight.bold)
                  ),
                  TextSpan(
                    text: hasFile ? label : label.replaceFirst('Subir un archivo', ''), 
                    style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87, fontWeight: hasFile ? FontWeight.w500 : FontWeight.normal)
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(sublabel, style: TextStyle(color: _subtextColor, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}