import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:audioguia_web/model/monumento_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'https://backend-tfg.fly.dev/api/v1';

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Basic ${base64Encode(utf8.encode('admin:admin123'))}',
    'Access-Control-Allow-Origin': '*',
  };

  Future<List<dynamic>> obtenerEstadisticasIA() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/admin/stats/all-ia'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<List<dynamic>> obtenerRutasActivas() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/public/route?isActive=true'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<List<dynamic>> obtenerDescargas() async {
    final String anio = DateTime.now().year.toString();
    final response = await http.get(
      Uri.parse('$_baseUrl/admin/stats/summary?period=$anio'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<List<dynamic>> obtenerMonumentos() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/public/monuments?orderBy=desc'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<bool> crearMonumento({
    required Monumento monumento,
    String? imagenUrl,
    String? audioUrl,
    int localidadId = 1,
    List<String> description = const [],
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/admin/monuments');
      final String fechaActual = DateTime.now().toIso8601String().substring(
        0,
        19,
      );

      final Map<String, dynamic> bodyJson = {
        'name': monumento.nombre,
        'description': description,
        "coordenates": {"lon": monumento.longitud, "lat": monumento.latitud},
        'accessibility': monumento.accesible,
        'isActive': monumento.activo,
        'maps_url':
            'https://www.google.com/maps?q=${monumento.latitud},${monumento.longitud}',
        'tag': {'id': int.tryParse(monumento.categoria) ?? 1},
        "picture": imagenUrl != null
            ? [
                {"url": imagenUrl},
              ]
            : [],
        'audio': audioUrl != null
            ? [
                {
                  "url": audioUrl,
                  "kids": monumento.paraNinos,
                  "language": monumento.idioma,
                },
              ]
            : [],
        'localidad_id': localidadId,
        'NLikes': monumento.likes,
        'created_at': fechaActual,
        'last_modified': fechaActual,
      };

      debugPrint("Enviando JSON completo y corregido al backend...");

      final response = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode(bodyJson),
      );

      debugPrint(
        "Respuesta servidor crear: ${response.statusCode} - ${response.body}",
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Error al crear monumento: ${response.body}');
      }
    } catch (e) {
      debugPrint("Excepción en crearMonumento: $e");
      rethrow;
    }
  }

  Future<bool> editarMonumento(
    Monumento monumento, {
    int localidadId = 1,
    List<String> description = const [],
  }) async {
    final uri = Uri.parse('$_baseUrl/admin/monuments/${monumento.id}');
    final String fechaActual = DateTime.now().toIso8601String().substring(
      0,
      19,
    );
    final bodyMapeado = {
      "name": monumento.nombre,
      "coordenates": {"lon": monumento.longitud, "lat": monumento.latitud},
      "accessibility": monumento.accesible,
      "isActive": monumento.activo,
      "tag": {"id": int.tryParse(monumento.categoria) ?? 1},
      "maps_url":
          'https://www.google.com/maps?q=${monumento.latitud},${monumento.longitud}',
      "description": description,
      "picture": monumento.imagenUrl != null
          ? [
              {"url": monumento.imagenUrl},
            ]
          : [],

      "audio": monumento.audioUrl != null
          ? [
              {
                "url": monumento.audioUrl,
                "kids": monumento.paraNinos,
                "language": monumento.idioma,
              },
            ]
          : [],
      "localidad_id": localidadId,
      "NLikes": monumento.likes,
      "last_modified": fechaActual,
    };

    try {
      final response = await http.put(
        uri,
        headers: _headers,
        body: jsonEncode(bodyMapeado),
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      debugPrint("Error en editarMonumento HTTP: $e");
      return false;
    }
  }

  Future<bool> eliminarMonumento(String id) async {
    final uri = Uri.parse('$_baseUrl/admin/monuments/$id');
    final response = await http.delete(uri, headers: _headers);
    return response.statusCode == 200 || response.statusCode == 204;
  }

  Future<Monumento> obtenerMonumentoPorId(String id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/public/monuments/$id'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return Monumento.fromJson(json.decode(response.body));
    } else {
      throw Exception('No se pudo cargar el monumento');
    }
  }
}
