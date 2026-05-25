class Monumento {
  final String? id;
  final String nombre;
  final String descripcion;
  final String categoria;
  final bool accesible;   
  final bool activo;      
  final double latitud;
  final double longitud;
  final String? imagenUrl;
  final String? audioUrl;
  final int likes;

  Monumento({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.categoria,
    required this.accesible,
    required this.activo,
    required this.latitud,
    required this.longitud,
    this.imagenUrl,
    this.audioUrl,
    this.likes = 0,
  });

  // Este método genera la estructura exacta que espera tu Spring Boot
  Map<String, String> toBackendJson() {
    return {
      'name': nombre,
      'description': descripcion,
      'latitude': latitud.toString(),
      'longitude': longitud.toString(),
      'accessibility': accesible.toString(),
      'isActive': activo.toString(),
      'tagId': categoria, 
    };
  }

  factory Monumento.fromJson(Map<String, dynamic> json) {
    // 1. Manejo seguro de la descripción (por si viene como lista o string)
    var descData = json['description'];
    String descFinal = "";
    
    if (descData is List) {
      descFinal = descData.join('\n'); // Une los elementos de la lista con un salto de línea
    } else {
      descFinal = descData?.toString() ?? '';
    }

    return Monumento(
      id: json['id']?.toString(),
      nombre: json['name'] ?? '',
      descripcion: descFinal, // Usamos la variable procesada
      categoria: json['tag'] != null ? json['tag']['id'].toString() : '1',
      accesible: json['accessibility'] ?? false,
      activo: json['isActive'] ?? true,
      latitud: (json['lat'] ?? 0.0).toDouble(),
      longitud: (json['lon'] ?? 0.0).toDouble(),
      imagenUrl: json['picture'] != null && (json['picture'] as List).isNotEmpty 
                  ? json['picture'][0]['url'] : null,
      audioUrl: json['audio'] != null && (json['audio'] as List).isNotEmpty 
                  ? json['audio'][0]['url'] : null,
    );
  }
}