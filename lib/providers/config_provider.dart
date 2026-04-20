// lib/providers/configuracion_provider.dart

import 'package:flutter/material.dart';

class ConfiguracionProvider extends ChangeNotifier {
  bool rutasTuristicas = true;
  bool asistenteIA = true;
  bool mapasInteractivos = true;
  bool notificacionesPush = false;
  bool audioGuias = true;
  bool creditos = true; // nueva opción

  bool _hayPendientes = false;
  bool _cargando = false;

  bool get hayPendientes => _hayPendientes;
  bool get cargando => _cargando;

  void _toggle(bool value, void Function(bool) setter) {
    setter(value);
    _hayPendientes = true;
    notifyListeners();
  }

  void toggleRutas(bool v) => _toggle(v, (val) => rutasTuristicas = val);
  void toggleAsistenteIA(bool v) => _toggle(v, (val) => asistenteIA = val);
  void toggleMapas(bool v) => _toggle(v, (val) => mapasInteractivos = val);
  void toggleNotificaciones(bool v) =>
      _toggle(v, (val) => notificacionesPush = val);
  void toggleAudioGuias(bool v) => _toggle(v, (val) => audioGuias = val);
  void toggleCreditos(bool v) => _toggle(v, (val) => creditos = val);

  Future<bool> guardarConfiguracion() async {
    _cargando = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    _cargando = false;
    _hayPendientes = false;
    notifyListeners();
    return true;
  }

  void descartarCambios() {
    rutasTuristicas = true;
    asistenteIA = true;
    mapasInteractivos = true;
    notificacionesPush = false;
    audioGuias = true;
    creditos = true;
    _hayPendientes = false;
    notifyListeners();
  }
}
