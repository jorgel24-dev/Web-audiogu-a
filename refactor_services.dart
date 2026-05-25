import 'dart:io';

void main() {
  var apiServiceFile = File('lib/service/api_service.dart');
  if (!apiServiceFile.existsSync()) return;
  var apiServiceContent = apiServiceFile.readAsStringSync();

  // 1. Create rendimiento_service.dart
  var rendimientoContent = apiServiceContent.replaceAll(
    'class ApiService {',
    'class RendimientoService {',
  );
  var indexCut = rendimientoContent.indexOf('  Future<bool> crearMonumento(');
  if (indexCut != -1) {
    rendimientoContent = rendimientoContent.substring(0, indexCut) + '}\n';
  }
  File(
    'lib/service/rendimiento_service.dart',
  ).writeAsStringSync(rendimientoContent);

  // 2. Refactor monumento_service.dart
  var monumentoContent = File(
    'lib/service/monumento_service.dart',
  ).readAsStringSync();
  var indexHeadersStart = apiServiceContent.indexOf(
    '  Map<String, String> get _headers => {',
  );
  var indexHeadersEnd = apiServiceContent.indexOf(
    '  Future<List<dynamic>> obtenerEstadisticasIA()',
  );
  var headersBlock = apiServiceContent.substring(
    indexHeadersStart,
    indexHeadersEnd,
  );

  var monumentosBlock = apiServiceContent.substring(
    indexCut,
    apiServiceContent.lastIndexOf('}'),
  );

  // Fix base URL usages to match MonumentoService
  monumentosBlock = monumentosBlock.replaceAll(
    '\$_baseUrl/admin/monuments',
    '\$_urlAdmin',
  );
  monumentosBlock = monumentosBlock.replaceAll(
    '\$_baseUrl/public/monuments',
    '\$_urlPublic',
  );

  if (!monumentoContent.contains('package:flutter/foundation.dart')) {
    monumentoContent =
        "import 'package:flutter/foundation.dart';\n" + monumentoContent;
  }

  var lastBrace = monumentoContent.lastIndexOf('}');
  var newMonumentoContent =
      monumentoContent.substring(0, lastBrace) +
      '\n' +
      headersBlock +
      '\n' +
      monumentosBlock +
      '\n}\n';
  File(
    'lib/service/monumento_service.dart',
  ).writeAsStringSync(newMonumentoContent);

  // 3. Update rendimiento_provider.dart
  var rProv = File('lib/provider/rendimiento_provider.dart').readAsStringSync();
  rProv = rProv.replaceAll('api_service.dart', 'rendimiento_service.dart');
  rProv = rProv.replaceAll('ApiService', 'RendimientoService');
  File('lib/provider/rendimiento_provider.dart').writeAsStringSync(rProv);

  // 4. Update monumentos_provider.dart
  var mProv = File('lib/provider/monumentos_provider.dart').readAsStringSync();
  mProv = mProv.replaceAll('api_service.dart', 'monumento_service.dart');
  mProv = mProv.replaceAll(
    'ApiService _apiService',
    'MonumentoService _monumentoService',
  );
  mProv = mProv.replaceAll('_apiService', '_monumentoService');
  mProv = mProv.replaceAll('ApiService()', 'MonumentoService()');
  File('lib/provider/monumentos_provider.dart').writeAsStringSync(mProv);

  // 5. Remove api_service.dart
  apiServiceFile.deleteSync();

  print('Refactoring completed!');
}
