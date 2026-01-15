// Libraries
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local Imports
import '../../../core/const/functions.dart';
import '../../../core/const/theme.dart';
import '../../../data/models/income.dart';
import '../view/income.dart';

class CardIncome extends StatelessWidget {
  const CardIncome({super.key, required this.inc});
  final Income inc;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: () => Get.to(() => ViewIncome(inc: inc)),
        leading: Icon(Icons.monetization_on_outlined, color: AppTheme.primary),
        title: Text(
          formatDate(inc.date),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          "Total: ${formatKwanza(inc.totalIncome())}",
          style: const TextStyle(fontSize: 14),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}
