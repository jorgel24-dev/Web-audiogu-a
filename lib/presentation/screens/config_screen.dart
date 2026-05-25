import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/tema_provider.dart';
import '../../provider/config_provider.dart';
import '../../widgets/app_bar_principal.dart';
import '../../widgets/menu_lateral.dart';

class ConfiguracionPage extends StatefulWidget {
  const ConfiguracionPage({super.key});

  @override
  State<ConfiguracionPage> createState() => _ConfiguracionPageState();
}

class _ConfiguracionPageState extends State<ConfiguracionPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConfiguracionProvider>().cargarConfiguracion();
    });
  }

  @override
  Widget build(BuildContext context) => const _ConfiguracionView();
}

class _ConfiguracionView extends StatelessWidget {
  const _ConfiguracionView();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<TemaProvider>().isDarkMode;
    final dividerColor = isDarkMode ? Colors.white12 : Colors.grey[200]!;
    final config = context.watch<ConfiguracionProvider>();

    if (config.cargandoInicial) {
      return Scaffold(
        backgroundColor: isDarkMode
            ? const Color(0xFF121212)
            : const Color(0xFFF8F9FA),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF2D6A4F)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color(0xFF121212)
          : const Color(0xFFF8F9FA),
      appBar: AppBarPrincipal(
        isDarkMode: isDarkMode,
        onToggleDarkMode: () => context.read<TemaProvider>().toggleDarkMode(),
        icono: Icons.settings_outlined,
        titulo: 'Configuración de la App',
        acciones: const [_BotonesAppBar()],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MenuLateral(rutaActual: '/configuracion', isDarkMode: isDarkMode),
          VerticalDivider(width: 1, color: dividerColor),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeaderConfig(isDarkMode: isDarkMode),
                  const SizedBox(height: 24),
                  _CardConfiguracion(isDarkMode: isDarkMode),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BotonesAppBar extends StatelessWidget {
  const _BotonesAppBar();

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfiguracionProvider>();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (config.hayPendientes)
          TextButton(
            onPressed: config.cargando ? null : config.descartarCambios,
            child: const Text(
              'Descartar',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: config.cargando
              ? null
              : () async {
                  final ok = await config.guardarConfiguracion();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          ok ? 'Configuración guardada' : 'Error al guardar',
                        ),
                        backgroundColor: ok ? Colors.green : Colors.red,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
          icon: config.cargando
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.save, size: 16),
          label: const Text('Guardar', style: TextStyle(fontSize: 13)),
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
    );
  }
}

class _HeaderConfig extends StatelessWidget {
  final bool isDarkMode;
  const _HeaderConfig({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Configuración de la App',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Gestiona las funcionalidades activas y la experiencia de usuario en la aplicación móvil.',
          style: TextStyle(
            fontSize: 13,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class _CardConfiguracion extends StatelessWidget {
  final bool isDarkMode;
  const _CardConfiguracion({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfiguracionProvider>();
    final cardColor = isDarkMode ? const Color(0xFF1E2A3A) : Colors.white;
    final dividerColor = isDarkMode ? Colors.white10 : Colors.grey[200]!;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.white10 : Colors.grey[200]!,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              children: [
                Icon(Icons.tune, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Funcionalidades Principales',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: dividerColor),

          ConfigExpansionItem(
            isDarkMode: isDarkMode,
            color: const Color(0xFF4CAF50),
            icono: Icons.hiking,
            titulo: 'Rutas',
            descripcion:
                'Habilita la sección de rutas recomendadas. Permite a los usuarios visualizar, seguir y descargar itinerarios turísticos predefinidos.',
            value: config.rutasTuristicas,
            onChanged: config.toggleRutas,
            children: config.rutas
                .map(
                  (r) => SwitchListTile(
                    title: Text(
                      r.name,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black87,
                        fontSize: 13,
                      ),
                    ),
                    value: r.isActive,
                    onChanged: (v) => config.toggleRuta(r.id, v),
                    activeThumbColor: const Color(0xFF4CAF50),
                    contentPadding: const EdgeInsets.only(left: 70, right: 24),
                  ),
                )
                .toList(),
          ),

          Divider(height: 1, color: dividerColor),
          ConfigItem(
            isDarkMode: isDarkMode,
            color: Colors.red[400]!,
            icono: Icons.smart_toy_outlined,
            titulo: 'Chat IA',
            descripcion:
                'Activa el chatbot inteligente basado en IA generativa. Responde preguntas sobre historia local, horarios de monumentos y ofrece recomendaciones personalizadas.',
            value: config.asistenteIA,
            onChanged: config.toggleAsistenteIA,
          ),

          Divider(height: 1, color: dividerColor),
          ConfigExpansionItem(
            isDarkMode: isDarkMode,
            color: const Color(0xFF2196F3),
            icono: Icons.map_outlined,
            titulo: 'Monumentos',
            descripcion:
                'Muestra el mapa detallado con puntos de interés (POIs), geolocalización del usuario y filtros por categorías.',
            value: config.mapasInteractivos,
            onChanged: config.toggleMapas,
            children: config.monumentos
                .map(
                  (m) => SwitchListTile(
                    title: Text(
                      m.name,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black87,
                        fontSize: 13,
                      ),
                    ),
                    value: m.isActive,
                    onChanged: (v) => config.toggleMonumento(m.id, v),
                    activeThumbColor: const Color(0xFF2196F3),
                    contentPadding: const EdgeInsets.only(left: 70, right: 24),
                  ),
                )
                .toList(),
          ),

          Divider(height: 1, color: dividerColor),
          ConfigItem(
            isDarkMode: isDarkMode,
            color: const Color(0xFF9C27B0),
            icono: Icons.article_outlined,
            titulo: 'Noticias',
            descripcion:
                'Habilita la sección de noticias y eventos. Muestra las últimas novedades y avisos importantes.',
            value: config.noticias,
            onChanged: config.toggleNoticias,
          ),
        ],
      ),
    );
  }
}

class ConfigItem extends StatelessWidget {
  final bool isDarkMode;
  final Color color;
  final IconData icono;
  final String titulo;
  final String descripcion;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ConfigItem({
    super.key,
    required this.isDarkMode,
    required this.color,
    required this.icono,
    required this.titulo,
    required this.descripcion,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDarkMode ? Colors.white : Colors.black87;
    final descColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(icono, size: 20, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  descripcion,
                  style: TextStyle(fontSize: 12, color: descColor),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF2D6A4F),
          ),
        ],
      ),
    );
  }
}

class ConfigExpansionItem extends StatelessWidget {
  final bool isDarkMode;
  final Color color;
  final IconData icono;
  final String titulo;
  final String descripcion;
  final bool value;
  final ValueChanged<bool> onChanged;
  final List<Widget> children;

