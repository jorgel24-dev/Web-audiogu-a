import 'dart:convert';
import 'package:audioguia_web/models/monumento_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'https://backend-tfg.fly.dev/api/v1';

  // Helper para headers
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Basic ' + base64Encode(utf8.encode('admin:admin123')),
    'Access-Control-Allow-Origin': '*',
  };

  // Obtener Estadísticas IA
  Future<List<dynamic>> obtenerEstadisticasIA() async {
    final response = await http.get(Uri.parse('$_baseUrl/admin/stats/all-ia'), headers: _headers);

    // Imprime esto en la consola
    print("Respuesta IA: ${response.body}"); 

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  // Obtener rutas activas
  Future<List<dynamic>> obtenerRutasActivas() async {
    final response = await http.get(Uri.parse('$_baseUrl/public/route?isActive=true'), headers: _headers);

    // Imprime esto en la consola
    print("Respuesta rutas: ${response.body}"); 

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  // Obtener Descargas (el resumen general)
  Future<List<dynamic>> obtenerDescargas() async {
    final response = await http.get(Uri.parse('$_baseUrl/admin/stats/summary?period=2026'), headers: _headers);
    
    // Imprime esto en la consola
    print("Respuesta Descargas: ${response.body}"); 
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  // Obtener Monumentos
  Future<List<dynamic>> obtenerMonumentos() async {
    final response = await http.get(Uri.parse('$_baseUrl/public/monuments?orderBy=desc'), headers: _headers);

    print("Respuesta monumentos: ${response.body}"); 

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  /*Future<bool> crearMonumento({
    required Monumento monumento,
    String? imagenUrl,
    String? audioUrl,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/admin/monuments');
      final String fechaActual = DateTime.now().toIso8601String().substring(0, 19); // Cortamos a 'YYYY-MM-DDTHH:MM:SS'

      final Map<String, dynamic> bodyJson = {
        'name': monumento.nombre,
        'description': [], 
        "coordenates": {
            "lon": monumento.longitud,
            "lat": monumento.latitud,
          },
        'accessibility': monumento.accesible,
        'isActive': monumento.activo, 
        'maps_url': 'https://www.google.com/maps?q=${monumento.latitud},${monumento.longitud}',
        'tag': {
          'id': int.tryParse(monumento.categoria) ?? 1 // Pasa el objeto Tag con su ID correspondiente
        },
        //"picture" : [],
        //"audio" : [],
        "picture": imagenUrl != null ? [
            {
              "url" : imagenUrl,
              "createdAt": fechaActual,
              "lastModified": fechaActual
            } 
          ] : [],
        'audio': audioUrl != null ? [
          {
            "url": audioUrl,
            "kids": monumento.paraNinos,      // <-- OBLIGATORIO
            "language": monumento.idioma,     // <-- OBLIGATORIO
            "createdAt": fechaActual,
            "lastModified": fechaActual
          }
        ] : [],
        'localidad_id': 1, // Añade el id de localidad si tu tabla lo requiere obligatoriamente
        'NLikes': monumento.likes,
        'created_at': fechaActual, 
        'last_modified': fechaActual
      };

      print("Enviando JSON completo y corregido al backend...");
      
      final response = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode(bodyJson),
      );

      print("Respuesta servidor crear: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Error al crear monumento: ${response.body}');
      }
    } catch (e) {
      print("Excepción en crearMonumento: $e");
      rethrow;
    }
  }*/

  Future<bool> crearMonumento({
    required Monumento monumento,
    String? imagenUrl,
    String? audioUrl,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/admin/monuments');

      // Construimos el JSON respetando al 100% los tipos de datos de Spring Boot
      final Map<String, dynamic> bodyJson = {
        'name': monumento.nombre,
        // Las coordenadas como MÚMEROS, no como Strings
        'coordenates': {
          'lat': monumento.latitud,
          'lon': monumento.longitud
        },
        // Booleanos puros
        'accessibility': monumento.accesible,
        'isActive': monumento.activo,
        'maps_url': 'http://googleusercontent.com/maps.google.com/?q=${monumento.latitud},${monumento.longitud}',
        
        // Envolvemos el ID del Tag, asegurando que sea un INT entero
        'tag': {
          'id': int.tryParse(monumento.categoria) ?? 1
        },
        
        // La base de datos espera un array de objetos Picture
        'picture': imagenUrl != null ? [
          {
            'url': imagenUrl
          }
        ] : [],
        
        // La base de datos espera un array de objetos Audio
        'audio': audioUrl != null ? [
          {
            'url': audioUrl,
            'kids': monumento.paraNinos,
            'language': monumento.idioma
          }
        ] : [],
        
        // Arrays vacíos para evitar NullPointers en el backend
        'description': [],
        'localidad_id': 1,
        'NLikes': monumento.likes
      };

      print("Enviando JSON tipado correctamente al backend...");
      
      final response = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode(bodyJson),
      );

      print("Respuesta servidor crear: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Error HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print("Excepción en crearMonumento: $e");
      rethrow;
    }
  }

  // Editar (PUT)
  Future<bool> editarMonumento(Monumento monumento) async {
    final uri = Uri.parse('$_baseUrl/admin/monuments/${monumento.id}');

    final String fechaActual = DateTime.now().toIso8601String().substring(0, 19);
    
    // Mapeamos el modelo con los datos exactos que procesa el formulario
    final bodyMapeado = {
      "name": monumento.nombre,
      "coordenates": {
        "lon": monumento.longitud,
        "lat": monumento.latitud
      },
      "accessibility": monumento.accesible,
      "isActive": monumento.activo,
      "tag": {
        "id": int.tryParse(monumento.categoria) ?? 1 
      },
      "maps_url": 'https://www.google.com/maps?q=${monumento.latitud},${monumento.longitud}',
      "description": [], 
      "picture": [], // Se mantienen vacíos al haber eliminado la carga de imágenes
      "audio": [],   // Se mantienen vacíos al haber eliminado la carga de audios
      "localidad_id": 1, 
      "NLikes": monumento.likes,
      "last_modified": fechaActual
    };

    try {
      final response = await http.put(
        uri,
        headers: _headers,
        body: jsonEncode(bodyMapeado),
      );
      
      // Retorna true si el backend de Spring Boot responde con un 200 OK o 204 No Content
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print("Error en editarMonumento HTTP: $e");
      return false;
    }
  }

  // Eliminar (DELETE)
  Future<bool> eliminarMonumento(String id) async {
    final uri = Uri.parse('$_baseUrl/admin/monuments/$id');
    final response = await http.delete(uri, headers: _headers);
    return response.statusCode == 200 || response.statusCode == 204;
  }

  Future<Monumento> obtenerMonumentoPorId(String id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/public/monuments/$id'), // Asegúrate de que este endpoint exista
      headers: _headers,
    );

    if (response.statusCode == 200) {
      // Usas el factory desdeJson de tu modelo Monumento
      return Monumento.fromJson(json.decode(response.body));
    } else {
      throw Exception('No se pudo cargar el monumento');
    }
  }
}