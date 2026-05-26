import 'dart:convert';
import 'package:http/http.dart';
import '../model/noticia_model.dart';
import '../config/api_config.dart';

class NoticiaService {
  String get _url => ApiConfig.baseUrl;

  Future<List<Noticia>?> obtenerTodas() async {
    try {
      final response = await get(
        Uri.parse('$_url/public/news'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> lista = json.decode(response.body);
        return lista
            .map((item) => Noticia.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Noticia?> obtenerPorId(String id) async {
    try {
      final response = await get(
        Uri.parse('$_url/public/news/$id'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return Noticia.fromRawJson(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Noticia?> crear(
    String titulo,
    String subtitulo,
    String contenido,
    int estado,
    DateTime? fechaPublicacion,
    String? imagenUrl,
    String authHeader,
  ) async {
    try {
      final response = await post(
        Uri.parse('$_url/admin/news'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': authHeader,
        },
        body: jsonEncode({
          "titulo": titulo,
          "subtitulo": subtitulo,
          "contenido": contenido,
          "estado": estado,
          if (fechaPublicacion != null)
            "fecha_publicacion": fechaPublicacion.toIso8601String(),
          if (imagenUrl != null) "imagen_url": imagenUrl,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Noticia.fromRawJson(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Noticia?> actualizar(
    String id,
    String titulo,
    String subtitulo,
    String contenido,
    int estado,
    DateTime? fechaPublicacion,
    String? imagenUrl,
    String authHeader,
  ) async {
    try {
      final response = await put(
        Uri.parse('$_url/admin/news/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': authHeader,
        },
        body: jsonEncode({
          "titulo": titulo,
          "subtitulo": subtitulo,
          "contenido": contenido,
          "estado": estado,
          if (fechaPublicacion != null)
            "fecha_publicacion": fechaPublicacion.toIso8601String(),
          if (imagenUrl != null) "imagen_url": imagenUrl,
        }),
      );
      if (response.statusCode == 200) {
        return Noticia.fromRawJson(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> eliminar(String id, String authHeader) async {
    try {
      final response = await delete(
        Uri.parse('$_url/admin/news/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': authHeader,
        },
      );

      return response.statusCode == 204 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
