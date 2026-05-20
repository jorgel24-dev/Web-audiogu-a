import 'dart:convert';

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

  // ─── Serialización ──────────────────────────────────────────────────────────

  factory Noticia.fromRawJson(String str) => Noticia.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Noticia.fromJson(Map<String, dynamic> json) => Noticia(
    id: (json['id'] ?? json['_id'] ?? '').toString(),
    titular: json['titular'] ?? json['title'] ?? '',
    subtitulo: json['subtitulo'] ?? json['subtitle'] ?? '',
    categoria: json['categoria'] ?? json['category'] ?? '',
    cuerpo: json['cuerpo'] ?? json['content'] ?? '',
    fechaPublicacion: json['fechaPublicacion'] != null
        ? DateTime.tryParse(json['fechaPublicacion'].toString())
        : null,
    estado: EstadoNoticiaParser.fromString(
      json['estado'] ?? json['status'] ?? 'borrador',
    ),
  );

  Map<String, dynamic> toJson() => {
    'titular': titular,
    'subtitulo': subtitulo,
    'categoria': categoria,
    'cuerpo': cuerpo,
    if (fechaPublicacion != null)
      'fechaPublicacion': fechaPublicacion!.toIso8601String(),
    'estado': estado.toApiString(),
  };

  // ─── Ejemplos locales (solo para el estado inicial vacío) ───────────────────

  static List<Noticia> get ejemplos => [];
}

// ─── Extensiones del enum ────────────────────────────────────────────────────

extension EstadoNoticiaX on EstadoNoticia {
  String toApiString() {
    switch (this) {
      case EstadoNoticia.publicado:
        return 'publicado';
      case EstadoNoticia.archivado:
        return 'archivado';
      case EstadoNoticia.borrador:
        return 'borrador';
    }
  }
}

extension EstadoNoticiaParser on EstadoNoticia {
  static EstadoNoticia fromString(dynamic valor) {
    switch (valor.toString().toLowerCase()) {
      case 'publicado':
      case 'published':
      case 'active':
        return EstadoNoticia.publicado;
      case 'archivado':
      case 'archived':
        return EstadoNoticia.archivado;
      default:
        return EstadoNoticia.borrador;
    }
  }
}
