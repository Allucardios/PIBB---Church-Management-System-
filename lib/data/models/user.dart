class Profile {
  final String? id;
  final String? name;
  final String? role;
  final String? img;
  final bool? active;
  final String? phone;
  final String? email;
  final DateTime? createdAt;

  final String level;

  Profile({
    this.id,
    this.name,
    this.role,
    this.img,
    this.active,
    this.phone,
    this.email,
    this.createdAt,
    required this.level,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    img: '',
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    phone: json['phone'] ?? '',
    email: json['email'] ?? '',
    createdAt:
        DateTime.tryParse(json['created_at'] ?? "") ??
        DateTime.fromMillisecondsSinceEpoch(0),
    role: json['role'] ?? 'Membro',
    level: json['level'] ?? 'User',
    active: json['active'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'email': email,
    'role': role,
    'level': level,
    'active': active,
  };

  Map<String, dynamic> toStorage() => {'img': img};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Profile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          role == other.role &&
          img == other.img &&
          active == other.active &&
          phone == other.phone &&
          email == other.email &&
          level == other.level &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      role.hashCode ^
      img.hashCode ^
      active.hashCode ^
      phone.hashCode ^
      email.hashCode ^
      level.hashCode ^
      createdAt.hashCode;
}
