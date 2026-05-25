import 'package:audioguia_web/model/stats_model.dart';
import 'package:audioguia_web/service/api_service.dart';
import 'package:flutter/material.dart';

class RendimientoProvider with ChangeNotifier {
  final ApiService _apiService = ApiService(); 
  
  // Usamos el modelo StatsModel, pero lo llamamos _data para que coincida con la UI
  StatsModel? _data; 
  bool _isLoading = false;
  String? _error;

  StatsModel? get data => _data; 
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchRendimiento() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Vamos a separar las llamadas para saber cuál falla
      final descargas = await _apiService.obtenerDescargas();
      final rutas = await _apiService.obtenerRutasActivas();
      final ia = await _apiService.obtenerEstadisticasIA();
      final monuments = await _apiService.obtenerMonumentos();

      final List<dynamic> descargasData = descargas;
      final List<dynamic> iaData = ia;
      final List<dynamic> rutasData = rutas;
      final List<dynamic> monumentosData = monuments;

      // Suma total de descargas (buscamos el objeto con nombre "general")
      final general = descargasData.firstWhere((i) => i['name'] == 'general', orElse: () => {'totalDownloads': 0});
      int totalDescargas = general['totalDownloads'];

      // Consultas IA exitosas
      final iaExitosa = iaData.firstWhere((i) => i['nameCount'] == 'peticiones_completas', orElse: () => {'count': 0});
      int totalIA = iaExitosa['count'];

      // Actualizamos el modelo
      _data = StatsModel(
        totalUsuarios: totalDescargas,
        peticionesIA: totalIA,
        rutasActivas: rutasData.length,
        monumentosPopulares: monumentosData.map((m) => MonumentStat.fromJson(m)).toList(),
      );

    } catch (e) {
      print("¡ERROR CAPTURADO!: $e"); 
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}