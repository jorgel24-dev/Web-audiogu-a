import 'package:flutter/material.dart';

class TarjetaModulo extends StatelessWidget {
  final IconData icono;
  final Color colorTema;
  final String titulo;
  final String descripcion;
  final String textoEstado;
  final String textoAccion;
  final List<Widget> widgetsInferiores;
  final VoidCallback alPulsarAccion;
  final bool isDarkMode;

  const TarjetaModulo({
    super.key,
    required this.icono,
    required this.colorTema,
    required this.titulo,
    required this.descripcion,
    this.textoEstado = '',
    required this.textoAccion,
    required this.widgetsInferiores,
    required this.alPulsarAccion,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = isDarkMode ? const Color(0xFF1A2332) : Colors.white;
    final borderColor = isDarkMode
        ? Colors.white.withValues(alpha: 0.07)
        : Colors.grey.shade100;
    final titleColor = isDarkMode ? Colors.white : Colors.black87;
    final descColor = isDarkMode ? const Color(0xFF8899AA) : Colors.grey[500];
    final estadoColor = isDarkMode ? const Color(0xFF6B7A8D) : Colors.grey[400];

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: isDarkMode
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Container(width: 5, color: colorTema),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? colorTema.withValues(alpha: 0.15)
                              : colorTema.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icono, color: colorTema, size: 20),
                      ),
                      Text(
                        textoEstado,
                        style: TextStyle(
                          color: estadoColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    titulo,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    descripcion,
                    style: TextStyle(
                      color: descColor,
                      fontSize: 13,
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: widgetsInferiores),
                      TextButton(
                        onPressed: alPulsarAccion,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        child: Row(
                          children: [
                            Text(
                              textoAccion,
                              style: TextStyle(
                                color: colorTema,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: colorTema,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
