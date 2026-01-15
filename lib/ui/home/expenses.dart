// Libraries
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Local Imports
import '../../core/widgets/admin_gate.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/finance_provider.dart';
import '../card/expense.dart';
import '../form/expense.dart';
import '../view/drawer.dart';
import '../../core/widgets/responsive.dart';

class ExpensePage extends ConsumerWidget {
  const ExpensePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expenseStreamProvider);
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Despesas'),
        leading: isDesktop ? const SizedBox.shrink() : null,
      ),
      drawer: isDesktop ? null : const MyDrawer(),
      body: SafeArea(
        child: expensesAsync.when(
          data: (expenses) {
            if (expenses.isEmpty) {
              return const Center(child: Text('Sem dados'));
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Responsive(
                mobile: ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) =>
                      CardExpense(exp: expenses[index]),
                ),
                tablet: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: expenses.length,
                  itemBuilder: (context, index) =>
                      CardExpense(exp: expenses[index]),
                ),
                desktop: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: expenses.length,
                  itemBuilder: (context, index) =>
                      CardExpense(exp: expenses[index]),
                ),
              ),
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
}
