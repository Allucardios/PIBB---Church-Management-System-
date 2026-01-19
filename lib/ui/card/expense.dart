import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/const/functions.dart';
import '../../data/models/expense.dart';
import '../../data/providers/account_provider.dart';
import '../view/expense.dart';

class CardExpense extends ConsumerWidget {
  const CardExpense({super.key, required this.exp});

  final Expense exp;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsStreamProvider);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: ListTile(
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => ViewExpense(exp: exp))),
        leading: const Icon(
          Icons.money_off_outlined,
          color: Color(0xFFFFB3BA),
          size: 30,
        ),
        title: Text(
          exp.obs ?? 'Sem descrição',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xBD000000),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total: ${formatKz(exp.amount)}",
              style: const TextStyle(fontSize: 14, color: Colors.redAccent),
            ),
            accountsAsync.when(
              data: (accounts) {
                final acc = accounts
                    .where((a) => a.id == exp.accountId)
                    .firstOrNull;
                if (acc == null) return const SizedBox.shrink();
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Color(
                      int.parse(acc.color.replaceFirst('#', '0xFF')),
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    acc.name,
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(
                        int.parse(acc.color.replaceFirst('#', '0xFF')),
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
