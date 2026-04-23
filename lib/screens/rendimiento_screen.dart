import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/app_bar_principal.dart';
import '../widgets/menu_lateral.dart';
import 'package:provider/provider.dart';
import '../providers/tema_provider.dart';

/// Pantalla de rendimiento y analítica de la aplicación.
/// Integrada desde feature/dev_jl. Muestra estadísticas, monumentos
/// populares y gráfico de uso por funcionalidad.
class RendimientoPage extends StatelessWidget {
  const RendimientoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<TemaProvider>().isDarkMode;
    final dividerColor = isDarkMode ? Colors.white12 : Colors.grey[200]!;
    final bgColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBarPrincipal(
        isDarkMode: isDarkMode,
        onToggleDarkMode: () => context.read<TemaProvider>().toggleDarkMode(),
        icono: Icons.analytics_outlined,
        titulo: 'Rendimiento',
      ),
      body: Row(
        children: [
          MenuLateral(rutaActual: '/rendimiento', isDarkMode: isDarkMode),
          VerticalDivider(width: 1, color: dividerColor),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _RendimientoContenido(isDarkMode: isDarkMode),
            ),
          ),
        ],
      ),
    );
  }
}

class _RendimientoContenido extends StatelessWidget {
  final bool isDarkMode;
  const _RendimientoContenido({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCabecera(),
        const SizedBox(height: 24),
        _buildEstadisticas(),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: _buildPopularMonuments()),
            const SizedBox(width: 16),
            Expanded(flex: 2, child: _buildDistribucionActividad()),
          ],
        ),
      ],
    );
  }

  Widget _buildCabecera() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rendimiento', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('Análisis de actividad de los últimos 30 días.',
                style: TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.download_outlined, size: 18),
          label: const Text('Exportar'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00796B),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  Widget _buildEstadisticas() {
    return Row(
      children: [
        _cardEstadistica('Total Usuarios', '12,450', '+12%', Icons.people_outline, Colors.blue),
        const SizedBox(width: 16),
        _cardEstadistica('Rutas Completadas', '3,892', '+8.5%', Icons.directions_walk, Colors.green),
        const SizedBox(width: 16),
        _cardEstadistica('Consultas a la IA', '45,200', '+24%', Icons.smart_toy_outlined, Colors.red),
      ],
    );
  }

  Widget _cardEstadistica(String title, String value, String trend, IconData icon, Color color) {
    final isNegative = trend.contains('-');
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF1F3F5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: color, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(isNegative ? Icons.south_east : Icons.north_east, size: 12,
                    color: isNegative ? Colors.red : Colors.green),
                const SizedBox(width: 4),
                Text(trend,
                    style: TextStyle(
                        color: isNegative ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold, fontSize: 12)),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F3F5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Monumentos más Populares',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('Últimos 30 días', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
            ],
          ),
          const SizedBox(height: 24),
          _monumentRow('01', 'Castillo de la Peña', '12.5k visitantes • 4.8/5 valoración', 0.95, '95%'),
          _monumentRow('02', 'Real Iglesia de Santa Marta', '8.2k visitantes • 4.6/5 valoración', 0.72, '72%'),
          _monumentRow('03', 'Torre del Homenaje', '6.1k visitantes • 4.5/5 valoración', 0.58, '58%'),
          _monumentRow('04', 'Fuente de la Villa', '4.5k visitantes • 4.2/5 valoración', 0.45, '45%'),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text('Ver todos los monumentos',
                  style: TextStyle(color: Color(0xFF008F68))),
            ),
          ),
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
          Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8))),
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
            child: LinearProgressIndicator(
                value: progress,
                backgroundColor: const Color(0xFFF1F3F5),
                color: const Color(0xFF008F68),
                minHeight: 6),
          ),
          const SizedBox(width: 12),
          Text(percent, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildDistribucionActividad() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F3F5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Uso por Funcionalidad',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 140,
                  width: 140,
                  child: CustomPaint(painter: _GraficoDonutPainter()),
                ),
                const Column(children: [
                  Text('100%', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text('Actividad', style: TextStyle(fontSize: 10, color: Colors.grey)),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 40),
          _indicadorActividad('Guía Mapa', '45%', const Color(0xFF008F68)),
          _indicadorActividad('Asistente IA', '35%', Colors.redAccent),
          _indicadorActividad('Audioguías', '20%', Colors.blueAccent),
        ],
      ),
    );
  }

  Widget _indicadorActividad(String label, String value, Color color) {
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

/// CustomPainter que dibuja el gráfico de dona de actividad.
class _GraficoDonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    const strokeWidth = 18.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final segmentos = [
      {'valor': 0.45, 'color': const Color(0xFF008F68)},
      {'valor': 0.35, 'color': const Color(0xFFFF5252)},
      {'valor': 0.20, 'color': const Color(0xFF448AFF)},
    ];

    double anguloInicial = -pi / 2;
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
