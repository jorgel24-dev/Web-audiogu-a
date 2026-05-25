class AdminUser {
  final String id;
  final String email;
  final String nombre;
  final String token;

  AdminUser({
    required this.id,
    required this.email,
    required this.nombre,
    required this.token,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      nombre: json['nombre'] ?? json['name'] ?? 'Administrador',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'nombre': nombre,
        'token': token,
      };
}