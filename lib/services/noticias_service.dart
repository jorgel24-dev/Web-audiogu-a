import 'dart:convert';
import 'package:http/http.dart';
import '../models/noticia_model.dart';

/// Servicio de noticias que se conecta directamente con el backend.
///
/// Endpoints:
///   GET    /public/news         → lista de noticias
///   GET    /public/news/{id}    → noticia por ID
///   POST   /admin/news          → crear noticia
///   PUT    /admin/news/{id}     → actualizar noticia
///   DELETE /admin/news/{id}     → eliminar noticia (204 No Content)
class NoticiasService {
  final String _url = 'http://backend-tfg-escuchatuhistoria.onrender.com/api/v1';

  // Cabeceras de administrador (Basic Auth: admin / admin123)
  final Map<String, String> _headersAdmin = {
    'Content-Type': 'application/json',
    'Authorization': 'Basic ${base64Encode(utf8.encode('admin:admin123'))}',
  };

  // ─── Obtener todas las noticias ────────────────────────────────────────────

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

  // ─── Obtener noticia por ID ────────────────────────────────────────────────

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

  // ─── Crear noticia ─────────────────────────────────────────────────────────

  Future<Noticia?> crear(Noticia noticia) async {
    final response = await post(
      Uri.parse('$_url/admin/news'),
      headers: _headersAdmin,
      body: noticia.toRawJson(),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Noticia.fromRawJson(response.body);
    }
    return null;
  }

  // ─── Actualizar noticia ────────────────────────────────────────────────────

  Future<Noticia?> actualizar(String id, Noticia noticia) async {
    final response = await put(
      Uri.parse('$_url/admin/news/$id'),
      headers: _headersAdmin,
      body: noticia.toRawJson(),
    );
    if (response.statusCode == 200) {
      return Noticia.fromRawJson(response.body);
    }
    return null;
  }

  // ─── Eliminar noticia ──────────────────────────────────────────────────────

  Future<bool> eliminar(String id) async {
    final response = await delete(
      Uri.parse('$_url/admin/news/$id'),
      headers: _headersAdmin,
    );
    // 204 No Content = eliminado correctamente
    return response.statusCode == 204 || response.statusCode == 200;
  }
}
