// Libraries
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Local Imports
import '../../core/widgets/admin_gate.dart';
import '../../core/widgets/responsive.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/finance_provider.dart';
import '../card/income.dart';
import '../form/income.dart';
import '../view/drawer.dart';

class IncomePage extends ConsumerWidget {
  const IncomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incomesAsync = ref.watch(incomeStreamProvider);
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Receitas'),
        leading: isDesktop ? const SizedBox.shrink() : null,
      ),
      drawer: isDesktop ? null : const MyDrawer(),
      body: SafeArea(
        child: incomesAsync.when(
          data: (incomes) {
            if (incomes.isEmpty) {
              return const Center(child: Text('Sem dados'));
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Responsive(
                mobile: ListView.builder(
                  itemCount: incomes.length,
                  itemBuilder: (context, index) =>
                      CardIncome(inc: incomes[index]),
                ),
                tablet: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3.0,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: incomes.length,
                  itemBuilder: (context, index) =>
                      CardIncome(inc: incomes[index]),
                ),
                desktop: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 4.0,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: incomes.length,
                  itemBuilder: (context, index) =>
                      CardIncome(inc: incomes[index]),
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
          heroTag: 'income_fab',
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const IncomeForm())),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Column d() {
    return Column(mainAxisSize: MainAxisSize.min, children: []);
  }
}
