// Libraries
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Local Imports
import '../../core/const/functions.dart';
import '../../core/const/theme.dart';
import '../../core/widgets/admin_gate.dart';
import '../../data/models/income.dart';
import '../../data/providers/account_provider.dart';
import '../../data/providers/finance_provider.dart';
import '../form/income.dart';

class ViewIncome extends ConsumerWidget {
  const ViewIncome({super.key, required this.inc});

  final Income inc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes da Receita"),
        centerTitle: true,
        actions: [
          PermitGate(
            value: 'Manager',
            child: IconButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => IncomeForm(income: inc)),
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
                      .deleteIncome(inc.id!);
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
                      .where((a) => a.id == inc.accountId)
                      .firstOrNull;
                  return _amountsCard(context, account?.name ?? 'Não definida');
                },
                loading: () => _amountsCard(context, 'Carregando...'),
                error: (_, __) => _amountsCard(context, 'Erro ao carregar'),
              ),
              _obsCard(),
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
        title: Text(formatDate(inc.date), style: const TextStyle(fontSize: 16)),
        subtitle: Text(
          "Registro Nº ${inc.id}",
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  // ---------------------------
  Widget _amountsCard(BuildContext context, String accountName) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Wrap(
            children: [
              _valueTile(context, "Dízimos", inc.tithes),
              _valueTile(context, "Ofertas", inc.offerings),
              _valueTile(context, "Missões", inc.missions),
              _valueTile(context, "Ofertas Alçadas", inc.pledged),
              _valueTile(context, "Ofertas Especiais", inc.special),
              _valueTile(context, "Outros", inc.other),
            ],
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.account_balance_wallet_outlined,
              color: AppTheme.primary,
            ),
            title: Text(accountName),
            subtitle: const Text("Conta de Destino"),
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
                  "Total: ${formatKz(inc.totalIncome())}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _obsCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Observação:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                inc.obs?.isNotEmpty == true
                    ? '=> ${inc.obs!}'
                    : "Nenhuma observação.",
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _valueTile(BuildContext context, String label, double value) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: size.width * .43,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.secondary.withOpacity(.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              "${formatKz(value)} ",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
