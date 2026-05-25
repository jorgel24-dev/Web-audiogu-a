import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../provider/tema_provider.dart';
import '../../provider/dashboard_provider.dart';
import '../widgets/app_bar_principal.dart';
import '../widgets/menu_lateral.dart';
import '../widgets/tarjeta_estadisticas.dart';
import '../widgets/tarjeta_modulo.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    final dashboardProvider = context.read<DashboardProvider>();
    Future.microtask(() => dashboardProvider.cargarStats());
  }

  @override
  Widget build(BuildContext context) {
    final temaProvider = context.watch<TemaProvider>();
    final dashboard = context.watch<DashboardProvider>();
    final isDarkMode = temaProvider.isDarkMode;

    final bgColor = isDarkMode
        ? const Color(0xFF121212)
        : const Color(0xFFF8F9FA);
    final cardColor = isDarkMode ? const Color(0xFF1E2A3A) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];

    final totalMonumentos = dashboard.stats?.totalMonumentos ?? 0;
    final totalNoticias = dashboard.stats?.totalNoticias ?? 0;
    final totalDescargas = dashboard.stats?.totalDescargas ?? 0;
    final rating = dashboard.stats?.rating ?? 0.0;

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
          VerticalDivider(
            width: 1,
            color: isDarkMode ? Colors.white12 : Colors.grey[200]!,
          ),
          Expanded(
            child: dashboard.cargando
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF2D6A4F)),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(30),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(
                              context,
                              textColor,
                              subTextColor,
                              cardColor,
                            ),
                            const SizedBox(height: 30),

                            Row(
                              children: [
                                Expanded(
                                  child: TarjetaEstadistica(
                                    icono: Icons.download_rounded,
                                    colorIcono: Colors.blue,
                                    valor: totalDescargas > 0
                                        ? totalDescargas.toString()
                                        : '—',
                                    titulo: 'Descargas',
                                    esIncremento: true,
                                    isDarkMode: isDarkMode,
                                  ),
                                ),
                                Expanded(
                                  child: TarjetaEstadistica(
                                    icono: Icons.castle_rounded,
                                    colorIcono: Colors.green,
                                    valor: totalMonumentos.toString(),
                                    titulo: 'Monumentos',
                                    esIncremento: true,
                                    isDarkMode: isDarkMode,
                                  ),
                                ),
                                Expanded(
                                  child: TarjetaEstadistica(
                                    icono: Icons.newspaper_rounded,
                                    colorIcono: Colors.red,
                                    valor: totalNoticias.toString(),
                                    titulo: 'Noticias',
                                    esIncremento: true,
                                    isDarkMode: isDarkMode,
                                  ),
                                ),
                                Expanded(
                                  child: TarjetaEstadistica(
                                    icono: Icons.star,
                                    colorIcono: Colors.orange,
                                    valor: rating > 0
                                        ? rating.toStringAsFixed(1)
                                        : '—',
                                    titulo: 'Rating',
                                    esIncremento: true,
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

                            LayoutBuilder(
                              builder: (context, constraints) {
                                double ratio = 2.1;
                                if (constraints.maxWidth < 600) {
                                  ratio = 1.2;
                                } else if (constraints.maxWidth < 800) {
                                  ratio = 1.6;
                                }

                                return GridView.count(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: constraints.maxWidth < 600
                                      ? 1
                                      : 2,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                  childAspectRatio: ratio,
                                  children: [
                                    TarjetaModulo(
                                      icono: Icons.castle_rounded,
                                      colorTema: const Color(0xFF00796B),
                                      titulo: 'Añadir un monumento',
                                      descripcion:
                                          'Añade nuevas ubicaciones históricas a tu catálogo de la app.',
                                      textoEstado: '$totalMonumentos Activos',
                                      textoAccion: 'Gestionar',
                                      widgetsInferiores: _buildAvatarStack(),
                                      alPulsarAccion: () =>
                                          context.go('/monumentos/agregar'),
                                      isDarkMode: isDarkMode,
                                    ),
                                    TarjetaModulo(
                                      icono: Icons.newspaper_rounded,
                                      colorTema: Colors.redAccent,
                                      titulo: 'Noticias',
                                      descripcion:
                                          'Publica novedades y festivales de la ciudad.',
                                      textoEstado: '$totalNoticias Publicadas',
                                      textoAccion: 'Redactar',
                                      widgetsInferiores: const [
                                        Icon(
                                          Icons.access_time,
                                          size: 14,
                                          color: Colors.grey,
                                        ),
                                      ],
                                      alPulsarAccion: () =>
                                          context.go('/noticias'),
                                      isDarkMode: isDarkMode,
                                    ),
                                    TarjetaModulo(
                                      icono: Icons.analytics_rounded,
                                      colorTema: Colors.blueAccent,
                                      titulo: 'Monumentos',
                                      descripcion:
                                          'Administra y edita los monumentos actuales de la app.',
                                      textoAccion: 'Administrar',
                                      widgetsInferiores: const [
                                        Icon(
                                          Icons.insights,
                                          size: 16,
                                          color: Colors.blueAccent,
                                        ),
                                      ],
                                      alPulsarAccion: () =>
                                          context.go('/rendimiento'),
                                      isDarkMode: isDarkMode,
                                    ),
                                    TarjetaModulo(
                                      icono: Icons.tune_rounded,
                                      colorTema: Colors.purpleAccent,
                                      titulo: 'Configuración',
                                      descripcion:
                                          'Control de API Keys y ajustes globales de la App.',
                                      textoAccion: 'Ajustar',
                                      widgetsInferiores: const [
                                        Icon(
                                          Icons.security,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                      ],
                                      alPulsarAccion: () =>
                                          context.go('/configuracion'),
                                      isDarkMode: isDarkMode,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
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
      ],
    );
  }

  List<Widget> _buildAvatarStack() {
    return [const Icon(Icons.people_outline, size: 16, color: Colors.grey)];
  }
}
