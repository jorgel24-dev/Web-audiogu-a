import 'package:flutter/material.dart';
import '../model/dashboard_model.dart';
import '../service/dashboard_service.dart';

class DashboardProvider extends ChangeNotifier {
  final DashboardService servicio = DashboardService();

  bool cargando = false;
  String? error;
  DashboardStats? stats;

  Future<void> cargarStats() async {
    cargando = true;
    error = null;
    notifyListeners();

    try {
      stats = await servicio.obtenerStats();
    } catch (e) {
      error = 'Error al cargar datos';
    }

    cargando = false;
    notifyListeners();
  }
}
