// Libraries
import 'package:flutter/material.dart';

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
      child: InkWell(
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => ViewIncome(inc: inc))),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.monetization_on_outlined,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      formatDate(inc.date),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Total: ${formatKwanza(inc.totalIncome())}",
                style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
