import 'dart:convert';

class ControlModel {
    int id;
    String name;
    bool isActive;
    DateTime createdAt;
    DateTime lastModified;

    ControlModel({
        required this.id,
        required this.name,
        required this.isActive,
        required this.createdAt,
        required this.lastModified,
    });

    factory ControlModel.fromRawJson(String str) => ControlModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ControlModel.fromJson(Map<String, dynamic> json) => ControlModel(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        isActive: json["isActive"] ?? json["is_active"] ?? false,
        createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : DateTime.now(),
        lastModified: json["last_modified"] != null ? DateTime.parse(json["last_modified"]) : DateTime.now(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "isActive": isActive,
        "created_at": createdAt.toIso8601String(),
        "last_modified": lastModified.toIso8601String(),
    };
}
