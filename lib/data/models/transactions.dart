class AccountTransaction {
  final int? id;
  final int accountId;
  final double amount;
  final String type; // 'income', 'expense', 'transfer'
  final String description;
  final DateTime date;
  final int? referenceId; // Link to income or expense id

  AccountTransaction({
    this.id,
    required this.accountId,
    required this.amount,
    required this.type,
    required this.description,
    required this.date,
    this.referenceId,
  });

  factory AccountTransaction.fromJson(Map<String, dynamic> json) =>
      AccountTransaction(
        id: json['id'],
        accountId: json['account_id'],
        amount: (json['amount'] ?? 0).toDouble(),
        type: json['type'] ?? '',
        description: json['description'] ?? '',
        date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
        referenceId: json['reference_id'],
      );

  Map<String, dynamic> toJson() => {
    'account_id': accountId,
    'amount': amount,
    'type': type,
    'description': description,
    'date': date.toIso8601String(),
    'reference_id': referenceId,
  };
}
