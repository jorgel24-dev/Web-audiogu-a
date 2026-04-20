import 'dart:convert';

enum EstadoNoticia { borrador, publicado, archivado }

class Noticia {
  final String id;
  final String titular;
  final String subtitulo;
  final String categoria;
  final String cuerpoJson;
  final DateTime? fechaPublicacion;
  final EstadoNoticia estado;

  const Noticia({
    required this.id,
    this.titular = '',
    this.subtitulo = '',
    this.categoria = '',
    this.cuerpoJson = '',
    this.fechaPublicacion,
    this.estado = EstadoNoticia.borrador,
  });

  Noticia copyWith({
    String? titular,
    String? subtitulo,
    String? categoria,
    String? cuerpoJson,
    DateTime? fechaPublicacion,
    EstadoNoticia? estado,
  }) {
    return Noticia(
      id: id,
      titular: titular ?? this.titular,
      subtitulo: subtitulo ?? this.subtitulo,
      categoria: categoria ?? this.categoria,
      cuerpoJson: cuerpoJson ?? this.cuerpoJson,
      fechaPublicacion: fechaPublicacion ?? this.fechaPublicacion,
      estado: estado ?? this.estado,
    );
  }

  static List<Noticia> get ejemplos => [
    Noticia(
      id: '1',
      titular: 'Festival de la Aceituna 2024',
      subtitulo:
          'Los preparativos para la gran fiesta anual del olivar martense ya están en marcha con nuevas actividades gastronómicas.',
      categoria: 'Cultura y Fiestas',
      cuerpoJson: jsonEncode([
        {
          "insert":
              "Este año el Festival de la Aceituna promete ser más espectacular que nunca. Martos, conocida como la cuna del olivar, se viste de gala para celebrar su producto estrella.\n",
        },
      ]),
      estado: EstadoNoticia.borrador,
      fechaPublicacion: DateTime.now(),
    ),
    Noticia(
      id: '2',
      titular: 'Ruta nocturna al Castillo',
      subtitulo:
          'Una experiencia única bajo las estrellas para descubrir la historia de la fortaleza.',
      categoria: 'Turismo',
      cuerpoJson: jsonEncode([
        {"insert": "Descripción completa de la ruta nocturna al castillo...\n"},
      ]),
      estado: EstadoNoticia.publicado,
      fechaPublicacion: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Noticia(
      id: '3',
      titular: 'Nuevos horarios Museos',
      subtitulo:
          'Actualización de los horarios de visita para la temporada de otoño-invierno.',
      categoria: 'Cultura y Fiestas',
      cuerpoJson: jsonEncode([
        {"insert": "Los museos municipales actualizan sus horarios...\n"},
      ]),
      estado: EstadoNoticia.publicado,
      fechaPublicacion: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Noticia(
      id: '4',
      titular: 'Feria de San Juan',
      subtitulo:
          'Resumen fotográfico de los mejores momentos de la feria de este año.',
      categoria: 'Eventos',
      cuerpoJson: jsonEncode([
        {"insert": "La Feria de San Juan ha dejado momentos inolvidables...\n"},
      ]),
      estado: EstadoNoticia.archivado,
      fechaPublicacion: DateTime.now().subtract(const Duration(days: 7)),
    ),
  ];
}
