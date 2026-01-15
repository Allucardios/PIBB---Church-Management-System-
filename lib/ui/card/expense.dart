import 'package:flutter/material.dart';

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
    child: InkWell(
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => ViewExpense(exp: exp))),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.money_off_outlined, color: Color(0xFFFFB3BA)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    exp.obs ?? 'Sem descrição',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xBD000000),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Total: ${formatKwanza(exp.amount)}",
              style: const TextStyle(fontSize: 14, color: Colors.redAccent),
            ),
          ],
        ),
      ),
    ),
  );
}
