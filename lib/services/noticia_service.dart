import 'dart:convert';
import 'package:audioguia_web/models/noticia_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class NoticiaService {
  
  static String get baseUrl => 'http://localhost:3000/api'; // todo: poner endpoint cuando este listo
  
  // Obtener todas las noticias
  Future<List<Noticia>> obtenerNoticias() async {
    List<Noticia> noticias = [];
    Uri uri = Uri.parse('$baseUrl/noticias');
    Response response = await get(uri, headers: {
          'Content-Type': 'application/json',
          // TODO: Añadir autenticación si es necesaria
          // 'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode != 200) throw Exception('Error al cargar noticias: ${response.statusCode}');
      final List<dynamic> data = json.decode(response.body);
      noticias = data.map((json) => Noticia.fromJson(json)).toList();
      print(noticias);
      return noticias;
  } 

  
  Future<Noticia?> obtenerNoticiaPorId(String id) async {
    Noticia noticia;
    Uri uri = Uri.parse('$baseUrl/noticias/$id');
    Response response = await get(uri, headers: {
          'Content-Type': 'application/json',
          // TODO: Añadir autenticación si es necesaria
          // 'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode != 200) throw Exception('Error al cargar noticia: ${response.statusCode}');
      final dynamic data = json.decode(response.body);
      noticia = Noticia.fromJson(data);
      return noticia;
  }

  // Crear nueva noticia
  Future<Noticia?> crearNoticia(Noticia noticia) async {
    Noticia? nuevaNoticia;
    Uri uri = Uri.parse('$baseUrl/noticias');
    Response response = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
      }
    );
    if (response.statusCode != 200 || response.statusCode != 201) throw Exception('Error al crear noticia: ${response.statusCode}');
    final dynamic data = json.decode(response.body);
    nuevaNoticia = Noticia.fromJson(data);
    print(nuevaNoticia);
    return nuevaNoticia;
  }



  // Eliminar noticia
  Future<bool> eliminarNoticia(String id) async {

    Uri uri = Uri.parse('$baseUrl/noticias/$id');
    Response response = await delete(uri, headers: {
          'Content-Type': 'application/json',
      }
    );
    return response.statusCode == 200 || response.statusCode == 204;
  }

  // Datos de ejemplo (mock) para desarrollo
  List<Noticia> obtenerNoticiasMock() {
    return [
      Noticia(
        id: '1',
        titulo: 'Festival de la Aceituna 2024',
        subtitulo: 'Los preparativos para la gran fiesta anual del olivar marteño ya están en marcha con nuevas actividades gastronómicas.',
        contenido: '''Este año el Festival de la Aceituna promete ser más espectacular que nunca. Martos, conocida como la cuna del olivar, se viste de gala para celebrar su producto estrella.

Durante la semana del 8 al 10 de diciembre, los visitantes podrán disfrutar de:
- Degustaciones de los primeros aceites de la campaña.
- Visitas guiadas a las almazaras locales.
- Concursos de gastronomía tradicional.

"Es una oportunidad única para poner en valor nuestro oro líquido", declaró el concejal de turismo en la presentación del cartel oficial.''',
        estado: EstadoNoticia.borrador,
        fechaCreacion: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Noticia(
        id: '2',
        titulo: 'Ruta nocturna al Castillo',
        subtitulo: 'Las experiencias bajo las estrellas para descubrir la historia de la fortaleza.',
        contenido: 'Cada viernes, el Castillo de la Villa ofrece visitas nocturnas guiadas con recreaciones históricas.',
        estado: EstadoNoticia.publicado,
        fechaCreacion: DateTime.now().subtract(const Duration(days: 4)),
      ),
      Noticia(
        id: '3',
        titulo: 'Nuevos horarios Museos',
        subtitulo: 'Actualización de los horarios de visita para el tiempo de otoño-invierno.',
        contenido: 'Los museos municipales ajustan sus horarios para la temporada de otoño.',
        estado: EstadoNoticia.publicado,
        fechaCreacion: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Noticia(
        id: '4',
        titulo: 'Feria de San Juan',
        subtitulo: 'Resumen de los principales momentos de la feria de San Juan.',
        contenido: 'La feria de San Juan fue un éxito de participación con todos los vecinos.',
        estado: EstadoNoticia.archivado,
        fechaCreacion: DateTime.now().subtract(const Duration(days: 31)),
      ),
    ];
  }
}
