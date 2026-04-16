import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/noticias_provider.dart';
import '../widgets/noticia_tarjeta.dart';
import '../widgets/editor_toolbar.dart';

class NoticiasPage extends StatelessWidget {
  const NoticiasPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NoticiasProvider(),
      child: const _NoticiasView(),
    );
  }
}

class _NoticiasView extends StatelessWidget {
  const _NoticiasView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Row(
        children: [
          // ── 1ª COLUMNA: Menú lateral ──────────────────────────────────
          const _MenuLateral(),

          // ── 2ª COLUMNA: Panel lista de noticias ───────────────────────
          Expanded(
            flex: 2,
            child: Column(
              children: [
                // AppBar personalizado con título y botón Guardar
                _AppBarNoticias(),
                // Panel con buscador, filtros y lista
                const Expanded(child: _PanelLista()),
              ],
            ),
          ),

          // Divisor vertical
          VerticalDivider(width: 1, color: Colors.grey[200]),

          // ── 3ª COLUMNA: Editor de contenido ───────────────────────────
          const Expanded(flex: 4, child: _PanelEditor()),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// MENÚ LATERAL (1ª columna) — estructura estándar del proyecto
// ════════════════════════════════════════════════════════

class _MenuLateral extends StatelessWidget {
  const _MenuLateral({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Colors.white,
      child: Column(
        children: [
          // Header: logo + nombre app
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D6A4F),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.square,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Martos Guía',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'Panel de Administración',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          const SizedBox(height: 8),
          // Items del menú
          _MenuItemLateral(
            icon: Icons.grid_view,
            label: 'Panel Principal',
            seleccionado: false,
            onTap: () {},
          ),
          _MenuItemLateral(
            icon: Icons.account_balance,
            label: 'Monumentos',
            seleccionado: false,
            onTap: () {},
          ),
          _MenuItemLateral(
            icon: Icons.article,
            label: 'Noticias',
            seleccionado: true,
            onTap: () {},
          ),
          _MenuItemLateral(
            icon: Icons.settings,
            label: 'Configuración',
            seleccionado: false,
            onTap: () {},
          ),
          const Spacer(),
          // Footer usuario
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFF2D6A4F),
                  child: Text(
                    'A',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Administrador',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'admin@martosguia.com',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.logout, size: 16, color: Colors.grey[400]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItemLateral extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool seleccionado;
  final VoidCallback onTap;

  const _MenuItemLateral({
    required this.icon,
    required this.label,
    required this.seleccionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        size: 18,
        color: seleccionado ? const Color(0xFF2D6A4F) : Colors.grey[600],
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: seleccionado ? FontWeight.w600 : FontWeight.normal,
          color: seleccionado ? const Color(0xFF2D6A4F) : Colors.grey[800],
        ),
      ),
      selected: seleccionado,
      selectedTileColor: const Color(0xFF2D6A4F).withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      dense: true,
      onTap: onTap,
    );
  }
}

// ════════════════════════════════════════════════════════
// APP BAR PERSONALIZADO
// ════════════════════════════════════════════════════════

class _AppBarNoticias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Recuperamos la info del provider (igual que el profesor)
    final noticiasProvider = Provider.of<NoticiasProvider>(context);

    return Container(
      height: 60,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(
            Icons.article_outlined,
            size: 20,
            color: Color(0xFF2D6A4F),
          ),
          const SizedBox(width: 8),
          const Text(
            'Editor de Noticias y Actualidades',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          const Spacer(),
          // Botón modo oscuro
          IconButton(
            icon: const Icon(Icons.dark_mode_outlined, size: 20),
            onPressed: () {},
            tooltip: 'Cambiar tema',
          ),
          const SizedBox(width: 8),
          // Botón Guardar Cambios — dispara validación (patrón del profesor)
          ElevatedButton.icon(
            onPressed: noticiasProvider.cargando
                ? null
                : () async {
                    final guardado = await noticiasProvider.guardarCambios();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            guardado
                                ? '✓ Noticia guardada correctamente'
                                : '✗ Revisa los campos obligatorios',
                          ),
                          backgroundColor: guardado
                              ? Colors.green
                              : Colors.red[700],
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
            label: const Text(
              'Guardar Cambios',
              style: TextStyle(fontSize: 13),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2D6A4F),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// PANEL LISTA (2ª columna)
// ════════════════════════════════════════════════════════

class _PanelLista extends StatelessWidget {
  const _PanelLista({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Recuperamos la info del provider
    final noticiasProvider = Provider.of<NoticiasProvider>(context);

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Buscador
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: TextField(
              onChanged: (value) => noticiasProvider.setBusqueda(value),
              decoration: InputDecoration(
                hintText: 'Buscar noticias...',
                hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
                prefixIcon: Icon(
                  Icons.search,
                  size: 18,
                  color: Colors.grey[400],
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
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
              ),
            ),
          ),
          // Filtros con ChoiceChip (Todos, Publicados, Borradores)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _ChipFiltro(
                  label: 'Todos',
                  valor: 'todos',
                  filtroActivo: noticiasProvider.filtroActivo,
                  onSelected: () => noticiasProvider.setFiltro('todos'),
                ),
                const SizedBox(width: 6),
                _ChipFiltro(
                  label: 'Publicados',
                  valor: 'publicado',
                  filtroActivo: noticiasProvider.filtroActivo,
                  onSelected: () => noticiasProvider.setFiltro('publicado'),
                ),
                const SizedBox(width: 6),
                _ChipFiltro(
                  label: 'Borradores',
                  valor: 'borrador',
                  filtroActivo: noticiasProvider.filtroActivo,
                  onSelected: () => noticiasProvider.setFiltro('borrador'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Botón crear nueva noticia
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
          // Lista de noticias
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

// Chip de filtro reutilizable
class _ChipFiltro extends StatelessWidget {
  final String label;
  final String valor;
  final String filtroActivo;
  final VoidCallback onSelected;

  const _ChipFiltro({
    required this.label,
    required this.valor,
    required this.filtroActivo,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final estaActivo = filtroActivo == valor;
    return ChoiceChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      selected: estaActivo,
      onSelected: (_) => onSelected(),
      selectedColor: const Color(0xFF2D6A4F),
      labelStyle: TextStyle(
        color: estaActivo ? Colors.white : Colors.grey[700],
        fontWeight: estaActivo ? FontWeight.w600 : FontWeight.normal,
      ),
      backgroundColor: Colors.grey[100],
      padding: const EdgeInsets.symmetric(horizontal: 8),
      visualDensity: VisualDensity.compact,
    );
  }
}

// ════════════════════════════════════════════════════════
// PANEL EDITOR (3ª columna)
// ════════════════════════════════════════════════════════

class _PanelEditor extends StatefulWidget {
  const _PanelEditor({Key? key}) : super(key: key);

  @override
  State<_PanelEditor> createState() => _PanelEditorState();
}

class _PanelEditorState extends State<_PanelEditor> {
  // Controladores para actualizar los campos cuando se selecciona una noticia
  final _titularController = TextEditingController();
  final _subtituloController = TextEditingController();
  final _cuerpoController = TextEditingController();

  @override
  void dispose() {
    _titularController.dispose();
    _subtituloController.dispose();
    _cuerpoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Recuperamos la info del provider (igual que el profesor)
    final noticiasProvider = Provider.of<NoticiasProvider>(context);

    // Sincronizar controladores cuando cambia la noticia seleccionada
    final noticia = noticiasProvider.noticiaSeleccionada;
    if (noticia != null) {
      if (_titularController.text != noticiasProvider.titular) {
        _titularController.text = noticiasProvider.titular;
      }
      if (_subtituloController.text != noticiasProvider.subtitulo) {
        _subtituloController.text = noticiasProvider.subtitulo;
      }
      if (_cuerpoController.text != noticiasProvider.cuerpo) {
        _cuerpoController.text = noticiasProvider.cuerpo;
      }
    } else if (noticiasProvider.titular.isEmpty &&
        _titularController.text.isNotEmpty) {
      _titularController.clear();
      _subtituloController.clear();
      _cuerpoController.clear();
    }

    return Container(
      color: const Color(0xFFF8F9FA),
      child:
          noticiasProvider.noticiaSeleccionada == null &&
              noticiasProvider.titular.isEmpty
          ? const _EditorVacio()
          : Form(
              key: noticiasProvider.formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Contenedor blanco del editor
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                                // ── Titular ──────────────────────────────
                                _LabelCampo(label: 'Titular de la Noticia'),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _titularController,
                                  // onChanged conecta el campo con el provider
                                  // (igual que el profesor: onChanged: (value) => provider.campo = value)
                                  onChanged: (value) =>
                                      noticiasProvider.setTitular(value),
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

                                // ── Subtítulo / Entradilla ────────────────
                                _LabelCampo(label: 'Subtítulo / Entradilla'),
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

                                // ── Fila: Categoría + Fecha ───────────────
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _LabelCampo(label: 'Categoría'),
                                          const SizedBox(height: 6),
                                          DropdownButtonFormField<String>(
                                            value:
                                                noticiasProvider
                                                    .categoria
                                                    .isEmpty
                                                ? null
                                                : noticiasProvider.categoria,
                                            decoration: _inputDecoration(
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
                                            // onChanged conecta con el provider
                                            onChanged: (value) =>
                                                noticiasProvider.setCategoria(
                                                  value ?? '',
                                                ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Selecciona una categoría';
                                              }
                                              return null;
                                            },
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
                                          _LabelCampo(
                                            label: 'Fecha de Publicación',
                                          ),
                                          const SizedBox(height: 6),
                                          // readOnly: true — al hacer tap abre showDatePicker
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
                                              // showDatePicker como indica la especificación
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
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // ── Editor de texto enriquecido ─────────────────
                          const Divider(height: 1),
                          // Toolbar de formato (widget reutilizable)
                          const EditorToolbar(),
                          // Área de texto con maxLines: null (como indica la especificación)
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: TextFormField(
                              controller: _cuerpoController,
                              onChanged: (value) =>
                                  noticiasProvider.setCuerpo(value),
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              minLines: 12,
                              decoration: const InputDecoration(
                                hintText: 'Escribe el cuerpo de la noticia...',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: const TextStyle(fontSize: 14, height: 1.6),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'El cuerpo de la noticia no puede estar vacío';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.month.toString().padLeft(2, '0')}/${fecha.day.toString().padLeft(2, '0')}/${fecha.year}';
  }

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
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
}

// Estado vacío del editor cuando no hay noticia seleccionada
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

// Widget reutilizable: etiqueta de campo de formulario
class _LabelCampo extends StatelessWidget {
  final String label;

  const _LabelCampo({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.grey[700],
      ),
    );
  }
}
