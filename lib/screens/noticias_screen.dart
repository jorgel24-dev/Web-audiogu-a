import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import '../models/noticia_model.dart';
import '../providers/noticias_provider.dart';
import '../providers/tema_provider.dart';
import '../widgets/app_bar_principal.dart';
import '../widgets/menu_lateral.dart';
import '../widgets/noticia_tarjeta.dart';
import '../widgets/editor_toolbar.dart';
import '../widgets/chip_filtro.dart';
import '../widgets/label_campo.dart';

class NoticiasPage extends StatelessWidget {
  const NoticiasPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const _NoticiasView();
}

class _NoticiasView extends StatelessWidget {
  const _NoticiasView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<TemaProvider>().isDarkMode;
    final bgColor = isDarkMode
        ? const Color(0xFF121212)
        : const Color(0xFFF8F9FA);
    final dividerColor = isDarkMode ? Colors.white12 : Colors.grey[200]!;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBarPrincipal(
        isDarkMode: isDarkMode,
        onToggleDarkMode: () => context.read<TemaProvider>().toggleDarkMode(),
        icono: Icons.article_outlined,
        titulo: 'Editor de noticias',
      ),
      body: Row(
        children: [
          MenuLateral(rutaActual: '/noticias', isDarkMode: isDarkMode),
          VerticalDivider(width: 1, color: dividerColor),
          Expanded(flex: 2, child: _PanelLista(isDarkMode: isDarkMode)),
          VerticalDivider(width: 1, color: dividerColor),
          Expanded(flex: 4, child: _PanelEditor(isDarkMode: isDarkMode)),
        ],
      ),
    );
  }
}

