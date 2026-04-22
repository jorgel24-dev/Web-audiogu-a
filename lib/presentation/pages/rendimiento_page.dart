import 'dart:math';

import 'package:flutter/material.dart';

class RendimientoPage extends StatelessWidget {
  const RendimientoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Row(
        children: [
          // --- SIDEBAR ---
          _buildSidebar(),
          
          // --- MAIN CONTENT ---
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildKpiGrid(),
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: _buildPopularMonuments()),
                            const SizedBox(width: 24),
                            Expanded(flex: 1, child: _buildUsageChart()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons. map_outlined, color: Color(0xFF008F68)),
              ),
              const SizedBox(width: 12),
              const Text('Martos Guía', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 40),
          _sidebarItem(Icons.grid_view_rounded, 'Panel Principal', active: true),
          _sidebarItem(Icons.location_on_outlined, 'Monumentos'),
          _sidebarItem(Icons.article_outlined, 'Noticias'),
          _sidebarItem(Icons.settings_outlined, 'Configuración'),
          const Spacer(),
          _sidebarItem(Icons.logout, 'Cerrar Sesión'),
        ],
      ),
    );
  }

  Widget _sidebarItem(IconData icon, String label, {bool active = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFE8F5E9) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: active ? const Color(0xFF008F68) : Colors.grey[600], size: 20),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: active ? const Color(0xFF008F68) : Colors.grey[700], fontWeight: active ? FontWeight.w600 : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Colors.white,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Rendimiento de la App', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('Última actualización: Hoy, 10:23 AM', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: 300,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar datos...',
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
                fillColor: const Color(0xFFF8F9FA),
                contentPadding: const EdgeInsets.all(0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.notifications_none, color: Colors.grey),
          const SizedBox(width: 16),
          const CircleAvatar(backgroundColor: Color(0xFF00BFA5), child: Text('AD', style: TextStyle(color: Colors.white, fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildKpiGrid() {
    return Row(
      children: [
        _kpiCard('Total Usuarios', '12,450', '+12%', Icons.people_outline, Colors.blue),
        const SizedBox(width: 16),
        _kpiCard('Rutas Completadas', '3,892', '+8.5%', Icons.directions_walk, Colors.green),
        const SizedBox(width: 16),
        _kpiCard('Consultas a la IA', '45,200', '+24%', Icons.smart_toy_outlined, Colors.red),
      ],
    );
  }

  Widget _kpiCard(String title, String value, String trend, IconData icon, Color color) {
    bool isNegative = trend.contains('-');
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFF1F3F5))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: color, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(isNegative ? Icons.south_east : Icons.north_east, size: 12, color: isNegative ? Colors.red : Colors.green),
                const SizedBox(width: 4),
                Text(trend, style: TextStyle(color: isNegative ? Colors.red : Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(width: 4),
                Text('vs mes anterior', style: TextStyle(color: Colors.grey[400], fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularMonuments() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF1F3F5))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Monumentos más Populares', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('Últimos 30 días', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
            ],
          ),
          const SizedBox(height: 24),
          _monumentRow('01', 'Castillo de la Peña', '12.5k visitantes • 4.8/5 valoración', 0.95, '95%'),
          _monumentRow('02', 'Real Iglesia de Santa Marta', '8.2k visitantes • 4.6/5 valoración', 0.72, '72%'),
          _monumentRow('03', 'Torre del Homenaje', '6.1k visitantes • 4.5/5 valoración', 0.58, '58%'),
          _monumentRow('04', 'Fuente de la Villa', '4.5k visitantes • 4.2/5 valoración', 0.45, '45%'),
          const SizedBox(height: 16),
          Center(child: TextButton(onPressed: () {}, child: const Text('Ver todos los monumentos', style: TextStyle(color: Color(0xFF008F68))))),
        ],
      ),
    );
  }

  Widget _monumentRow(String rank, String name, String stats, double progress, String percent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Text(rank, style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold)),
          const SizedBox(width: 16),
          Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(stats, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: 100,
            child: LinearProgressIndicator(value: progress, backgroundColor: const Color(0xFFF1F3F5), color: const Color(0xFF008F68), minHeight: 6),
          ),
          const SizedBox(width: 12),
          Text(percent, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildUsageChart() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF1F3F5))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Uso por Funcionalidad', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 140, 
                  width: 140,
                  child: CustomPaint(
                    painter: GraficoDonutPainter(),
                  ),
                ),
                const Column(
                  children: [
                    Text('100%', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    Text('Actividad', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 40),
          _chartLegend('Guía Mapa', '45%', const Color(0xFF008F68)),
          _chartLegend('Asistente IA', '35%', Colors.redAccent),
          _chartLegend('Audioguías', '20%', Colors.blueAccent),
        ],
      ),
    );
  }

  Widget _chartLegend(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}

// CustomPainter extension que se encarga de pintar
class GraficoDonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    const strokeWidth = 18.0;

    // El pincel
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt; // Cambia a StrokeCap.round para bordes circulares

    // Datos: [Porcentaje (0.0 a 1.0), Color]
    final segmentos = [
      {'valor': 0.45, 'color': const Color(0xFF008F68)}, // Guía Mapa
      {'valor': 0.35, 'color': const Color(0xFFFF5252)}, // Asistente IA
      {'valor': 0.20, 'color': const Color(0xFF448AFF)}, // Audioguías
    ];

    double anguloInicial = -pi / 2; // Empezar a las 12 en punto

    // El bucle de dibujo
    for (var seg in segmentos) {
      final sweepAngle = (seg['valor'] as double) * 2 * pi;
      paint.color = seg['color'] as Color;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - (strokeWidth / 2)),
        anguloInicial,
        sweepAngle,
        false,
        paint,
      );
      
      anguloInicial += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}