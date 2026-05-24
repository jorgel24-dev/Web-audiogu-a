import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Sube un archivo a Supabase Storage y devuelve la URL pública.
  Future<String?> subirImagen(Uint8List bytes, String nombreArchivo) async {
    try {
      final currentYear = DateTime.now().year.toString();
      // Generamos un nombre único para evitar colisiones
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = nombreArchivo.split('.').last;
      final uniqueName = '${timestamp}_$nombreArchivo';
      
      final ruta = '$currentYear/$uniqueName';

      await _client.storage.from('monumentos').uploadBinary(
            ruta,
            bytes,
            fileOptions: FileOptions(
              contentType: _getContentType(extension),
              upsert: true,
            ),
          );

      // Obtenemos la URL pública
      final urlPublica = _client.storage.from('monumentos').getPublicUrl(ruta);
      return urlPublica;
    } catch (e) {
      print('Error al subir imagen a Supabase: $e');
      return null;
    }
  }

  String _getContentType(String extension) {
    switch (extension.toLowerCase()) {
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'webp':
        return 'image/webp';
      case 'gif':
        return 'image/gif';
      default:
        return 'application/octet-stream';
    }
  }
}
