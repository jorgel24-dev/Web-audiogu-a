import 'dart:convert';
import 'dart:typed_data';
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

  Future<bool> crearMonumento({
    required Monumento monumento,
    required Uint8List? imagenBytes, 
    required String? imagenNombre,
    required Uint8List? audioBytes,  
    required String? audioNombre,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/admin/monuments');

      // Generamos la fecha actual en el formato ISO estándar que entiende Spring Boot
      final String fechaActual = DateTime.now().toIso8601String().substring(0, 19); // Cortamos a 'YYYY-MM-DDTHH:MM:SS'

      final Map<String, dynamic> bodyJson = {
        'name': monumento.nombre,
        'description': [], // El backend espera un List<Description> según el modelo
        'lat': double.tryParse(monumento.latitud.toString()) ?? 0.0,
        'lon': double.tryParse(monumento.longitud.toString()) ?? 0.0,
        'accessibility': monumento.accesible,
        'isActive': monumento.activo, 
        'maps_url': 'https://www.google.com/maps?q=${monumento.latitud},${monumento.longitud}',
        'tag': {
          'id': int.tryParse(monumento.categoria) ?? 1 // Pasa el objeto Tag con su ID correspondiente
        },
        'picture': [], // List<Picture> en blanco por ahora
        'audio': [],   // List<Audio> en blanco por ahora
        'localidad_id': 1, // Añade el id de localidad si tu tabla lo requiere obligatoriamente
        'NLikes': 0,
        'n_likes': 0,
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
  }
}