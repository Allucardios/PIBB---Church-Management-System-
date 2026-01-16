import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/responsive.dart';
import '../../data/models/account.dart';
import '../../data/providers/account_provider.dart';
import '../card/account.dart';
import '../view/balancebar.dart';

class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({super.key});

  @override
  ConsumerState<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  @override
  void initState() {
    super.initState();
    _checkInitialBalance();
  }

  Future<void> _checkInitialBalance() async {
    // Wait for the UI to be ready
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    final accounts = await ref.read(accountsStreamProvider.future);
    final caixa = accounts.firstWhere(
      (a) => a.id == 1,
      orElse: () => Account(name: 'Caixa', balance: 0),
    );

    // If Caixa is at 0 and has no transactions (other than potentially auto-created),
    // ask for real current balance.
    final txs = await ref.read(
      accountTransactionsStreamProvider(caixa.id ?? -1).future,
    );

    if (caixa.balance == 0 && txs.isEmpty) {
      if (mounted) _showInitialBalancePrompt(context, caixa.id!);
    }
  }

  void _showInitialBalancePrompt(BuildContext context, int accountId) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Configuração Inicial de Saldo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            const Text('Informe o saldo actual em Caixa para começar:'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Saldo em AKZ',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.account_balance_wallet_outlined),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              final val = double.tryParse(controller.text) ?? 0;
              await ref
                  .read(accountServiceProvider.notifier)
                  .setAccountBalance(accountId, val);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Guardar Saldo'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(accountsStreamProvider);
    final allTxsAsync = ref.watch(allTransactionsStreamProvider);
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Contas'),
        leading: isDesktop ? const SizedBox.shrink() : null,
      ),
      body: accountsAsync.when(
        data: (accounts) {
          if (accounts.isEmpty) {
            return const Center(child: Text('Nenhuma conta encontrada.'));
          }
          return allTxsAsync.when(
            data: (allTxs) {
              return Column(
                children: [
                  BalanceProgressBar(accounts: accounts, allTxs: allTxs),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: accounts.length,
                      itemBuilder: (context, index) {
                        final account = accounts[index];
                        final txs = allTxs
                            .where((t) => t.accountId == account.id)
                            .toList();
                        return AccountCard(account: account, txs: txs);
                      },
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) =>
                Center(child: Text('Erro ao carregar movimentos: $err')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erro: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAccountDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddAccountDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final balanceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova Conta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nome da Conta(Banco)',
              ),
            ),
            TextField(
              controller: balanceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Saldo Inicial'),
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
              final name = nameController.text.trim();
              final bal = double.tryParse(balanceController.text) ?? 0;
              if (name.isNotEmpty) {
                await ref
                    .read(accountServiceProvider.notifier)
                    .addAccount(Account(name: name, balance: bal));
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Criar'),
          ),
        ],
      ),
    );
  }
}
