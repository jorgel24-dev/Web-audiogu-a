import 'dart:convert';

class Noticia {
    String id;
    String titulo;
    String subtitulo;
    String contenido;
    int estado;
    dynamic fechaPublicacion;
    dynamic imagenUrl;
    DateTime createdAt;
    DateTime lastModified;

    Noticia({
        required this.id,
        required this.titulo,
        required this.subtitulo,
        required this.contenido,
        required this.estado,
        required this.fechaPublicacion,
        required this.imagenUrl,
        required this.createdAt,
        required this.lastModified,
    });

    factory Noticia.fromRawJson(String str) => Noticia.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Noticia.fromJson(Map<String, dynamic> json) => Noticia(
        id: json["id"].toString(),
        titulo: json["titulo"] ?? '',
        subtitulo: json["subtitulo"] ?? '',
        contenido: json["contenido"] ?? '',
        estado: json["estado"] ?? 0,
        fechaPublicacion: json["fecha_publicacion"],
        imagenUrl: json["imagen_url"],
        createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : DateTime.now(),
        lastModified: json["last_modified"] != null ? DateTime.parse(json["last_modified"]) : DateTime.now(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "titulo": titulo,
        "subtitulo": subtitulo,
        "contenido": contenido,
        "estado": estado,
        "fecha_publicacion": fechaPublicacion,
        "imagen_url": imagenUrl,
        "created_at": createdAt.toIso8601String(),
        "last_modified": lastModified.toIso8601String(),
    };
}
