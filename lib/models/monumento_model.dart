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
  final bool paraNinos;
  final String idioma;

  Monumento({
    this.id,
    required this.nombre,
    required this.categoria,
    required this.accesible,
    required this.activo,
    required this.latitud,
    required this.longitud,
    required this.paraNinos,
    required this.idioma,
    this.imagenUrl,
    this.audioUrl,
    this.likes = 0,
  });

  factory Monumento.fromJson(Map<String, dynamic> json) {
    // Extraemos las coordenadas de forma segura desde el mapa 'coordenates'
    final Map<String, dynamic>? coords = json['coordenates'];
    final double lat = coords != null ? (coords['lat'] ?? 0.0).toDouble() : 0.0;
    final double lon = coords != null ? (coords['lon'] ?? 0.0).toDouble() : 0.0;

    // Extraemos el primer audio si existe para recuperar sus propiedades hijas
    final List<dynamic>? listaAudios = json['audio'];
    final Map<String, dynamic>? primerAudio = (listaAudios != null && listaAudios.isNotEmpty) 
        ? listaAudios[0] as Map<String, dynamic>
        : null;

    return Monumento(
      id: json['id']?.toString(),
      nombre: json['name'] ?? '',
      categoria: json['tag'] != null ? json['tag']['id'].toString() : '1',
      accesible: json['accessibility'] ?? false,
      activo: json['isActive'] ?? true, 
      latitud: lat,
      longitud: lon,
      imagenUrl: json['picture'] != null && (json['picture'] as List).isNotEmpty 
                  ? json['picture'][0]['url'] : null,
      audioUrl: primerAudio != null ? primerAudio['url'] : null,
      likes: json['NLikes'] ?? 0,
      paraNinos: primerAudio != null ? (primerAudio['kids'] ?? false) : false, 
      idioma: primerAudio != null ? (primerAudio['language'] ?? 'es') : 'es',  
    );
  }
}