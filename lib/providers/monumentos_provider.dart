import 'package:audioguia_web/services/api_service.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import '../models/monumento_model.dart';

class NuevoMonumentoProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  // Datos de los archivos en memoria para Flutter Web
  Uint8List? _imagenBytes;
  String? _imagenNombre;
  Uint8List? _audioBytes;
  String? _audioNombre;

  Uint8List? get imagenBytes => _imagenBytes;
  String? get imagenNombre => _imagenNombre;
  Uint8List? get audioBytes => _audioBytes;
  String? get audioNombre => _audioNombre;

  // Método para seleccionar la imagen
  Future<void> seleccionarImagen() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      withData: true, // Crucial en Web para obtener los bytes
    );

    if (result != null && result.files.single.bytes != null) {
      _imagenBytes = result.files.single.bytes;
      _imagenNombre = result.files.single.name;
      notifyListeners();
    }
  }

  // Método para seleccionar el audio
  Future<void> seleccionarAudio() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'm4a'],
      withData: true, // Crucial en Web para obtener los bytes
    );

    if (result != null && result.files.single.bytes != null) {
      _audioBytes = result.files.single.bytes;
      _audioNombre = result.files.single.name;
      notifyListeners();
    }
  }

  // Limpiar selección
  void limpiarArchivos() {
    _imagenBytes = null;
    _imagenNombre = null;
    _audioBytes = null;
    _audioNombre = null;
    notifyListeners();
  }

  // Método para guardar todo el monumento a través de la API
  Future<bool> guardarMonumento(Monumento monumento) async {
    _isSaving = true;
    notifyListeners();

    try {
      final exito = await _apiService.crearMonumento(
        monumento: monumento,
        imagenBytes: _imagenBytes,
        imagenNombre: _imagenNombre,
        audioBytes: _audioBytes,
        audioNombre: _audioNombre,
      );
      
      if (exito) limpiarArchivos();
      return exito;
    } catch (e) {
      _isSaving = false;
      notifyListeners();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}