import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/tema_provider.dart';
import '../widgets/app_bar_principal.dart';
import '../widgets/menu_lateral.dart';
import '../widgets/tarjeta_estadisticas.dart';
import '../widgets/tarjeta_modulo.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final temaProvider = context.watch<TemaProvider>();
    final isDarkMode = temaProvider.isDarkMode;

    final bgColor = isDarkMode
        ? const Color(0xFF121212)
        : const Color(0xFFF8F9FA);
    final cardColor = isDarkMode ? const Color(0xFF1E2A3A) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBarPrincipal(
        isDarkMode: isDarkMode,
        onToggleDarkMode: () => context.read<TemaProvider>().toggleDarkMode(),
        icono: Icons.dashboard_rounded,
        titulo: 'Panel de Control',
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MenuLateral(rutaActual: '/dashboard', isDarkMode: isDarkMode),
          VerticalDivider(width: 1, color: isDarkMode ? Colors.white12 : Colors.grey[200]!),
          Expanded(
            child: Container(
              color: bgColor,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context, textColor, subTextColor, cardColor),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                              child: TarjetaEstadistica(
                                icono: Icons.visibility,
                                colorIcono: Colors.blue,
                                valor: '24.5k',
                                titulo: 'Visitas',
                                porcentaje: '+12%',
                                esIncremento: true,
                                isDarkMode: isDarkMode,
                              ),
                            ),
                            Expanded(
                              child: TarjetaEstadistica(
                                icono: Icons.person,
                                colorIcono: Colors.green,
                                valor: '1,204',
                                titulo: 'Usuarios',
                                porcentaje: '+4%',
                                esIncremento: true,
                                isDarkMode: isDarkMode,
                              ),
                            ),
                            Expanded(
                              child: TarjetaEstadistica(
                                icono: Icons.smart_toy,
                                colorIcono: Colors.red,
                                valor: '856',
                                titulo: 'Consultas IA',
                                porcentaje: '0%',
                                esIncremento: true,
                                isDarkMode: isDarkMode,
                              ),
                            ),
                            Expanded(
                              child: TarjetaEstadistica(
                                icono: Icons.star,
                                colorIcono: Colors.orange,
                                valor: '4.8',
                                titulo: 'Rating',
                                porcentaje: '-2%',
                                esIncremento: false,
                                isDarkMode: isDarkMode,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Text(
                          'Módulos de Gestión',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 2.1,
                          children: [
                            TarjetaModulo(
                              icono: Icons.castle_rounded,
                              colorTema: const Color(0xFF00796B),
                              titulo: 'Monumentos',
                              descripcion:
                                  'Edita puntos de interés, horarios y audioguías.',
                              textoEstado: '14 Activos',
                              textoAccion: 'Gestionar',
                              widgetsInferiores: _buildAvatarStack(),
                              alPulsarAccion: () {
                                context.go( '/monumentos/agregar' );
                              },
                              isDarkMode: isDarkMode,
                            ),
                            TarjetaModulo(
                              icono: Icons.newspaper_rounded,
                              colorTema: Colors.redAccent,
                              titulo: 'Noticias',
                              descripcion:
                                  'Publica novedades y festivales de la ciudad.',
                              textoEstado: '3 Pendientes',
                              textoAccion: 'Redactar',
                              widgetsInferiores: const [
                                Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                              ],
                              alPulsarAccion: () {
                                context.go('/noticias');
                              },
                              isDarkMode: isDarkMode,
                            ),
                            TarjetaModulo(
                              icono: Icons.analytics_rounded,
                              colorTema: Colors.blueAccent,
                              titulo: 'Analítica',
                              descripcion:
                                  'Comportamiento de usuarios y rutas visitadas.',
                              textoEstado: 'Mensual',
                              textoAccion: 'Ver Reportes',
                              widgetsInferiores: const [
                                Icon(
                                  Icons.insights,
                                  size: 16,
                                  color: Colors.blueAccent,
                                ),
                              ],
                              alPulsarAccion: () {},
                              isDarkMode: isDarkMode,
                            ),
                            TarjetaModulo(
                              icono: Icons.tune_rounded,
                              colorTema: Colors.purpleAccent,
                              titulo: 'Configuración',
                              descripcion:
                                  'Control de API Keys y ajustes globales de la App.',
                              textoEstado: 'v2.4',
                              textoAccion: 'Ajustar',
                              widgetsInferiores: const [
                                Icon(
                                  Icons.security,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ],
                              alPulsarAccion: () {
                                context.go('/configuracion');
                              },
                              isDarkMode: isDarkMode,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    Color textColor,
    Color? subTextColor,
    Color cardColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Panel de Control',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Resumen de actividad hoy.',
              style: TextStyle(color: subTextColor, fontSize: 14),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {
            context.go('/monumentos/agregar');
          },
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Nuevo'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00796B),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildAvatarStack() {
    return [const Icon(Icons.people_outline, size: 16, color: Colors.grey)];
  }
}
