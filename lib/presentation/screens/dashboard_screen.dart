import 'package:audioguia_web/shared/widgets/barra_lateral.dart';
import 'package:audioguia_web/shared/widgets/tarjeta_estadisticas.dart';
import 'package:audioguia_web/shared/widgets/tarjeta_modulo.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isDarkMode = false; // Estado para la luna

  @override
  Widget build(BuildContext context) {
    // Definimos colores según el modo
    final bgColor = isDarkMode
        ? const Color(0xFF121212)
        : const Color(0xFFF8F9FA);
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      backgroundColor: cardColor,
      body: Row(
        children: [
          // --- BARRA LATERAL ---
          Container(
            width: 240, // Un poco más estrecha
            decoration: BoxDecoration(
              color: cardColor,
              border: Border(
                right: BorderSide(
                  color: isDarkMode ? Colors.white10 : Colors.grey[200]!,
                ),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 20,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.map_rounded,
                        color: Color(0xFF00796B),
                        size: 26,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Martos Guía",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: textColor,
                            ),
                          ),
                          Text(
                            "Admin Panel",
                            style: TextStyle(fontSize: 10, color: subTextColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                BarraLateral(
                  icono: Icons.grid_view_rounded,
                  titulo: "Panel Principal",
                  estaSeleccionado: true,
                  alPulsar: () {},
                  isDarkMode: isDarkMode,
                ),
                BarraLateral(
                  icono: Icons.account_balance_rounded,
                  titulo: "Monumentos",
                  alPulsar: () {},
                  isDarkMode: isDarkMode,
                ),
                BarraLateral(
                  icono: Icons.article_rounded,
                  titulo: "Noticias",
                  alPulsar: () {},
                  isDarkMode: isDarkMode,
                ),
                BarraLateral(
                  icono: Icons.settings_rounded,
                  titulo: "Configuración",
                  alPulsar: () {},
                  isDarkMode: isDarkMode,
                ),
                const Spacer(),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // --- CONTENIDO PRINCIPAL ---
          Expanded(
            child: Container(
              color: bgColor,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30), // Padding reducido
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 1100,
                    ), // Más compacto
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(textColor, subTextColor),
                        const SizedBox(height: 30),

                        // ESTADÍSTICAS
                        Row(
                          children: [
                            Expanded(
                              child: TarjetaEstadistica(
                                icono: Icons.visibility,
                                colorIcono: Colors.blue,
                                valor: "24.5k",
                                titulo: "Visitas",
                                porcentaje: "+12%",
                                esIncremento: true,
                                isDarkMode: isDarkMode,
                              ),
                            ),
                            Expanded(
                              child: TarjetaEstadistica(
                                icono: Icons.person,
                                colorIcono: Colors.green,
                                valor: "1,204",
                                titulo: "Usuarios",
                                porcentaje: "+4%",
                                esIncremento: true,
                                isDarkMode: isDarkMode,
                              ),
                            ),
                            Expanded(
                              child: TarjetaEstadistica(
                                icono: Icons.smart_toy,
                                colorIcono: Colors.red,
                                valor: "856",
                                titulo: "Consultas IA",
                                porcentaje: "0%",
                                esIncremento: true,
                                isDarkMode: isDarkMode,
                              ),
                            ),
                            Expanded(
                              child: TarjetaEstadistica(
                                icono: Icons.star,
                                colorIcono: Colors.orange,
                                valor: "4.8",
                                titulo: "Rating",
                                porcentaje: "-2%",
                                esIncremento: false,
                                isDarkMode: isDarkMode,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),
                        Text(
                          "Módulos de Gestión",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // GRID DE MÓDULOS
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio:
                              2.1, // Tarjetas más bajas/estilizadas
                          children: [
                            TarjetaModulo(
                              icono: Icons.castle_rounded,
                              colorTema: const Color(0xFF00796B),
                              titulo: "Monumentos",
                              descripcion:
                                  "Edita puntos de interés, horarios y audioguías.",
                              textoEstado: "14 Activos",
                              textoAccion: "Gestionar",
                              widgetsInferiores: _buildAvatarStack(),
                              alPulsarAccion: () {},
                              isDarkMode: isDarkMode,
                            ),
                            TarjetaModulo(
                              icono: Icons.newspaper_rounded,
                              colorTema: Colors.redAccent,
                              titulo: "Noticias",
                              descripcion:
                                  "Publica novedades y festivales de la ciudad.",
                              textoEstado: "3 Pendientes",
                              textoAccion: "Redactar",
                              widgetsInferiores: const [
                                Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                              ],
                              alPulsarAccion: () {},
                              isDarkMode: isDarkMode,
                            ),
                            TarjetaModulo(
                              icono: Icons.analytics_rounded,
                              colorTema: Colors.blueAccent,
                              titulo: "Analítica",
                              descripcion:
                                  "Comportamiento de usuarios y rutas visitadas.",
                              textoEstado: "Mensual",
                              textoAccion: "Ver Reportes",
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
                              titulo: "Configuración",
                              descripcion:
                                  "Control de API Keys y ajustes globales de la App.",
                              textoEstado: "v2.4",
                              textoAccion: "Ajustar",
                              widgetsInferiores: const [
                                Icon(
                                  Icons.security,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ],
                              alPulsarAccion: () {},
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

  Widget _buildHeader(Color textColor, Color? subTextColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Panel de Control",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Resumen de actividad hoy.",
              style: TextStyle(color: subTextColor, fontSize: 14),
            ),
          ],
        ),
        Row(
          children: [
            _buildIconButton(Icons.notifications_none_rounded),
            const SizedBox(width: 10),
            // BOTÓN DE LUNA (DARK MODE)
            _buildIconButton(
              isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_outlined,
              onTap: () => setState(() => isDarkMode = !isDarkMode),
            ),
            const SizedBox(width: 20),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text("Nuevo"),
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
        ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, {VoidCallback? onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white10 : Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        onPressed: onTap ?? () {},
        icon: Icon(
          icon,
          color: isDarkMode ? Colors.white70 : Colors.grey[700],
          size: 20,
        ),
      ),
    );
  }

  List<Widget> _buildAvatarStack() {
    return [const Icon(Icons.people_outline, size: 16, color: Colors.grey)];
  }
}
