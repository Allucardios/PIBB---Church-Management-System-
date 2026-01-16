class Income {
  final int? id;
  final DateTime date;
  final DateTime? createdAt;
  final int? accountId; // Destination account

  final double tithes;
  final double offerings;
  final double missions;
  final double pledged;
  final double special;
  final double other;

  final String? obs;

  Income({
    this.id,
    required this.date,
    this.createdAt,
    this.accountId,
    required this.tithes,
    required this.offerings,
    required this.missions,
    required this.pledged,
    required this.special,
    required this.other,
    this.obs,
  });

  factory Income.fromJson(Map<String, dynamic> json) => Income(
    id: json['id'] ?? 0,
    date: DateTime.tryParse(json['date'] ?? "") ?? DateTime.now(),
    createdAt:
        DateTime.tryParse(json['createdAt'] ?? "") ??
        DateTime.fromMillisecondsSinceEpoch(0),
    accountId: json['account_id'],
    tithes: (json['tithes'] ?? 0).toDouble(),
    offerings: (json['offerings'] ?? 0).toDouble(),
    missions: (json['missions'] ?? 0).toDouble(),
    pledged: (json['pledged'] ?? 0).toDouble(),
    special: (json['special'] ?? 0).toDouble(),
    other: (json['other'] ?? 0).toDouble(),
    obs: json['obs'],
  );

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'account_id': accountId,
    'tithes': tithes,
    'offerings': offerings,
    'missions': missions,
    'pledged': pledged,
    'special': special,
    'other': other,
    'obs': obs,
  };

  double totalIncome() =>
      tithes + offerings + missions + pledged + special + other;
}
