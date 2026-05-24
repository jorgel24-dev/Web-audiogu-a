class RendimientoData {
  final String totalUsuarios;
  final String trendUsuarios;
  final String rutasCompletadas;
  final String trendRutas;
  final String consultasIA;
  final String trendIA;
  final List<MonumentoPopular> monumentosPopulares;
  final Map<String, double> usoFuncionalidades; // Ej: {'Guía Mapa': 0.45, ...}

  RendimientoData({
    required this.totalUsuarios,
    required this.trendUsuarios,
    required this.rutasCompletadas,
    required this.trendRutas,
    required this.consultasIA,
    required this.trendIA,
    required this.monumentosPopulares,
    required this.usoFuncionalidades,
  });

  factory RendimientoData.fromJson(Map<String, dynamic> json) {
    var monumentosJson = json['monumentosPopulares'] as List? ?? [];
    List<MonumentoPopular> monumentos = monumentosJson
        .map((m) => MonumentoPopular.fromJson(m))
        .toList();

    Map<String, double> uso = {};
    if (json['usoFuncionalidades'] != null) {
      (json['usoFuncionalidades'] as Map<String, dynamic>).forEach((key, value) {
        uso[key] = (value as num).toDouble();
      });
    }

    return RendimientoData(
      totalUsuarios: json['totalUsuarios'] ?? '0',
      trendUsuarios: json['trendUsuarios'] ?? '+0%',
      rutasCompletadas: json['rutasCompletadas'] ?? '0',
      trendRutas: json['trendRutas'] ?? '+0%',
      consultasIA: json['consultasIA'] ?? '0',
      trendIA: json['trendIA'] ?? '+0%',
      monumentosPopulares: monumentos,
      usoFuncionalidades: uso,
    );
  }
}

class MonumentoPopular {
  final String rank;
  final String nombre;
  final String estadisticas;
  final double progreso;
  final String porcentaje;

  MonumentoPopular({
    required this.rank,
    required this.nombre,
    required this.estadisticas,
    required this.progreso,
    required this.porcentaje,
  });

  factory MonumentoPopular.fromJson(Map<String, dynamic> json) {
    return MonumentoPopular(
      rank: json['rank'] ?? '00',
      nombre: json['nombre'] ?? '',
      estadisticas: json['estadisticas'] ?? '',
      progreso: (json['progreso'] as num? ?? 0.0).toDouble(),
      porcentaje: json['porcentaje'] ?? '0%',
    );
  }
}