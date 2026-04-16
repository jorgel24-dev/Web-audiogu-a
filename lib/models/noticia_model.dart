enum EstadoNoticia { borrador, publicado, archivado }

class Noticia {
  final String id;
  String titular;
  String subtitulo;
  String categoria;
  String cuerpo;
  DateTime? fechaPublicacion;
  EstadoNoticia estado;

  Noticia({
    required this.id,
    this.titular = '',
    this.subtitulo = '',
    this.categoria = '',
    this.cuerpo = '',
    this.fechaPublicacion,
    this.estado = EstadoNoticia.borrador,
  });

  static List<Noticia> get ejemplos => [
    Noticia(
      id: '1',
      titular: 'Festival de la Aceituna 2024',
      subtitulo:
          'Los preparativos para la gran fiesta anual del olivar martense ya están en marcha con nuevas actividades gastronómicas.',
      categoria: 'Cultura y Fiestas',
      cuerpo:
          'Este año el Festival de la Aceituna promete ser más espectacular que nunca. Martos, conocida como la cuna del olivar, se viste de gala para celebrar su producto estrella.',
      estado: EstadoNoticia.borrador,
      fechaPublicacion: DateTime.now(),
    ),
    Noticia(
      id: '2',
      titular: 'Ruta nocturna al Castillo',
      subtitulo:
          'Una experiencia única bajo las estrellas para descubrir la historia de la fortaleza.',
      categoria: 'Turismo',
      cuerpo: 'Descripción completa de la ruta nocturna al castillo...',
      estado: EstadoNoticia.publicado,
      fechaPublicacion: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Noticia(
      id: '3',
      titular: 'Nuevos horarios Museos',
      subtitulo:
          'Actualización de los horarios de visita para la temporada de otoño-invierno.',
      categoria: 'Cultura y Fiestas',
      cuerpo: 'Los museos municipales actualizan sus horarios...',
      estado: EstadoNoticia.publicado,
      fechaPublicacion: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Noticia(
      id: '4',
      titular: 'Feria de San Juan',
      subtitulo:
          'Resumen fotográfico de los mejores momentos de la feria de este año.',
      categoria: 'Eventos',
      cuerpo: 'La Feria de San Juan ha dejado momentos inolvidables...',
      estado: EstadoNoticia.archivado,
      fechaPublicacion: DateTime.now().subtract(const Duration(days: 7)),
    ),
  ];
}
