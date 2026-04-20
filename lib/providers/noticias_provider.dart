import 'package:flutter/material.dart';
import '../models/noticia_model.dart';

class NoticiasProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<Noticia> _noticias = Noticia.ejemplos;

  Noticia? _noticiaSeleccionada;

  String _filtroActivo = 'todos';

  String _textoBusqueda = '';

  bool _cargando = false;
  bool _modoCreacion = false;

  String titular = '';
  String subtitulo = '';
  String categoria = '';
  String cuerpo = '';
  DateTime? fechaPublicacion;
  EstadoNoticia estadoEditor = EstadoNoticia.borrador;

  bool get cargando => _cargando;
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

  void seleccionarNoticia(Noticia noticia) {
    _noticiaSeleccionada = noticia;
    _modoCreacion = false;
    titular = noticia.titular;
    subtitulo = noticia.subtitulo;
    categoria = noticia.categoria;
    cuerpo = noticia.cuerpo;
    fechaPublicacion = noticia.fechaPublicacion;
    estadoEditor = noticia.estado;

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

    formKey = GlobalKey<FormState>();

    notifyListeners();
  }

  Future<bool> guardarCambios() async {
    final esValido = formKey.currentState?.validate() ?? false;
    if (!esValido) return false;

    _cargando = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (_noticiaSeleccionada != null) {
      _noticiaSeleccionada!.titular = titular;
      _noticiaSeleccionada!.subtitulo = subtitulo;
      _noticiaSeleccionada!.categoria = categoria;
      _noticiaSeleccionada!.cuerpo = cuerpo;
      _noticiaSeleccionada!.fechaPublicacion = fechaPublicacion;
      _noticiaSeleccionada!.estado = estadoEditor;
    } else {
      final nueva = Noticia(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        titular: titular,
        subtitulo: subtitulo,
        categoria: categoria,
        cuerpo: cuerpo,
        fechaPublicacion: fechaPublicacion,
        estado: estadoEditor,
      );
      _noticias.insert(0, nueva);
      _noticiaSeleccionada = nueva;
    }

    _cargando = false;
    notifyListeners();

    return true;
  }

  void cambiarEstado(EstadoNoticia nuevoEstado) {
    estadoEditor = nuevoEstado;
    if (_noticiaSeleccionada != null) {
      _noticiaSeleccionada!.estado = nuevoEstado;
    }
    notifyListeners();
  }

  void eliminarNoticia() {
    if (_noticiaSeleccionada == null) return;
    _noticias.removeWhere((n) => n.id == _noticiaSeleccionada!.id);
    _noticiaSeleccionada = null;
    _modoCreacion = false;
    titular = '';
    subtitulo = '';
    categoria = '';
    cuerpo = '';
    fechaPublicacion = null;
    estadoEditor = EstadoNoticia.borrador;
    notifyListeners();
  }
}
