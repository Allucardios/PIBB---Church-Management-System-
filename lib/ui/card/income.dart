import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/const/functions.dart';
import '../../core/const/theme.dart';
import '../../data/models/income.dart';
import '../../data/providers/account_provider.dart';
import '../view/income.dart';

class CardIncome extends ConsumerWidget {
  const CardIncome({super.key, required this.inc});

  final Income inc;

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
        ).push(MaterialPageRoute(builder: (_) => ViewIncome(inc: inc))),
        leading: const Icon(
          Icons.monetization_on_outlined,
          color: AppTheme.primary,
          size: 30,
        ),
        title: Text(
          formatDate(inc.date),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total: ${formatKz(inc.totalIncome())}",
              style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
            ),
            accountsAsync.when(
              data: (accounts) {
                final acc = accounts
                    .where((a) => a.id == inc.accountId)
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
