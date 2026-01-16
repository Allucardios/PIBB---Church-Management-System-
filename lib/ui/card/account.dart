import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/const/theme.dart';
import '../../data/models/account.dart';
import '../../data/models/transactions.dart';
import '../../data/providers/account_provider.dart';
import '../home/transactions.dart';

class AccountCard extends ConsumerWidget {
  const AccountCard({super.key, required this.account, required this.txs});

  final Account account;
  final List<AccountTransaction> txs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double currentBalance = account.balance;
    for (var tx in txs) {
      if (tx.description != 'Saldo Inicial') {
        currentBalance += tx.amount;
      }
    }

    final accColor = Color(int.parse(account.color.replaceFirst('#', '0xFF')));
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: accColor.withOpacity(0.3), width: 1.5),
      ),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AccountTransactionsPage(account: account),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: accColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        account.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (account.name == 'Caixa')
                    IconButton(
                      icon: const Icon(Icons.send, color: AppTheme.primary),
                      onPressed: () =>
                          _showTransferDialog(context, ref, account),
                      tooltip: 'Transferir / Depositar',
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Saldo Atual: ${NumberFormat.currency(symbol: 'Kz ').format(currentBalance)}',
                style: TextStyle(
                  fontSize: 16,
                  color: currentBalance >= 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTransferDialog(
    BuildContext context,
    WidgetRef ref,
    Account fromAccount,
  ) {
    final accountsAsync = ref.read(accountsStreamProvider);
    final amountController = TextEditingController();
    final descController = TextEditingController();
    int? selectedToId;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Depositar / Transferir'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            accountsAsync.when(
              data: (accounts) {
                final otherAccounts = accounts
                    .where((a) => a.id != fromAccount.id)
                    .toList();
                return DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Conta Destino'),
                  items: otherAccounts
                      .map(
                        (a) =>
                            DropdownMenuItem(value: a.id, child: Text(a.name)),
                      )
                      .toList(),
                  onChanged: (val) => selectedToId = val,
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (err, _) => Text('Erro ao carregar contas'),
            ),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Valor'),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(amountController.text) ?? 0;
              if (selectedToId != null && amount > 0) {
                await ref
                    .read(accountServiceProvider.notifier)
                    .transferFunds(
                      fromId: fromAccount.id!,
                      toId: selectedToId!,
                      amount: amount,
                      description: descController.text,
                    );
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}
