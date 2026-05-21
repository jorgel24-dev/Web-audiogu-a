import 'package:flutter/material.dart';
import '../models/noticia_model.dart';
import '../services/noticias_service.dart';

class NoticiasProvider extends ChangeNotifier {
  final NoticiasService _noticiasService = NoticiasService();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<Noticia> _noticias = [];

  Noticia? _noticiaSeleccionada;

  int _editorKey = 0;
  int get editorKey => _editorKey;

  String _filtroActivo = 'todos';
  String _textoBusqueda = '';

  bool _cargando = false;
  bool _modoCreacion = false;
  bool _cargandoLista = false;

  String? _error;

  String titulo = '';
  String subtitulo = '';
  String contenido = '';
  DateTime? fechaPublicacion;
  int estadoEditor = 0;

  bool get cargando => _cargando;
  bool get cargandoLista => _cargandoLista;
  String? get error => _error;
  String get filtroActivo => _filtroActivo;
  Noticia? get noticiaSeleccionada => _noticiaSeleccionada;
  bool get editorActivo => _noticiaSeleccionada != null || _modoCreacion;

  List<Noticia> get noticiasFiltradas {
    List<Noticia> resultado = List.from(_noticias);

    if (_textoBusqueda.isNotEmpty) {
      resultado = resultado
          .where(
            (n) =>
                n.titulo.toLowerCase().contains(_textoBusqueda.toLowerCase()),
          )
          .toList();
    }

    if (_filtroActivo == 'publicado') {
      resultado =
          resultado.where((n) => n.estado == 1).toList();
    } else if (_filtroActivo == 'borrador') {
      resultado =
          resultado.where((n) => n.estado == 0).toList();
    }

    return resultado;
  }

  // ─── Carga inicial del backend ─────────────────────────────────────────────

  Future<void> cargarNoticias() async {
    _cargandoLista = true;
    _error = null;
    notifyListeners();

    final lista = await _noticiasService.obtenerTodas();

    if (lista != null) {
      _noticias
        ..clear()
        ..addAll(lista);
    } else {
      _error = 'No se pudieron cargar las noticias del servidor.';
    }

    _cargandoLista = false;
    notifyListeners();
  }

  // ─── Setters de campos del editor ─────────────────────────────────────────

  void setTitulo(String value) {
    titulo = value;
  }

  void setSubtitulo(String value) {
    subtitulo = value;
  }

  void setContenido(String value) {
    contenido = value;
  }

  void setFechaPublicacion(DateTime? fecha) {
    fechaPublicacion = fecha;
    notifyListeners();
  }

  void setFiltro(String filtro) {
    _filtroActivo = filtro;
    notifyListeners();
  }

  void setBusqueda(String texto) {
    _textoBusqueda = texto;
    notifyListeners();
  }

  // ─── Selección y creación ──────────────────────────────────────────────────

  void seleccionarNoticia(Noticia noticia) {
    _noticiaSeleccionada = noticia;
    _modoCreacion = false;
    titulo = noticia.titulo;
    subtitulo = noticia.subtitulo;
    contenido = noticia.contenido;
    fechaPublicacion = noticia.fechaPublicacion;
    estadoEditor = noticia.estado;
    _editorKey++;
    notifyListeners();
  }

  void nuevaNoticia() {
    _noticiaSeleccionada = null;
    _modoCreacion = true;
    titulo = '';
    subtitulo = '';
    contenido = '';
    fechaPublicacion = null;
    estadoEditor = 0;
    _editorKey++;
    formKey = GlobalKey<FormState>();
    notifyListeners();
  }

  // ─── Guardar (crear o actualizar) ──────────────────────────────────────────

  Future<bool> guardarCambios() async {
    final esValido = formKey.currentState?.validate() ?? false;
    if (!esValido) return false;

    _cargando = true;
    _error = null;
    notifyListeners();

    bool exito = false;

    if (_noticiaSeleccionada != null) {
      final actualizada = await _noticiasService.actualizar(
        _noticiaSeleccionada!.id,
        titulo,
        subtitulo,
        contenido,
        estadoEditor,
        fechaPublicacion,
        _noticiaSeleccionada?.imagenUrl,
      );
      if (actualizada != null) {
        final index = _noticias.indexWhere((n) => n.id == actualizada.id);
        if (index != -1) _noticias[index] = actualizada;
        _noticiaSeleccionada = actualizada;
        exito = true;
      }
    } else {
      final creada = await _noticiasService.crear(
        titulo,
        subtitulo,
        contenido,
        estadoEditor,
        fechaPublicacion,
        null,
      );
      if (creada != null) {
        _noticias.insert(0, creada);
        _noticiaSeleccionada = creada;
        _modoCreacion = false;
        exito = true;
      }
    }

    _cargando = false;
    notifyListeners();
    return exito;
  }

  // ─── Cambiar estado ────────────────────────────────────────────────────────

  void cambiarEstado(int nuevoEstado) {
    estadoEditor = nuevoEstado;
    if (_noticiaSeleccionada != null) {
      _noticiaSeleccionada!.estado = nuevoEstado;
    }
    notifyListeners();
  }

  // ─── Eliminar noticia ──────────────────────────────────────────────────────

  Future<bool> eliminarNoticia() async {
    if (_noticiaSeleccionada == null) return false;

    _cargando = true;
    _error = null;
    notifyListeners();

    final ok = await _noticiasService.eliminar(_noticiaSeleccionada!.id);

    if (ok) {
      _noticias.removeWhere((n) => n.id == _noticiaSeleccionada!.id);
      _noticiaSeleccionada = null;
      _modoCreacion = false;
      titulo = '';
      subtitulo = '';
      contenido = '';
      fechaPublicacion = null;
      estadoEditor = 0;
      _editorKey++;
      _cargando = false;
      notifyListeners();
      return true;
    } else {
      _error = 'No se pudo eliminar la noticia.';
      _cargando = false;
      notifyListeners();
      return false;
    }
  }
}
