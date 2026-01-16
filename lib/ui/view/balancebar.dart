import 'package:flutter/material.dart';

import '../../core/const/functions.dart';
import '../../data/models/account.dart';
import '../../data/models/transactions.dart';

class BalanceProgressBar extends StatelessWidget {
  const BalanceProgressBar({
    super.key,
    required this.accounts,
    required this.allTxs,
  });

  final List<Account> accounts;
  final List<AccountTransaction> allTxs;

  @override
  Widget build(BuildContext context) {
    Map<int, double> balances = {};
    double totalBalance = 0;

    for (var acc in accounts) {
      double bal = acc.balance;
      for (var tx in allTxs) {
        if (tx.accountId == acc.id && tx.description != 'Saldo Inicial') {
          bal += tx.amount;
        }
      }
      balances[acc.id!] = bal > 0 ? bal : 0; // Don't show negative in bar
      totalBalance += bal > 0 ? bal : 0;
    }

    if (totalBalance == 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Distribuição de Saldo: ${formatKz(totalBalance)}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 20,
              child: Row(
                children: accounts.map((acc) {
                  final bal = balances[acc.id] ?? 0;
                  final percentage = bal / totalBalance;
                  if (percentage == 0) return const SizedBox.shrink();

                  return Expanded(
                    flex: (percentage * 1000).toInt(),
                    child: Container(
                      color: Color(
                        int.parse(acc.color.replaceFirst('#', '0xFF')),
                      ),
                      child: Tooltip(
                        message:
                            '${acc.name}: ${(percentage * 100).toStringAsFixed(1)}%',
                        child: const SizedBox.expand(),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 12,
            children: accounts.map((acc) {
              final bal = balances[acc.id] ?? 0;
              if (bal <= 0) return const SizedBox.shrink();
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Color(
                        int.parse(acc.color.replaceFirst('#', '0xFF')),
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(acc.name, style: const TextStyle(fontSize: 10)),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
