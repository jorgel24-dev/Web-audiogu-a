import 'package:flutter/material.dart';

/// Valores por defecto de cada funcionalidad.
class _Defaults {
  static const rutasTuristicas = true;
  static const asistenteIA = true;
  static const mapasInteractivos = true;
  static const notificacionesPush = false;
  static const audioGuias = true;
  static const creditos = true;
}

/// Provider que gestiona el estado de las funcionalidades configurables
/// de la aplicación móvil de Audioguía. Proviene de dev_ahmed.
class ConfiguracionProvider extends ChangeNotifier {
  bool rutasTuristicas = _Defaults.rutasTuristicas;
  bool asistenteIA = _Defaults.asistenteIA;
  bool mapasInteractivos = _Defaults.mapasInteractivos;
  bool notificacionesPush = _Defaults.notificacionesPush;
  bool audioGuias = _Defaults.audioGuias;
  bool creditos = _Defaults.creditos;

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

  /// Simula guardado asíncrono de la configuración.
  Future<bool> guardarConfiguracion() async {
    _cargando = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    _cargando = false;
    _hayPendientes = false;
    notifyListeners();
    return true;
  }

  /// Descarta los cambios pendientes y restaura valores por defecto.
  void descartarCambios() {
    rutasTuristicas = _Defaults.rutasTuristicas;
    asistenteIA = _Defaults.asistenteIA;
    mapasInteractivos = _Defaults.mapasInteractivos;
    notificacionesPush = _Defaults.notificacionesPush;
    audioGuias = _Defaults.audioGuias;
    creditos = _Defaults.creditos;
    _hayPendientes = false;
    notifyListeners();
  }
}
