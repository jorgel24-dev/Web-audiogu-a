class Monumento {
  final String? id;
  final String nombre;
  final String categoria;
  final bool accesible;   
  final bool activo;      
  final double latitud;
  final double longitud;
  final String? imagenUrl;
  final String? audioUrl;
  final int likes;
  final bool paraNinos; // AÑADIDO
  final String idioma;  // AÑADIDO

  Monumento({
    this.id,
    required this.nombre,
    required this.categoria,
    required this.accesible,
    required this.activo,
    required this.latitud,
    required this.longitud,
    required this.paraNinos, // AÑADIDO
    required this.idioma,    // AÑADIDO
    this.imagenUrl,
    this.audioUrl,
    this.likes = 0,
  });

  factory Monumento.fromJson(Map<String, dynamic> json) {
    return Monumento(
      id: json['id']?.toString(),
      nombre: json['name'] ?? '',
      categoria: json['tag'] != null ? json['tag']['id'].toString() : '1',
      accesible: json['accessibility'] ?? false,
      activo: json['isActive'] ?? true,
      latitud: (json['lat'] ?? 0.0).toDouble(),
      longitud: (json['lon'] ?? 0.0).toDouble(),
      imagenUrl: json['picture'] != null && (json['picture'] as List).isNotEmpty 
                  ? json['picture'][0]['url'] : null,
      audioUrl: json['audio'] != null && (json['audio'] as List).isNotEmpty 
                  ? json['audio'][0]['url'] : null,
      likes: json['NLikes'] ?? 0, // CORREGIDO: Ahora sí lee los likes del backend
      paraNinos: json['kids'] ?? false, // AÑADIDO: Mapeo de la API a Dart
      idioma: json['language'] ?? 'es',  // AÑADIDO: Mapeo de la API a Dart
    );
  }
}