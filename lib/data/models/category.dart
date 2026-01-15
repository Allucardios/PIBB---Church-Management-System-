class Categories {
  int? id;
  String name;

  Categories({this.id, required this.name});

  factory Categories.fromJson(Map<String, dynamic> json) =>
      Categories(id: json['id'] ?? 0, name: json['name'] ?? '');

  Map<String, dynamic> toJson() => {'name': name};
}
