import 'dart:convert';
import 'package:http/http.dart';
import '../model/control_model.dart';
import '../config/api_config.dart';

class ControlService {
  String get _urlPublic => '${ApiConfig.baseUrl}/public/control';
  String get _urlAdmin => '${ApiConfig.baseUrl}/admin/control';

  static const String nombreMonumentos = 'monuments';
  static const String nombreRutas = 'routes';
  static const String nombreIA = 'IA_Chatbox';
  static const String nombreNoticias = 'News';

  Future<List<ControlModel>?> obtenerTodos() async {
    try {
      final response = await get(
        Uri.parse(_urlPublic),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> lista = json.decode(
          utf8.decode(response.bodyBytes),
        );
        return lista
            .map((item) => ControlModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool?> obtenerEstado(String nombre) async {
    try {
      final response = await get(
        Uri.parse('$_urlPublic/$nombre/status'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final body = json.decode(utf8.decode(response.bodyBytes));
        if (body is bool) return body;
        if (body is Map<String, dynamic>) {
          return body['active'] ?? body['activo'] ?? body['isActive'];
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<ControlModel?> actualizarEstado(
    String nombre,
    bool activo,
    String authHeader,
  ) async {
    try {
      final response = await put(
        Uri.parse('$_urlAdmin/$nombre'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': authHeader,
        },
        body: jsonEncode({'active': activo}),
      );
      if (response.statusCode == 200) {
        return ControlModel.fromJson(
          json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
