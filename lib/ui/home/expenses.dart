// Libraries
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// Local Imports
import '../../core/const/functions.dart';
import '../../core/widgets/admin_gate.dart';
import '../../core/widgets/responsive.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/finance_provider.dart';
import '../card/expense.dart';
import '../form/expense.dart';
import '../view/drawer.dart';

class ExpensePage extends ConsumerWidget {
  const ExpensePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(listExpenseStreamProvider);
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('D E S P E S A S'),
        leading: isDesktop ? const SizedBox.shrink() : null,
      ),
      drawer: isDesktop ? null : const MyDrawer(),
      body: SafeArea(
        child: expensesAsync.when(
          data: (expenses) {
            final total = expenses.fold(0.0, (sum, i) => sum + i.amount);
            return Column(
              children: [
                ///
                _periodSelector(ref, context, total),

                /// Lista de Despesas
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () =>
                        ref.refresh(listExpenseStreamProvider.future),
                    child: expenses.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [
                              SizedBox(height: 100),
                              Center(child: Text('Sem dados neste mês')),
                            ],
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Responsive(
                              mobile: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: expenses.length,
                                itemBuilder: (context, index) =>
                                    CardExpense(exp: expenses[index]),
                              ),
                              tablet: GridView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 3.0,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                itemCount: expenses.length,
                                itemBuilder: (context, index) =>
                                    CardExpense(exp: expenses[index]),
                              ),
                              desktop: GridView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      childAspectRatio: 3,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                itemCount: expenses.length,
                                itemBuilder: (context, index) =>
                                    CardExpense(exp: expenses[index]),
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) {
            if (error.toString().contains('invalidjwttoken')) {
              Future.microtask(
                () => ref.read(authServiceProvider.notifier).signOut(),
              );
              return const Center(child: Text('Sessão expirada.'));
            }
            return Center(child: Text('Erro: $error'));
          },
        ),
      ),
      floatingActionButton: PermitGate(
        value: 'Manager',
        child: FloatingActionButton(
          heroTag: 'expense_fab',
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const ExpenseForm())),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _periodSelector(WidgetRef ref, BuildContext context, total) {
    final date = ref.watch(expenseListFilterProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.redAccent),
            onPressed: () {
              final newDate = DateTime(date.year, date.month - 1);
              ref.read(expenseListFilterProvider.notifier).setDate(newDate);
            },
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('MMM yyyy', 'pt_PT').format(date).toUpperCase(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text('Total:  ${formatKz(total)}'),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.blue),
            onPressed: () {
              final newDate = DateTime(date.year, date.month + 1);
              ref.read(expenseListFilterProvider.notifier).setDate(newDate);
            },
          ),
        ],
      ),
    );
  }
}
