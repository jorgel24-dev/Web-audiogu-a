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
}