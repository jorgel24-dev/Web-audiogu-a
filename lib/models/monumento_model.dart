class Monumento {
  final String? id;
  final String nombre;
  final String descripcion;
  final String categoria;
  final String estado;
  final double latitud;
  final double longitud;
  final String? imagenUrl;
  final String? audioUrl;

  Monumento({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.categoria,
    required this.estado,
    required this.latitud,
    required this.longitud,
    this.imagenUrl,
    this.audioUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'categoria': categoria,
      'estado': estado,
      'latitud': latitud,
      'longitud': longitud,
      'imagenUrl': imagenUrl,
      'audioUrl': audioUrl,
    };
  }

  factory Monumento.fromJson(Map<String, dynamic> json) {
    return Monumento(
      id: json['id']?.toString(),
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      categoria: json['categoria'] ?? '',
      estado: json['estado'] ?? 'Publicado',
      latitud: (json['latitud'] as num).toDouble(),
      longitud: (json['longitud'] as num).toDouble(),
      imagenUrl: json['imagenUrl'],
      audioUrl: json['audioUrl'],
    );
  }
}