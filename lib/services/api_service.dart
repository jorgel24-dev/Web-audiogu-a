import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'https://corsproxy.io/?https://backend-tfg.fly.dev/api/v1';

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
}