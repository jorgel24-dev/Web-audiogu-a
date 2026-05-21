import 'package:flutter/material.dart';
import '../services/control_service.dart';

class ConfiguracionProvider extends ChangeNotifier {
  final ControlService _controlService = ControlService();

  bool rutasTuristicas = true;
  bool asistenteIA = true;
  bool mapasInteractivos = true;
  bool noticias = true;

  bool _hayPendientes = false;
  bool _cargando = false;
  bool _cargandoInicial = false;

  String? _error;

  bool get hayPendientes => _hayPendientes;
  bool get cargando => _cargando;
  bool get cargandoInicial => _cargandoInicial;
  String? get error => _error;



  Future<void> cargarConfiguracion() async {
    _cargandoInicial = true;
    _error = null;
    notifyListeners();

    final lista = await _controlService.obtenerTodos();

    if (lista != null) {
      for (final control in lista) {
        switch (control.name) {
          case ControlService.nombreRutas:
            rutasTuristicas = control.isActive;
            break;
          case ControlService.nombreIA:
            asistenteIA = control.isActive;
            break;
          case ControlService.nombreMonumentos:
            mapasInteractivos = control.isActive;
            break;
          case ControlService.nombreNoticias:
            noticias = control.isActive;
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



  void _toggle(bool value, void Function(bool) setter) {
    setter(value);
    _hayPendientes = true;
    notifyListeners();
  }

  void toggleRutas(bool v) => _toggle(v, (val) => rutasTuristicas = val);
  void toggleAsistenteIA(bool v) => _toggle(v, (val) => asistenteIA = val);
  void toggleMapas(bool v) => _toggle(v, (val) => mapasInteractivos = val);
  void toggleNoticias(bool v) => _toggle(v, (val) => noticias = val);

  Future<bool> guardarConfiguracion() async {
    _cargando = true;
    _error = null;
    notifyListeners();

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
      _controlService.actualizarEstado(
        ControlService.nombreNoticias,
        noticias,
      ),
    ]);

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

  void descartarCambios() {
    cargarConfiguracion();
  }
}
