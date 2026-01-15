class Income {
  final int? id;
  final DateTime date;
  final DateTime? createdAt;

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
    date: DateTime.tryParse(json['date'] ?? "") ?? DateTime.now(), // SAFE
    createdAt:
        DateTime.tryParse(json['createdAt'] ?? "") ?? DateTime.now(), // SAFE
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
