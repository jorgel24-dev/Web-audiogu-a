import 'dart:convert';
import 'package:http/http.dart';
import '../models/noticia_model.dart';

class NoticiasService {
  final String _url = 'http://backend-tfg-escuchatuhistoria.onrender.com/api/v1';


  final Map<String, String> _headersAdmin = {
    'Content-Type': 'application/json',
    'Authorization': 'Basic ${base64Encode(utf8.encode('admin:admin123'))}',
  };


  Future<List<Noticia>?> obtenerTodas() async {
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
  }


  Future<Noticia?> obtenerPorId(String id) async {
    final response = await get(
      Uri.parse('$_url/public/news/$id'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return Noticia.fromRawJson(response.body);
    }
    return null;
  }


  Future<Noticia?> crear(
    String titulo,
    String subtitulo,
    String contenido,
    int estado,
    DateTime? fechaPublicacion,
    String? imagenUrl,
  ) async {
    final response = await post(
      Uri.parse('$_url/admin/news'),
      headers: _headersAdmin,
      body: jsonEncode({
        "titulo": titulo,
        "subtitulo": subtitulo,
        "contenido": contenido,
        "estado": estado,
        if (fechaPublicacion != null) "fecha_publicacion": fechaPublicacion.toIso8601String(),
        if (imagenUrl != null) "imagen_url": imagenUrl,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Noticia.fromRawJson(response.body);
    }
    return null;
  }

  Future<Noticia?> actualizar(
    String id,
    String titulo,
    String subtitulo,
    String contenido,
    int estado,
    DateTime? fechaPublicacion,
    String? imagenUrl,
  ) async {
    final response = await put(
      Uri.parse('$_url/admin/news/$id'),
      headers: _headersAdmin,
      body: jsonEncode({
        "titulo": titulo,
        "subtitulo": subtitulo,
        "contenido": contenido,
        "estado": estado,
        if (fechaPublicacion != null) "fecha_publicacion": fechaPublicacion.toIso8601String(),
        if (imagenUrl != null) "imagen_url": imagenUrl,
      }),
    );
    if (response.statusCode == 200) {
      return Noticia.fromRawJson(response.body);
    }
    return null;
  }


  Future<bool> eliminar(String id) async {
    final response = await delete(
      Uri.parse('$_url/admin/news/$id'),
      headers: _headersAdmin,
    );

    return response.statusCode == 204 || response.statusCode == 200;
  }
}
