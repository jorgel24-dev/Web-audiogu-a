import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:provider/provider.dart';
import '../providers/noticias_provider.dart';
import '../providers/tema_provider.dart';
import '../widgets/app_bar_principal.dart';
import '../widgets/menu_lateral.dart';
import '../widgets/noticia_tarjeta.dart';
import '../widgets/editor_toolbar.dart';
import '../widgets/chip_filtro.dart';
import '../widgets/label_campo.dart';

class NoticiasPage extends StatefulWidget {
  const NoticiasPage({super.key});

  @override
  State<NoticiasPage> createState() => _NoticiasPageState();
}

class _NoticiasPageState extends State<NoticiasPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoticiasProvider>().cargarNoticias();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const _NoticiasView();
  }
}

class _NoticiasView extends StatelessWidget {
  const _NoticiasView();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<TemaProvider>().isDarkMode;
    final dividerColor = isDarkMode ? Colors.white12 : Colors.grey[200]!;

    final bgColor = isDarkMode
        ? const Color(0xFF121212)
        : const Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBarPrincipal(
        isDarkMode: isDarkMode,
        onToggleDarkMode: () => context.read<TemaProvider>().toggleDarkMode(),
        icono: Icons.article_outlined,
        titulo: 'Editor de noticias',
      ),
      body: Consumer<NoticiasProvider>(
        builder: (context, noticiasProvider, _) {
          return Row(
            children: [
              MenuLateral(rutaActual: '/noticias', isDarkMode: isDarkMode),
              VerticalDivider(width: 1, color: dividerColor),
              Expanded(flex: 2, child: _PanelLista(isDarkMode: isDarkMode)),
              VerticalDivider(width: 1, color: dividerColor),
              Expanded(
                flex: 4,
                child: _PanelEditor(
                  key: ValueKey(noticiasProvider.editorKey),
                  isDarkMode: isDarkMode,
                  initialContenido: noticiasProvider.contenido,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PanelLista extends StatelessWidget {
  final bool isDarkMode;

  const _PanelLista({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final noticiasProvider = Provider.of<NoticiasProvider>(context);
    final cardColor = isDarkMode ? const Color(0xFF1E2A3A) : Colors.white;
    final inputBg = isDarkMode ? const Color(0xFF1A2332) : Colors.white;
    final hintColor = isDarkMode ? Colors.grey[600]! : Colors.grey[400]!;
    final borderColor = isDarkMode ? Colors.white12 : Colors.grey[300]!;

    return Container(
      color: cardColor,
      child: Column(
        children: [
          if (noticiasProvider.cargandoLista)
            const LinearProgressIndicator(
              minHeight: 2,
              backgroundColor: Colors.transparent,
              color: Color(0xFF2D6A4F),
            )
          else if (noticiasProvider.error != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                noticiasProvider.error!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: TextField(
              onChanged: (value) => noticiasProvider.setBusqueda(value),
              decoration: InputDecoration(
                filled: true,
                fillColor: inputBg,
                hintText: 'Buscar noticias...',
                hintStyle: TextStyle(fontSize: 13, color: hintColor),
                prefixIcon: Icon(Icons.search, size: 18, color: hintColor),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF2D6A4F)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChipFiltro(
                    label: 'Todos',
                    valor: 'todos',
                    filtroActivo: noticiasProvider.filtroActivo,
                    onSelected: () => noticiasProvider.setFiltro('todos'),
                  ),
                  const SizedBox(width: 6),
                  ChipFiltro(
                    label: 'Publicados',
                    valor: 'publicado',
                    filtroActivo: noticiasProvider.filtroActivo,
                    onSelected: () => noticiasProvider.setFiltro('publicado'),
                  ),
                  const SizedBox(width: 6),
                  ChipFiltro(
                    label: 'Borradores',
                    valor: 'borrador',
                    filtroActivo: noticiasProvider.filtroActivo,
                    onSelected: () => noticiasProvider.setFiltro('borrador'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => noticiasProvider.nuevaNoticia(),
                icon: const Icon(Icons.add_circle_outline, size: 16),
                label: const Text(
                  'Crear nueva noticia',
                  style: TextStyle(fontSize: 13),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2D6A4F),
                  side: const BorderSide(color: Color(0xFF2D6A4F)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: noticiasProvider.noticiasFiltradas.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final noticia = noticiasProvider.noticiasFiltradas[index];
                return NoticiaTarjeta(
                  noticia: noticia,
                  seleccionada:
                      noticiasProvider.noticiaSeleccionada?.id == noticia.id,
                  onTap: () => noticiasProvider.seleccionarNoticia(noticia),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PanelEditor extends StatefulWidget {
  final bool isDarkMode;
  final String initialContenido;

  const _PanelEditor({
    super.key,
    required this.isDarkMode,
    this.initialContenido = '',
  });

  @override
  State<_PanelEditor> createState() => _PanelEditorState();
}

class _PanelEditorState extends State<_PanelEditor> {
  final _titularController = TextEditingController();
  final _subtituloController = TextEditingController();
  late final quill.QuillController _quillController;

  quill.QuillController _buildQuillController(String contenido) {
    if (contenido.isEmpty) return quill.QuillController.basic();
    try {
      final delta = jsonDecode(contenido) as List;
      return quill.QuillController(
        document: quill.Document.fromJson(delta),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } catch (_) {
      final doc = quill.Document();
      doc.insert(0, contenido);
      return quill.QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _quillController = _buildQuillController(widget.initialContenido);
    _quillController.addListener(() {
      final delta = jsonEncode(
        _quillController.document.toDelta().toJson(),
      );
      context.read<NoticiasProvider>().setContenido(delta);
    });
  }

  @override
  void dispose() {
    _titularController.dispose();
    _subtituloController.dispose();
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.isDarkMode;
    final noticiasProvider = Provider.of<NoticiasProvider>(context);
    final noticia = noticiasProvider.noticiaSeleccionada;
    if (noticia != null) {
      if (_titularController.text != noticiasProvider.titulo) {
        _titularController.text = noticiasProvider.titulo;
      }
      if (_subtituloController.text != noticiasProvider.subtitulo) {
        _subtituloController.text = noticiasProvider.subtitulo;
      }
    } else if (noticiasProvider.titulo.isEmpty &&
        _titularController.text.isNotEmpty) {
      _titularController.clear();
      _subtituloController.clear();
    }

    return Container(
      color: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      child: !noticiasProvider.editorActivo
          ? const _EditorVacio()
          : Form(
              key: noticiasProvider.formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? const Color(0xFF1E2A3A)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LabelCampo(label: 'Titular de la Noticia'),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _titularController,
                                  onChanged: (value) =>
                                      noticiasProvider.setTitulo(value),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: _inputDecoration(
                                    hint: 'Festival de la Aceituna 2024',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'El titular no puede estar vacío';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                LabelCampo(label: 'Subtítulo / Entradilla'),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _subtituloController,
                                  onChanged: (value) =>
                                      noticiasProvider.setSubtitulo(value),
                                  maxLines: 2,
                                  decoration: _inputDecoration(
                                    hint:
                                        'Breve descripción introductoria de la noticia...',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'El subtítulo no puede estar vacío';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          LabelCampo(
                                            label: 'Fecha de Publicación',
                                          ),
                                          const SizedBox(height: 6),
                                          TextFormField(
                                            readOnly: true,
                                            controller: TextEditingController(
                                              text:
                                                  noticiasProvider
                                                          .fechaPublicacion !=
                                                      null
                                                  ? _formatearFecha(
                                                      noticiasProvider
                                                          .fechaPublicacion!,
                                                    )
                                                  : '',
                                            ),
                                            decoration:
                                                _inputDecoration(
                                                  hint: 'mm/dd/yyyy',
                                                ).copyWith(
                                                  suffixIcon: const Icon(
                                                    Icons.calendar_today,
                                                    size: 16,
                                                  ),
                                                ),
                                            onTap: () async {
                                              final fecha =
                                                  await showDatePicker(
                                                    context: context,
                                                    initialDate:
                                                        noticiasProvider
                                                            .fechaPublicacion ??
                                                        DateTime.now(),
                                                    firstDate: DateTime(2020),
                                                    lastDate: DateTime(2030),
                                                    locale: const Locale(
                                                      'es',
                                                      'ES',
                                                    ),
                                                  );
                                              if (fecha != null) {
                                                noticiasProvider
                                                    .setFechaPublicacion(fecha);
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const Divider(height: 1),
                          EditorToolbar(
                            controller: _quillController,
                            isDarkMode: isDarkMode,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Container(
                              height: 300,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.transparent),
                              ),
                              child: quill.QuillEditor.basic(
                                controller: _quillController,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (noticiasProvider.editorActivo) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? const Color(0xFF1E2A3A)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDarkMode
                                ? Colors.white12
                                : Colors.grey[200]!,
                          ),
                        ),
                        child: Row(
                          children: [
                            if (noticiasProvider.noticiaSeleccionada !=
                                null) ...[
                              const Icon(
                                Icons.tune,
                                size: 16,
                                color: Color(0xFF2D6A4F),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Estado:',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[700],
                                ),
                              ),
                              const SizedBox(width: 12),
                              _BotonEstado(
                                label: 'Borrador',
                                color: Colors.orange,
                                activo:
                                    noticiasProvider.estadoEditor ==
                                    0,
                                onTap: () => noticiasProvider.cambiarEstado(
                                  0,
                                ),
                              ),
                              const SizedBox(width: 8),
                              _BotonEstado(
                                label: 'Publicado',
                                color: Colors.green,
                                activo:
                                    noticiasProvider.estadoEditor ==
                                    1,
                                onTap: () => noticiasProvider.cambiarEstado(
                                  1,
                                ),
                              ),
                              const SizedBox(width: 12),
                              OutlinedButton.icon(
                                onPressed: () => _mostrarDialogoEliminar(
                                  context,
                                  noticiasProvider,
                                ),
                                icon: const Icon(
                                  Icons.delete_outline,
                                  size: 16,
                                ),
                                label: const Text('Eliminar'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red[700],
                                  side: BorderSide(color: Colors.red[300]!),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                            const Spacer(),
                            _BotonGuardar(),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  void _mostrarDialogoEliminar(
    BuildContext context,
    NoticiasProvider noticiasProvider,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 22),
            SizedBox(width: 8),
            Text('Eliminar noticia', style: TextStyle(fontSize: 17)),
          ],
        ),
        content: Text(
          '¿Estás seguro de que quieres eliminar "${noticiasProvider.titulo}"?\n\nEsta acción no se puede deshacer.',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final ok = await noticiasProvider.eliminarNoticia();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      ok
                          ? 'Noticia eliminada correctamente'
                          : 'Error al eliminar la noticia',
                    ),
                    backgroundColor: ok ? Colors.green : Colors.red[700],
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            icon: const Icon(Icons.delete_outline, size: 16),
            label: const Text('Eliminar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.month.toString().padLeft(2, '0')}/${fecha.day.toString().padLeft(2, '0')}/${fecha.year}';
  }

  InputDecoration _inputDecoration({required String hint}) {
    final borderColor = widget.isDarkMode ? Colors.white24 : Colors.grey[300]!;
    final hintColor = widget.isDarkMode ? Colors.grey[500]! : Colors.grey;
    final fillColor = widget.isDarkMode ? const Color(0xFF1E2A3A) : Colors.white;
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: hintColor, fontSize: 13),
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF2D6A4F)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }
}

class _EditorVacio extends StatelessWidget {
  const _EditorVacio();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.article_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Selecciona una noticia para editarla',
            style: TextStyle(color: Colors.grey[400], fontSize: 15),
          ),
          const SizedBox(height: 8),
          Text(
            'o crea una nueva desde el panel de la izquierda',
            style: TextStyle(color: Colors.grey[400], fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _BotonEstado extends StatelessWidget {
  final String label;
  final Color color;
  final bool activo;
  final VoidCallback onTap;

  const _BotonEstado({
    required this.label,
    required this.color,
    required this.activo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: activo ? color.withValues(alpha: 0.15) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: activo ? color : Colors.grey[300]!,
            width: activo ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: activo ? FontWeight.w700 : FontWeight.normal,
            color: activo ? color : Colors.grey[600],
          ),
        ),
      ),
    );
  }
}

class _BotonGuardar extends StatelessWidget {
  const _BotonGuardar();

  @override
  Widget build(BuildContext context) {
    final noticiasProvider = Provider.of<NoticiasProvider>(context);

    return ElevatedButton.icon(
      onPressed: noticiasProvider.cargando
          ? null
          : () async {
              final guardado = await noticiasProvider.guardarCambios();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      guardado
                          ? 'Noticia guardada correctamente'
                          : 'Revisa los campos obligatorios',
                    ),
                    backgroundColor: guardado ? Colors.green : Colors.red[700],
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
      icon: noticiasProvider.cargando
          ? const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Icon(Icons.save, size: 16),
      label: const Text('Guardar Cambios', style: TextStyle(fontSize: 13)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2D6A4F),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
