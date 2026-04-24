import 'dart:developer';

import 'package:audioguia_web/models/noticia_model.dart';
import 'package:flutter/material.dart';
import '../services/noticia_service.dart';

class NoticiasProvider extends ChangeNotifier {
  final NoticiaService _service = NoticiaService();
  
  List<Noticia> _noticias = [];
  Noticia? _noticiaSeleccionada;
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  List<Noticia> get noticias => _noticias;
  Noticia? get noticiaSeleccionada => _noticiaSeleccionada;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  // Noticias filtradas por búsqueda
  List<Noticia> get noticiasFiltradas {
    if (_searchQuery.isEmpty) {
      return _noticias;
    }
    return _noticias.where((noticia) {
      final query = _searchQuery.toLowerCase();
      return noticia.titulo.toLowerCase().contains(query) ||
          noticia.subtitulo.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> cargarNoticias() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      //_noticias = await _service.obtenerNoticias();
      _noticias = _service.obtenerNoticiasMock();
      _error = null;
    } catch (e) {
      _error = 'Error al cargar noticias: $e';
      print(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


 // Seleccionar una noticia para editar
  void seleccionarNoticia(Noticia noticia) {
    _noticiaSeleccionada = noticia;
    notifyListeners();
  }

  // Crear nueva noticia
  void crearNuevaNoticia() {
    _noticiaSeleccionada = Noticia(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: '',
      subtitulo: '',
      contenido: '',

      estado: EstadoNoticia.borrador,
      fechaCreacion: DateTime.now(),
    );
    notifyListeners();
  }

  // Guardar noticia
  Future<bool> guardarNoticia(Noticia noticia) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      Noticia? resultado;
      resultado = await _service.crearNoticia(noticia);
      if (resultado != null) {
        _noticias.insert(0, resultado);
        _noticiaSeleccionada = resultado;
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = 'Error al guardar la noticia';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error al guardar: $e';
      print(_error);
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Eliminar noticia
  Future<bool> eliminarNoticia(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _service.eliminarNoticia(id);
      
      if (success) {
        _noticias.removeWhere((n) => n.id == id);
        if (_noticiaSeleccionada?.id == id) {
          _noticiaSeleccionada = null;
        }
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = 'Error al eliminar la noticia';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error al eliminar: $e';
      print(_error);
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Actualizar query de búsqueda
  void actualizarBusqueda(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Limpiar selección
  void limpiarSeleccion() {
    _noticiaSeleccionada = null;
    notifyListeners();
  }
}
