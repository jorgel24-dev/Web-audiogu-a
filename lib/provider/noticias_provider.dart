import 'package:flutter/material.dart';
import '../models/noticia_model.dart';

class NoticiasProvider extends ChangeNotifier {
  // Key que conecta el provider con el Form (igual que hace el profesor)
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Lista de noticias
  List<Noticia> _noticias = Noticia.ejemplos;

  // Noticia seleccionada actualmente en el editor
  Noticia? _noticiaSeleccionada;

  // Filtro activo: 'todos', 'publicado', 'borrador'
  String _filtroActivo = 'todos';

  // Texto de búsqueda
  String _textoBusqueda = '';

  // Estado de carga (para simular petición HTTP)
  bool _cargando = false;

  // ─── Campos del formulario (conectados con onChanged, como el profesor) ───
  String titular = '';
  String subtitulo = '';
  String categoria = '';
  String cuerpo = '';
  DateTime? fechaPublicacion;
  EstadoNoticia estadoEditor = EstadoNoticia.borrador;

  // ─── Getters ───
  bool get cargando => _cargando;
  String get filtroActivo => _filtroActivo;
  Noticia? get noticiaSeleccionada => _noticiaSeleccionada;

  List<Noticia> get noticiasFiltradas {
    List<Noticia> resultado = List.from(_noticias);

    // Filtrar por texto de búsqueda
    if (_textoBusqueda.isNotEmpty) {
      resultado = resultado
          .where(
            (n) =>
                n.titular.toLowerCase().contains(_textoBusqueda.toLowerCase()),
          )
          .toList();
    }

    // Filtrar por estado
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

  // ─── Métodos que actualizan los campos (patrón del profesor: onChanged) ───

  void setTitular(String value) {
    titular = value;
    // No llamamos notifyListeners para no reconstruir mientras se escribe
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

  // Cargar noticia en el editor al hacer tap
  void seleccionarNoticia(Noticia noticia) {
    _noticiaSeleccionada = noticia;

    // Rellenar los campos del formulario con los datos de la noticia
    titular = noticia.titular;
    subtitulo = noticia.subtitulo;
    categoria = noticia.categoria;
    cuerpo = noticia.cuerpo;
    fechaPublicacion = noticia.fechaPublicacion;
    estadoEditor = noticia.estado;

    notifyListeners();
  }

  // Limpiar el formulario para crear una noticia nueva
  void nuevaNoticia() {
    _noticiaSeleccionada = null;
    titular = '';
    subtitulo = '';
    categoria = '';
    cuerpo = '';
    fechaPublicacion = null;
    estadoEditor = EstadoNoticia.borrador;

    // Resetear el formKey para limpiar errores de validación
    formKey = GlobalKey<FormState>();

    notifyListeners();
  }

  // Guardar cambios (POST/PUT al servidor)
  Future<bool> guardarCambios() async {
    // Primero validamos el formulario (igual que el profesor)
    final esValido = formKey.currentState?.validate() ?? false;
    if (!esValido) return false;

    _cargando = true;
    notifyListeners();

    // Simulamos petición HTTP (como el profesor simula con Future.delayed)
    await Future.delayed(const Duration(seconds: 1));

    if (_noticiaSeleccionada != null) {
      // PUT - Actualizar noticia existente
      _noticiaSeleccionada!.titular = titular;
      _noticiaSeleccionada!.subtitulo = subtitulo;
      _noticiaSeleccionada!.categoria = categoria;
      _noticiaSeleccionada!.cuerpo = cuerpo;
      _noticiaSeleccionada!.fechaPublicacion = fechaPublicacion;
      _noticiaSeleccionada!.estado = estadoEditor;
    } else {
      // POST - Crear noticia nueva
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
}
