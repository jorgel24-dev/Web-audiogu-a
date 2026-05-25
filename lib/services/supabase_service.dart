import 'dart:typed_data';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<String?> subirImagen(Uint8List bytes, String nombreArchivo) async {
    try {
      final extension = nombreArchivo.split('.').last;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final uniqueName = '${timestamp}_imagen.$extension';
      final ruta = uniqueName;

      await _client.storage
          .from('monumentos')
          .uploadBinary(
            ruta,
            bytes,
            fileOptions: FileOptions(
              contentType: _getContentType(extension),
              upsert: false,
            ),
          );

      final urlPublica = _client.storage.from('monumentos').getPublicUrl(ruta);
      return urlPublica;
    } catch (e) {
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