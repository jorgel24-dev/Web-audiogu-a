import 'package:audioguia_web/models/noticia_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/noticias_provider.dart';

class EditorNoticias extends StatefulWidget {
  const EditorNoticias({Key? key}) : super(key: key);

  @override
  State<EditorNoticias> createState() => _EditorNoticiasState();
}

class _EditorNoticiasState extends State<EditorNoticias> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _subtituloController;
  late TextEditingController _contenidoController;
  String _categoriaSeleccionada = 'Cultura y Fiestas';
  DateTime _fechaPublicacion = DateTime.now();

  final List<String> _categorias = [
    'Cultura y Fiestas',
    'Turismo',
    'Gastronomía',
    'Historia',
    'Eventos',
    'Noticias Locales',
  ];

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController();
    _subtituloController = TextEditingController();
    _contenidoController = TextEditingController();
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _subtituloController.dispose();
    _contenidoController.dispose();
    super.dispose();
  }

  void _cargarNoticia(Noticia noticia) {
    _tituloController.text = noticia.titulo;
    _subtituloController.text = noticia.subtitulo;
    _contenidoController.text = noticia.contenido;
  }

  Future<void> _guardarCambios(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = context.read<NoticiasProvider>();
    final noticiaActual = provider.noticiaSeleccionada;

    if (noticiaActual == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay noticia seleccionada')),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoticiasProvider>(
      builder: (context, provider, child) {
        final noticia = provider.noticiaSeleccionada;

        if (noticia == null) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.article_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Selecciona una noticia o crea una nueva',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Cargar datos de la noticia seleccionada
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _cargarNoticia(noticia);
        });

        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              _buildToolbar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTituloField(),
                        const SizedBox(height: 24),
                        _buildSubtituloField(),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(child: _buildCategoriaField()),
                            const SizedBox(width: 16),
                            Expanded(child: _buildFechaField(context)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildTextToolbar(),
                        const SizedBox(height: 8),
                        _buildContenidoField(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          const Text(
            'Editor de Noticias y Actualidades',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final provider = context.read<NoticiasProvider>();
              final noticia = provider.noticiaSeleccionada;
              
              if (noticia != null) {
                final confirmar = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Eliminar noticia'),
                    content: Text('¿Estás seguro de que quieres eliminar "${noticia.titulo}"?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Eliminar'),
                      ),
                    ],
                  ),
                );

                if (confirmar == true) {
                  final success = await provider.eliminarNoticia(noticia.id);
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Noticia eliminada correctamente'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(provider.error ?? 'Error al eliminar la noticia'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            tooltip: 'Eliminar noticia',
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6_outlined),
            onPressed: () {
              // TODO: Implementar cambio de tema
            },
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () => _guardarCambios(context),
            icon: const Icon(Icons.save, size: 18),
            label: const Text('Guardar Cambios'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00897B),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTituloField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Título de la Noticia',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _tituloController,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Escribe el título aquí...',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El título es obligatorio';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubtituloField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Subtítulo / Entradilla',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _subtituloController,
          maxLines: 3,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            hintText: 'Escribe el subtítulo o entradilla...',
            hintStyle: TextStyle(color: Colors.grey.shade400),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El subtítulo es obligatorio';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCategoriaField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categoría',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _categoriaSeleccionada,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          items: _categorias.map((categoria) {
            return DropdownMenuItem(
              value: categoria,
              child: Text(categoria),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _categoriaSeleccionada = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildFechaField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fecha de Publicación',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _fechaPublicacion,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (date != null) {
              setState(() {
                _fechaPublicacion = date;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Spacer(),
                const Icon(Icons.calendar_today, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          _buildToolbarButton(Icons.format_bold, 'Negrita'),
          _buildToolbarButton(Icons.format_italic, 'Cursiva'),
          _buildToolbarButton(Icons.format_underlined, 'Subrayado'),
          const SizedBox(width: 8),
          Container(
            width: 1,
            height: 24,
            color: Colors.grey.shade300,
          ),
          const SizedBox(width: 8),
          _buildToolbarButton(Icons.format_align_left, 'Alinear izquierda'),
          _buildToolbarButton(Icons.format_align_center, 'Centrar'),
          _buildToolbarButton(Icons.format_align_right, 'Alinear derecha'),
          const SizedBox(width: 8),
          Container(
            width: 1,
            height: 24,
            color: Colors.grey.shade300,
          ),
          const SizedBox(width: 8),
          _buildToolbarButton(Icons.format_list_bulleted, 'Lista'),
          _buildToolbarButton(Icons.format_list_numbered, 'Lista numerada'),
          const SizedBox(width: 8),
          Container(
            width: 1,
            height: 24,
            color: Colors.grey.shade300,
          ),
          const SizedBox(width: 8),
          _buildToolbarButton(Icons.image, 'Insertar imagen'),
        ],
      ),
    );
  }

  Widget _buildToolbarButton(IconData icon, String tooltip) {
    return IconButton(
      icon: Icon(icon, size: 20),
      tooltip: tooltip,
      onPressed: () {
        // TODO: Implementar funcionalidad del editor de texto
      },
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(
        minWidth: 36,
        minHeight: 36,
      ),
    );
  }

  Widget _buildContenidoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _contenidoController,
          maxLines: 20,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            hintText: 'Escribe el contenido de la noticia aquí...',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            contentPadding: const EdgeInsets.all(16),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El contenido es obligatorio';
            }
            return null;
          },
        ),
      ],
    );
  }
}