class _PanelLista extends StatelessWidget {
  final bool isDarkMode;
  const _PanelLista({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NoticiasProvider>(context);
    final cardColor = isDarkMode ? const Color(0xFF1E2A3A) : Colors.white;
    final inputBg = isDarkMode ? const Color(0xFF1A2332) : Colors.white;
    final hintColor = isDarkMode ? Colors.grey[600]! : Colors.grey[400]!;
    final borderColor = isDarkMode ? Colors.white12 : Colors.grey[300]!;

    return Container(
      color: cardColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: TextField(
              onChanged: provider.setBusqueda,
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
                    filtroActivo: provider.filtroActivo,
                    onSelected: () => provider.setFiltro('todos'),
                  ),
                  const SizedBox(width: 6),
                  ChipFiltro(
                    label: 'Publicados',
                    valor: 'publicado',
                    filtroActivo: provider.filtroActivo,
                    onSelected: () => provider.setFiltro('publicado'),
                  ),
                  const SizedBox(width: 6),
                  ChipFiltro(
                    label: 'Borradores',
                    valor: 'borrador',
                    filtroActivo: provider.filtroActivo,
                    onSelected: () => provider.setFiltro('borrador'),
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
                onPressed: provider.nuevaNoticia,
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
              itemCount: provider.noticiasFiltradas.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final noticia = provider.noticiasFiltradas[index];
                return NoticiaTarjeta(
                  noticia: noticia,
                  seleccionada: provider.noticiaSeleccionada?.id == noticia.id,
                  onTap: () => provider.seleccionarNoticia(noticia),
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
  const _PanelEditor({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  State<_PanelEditor> createState() => _PanelEditorState();
}

class _PanelEditorState extends State<_PanelEditor> {
  final _titularController = TextEditingController();
  final _subtituloController = TextEditingController();
  late QuillController _quillController;
  final _quillFocus = FocusNode();
  final _quillScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _quillController = QuillController.basic();
  }

  @override
  void dispose() {
    _titularController.dispose();
    _subtituloController.dispose();
    _quillController.dispose();
    _quillFocus.dispose();
    _quillScrollController.dispose();
    super.dispose();
  }

  String _quillToPlainText() {
    return _quillController.document.toPlainText().trim();
  }

  void _loadCuerpo(String texto) {
    final doc = Document()..insert(0, texto);
    _quillController = QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.isDarkMode;
    final provider = Provider.of<NoticiasProvider>(context);
    final noticia = provider.noticiaSeleccionada;

    if (noticia != null) {
      if (_titularController.text != provider.titular) {
        _titularController.text = provider.titular;
      }
      if (_subtituloController.text != provider.subtitulo) {
        _subtituloController.text = provider.subtitulo;
      }
      if (_quillToPlainText() != provider.cuerpo) {
        _loadCuerpo(provider.cuerpo);
      }
    } else if (provider.titular.isEmpty && _titularController.text.isNotEmpty) {
      _titularController.clear();
      _subtituloController.clear();
      _quillController = QuillController.basic();
    }

    return Container(
      color: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      child: !provider.editorActivo
          ? const _EditorVacio()
          : Form(
              key: provider.formKey,
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
                                const LabelCampo(
                                  label: 'Titular de la Noticia',
                                ),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _titularController,
                                  onChanged: provider.setTitular,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: _inputDeco(
                                    hint: 'Festival de la Aceituna 2024',
                                  ),
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? 'El titular no puede estar vacío'
                                      : null,
                                ),
                                const SizedBox(height: 16),
                                const LabelCampo(
                                  label: 'Subtítulo / Entradilla',
                                ),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _subtituloController,
                                  onChanged: provider.setSubtitulo,
                                  maxLines: 2,
                                  decoration: _inputDeco(
                                    hint:
                                        'Breve descripción introductoria de la noticia...',
                                  ),
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? 'El subtítulo no puede estar vacío'
                                      : null,
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const LabelCampo(label: 'Categoría'),
                                          const SizedBox(height: 6),
                                          DropdownButtonFormField<String>(
                                            initialValue:
                                                provider.categoria.isEmpty
                                                ? null
                                                : provider.categoria,
                                            decoration: _inputDeco(
                                              hint: 'Seleccionar...',
                                            ),
                                            items: const [
                                              DropdownMenuItem(
                                                value: 'Cultura y Fiestas',
                                                child: Text(
                                                  'Cultura y Fiestas',
                                                ),
                                              ),
                                              DropdownMenuItem(
                                                value: 'Turismo',
                                                child: Text('Turismo'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'Eventos',
                                                child: Text('Eventos'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'Gastronomía',
                                                child: Text('Gastronomía'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'Deportes',
                                                child: Text('Deportes'),
                                              ),
                                            ],
                                            onChanged: (v) =>
                                                provider.setCategoria(v ?? ''),
                                            validator: (v) =>
                                                (v == null || v.isEmpty)
                                                ? 'Selecciona una categoría'
                                                : null,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const LabelCampo(
                                            label: 'Fecha de Publicación',
                                          ),
                                          const SizedBox(height: 6),
                                          TextFormField(
                                            readOnly: true,
                                            controller: TextEditingController(
                                              text:
                                                  provider.fechaPublicacion !=
                                                      null
                                                  ? _fmtFecha(
                                                      provider
                                                          .fechaPublicacion!,
                                                    )
                                                  : '',
                                            ),
                                            decoration:
                                                _inputDeco(
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
                                                        provider
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
                                                provider.setFechaPublicacion(
                                                  fecha,
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const Divider(height: 1),

                          EditorToolbar(controller: _quillController),

                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: FormField<String>(
                              validator: (_) {
                                final text = _quillToPlainText();
                                return text.isEmpty
                                    ? 'El cuerpo de la noticia no puede estar vacío'
                                    : null;
                              },
                              builder: (field) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  QuillEditor(
                                    controller: _quillController,
                                    focusNode: _quillFocus,
                                    scrollController: _quillScrollController,
                                    config: const QuillEditorConfig(
                                      minHeight: 200,
                                      placeholder:
                                          'Escribe el cuerpo de la noticia...',
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                  if (field.hasError)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        field.errorText!,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (provider.editorActivo) ...[
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
                            if (provider.noticiaSeleccionada != null) ...[
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
                                    provider.estadoEditor ==
                                    EstadoNoticia.borrador,
                                onTap: () => provider.cambiarEstado(
                                  EstadoNoticia.borrador,
                                ),
                              ),
                              const SizedBox(width: 8),
                              _BotonEstado(
                                label: 'Publicado',
                                color: Colors.green,
                                activo:
                                    provider.estadoEditor ==
                                    EstadoNoticia.publicado,
                                onTap: () => provider.cambiarEstado(
                                  EstadoNoticia.publicado,
                                ),
                              ),
                              const SizedBox(width: 12),
                              OutlinedButton.icon(
                                onPressed: () =>
                                    _dialEliminar(context, provider),
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
                            _BotonGuardar(
                              onGuardar: () {
                                provider.setCuerpo(_quillToPlainText());
                              },
                            ),
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

  void _dialEliminar(BuildContext context, NoticiasProvider provider) {
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
          '¿Estás seguro de que quieres eliminar "${provider.titular}"?\n\nEsta acción no se puede deshacer.',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(ctx).pop();
              provider.eliminarNoticia();
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

  String _fmtFecha(DateTime f) =>
      '${f.month.toString().padLeft(2, '0')}/${f.day.toString().padLeft(2, '0')}/${f.year}';

  InputDecoration _inputDeco({required String hint}) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey[300]!),
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
  final VoidCallback onGuardar;
  const _BotonGuardar({required this.onGuardar});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NoticiasProvider>(context);

    return ElevatedButton.icon(
      onPressed: provider.cargando
          ? null
          : () async {
              onGuardar();
              final ok = await provider.guardarCambios();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      ok
                          ? '✓ Noticia guardada correctamente'
                          : '✗ Revisa los campos obligatorios',
                    ),
                    backgroundColor: ok ? Colors.green : Colors.red[700],
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
      icon: provider.cargando
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
