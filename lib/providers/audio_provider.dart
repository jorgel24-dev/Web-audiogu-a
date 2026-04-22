import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AudioProvider extends ChangeNotifier {
  PlatformFile? _selectedFile;
  bool _isUploading = false;

  PlatformFile? get selectedFile => _selectedFile;
  bool get isUploading => _isUploading;

  // Seleccionar archivo
  Future<void> pickAudio() async {
    try {
      // Usamos la sintaxis que te funciona a ti
      final result = await FilePicker.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
        withData: true, // Carga los bytes necesarios para la subida
      );

      if (result != null && result.files.isNotEmpty) {
        _selectedFile = result.files.first;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error al seleccionar audio: $e");
    }
  }

  // Lógica de subida (Simulada)
  Future<void> uploadAudio() async {
    if (_selectedFile == null) return;

    _isUploading = true;
    notifyListeners();

    // Aquí iría tu petición HTTP (POST) enviando los bytes: _selectedFile!.bytes
    await Future.delayed(const Duration(seconds: 2)); 

    _isUploading = false;
    _selectedFile = null;
    notifyListeners();
  }
}