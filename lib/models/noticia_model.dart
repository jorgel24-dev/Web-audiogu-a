import 'package:flutter/material.dart';

class Noticia {
  final String id;
  final String titulo;
  final String subtitulo;
  final String contenido;
  final EstadoNoticia estado;
  final DateTime? fechaCreacion;

  Noticia({
    required this.id,
    required this.titulo,
    required this.subtitulo,
    required this.contenido,
    required this.estado,
    this.fechaCreacion,
  });

  // Constructor desde JSON (para backend)
  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      subtitulo: json['subtitulo'] as String,
      contenido: json['contenido'] as String,
      estado: EstadoNoticia.values.firstWhere(
        (e) => e.toString().split('.').last == json['estado'],
        orElse: () => EstadoNoticia.borrador,
      ),
      fechaCreacion: json['fecha_creacion'] != null
          ? DateTime.parse(json['fecha_creacion'] as String)
          : null,
    );
  }

  // Convertir a JSON (para enviar al backend)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'subtitulo': subtitulo,
      'contenido': contenido,

      'estado': estado.toString().split('.').last,
      if (fechaCreacion != null)
        'fecha_creacion': fechaCreacion!.toIso8601String(),
    };
  }
}

enum EstadoNoticia {
  borrador,
  publicado,
  archivado,
}

extension EstadoNoticiaExtension on EstadoNoticia {
  String get displayName {
    switch (this) {
      case EstadoNoticia.borrador:
        return 'BORRADOR';
      case EstadoNoticia.publicado:
        return 'PUBLICADO';
      case EstadoNoticia.archivado:
        return 'ARCHIVADO';
    }
  }

  Color get color {
    switch (this) {
      case EstadoNoticia.borrador:
        return const Color(0xFFFFA726); // Naranja
      case EstadoNoticia.publicado:
        return const Color(0xFF66BB6A); // Verde
      case EstadoNoticia.archivado:
        return const Color(0xFF78909C); // Gris
    }
  }
}
