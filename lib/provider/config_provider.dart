import 'dart:convert';
import 'package:flutter/material.dart';
import '../service/control_service.dart';
import '../service/monumento_service.dart';
import '../service/ruta_service.dart';
import '../model/monumento_model.dart';
import '../model/ruta_model.dart';

class ConfiguracionProvider extends ChangeNotifier {
  final ControlService _controlService = ControlService();
  final MonumentoService _monumentosService = MonumentoService();
  final RutaService _rutasService = RutaService();

  bool rutasTuristicas = true;
  bool asistenteIA = true;
  bool mapasInteractivos = true;
  bool noticias = true;

  List<MonumentoModel> monumentos = [];
  List<RutaModel> rutas = [];

  Map<String, bool> _originalMonumentosState = {};
  Map<String, bool> _originalRutasState = {};

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

    final resultados = await Future.wait([
      _controlService.obtenerTodos(),
      _monumentosService.obtenerTodos(),
      _rutasService.obtenerTodas(),
    ]);

    final listaControl = resultados[0];
    final listaMonumentos = resultados[1] as List<MonumentoModel>?;
    final listaRutas = resultados[2] as List<RutaModel>?;

    if (listaControl != null) {
      for (final control in listaControl as Iterable<dynamic>) {
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
    } else {
      _error = 'No se pudo cargar la configuración del servidor.';
    }

    if (listaMonumentos != null) {
      monumentos = listaMonumentos;
      _originalMonumentosState = { for (var m in monumentos) m.id : m.isActive };
    }

    if (listaRutas != null) {
      rutas = listaRutas;
      _originalRutasState = { for (var r in rutas) r.id : r.isActive };
    }

    _hayPendientes = false;
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

  void toggleMonumento(String id, bool v) {
    final index = monumentos.indexWhere((m) => m.id == id);
    if (index != -1) {
      final old = monumentos[index];
      monumentos[index] = MonumentoModel(id: old.id, name: old.name, isActive: v);
      _hayPendientes = true;
      notifyListeners();
    }
  }

  void toggleRuta(String id, bool v) {
    final index = rutas.indexWhere((r) => r.id == id);
    if (index != -1) {
      final old = rutas[index];
      rutas[index] = RutaModel(id: old.id, name: old.name, isActive: v);
      _hayPendientes = true;
      notifyListeners();
    }
  }

  Future<bool> guardarConfiguracion() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    final authHeader = 'Basic ${base64Encode(utf8.encode('admin:admin123'))}';
    final List<Future<dynamic>> promesas = [];

    promesas.addAll([
      _controlService.actualizarEstado(ControlService.nombreRutas, rutasTuristicas, authHeader),
      _controlService.actualizarEstado(ControlService.nombreIA, asistenteIA, authHeader),
      _controlService.actualizarEstado(ControlService.nombreMonumentos, mapasInteractivos, authHeader),
      _controlService.actualizarEstado(ControlService.nombreNoticias, noticias, authHeader),
    ]);

    for (var m in monumentos) {
      if (_originalMonumentosState[m.id] != m.isActive) {
        promesas.add(_monumentosService.toggleActivo(m.id, authHeader));
      }
    }

    for (var r in rutas) {
      if (_originalRutasState[r.id] != r.isActive) {
        promesas.add(_rutasService.toggleActiva(r.id, authHeader));
      }
    }

    final resultados = await Future.wait(promesas);

    final exito = resultados.every((r) => r != null && r != false);

    if (exito) {
      _hayPendientes = false;
      _originalMonumentosState = { for (var m in monumentos) m.id : m.isActive };
      _originalRutasState = { for (var r in rutas) r.id : r.isActive };
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
