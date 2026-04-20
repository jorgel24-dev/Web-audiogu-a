import 'package:flutter/material.dart';
import '../models/noticia_model.dart';

class EditorState {
  final String titular;
  final String subtitulo;
  final String categoria;
  final String cuerpoJson;
  final DateTime? fechaPublicacion;
  final EstadoNoticia estadoNoticia;

  const EditorState({
    this.titular = '',
    this.subtitulo = '',
    this.categoria = '',
    this.cuerpoJson = '',
    this.fechaPublicacion,
    this.estadoNoticia = EstadoNoticia.borrador,
  });

  EditorState copyWith({
    String? titular,
    String? subtitulo,
    String? categoria,
    String? cuerpoJson,
    DateTime? fechaPublicacion,
    EstadoNoticia? estadoNoticia,
  }) {
    return EditorState(
      titular: titular ?? this.titular,
      subtitulo: subtitulo ?? this.subtitulo,
      categoria: categoria ?? this.categoria,
      cuerpoJson: cuerpoJson ?? this.cuerpoJson,
      fechaPublicacion: fechaPublicacion ?? this.fechaPublicacion,
      estadoNoticia: estadoNoticia ?? this.estadoNoticia,
    );
  }

  static EditorState fromNoticia(Noticia n) => EditorState(
    titular: n.titular,
    subtitulo: n.subtitulo,
    categoria: n.categoria,
    cuerpoJson: n.cuerpoJson,
    fechaPublicacion: n.fechaPublicacion,
    estadoNoticia: n.estado,
  );

  static const empty = EditorState();
}

class NoticiasProvider extends ChangeNotifier {
  final List<Noticia> _noticias = List.from(Noticia.ejemplos);

  Noticia? _noticiaSeleccionada;
  bool _modoCreacion = false;
  bool _cargando = false;
  String _filtroActivo = 'todos';
  String _textoBusqueda = '';
  EditorState _editor = EditorState.empty;

  bool get cargando => _cargando;
  String get filtroActivo => _filtroActivo;
  Noticia? get noticiaSeleccionada => _noticiaSeleccionada;
  bool get editorActivo => _noticiaSeleccionada != null || _modoCreacion;
  EditorState get editor => _editor;

  List<Noticia> get noticiasFiltradas {
    var resultado = List<Noticia>.from(_noticias);
    if (_textoBusqueda.isNotEmpty) {
      resultado = resultado
          .where(
            (n) =>
                n.titular.toLowerCase().contains(_textoBusqueda.toLowerCase()),
          )
          .toList();
    }
    if (_filtroActivo == 'publicado') {
      resultado = resultado
          .where((n) => n.estado == EstadoNoticia.publicado)
          .toList();
    } else if (_filtroActivo == 'borrador') {
      resultado = resultado
          .where((n) => n.estado == EstadoNoticia.borrador)
          .toList();
    }
    return resultado;
  }

  void setTitular(String v) {
    _editor = _editor.copyWith(titular: v);
  }

  void setSubtitulo(String v) {
    _editor = _editor.copyWith(subtitulo: v);
  }

  void setCategoria(String v) {
    _editor = _editor.copyWith(categoria: v);
    notifyListeners();
  }

  void setCuerpoJson(String json) {
    _editor = _editor.copyWith(cuerpoJson: json);
  }

  void setFechaPublicacion(DateTime? fecha) {
    _editor = _editor.copyWith(fechaPublicacion: fecha);
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

  void seleccionarNoticia(Noticia noticia) {
    _noticiaSeleccionada = noticia;
    _modoCreacion = false;
    _editor = EditorState.fromNoticia(noticia);
    notifyListeners();
  }

  void nuevaNoticia() {
    _noticiaSeleccionada = null;
    _modoCreacion = true;
    _editor = EditorState.empty;
    notifyListeners();
  }

  Future<bool> guardarCambios(GlobalKey<FormState> formKey) async {
    final esValido = formKey.currentState?.validate() ?? false;
    if (!esValido) return false;

    _cargando = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (_noticiaSeleccionada != null) {
      final idx = _noticias.indexWhere((n) => n.id == _noticiaSeleccionada!.id);
      if (idx != -1) {
        _noticias[idx] = _noticiaSeleccionada!.copyWith(
          titular: _editor.titular,
          subtitulo: _editor.subtitulo,
          categoria: _editor.categoria,
          cuerpoJson: _editor.cuerpoJson,
          fechaPublicacion: _editor.fechaPublicacion,
          estado: _editor.estadoNoticia,
        );
        _noticiaSeleccionada = _noticias[idx];
      }
    } else {
      final nueva = Noticia(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        titular: _editor.titular,
        subtitulo: _editor.subtitulo,
        categoria: _editor.categoria,
        cuerpoJson: _editor.cuerpoJson,
        fechaPublicacion: _editor.fechaPublicacion,
        estado: _editor.estadoNoticia,
      );
      _noticias.insert(0, nueva);
      _noticiaSeleccionada = nueva;
    }

    _cargando = false;
    notifyListeners();
    return true;
  }

  void cambiarEstado(EstadoNoticia nuevoEstado) {
    _editor = _editor.copyWith(estadoNoticia: nuevoEstado);
    if (_noticiaSeleccionada != null) {
      final idx = _noticias.indexWhere((n) => n.id == _noticiaSeleccionada!.id);
      if (idx != -1) {
        _noticias[idx] = _noticias[idx].copyWith(estado: nuevoEstado);
        _noticiaSeleccionada = _noticias[idx];
      }
    }
    notifyListeners();
  }

  void eliminarNoticia() {
    if (_noticiaSeleccionada == null) return;
    _noticias.removeWhere((n) => n.id == _noticiaSeleccionada!.id);
    _noticiaSeleccionada = null;
    _modoCreacion = false;
    _editor = EditorState.empty;
    notifyListeners();
  }
}
