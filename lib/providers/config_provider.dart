import 'package:flutter/material.dart';
import '../services/control_service.dart';

/// Provider que gestiona el estado de las funcionalidades configurables
/// de la app móvil. Se conecta al backend a través de [ControlService].
///
/// ✅ Controles CON endpoint en el backend:
///   - Rutas Turísticas   → "routes"
///   - Asistente IA       → "IA_Chatbox"
///   - Mapas Interactivos → "monuments"
///
/// ⚠️ Controles SIN endpoint en el backend (solo locales por ahora):
///   - Notificaciones Push  (no existe /control/notifications)
///   - Audio Guías          (no existe /control/audioGuides)
///   - Créditos             (no existe /control/credits)
class ConfiguracionProvider extends ChangeNotifier {
  final ControlService _controlService = ControlService();

  // Controles con endpoint en el backend
  bool rutasTuristicas = true;
  bool asistenteIA = true;
  bool mapasInteractivos = true;

  bool _hayPendientes = false;
  bool _cargando = false;
  bool _cargandoInicial = false;

  String? _error;

  bool get hayPendientes => _hayPendientes;
  bool get cargando => _cargando;
  bool get cargandoInicial => _cargandoInicial;
  String? get error => _error;

  // ─── Carga inicial del backend ─────────────────────────────────────────────

  Future<void> cargarConfiguracion() async {
    _cargandoInicial = true;
    _error = null;
    notifyListeners();

    // GET /public/control → lista de todos los controles
    final lista = await _controlService.obtenerTodos();

    if (lista != null) {
      for (final control in lista) {
        switch (control.name) {
          case ControlService.nombreRutas:
            rutasTuristicas = control.active;
            break;
          case ControlService.nombreIA:
            asistenteIA = control.active;
            break;
          case ControlService.nombreMonumentos:
            mapasInteractivos = control.active;
            break;
        }
      }
      _hayPendientes = false;
    } else {
      _error = 'No se pudo cargar la configuración del servidor.';
    }

    _cargandoInicial = false;
    notifyListeners();
  }

  // ─── Toggles ───────────────────────────────────────────────────────────────

  void _toggle(bool value, void Function(bool) setter) {
    setter(value);
    _hayPendientes = true;
    notifyListeners();
  }

  void toggleRutas(bool v) => _toggle(v, (val) => rutasTuristicas = val);
  void toggleAsistenteIA(bool v) => _toggle(v, (val) => asistenteIA = val);
  void toggleMapas(bool v) => _toggle(v, (val) => mapasInteractivos = val);

  // ─── Guardar en el backend ─────────────────────────────────────────────────

  Future<bool> guardarConfiguracion() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    // Guardamos solo los controles que tienen endpoint
    final resultados = await Future.wait([
      _controlService.actualizarEstado(
        ControlService.nombreRutas,
        rutasTuristicas,
      ),
      _controlService.actualizarEstado(
        ControlService.nombreIA,
        asistenteIA,
      ),
      _controlService.actualizarEstado(
        ControlService.nombreMonumentos,
        mapasInteractivos,
      ),
    ]);

    // Si alguno devolvió null, hubo un error en esa petición
    final exito = resultados.every((r) => r != null);

    if (exito) {
      _hayPendientes = false;
    } else {
      _error = 'Error al guardar alguna configuración en el servidor.';
    }

    _cargando = false;
    notifyListeners();
    return exito;
  }

  // ─── Descartar cambios ─────────────────────────────────────────────────────

  void descartarCambios() {
    // Recargamos desde el backend para restaurar el estado real
    cargarConfiguracion();
  }
}
