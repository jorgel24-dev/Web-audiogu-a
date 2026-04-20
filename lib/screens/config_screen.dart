import 'package:audioguia_web/providers/config_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tema_provider.dart';
import '../widgets/app_bar_principal.dart';
import '../widgets/menu_lateral.dart';

class ConfiguracionPage extends StatelessWidget {
  const ConfiguracionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const _ConfiguracionView();
}

class _ConfiguracionView extends StatelessWidget {
  const _ConfiguracionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<TemaProvider>().isDarkMode;
    final dividerColor = isDarkMode ? Colors.white12 : Colors.grey[200]!;

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
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeaderConfig(isDarkMode: isDarkMode),
                    const SizedBox(height: 24),
                    _CardConfiguracion(isDarkMode: isDarkMode),
                  ],
                ),
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
        OutlinedButton(
          onPressed: config.hayPendientes ? config.descartarCambios : null,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.grey[700],
            side: BorderSide(color: Colors.grey[300]!),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Descartar cambios',
            style: TextStyle(fontSize: 13),
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
                          ok
                              ? '✓ Configuración guardada'
                              : '✗ Error al guardar',
                        ),
                        backgroundColor: ok ? Colors.green : Colors.red[700],
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
              : const Icon(Icons.check, size: 16),
          label: const Text(
            'Guardar configuración',
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
          ConfigItem(
            isDarkMode: isDarkMode,
            color: const Color(0xFF4CAF50),
            icono: Icons.hiking,
            titulo: 'Rutas Turísticas',
            descripcion:
                'Habilita la sección de rutas recomendadas. Permite a los usuarios visualizar, seguir y descargar itinerarios turísticos predefinidos.',
            value: config.rutasTuristicas,
            onChanged: config.toggleRutas,
          ),
          Divider(height: 1, color: dividerColor),
          ConfigItem(
            isDarkMode: isDarkMode,
            color: Colors.red[400]!,
            icono: Icons.smart_toy_outlined,
            titulo: 'Asistente IA',
            descripcion:
                'Activa el chatbot inteligente basado en IA generativa. Responde preguntas sobre historia local, horarios de monumentos y ofrece recomendaciones personalizadas.',
            advertencia: '⚠ Consume tokens de API adicionales.',
            value: config.asistenteIA,
            onChanged: config.toggleAsistenteIA,
          ),
          Divider(height: 1, color: dividerColor),
          ConfigItem(
            isDarkMode: isDarkMode,
            color: const Color(0xFF2196F3),
            icono: Icons.map_outlined,
            titulo: 'Mapas Interactivos',
            descripcion:
                'Muestra el mapa detallado con puntos de interés (POIs), geolocalización del usuario y filtros por categorías.',
            value: config.mapasInteractivos,
            onChanged: config.toggleMapas,
          ),
          Divider(height: 1, color: dividerColor),
          ConfigItem(
            isDarkMode: isDarkMode,
            color: Colors.grey[500]!,
            icono: Icons.notifications_outlined,
            titulo: 'Notificaciones Push',
            descripcion:
                'Envío de alertas sobre eventos locales, proximidad a monumentos importantes y actualizaciones de rutas.',
            value: config.notificacionesPush,
            onChanged: config.toggleNotificaciones,
          ),
          Divider(height: 1, color: dividerColor),
          ConfigItem(
            isDarkMode: isDarkMode,
            color: const Color(0xFF00BCD4),
            icono: Icons.headphones_outlined,
            titulo: 'Audio Guías',
            descripcion:
                'Habilita la reproducción de narraciones de voz para monumentos y puntos de interés. Requiere descarga de paquetes de audio.',
            value: config.audioGuias,
            onChanged: config.toggleAudioGuias,
          ),
          Divider(height: 1, color: dividerColor),
          ConfigItem(
            isDarkMode: isDarkMode,
            color: Colors.purple,
            icono: Icons.info_outline,
            titulo: 'Créditos',
            descripcion:
                'Muestra la sección de créditos en la aplicación móvil con información sobre el equipo de desarrollo, licencias y versión.',
            value: config.creditos,
            onChanged: config.toggleCreditos,
          ),
          Divider(height: 1, color: dividerColor),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              'Última actualización: hace 2 horas por Admin',
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
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
  final String? advertencia;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ConfigItem({
    Key? key,
    required this.isDarkMode,
    required this.color,
    required this.icono,
    required this.titulo,
    required this.descripcion,
    this.advertencia,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

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
                if (advertencia != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    advertencia!,
                    style: const TextStyle(fontSize: 11, color: Colors.orange),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 16),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF2D6A4F),
          ),
        ],
      ),
    );
  }
}
