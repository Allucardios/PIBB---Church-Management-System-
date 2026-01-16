// Libraries
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Local Imports
import '../../core/const/functions.dart';
import '../../core/const/theme.dart';
import '../../core/widgets/admin_gate.dart';
import '../../data/models/expense.dart';
import '../../data/providers/account_provider.dart';
import '../../data/providers/finance_provider.dart';
import '../form/expense.dart';

class ViewExpense extends ConsumerWidget {
  const ViewExpense({super.key, required this.exp});

  final Expense exp;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes da Despesa"),
        centerTitle: true,
        actions: [
          PermitGate(
            value: 'Manager',
            child: IconButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ExpenseForm(expense: exp)),
              ),
              icon: const Icon(Icons.edit_outlined, color: AppTheme.primary),
            ),
          ),
          PermitGate(
            value: 'Manager',
            child: IconButton(
              onPressed: () async {
                final confirmed = await showYesNoDialog(
                  context: context,
                  title: "Confirmação",
                  message: "Tem certeza que deseja apagar este item?",
                );
                if (confirmed) {
                  await ref
                      .read(financeServiceProvider.notifier)
                      .deleteExpense(exp.id!);
                  if (context.mounted) Navigator.of(context).pop();
                }
              },
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            spacing: 8,
            children: [
              _headerCard(context),
              accountsAsync.when(
                data: (accounts) {
                  final account = accounts
                      .where((a) => a.id == exp.accountId)
                      .firstOrNull;
                  return _amountsCard(account?.name ?? 'Não definida');
                },
                loading: () => _amountsCard('Carregando...'),
                error: (_, __) => _amountsCard('Erro ao carregar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------
  Widget _headerCard(BuildContext ctx) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: const Icon(
          Icons.calendar_month_outlined,
          size: 40,
          color: AppTheme.primary,
        ),
        title: Text(formatDate(exp.date), style: const TextStyle(fontSize: 16)),
        subtitle: Text(
          "Registro Nº ${exp.id}",
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  // ---------------------------
  Widget _amountsCard(String accountName) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Wrap(
            children: [
              _valueTile(
                "Descrição",
                exp.obs ?? '',
                Icons.description_outlined,
              ),
              _valueTile("Categoria", exp.category, Icons.category_outlined),
              _valueTile(
                "Conta de Pagamento",
                accountName,
                Icons.account_balance_wallet_outlined,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Total: ${formatKz(exp.amount)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------
  Widget _valueTile(String label, String value, IconData icon) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
        color: AppTheme.secondary.withOpacity(.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primary),
        title: Text(value),
        subtitle: Text(label),
      ),
    ),
  );
}
