class RutaModel {
  final String id;
  final String name;
  final bool isActive;

  RutaModel({required this.id, required this.name, required this.isActive});

  RutaModel copyWith({String? id, String? name, bool? isActive}) {
    return RutaModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
    );
  }

  factory RutaModel.fromJson(Map<String, dynamic> json) {
    return RutaModel(
      id: json['id'] as String,
      name: json['name'] as String,
      isActive: json['isActive'] as bool,
    );
  }
}
