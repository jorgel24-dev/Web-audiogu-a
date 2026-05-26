import 'package:flutter/material.dart';

class TarjetaEstadistica extends StatelessWidget {
  final IconData icono;
  final Color colorIcono;
  final String valor;
  final String titulo;
  final bool esIncremento;
  final bool isDarkMode;

  const TarjetaEstadistica({
    super.key,
    required this.icono,
    required this.colorIcono,
    required this.valor,
    required this.titulo,
    required this.esIncremento,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorTendencia = esIncremento
        ? const Color(0xFF22C55E)
        : const Color(0xFFEF4444);

    final cardBg = isDarkMode ? const Color(0xFF1E2A3A) : Colors.white;
    final borderColor = isDarkMode
        ? colorIcono.withValues(alpha: 0.35)
        : colorIcono.withValues(alpha: 0.25);
    final valueColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final labelColor = isDarkMode
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);
    final iconBg = isDarkMode
        ? colorIcono.withValues(alpha: 0.18)
        : colorIcono.withValues(alpha: 0.1);
    final trendBg = isDarkMode
        ? colorTendencia.withValues(alpha: 0.18)
        : colorTendencia.withValues(alpha: 0.1);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: isDarkMode
            ? [
                BoxShadow(
                  color: colorIcono.withValues(alpha: 0.12),
                  blurRadius: 16,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icono, color: colorIcono, size: 20),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: trendBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    esIncremento
                        ? Icons.trending_up_rounded
                        : Icons.trending_down_rounded,
                    color: colorTendencia,
                    size: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              valor,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: valueColor,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              titulo,
              style: TextStyle(
                color: labelColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
