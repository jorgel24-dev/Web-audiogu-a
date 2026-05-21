import 'package:http/http.dart';

class AuthService {
  final String _url = 'http://backend-tfg-escuchatuhistoria.onrender.com/api/v1';

  static const String _usuarioAdmin = 'admin';
  static const String _contrasenaAdmin = 'admin123';

  Future<ResultadoLogin> iniciarSesion(String usuario, String contrasena) async {
    if (usuario.trim() != _usuarioAdmin || contrasena != _contrasenaAdmin) {
      return ResultadoLogin.credencialesInvalidas;
    }

    try {
      final response = await get(
        Uri.parse('$_url/public/control'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) return ResultadoLogin.exito;
      return ResultadoLogin.errorServidor;
    } catch (_) {
      return ResultadoLogin.errorConexion;
    }
  }
}

enum ResultadoLogin { exito, credencialesInvalidas, errorServidor, errorConexion }
