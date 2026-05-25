class RutaModel {
  final String id;
  final String name;
  final bool isActive;

  RutaModel({required this.id, required this.name, required this.isActive});

  factory RutaModel.fromJson(Map<String, dynamic> json) {
    return RutaModel(
      id: json['id'] as String,
      name: json['name'] as String,
      isActive: json['isActive'] as bool,
    );
  }
}
