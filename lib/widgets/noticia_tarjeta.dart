import 'package:flutter/material.dart';
import '../models/noticia_model.dart';

class NoticiaTarjeta extends StatelessWidget {
  final Noticia noticia;
  final bool seleccionada;
  final VoidCallback onTap;

  const NoticiaTarjeta({
    super.key,
    required this.noticia,
    required this.onTap,
    this.seleccionada = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: seleccionada ? 3 : 1,
        color: seleccionada
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08)
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: seleccionada
              ? BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.5,
                )
              : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _EtiquetaEstado(estado: noticia.estado),
                  Text(
                    _fechaRelativa(noticia.fechaPublicacion),
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                noticia.titular,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                noticia.subtitulo,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _fechaRelativa(DateTime? fecha) {
    if (fecha == null) return '';
    final ahora = DateTime.now();
    final diferencia = ahora.difference(fecha);

    if (diferencia.inMinutes < 60) {
      return 'Hoy, ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')} AM';
    } else if (diferencia.inDays == 0) {
      return 'Hoy';
    } else if (diferencia.inDays == 1) {
      return 'Ayer';
    } else if (diferencia.inDays < 7) {
      return 'Hace ${diferencia.inDays} días';
    } else {
      return 'Semana pasada';
    }
  }
}

class _EtiquetaEstado extends StatelessWidget {
  final EstadoNoticia estado;

  const _EtiquetaEstado({required this.estado});

  @override
  Widget build(BuildContext context) {
    final (Color color, String texto) = switch (estado) {
      EstadoNoticia.borrador  => (Colors.orange, 'BORRADOR'),
      EstadoNoticia.publicado => (Colors.green,  'PUBLICADO'),
      EstadoNoticia.archivado => (Colors.grey,   'ARCHIVADO'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        texto,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
