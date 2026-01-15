class Expense {
  final int? id;
  final String category;
  final double amount;
  final DateTime date;
  final String originType;
  final String? obs;
  final DateTime? createdAt;

  Expense({
    this.id,
    required this.category,
    required this.amount,
    required this.date,
    required this.originType,
    this.obs,
    this.createdAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
    id: json['id'] ?? 0,
    category: json['category'] ?? '',
    amount: (json['amount'] ?? 0).toDouble(),
    date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
    originType: json['origin_type'] ?? '',
    obs: json['obs'] ?? '',
    createdAt: DateTime.tryParse(json['createdAt'] ?? "") ?? DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    'category': category,
    'amount': amount,
    'date': date.toIso8601String(),
    'origin_type': originType,
    'obs': obs,
  };
}
