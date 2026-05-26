import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/dashboard_model.dart';
import '../provider/auth_provider.dart';
import '../config/api_config.dart';

class DashboardService {
  static String get baseUrlHttp => ApiConfig.baseUrl;

  Future<DashboardStats> obtenerStats() async {
    final anioActual = DateTime.now().year.toString();

    final resultados = await Future.wait([
      http.get(Uri.parse('$baseUrlHttp/public/monuments')),

      http.get(Uri.parse('$baseUrlHttp/public/news')),

      http.get(
        Uri.parse('$baseUrlHttp/admin/stats/summary?period=$anioActual'),
        headers: AuthProvider.headersAdmin,
      ),
    ]);

    final respMonumentos = resultados[0];
    final respNoticias = resultados[1];
    final respStats = resultados[2];

    int totalMonumentos = 0;
    int totalNoticias = 0;
    int totalDescargas = 0;
    double rating = 0.0;

    if (respMonumentos.statusCode == 200) {
      final lista = jsonDecode(respMonumentos.body) as List;

      totalMonumentos = lista.where((item) {
        if (item is Map<String, dynamic>) {
          return item['isActive'] == true;
        }
        return false;
      }).length;
    }

    if (respNoticias.statusCode == 200) {
      final lista = jsonDecode(respNoticias.body) as List;

      totalNoticias = lista.length;
    }

    if (respStats.statusCode == 200) {
      final lista = jsonDecode(respStats.body) as List;

      final general = lista.firstWhere(
        (item) => item['name'] == 'general',
        orElse: () => null,
      );

      if (general != null) {
        totalDescargas = (general['totalDownloads'] ?? 0).toInt();

        rating = (general['average_score'] ?? 0.0).toDouble();
      }
    }

    return DashboardStats(
      totalMonumentos: totalMonumentos,
      totalNoticias: totalNoticias,
      totalDescargas: totalDescargas,
      rating: rating,
    );
  }
}
