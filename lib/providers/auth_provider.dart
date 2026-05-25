import 'dart:convert';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  static const String usuarioAdmin = 'admin';
  static const String passwordAdmin = 'admin123';

  bool cargando = false;
  String? error;
  bool autenticado = false;
  String nombreUsuario = '';

  static String get basicAuth {
    final credenciales = '$usuarioAdmin:$passwordAdmin';
    return 'Basic ${base64Encode(utf8.encode(credenciales))}';
  }

  static Map<String, String> get headersAdmin => {
        'Content-Type': 'application/json',
        'Authorization': basicAuth,
      };

  Future<bool> login(String nombre, String password) async {
    cargando = true;
    error = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    if (nombre.trim() == usuarioAdmin && password.trim() == passwordAdmin) {
      autenticado = true;
      nombreUsuario = nombre.trim();
      cargando = false;
      notifyListeners();
      return true;
    } else {
      error = 'Usuario o contraseña incorrectos';
      autenticado = false;
      cargando = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    autenticado = false;
    nombreUsuario = '';
    error = null;
    notifyListeners();
  }
}