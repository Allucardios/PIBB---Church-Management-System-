import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/const/functions.dart';
import '../../data/models/expense.dart';
import '../view/expense.dart';

class CardExpense extends StatelessWidget {
  const CardExpense({super.key, required this.exp});
  final Expense exp;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: ListTile(
      onTap: () => Get.to(() => ViewExpense(exp: exp)),
      leading: Icon(Icons.money_off_outlined, color: Color(0xFFFFB3BA)),
      title: Text(
        exp.obs!,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Color(0xBD000000),
        ),
      ),
      subtitle: Text(
        "Total: ${formatKwanza(exp.amount)}",
        style: const TextStyle(fontSize: 14),
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
    ),
  );
}
