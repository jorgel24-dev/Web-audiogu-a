import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/monumento_model.dart';

class MonumentosProvider with ChangeNotifier {
  bool _isSaving = false;
  bool get isSaving => _isSaving;

  final String _baseUrl = 'http://localhost:3000/api';

  Future<bool> guardarMonumento(Monumento monumento) async {
    _isSaving = true;
    notifyListeners();

    try {
      final url = Uri.parse('$_baseUrl/monumentos');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(monumento.toJson()),
      );

      _isSaving = false;
      notifyListeners();

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }
}