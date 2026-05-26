import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'https://backend-tfg.fly.dev/api/v1';
  
  static String get _adminUser => dotenv.env['API_ADMIN_USER'] ?? 'admin';
  static String get _adminPass => dotenv.env['API_ADMIN_PASS'] ?? 'admin123';
  
  static String get basicAuthHeader => 
      'Basic ${base64Encode(utf8.encode('$_adminUser:$_adminPass'))}';

  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> get adminHeaders => {
    ...defaultHeaders,
    'Authorization': basicAuthHeader,
  };
}
