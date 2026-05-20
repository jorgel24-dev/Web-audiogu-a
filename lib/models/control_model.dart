import 'dart:convert';

/// Modelo que representa una entrada de control del backend.
/// Ejemplo de respuesta: { "name": "routes", "active": true }
class ControlModel {
  final String name;
  final bool active;

  ControlModel({required this.name, required this.active});

  // ─── Serialización ──────────────────────────────────────────────────────────

  factory ControlModel.fromRawJson(String str) =>
      ControlModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ControlModel.fromJson(Map<String, dynamic> json) => ControlModel(
    name: json['name'] ?? json['nombre'] ?? '',
    active: json['active'] ?? json['activo'] ?? false,
  );

  Map<String, dynamic> toJson() => {'name': name, 'active': active};
}
