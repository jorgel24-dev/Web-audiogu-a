class MonumentoModel {
  final String id;
  final String name;
  final bool isActive;

  MonumentoModel({
    required this.id,
    required this.name,
    required this.isActive,
  });

  factory MonumentoModel.fromJson(Map<String, dynamic> json) {
    return MonumentoModel(
      id: json['id'] as String,
      name: json['name'] as String,
      isActive: json['isActive'] as bool,
    );
  }
}
