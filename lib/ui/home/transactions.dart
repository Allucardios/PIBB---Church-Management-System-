import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/const/functions.dart';
import '../../data/models/account.dart';
import '../../data/providers/account_provider.dart';

class AccountTransactionsPage extends ConsumerWidget {
  final Account account;

  const AccountTransactionsPage({super.key, required this.account});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txsAsync = ref.watch(accountTransactionsStreamProvider(account.id!));

    return Scaffold(
      appBar: AppBar(title: Text('Movimentos: ${account.name}')),
      body: txsAsync.when(
        data: (txs) {
          if (txs.isEmpty) {
            return const Center(child: Text('Sem movimentos.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: txs.length,
            separatorBuilder: (context, index) =>
                const Divider(color: Colors.white54),
            itemBuilder: (context, index) {
              final tx = txs[index];
              final isPositive = tx.amount > 0;
              return Card(
                elevation: 2,
                child: ListTile(
                  leading: Icon(
                    isPositive ? Icons.add_circle : Icons.remove_circle,
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                  title: Text(tx.description, style: TextStyle(fontSize: 12)),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(tx.date),
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        formatKz(tx.amount),
                        style: TextStyle(
                          color: isPositive ? Colors.green : Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erro: $err')),
      ),
    );
  }
}
