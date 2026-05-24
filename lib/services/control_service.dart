import 'dart:convert';
import 'package:http/http.dart';
import '../models/control_model.dart';

class ControlService {
  final String _url = 'https://backend-tfg.fly.dev/api/v1';


  static const String nombreMonumentos = 'monuments';
  static const String nombreRutas = 'routes';
  static const String nombreIA = 'IA_Chatbox';
  static const String nombreNoticias = 'News';


  Future<List<ControlModel>?> obtenerTodos() async {
    try {
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
    } catch (e) {
      return null;
    }
  }


  Future<bool?> obtenerEstado(String nombre) async {
    try {
      final response = await get(
        Uri.parse('$_url/public/control/$nombre/status'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
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


  Future<ControlModel?> actualizarEstado(String nombre, bool activo, String authHeader) async {
    try {
      final response = await put(
        Uri.parse('$_url/admin/control/$nombre'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': authHeader,
        },
        body: jsonEncode({'active': activo}),
      );
      if (response.statusCode == 200) {
        return ControlModel.fromRawJson(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
