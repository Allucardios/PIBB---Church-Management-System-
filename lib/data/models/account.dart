class Account {
  final int? id;
  final String name;
  final double balance; // Renamed from initialBalance
  final DateTime? createdAt;
  final String color; // Hex color string

  Account({
    this.id,
    required this.name,
    required this.balance,
    this.createdAt,
    this.color = '#0E5F5A', // Default color
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    id: json['id'],
    name: json['name'] ?? '',
    balance: (json['balance'] ?? 0).toDouble(),
    // Renamed from initial_balance
    createdAt: json['created_at'] != null
        ? DateTime.tryParse(json['created_at'])
        : null,
    color: json['color'] ?? '#0E5F5A',
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'balance': balance, // Renamed from initial_balance
    'color': color,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Account &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          color == other.color &&
          balance == other.balance;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ balance.hashCode ^ color.hashCode;
}