  const ConfigExpansionItem({
    super.key,
    required this.isDarkMode,
    required this.color,
    required this.icono,
    required this.titulo,
    required this.descripcion,
    required this.value,
    required this.onChanged,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDarkMode ? Colors.white : Colors.black87;
    final descColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(icono, size: 20, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    descripcion,
                    style: TextStyle(fontSize: 12, color: descColor),
                  ),
                ],
              ),
            ),
          ],
        ),
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.white.withValues(alpha: 0.02)
                  : Colors.black.withValues(alpha: 0.02),
              border: Border(
                top: BorderSide(
                  color: isDarkMode ? Colors.white10 : Colors.black12,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(
                    'Activar $titulo',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                      fontSize: 13,
                    ),
                  ),
                  subtitle: Text(
                    'Habilita o deshabilita este módulo por completo en la app',
                    style: TextStyle(fontSize: 11, color: descColor),
                  ),
                  value: value,
                  onChanged: onChanged,
                  activeThumbColor: color,
                  contentPadding: const EdgeInsets.only(left: 70, right: 24),
                ),
                Divider(
                  height: 1,
                  indent: 70,
                  color: isDarkMode ? Colors.white10 : Colors.black12,
                ),
                if (children.isNotEmpty)
                  ...children
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange[400],
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'No se han podido cargar los elementos desde el servidor. Comprueba la conexión o la configuración.',
                            style: TextStyle(
                              color: isDarkMode
                                  ? Colors.white70
                                  : Colors.black54,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
