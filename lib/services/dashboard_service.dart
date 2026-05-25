import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/dashboard_model.dart';
import '../provider/auth_provider.dart';

class DashboardService {

  // URL base de la API
  static const String baseUrlHttp =
      'https://fly.io/apps/backend-tfg/api/v1';

  Future<DashboardStats> obtenerStats() async {

    final anioActual = DateTime.now().year.toString();

    // Se realizan varias peticiones al backend al mismo tiempo
    final resultados = await Future.wait([

      // Obtiene los monumentos
      http.get(
        Uri.parse('$baseUrlHttp/public/monuments'),
      ),

      // Obtiene las noticias
      http.get(
        Uri.parse('$baseUrlHttp/public/news'),
      ),

      // Obtiene el resumen de estadísticas
      http.get(
        Uri.parse('$baseUrlHttp/admin/stats/summary?period=$anioActual'),
        headers: AuthProvider.headersAdmin,
      ),
    ]);

    // Se guardan las respuestas de cada petición
    final respMonumentos = resultados[0];
    final respNoticias = resultados[1];
    final respStats = resultados[2];

    // Muestra información por consola para depuración
    print('MONUMENTOS: ${respMonumentos.statusCode}');
    print('NOTICIAS: ${respNoticias.statusCode} → ${respNoticias.body}');
    print('STATS: ${respStats.statusCode} → ${respStats.body}');

    // Variables donde se almacenarán los datos finales
    int totalMonumentos = 0;
    int totalNoticias = 0;
    int totalDescargas = 0;
    double rating = 0.0;

    // Si la petición de monumentos fue correcta
    if (respMonumentos.statusCode == 200) {

      // Convierte el JSON en una lista
      final lista = jsonDecode(respMonumentos.body) as List;

      // Cuenta el número de monumentos
      totalMonumentos = lista.length;
    }

    // Si la petición de noticias fue correcta
    if (respNoticias.statusCode == 200) {

      // Convierte el JSON en lista
      final lista = jsonDecode(respNoticias.body) as List;

      // Cuenta el número de noticias
      totalNoticias = lista.length;
    }

    // Si la petición de estadísticas fue correcta
    if (respStats.statusCode == 200) {

      // Convierte la respuesta JSON en lista
      final lista = jsonDecode(respStats.body) as List;

      // Busca el objeto llamado "general"
      final general = lista.firstWhere(
        (item) => item['name'] == 'general',
        orElse: () => null,
      );

      // Si existe el objeto general
      if (general != null) {

        // Obtiene el total de descargas
        totalDescargas = (general['totalDownloads'] ?? 0).toInt();

        // Obtiene la valoración media
        rating = (general['average_score'] ?? 0.0).toDouble();
      }
    }

    // Devuelve un objeto DashboardStats con todos los datos
    return DashboardStats(
      totalMonumentos: totalMonumentos,
      totalNoticias: totalNoticias,
      totalDescargas: totalDescargas,
      rating: rating,
    );
  }
}