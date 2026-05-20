import 'package:flutter/material.dart';
import '../models/noticia_model.dart';
import '../services/noticias_service.dart';

/// Provider que gestiona el estado de la pantalla de noticias.
/// Se conecta al backend a través de [NoticiasService].
class NoticiasProvider extends ChangeNotifier {
  final NoticiasService _noticiasService = NoticiasService();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<Noticia> _noticias = [];

  Noticia? _noticiaSeleccionada;

  /// Clave que cambia cada vez que se abre un editor distinto.
  /// Permite reconstruir el estado del widget editor desde cero.
  int _editorKey = 0;
  int get editorKey => _editorKey;

  String _filtroActivo = 'todos';
  String _textoBusqueda = '';

  bool _cargando = false;
  bool _modoCreacion = false;
  bool _cargandoLista = false;

  String? _error;

  String titular = '';
  String subtitulo = '';
  String categoria = '';
  String cuerpo = '';
  DateTime? fechaPublicacion;
  EstadoNoticia estadoEditor = EstadoNoticia.borrador;

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
                n.titular.toLowerCase().contains(_textoBusqueda.toLowerCase()),
          )
          .toList();
    }

    if (_filtroActivo == 'publicado') {
      resultado =
          resultado.where((n) => n.estado == EstadoNoticia.publicado).toList();
    } else if (_filtroActivo == 'borrador') {
      resultado =
          resultado.where((n) => n.estado == EstadoNoticia.borrador).toList();
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

  void setTitular(String value) {
    titular = value;
  }

  void setSubtitulo(String value) {
    subtitulo = value;
  }

  void setCategoria(String value) {
    categoria = value;
    notifyListeners();
  }

  void setCuerpo(String value) {
    cuerpo = value;
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
    titular = noticia.titular;
    subtitulo = noticia.subtitulo;
    categoria = noticia.categoria;
    cuerpo = noticia.cuerpo;
    fechaPublicacion = noticia.fechaPublicacion;
    estadoEditor = noticia.estado;
    _editorKey++;
    notifyListeners();
  }

  void nuevaNoticia() {
    _noticiaSeleccionada = null;
    _modoCreacion = true;
    titular = '';
    subtitulo = '';
    categoria = '';
    cuerpo = '';
    fechaPublicacion = null;
    estadoEditor = EstadoNoticia.borrador;
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

    final noticiaParaEnviar = Noticia(
      id: _noticiaSeleccionada?.id ?? '',
      titular: titular,
      subtitulo: subtitulo,
      categoria: categoria,
      cuerpo: cuerpo,
      fechaPublicacion: fechaPublicacion,
      estado: estadoEditor,
    );

    bool exito = false;

    if (_noticiaSeleccionada != null) {
      // Actualizar existente → PUT /admin/news/{id}
      final actualizada = await _noticiasService.actualizar(
        _noticiaSeleccionada!.id,
        noticiaParaEnviar,
      );
      if (actualizada != null) {
        final index = _noticias.indexWhere((n) => n.id == actualizada.id);
        if (index != -1) _noticias[index] = actualizada;
        _noticiaSeleccionada = actualizada;
        exito = true;
      }
    } else {
      // Crear nueva → POST /admin/news
      final creada = await _noticiasService.crear(noticiaParaEnviar);
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

  void cambiarEstado(EstadoNoticia nuevoEstado) {
    estadoEditor = nuevoEstado;
    if (_noticiaSeleccionada != null) {
      _noticiaSeleccionada!.estado = nuevoEstado;
    }
    notifyListeners();
  }

  // ─── Eliminar noticia ──────────────────────────────────────────────────────

  Future<void> eliminarNoticia() async {
    if (_noticiaSeleccionada == null) return;

    _cargando = true;
    _error = null;
    notifyListeners();

    // DELETE /admin/news/{id}
    final ok = await _noticiasService.eliminar(_noticiaSeleccionada!.id);

    if (ok) {
      _noticias.removeWhere((n) => n.id == _noticiaSeleccionada!.id);
    } else {
      _error = 'No se pudo eliminar la noticia.';
    }

    _noticiaSeleccionada = null;
    _modoCreacion = false;
    titular = '';
    subtitulo = '';
    categoria = '';
    cuerpo = '';
    fechaPublicacion = null;
    estadoEditor = EstadoNoticia.borrador;
    _editorKey++;
    _cargando = false;
    notifyListeners();
  }
}
