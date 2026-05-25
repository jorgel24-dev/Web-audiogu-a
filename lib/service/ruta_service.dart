import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ruta_model.dart';

class RutasService {
  final String _urlPublic = 'https://backend-tfg.fly.dev/api/v1/public/route';
  final String _urlAdmin = 'https://backend-tfg.fly.dev/api/v1/admin/route';

  Future<List<RutaModel>?> obtenerTodas() async {
    try {
      final response = await http.get(Uri.parse(_urlPublic));
      if (response.statusCode == 200) {
        final List<dynamic> lista = json.decode(utf8.decode(response.bodyBytes));
        return lista
            .map((item) => RutaModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> toggleActiva(String id, String authHeader) async {
    try {
      final response = await http.patch(
        Uri.parse('$_urlAdmin/$id/activate'),
        headers: {
          'Authorization': authHeader,
          'Content-Type': 'application/json',
        },
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }
}
