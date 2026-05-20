import 'dart:convert';
import 'package:http/http.dart';
import '../models/control_model.dart';

/// Servicio de control que se conecta directamente con el backend.
///
/// Endpoints:
///   GET /public/control              → todos los controles
///   GET /public/control/{name}/status → estado de un control (true/false)
///   PUT /admin/control/{name}         → actualizar estado
///
/// Nombres válidos: monuments · routes · IA_Chatbox · News
///
/// ⚠️ Sin endpoint en el backend (solo locales de momento):
///   notifications · audioGuides · credits
class ControlService {
  final String _url = 'http://backend-tfg-escuchatuhistoria.onrender.com/api/v1';

  // Cabeceras de administrador (Basic Auth: admin / admin123)
  final Map<String, String> _headersAdmin = {
    'Content-Type': 'application/json',
    'Authorization': 'Basic ${base64Encode(utf8.encode('admin:admin123'))}',
  };

  // Nombres de control disponibles en el backend
  static const String nombreMonumentos = 'monuments';
  static const String nombreRutas = 'routes';
  static const String nombreIA = 'IA_Chatbox';
  static const String nombreNoticias = 'News';

  // ─── Obtener todos los controles ───────────────────────────────────────────

  Future<List<ControlModel>?> obtenerTodos() async {
    final response = await get(
      Uri.parse('$_url/public/control'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> lista = json.decode(response.body);
      return lista
          .map((item) => ControlModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return null;
  }

  // ─── Obtener estado de un control concreto ─────────────────────────────────

  Future<bool?> obtenerEstado(String nombre) async {
    final response = await get(
      Uri.parse('$_url/public/control/$nombre/status'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      // El backend devuelve true/false directamente o envuelto en objeto
      if (body is bool) return body;
      if (body is Map<String, dynamic>) {
        return body['active'] ?? body['activo'];
      }
    }
    return null;
  }

  // ─── Actualizar estado de un control ──────────────────────────────────────

  Future<ControlModel?> actualizarEstado(String nombre, bool activo) async {
    final response = await put(
      Uri.parse('$_url/admin/control/$nombre'),
      headers: _headersAdmin,
      body: jsonEncode({'active': activo}),
    );
    if (response.statusCode == 200) {
      return ControlModel.fromRawJson(response.body);
    }
    return null;
  }
}
