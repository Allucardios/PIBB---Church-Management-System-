// Libraries
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Local Imports
import '../../core/const/functions.dart';
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
    final incomesAsync = ref.watch(listIncomeStreamProvider);
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: AppBar(
        title: Consumer(
          builder: (context, ref, child) {
            final date = ref.watch(incomeListFilterProvider);
            return Text(
              'Receitas: ${date.month}/${date.year}',
              style: const TextStyle(fontSize: 18),
            );
          },
        ),
        leading: isDesktop ? const SizedBox.shrink() : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () async {
              final current = ref.read(incomeListFilterProvider);
              final picked = await showDatePicker(
                context: context,
                initialDate: current,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
                helpText: 'Selecione Mês e Ano',
              );
              if (picked != null) {
                ref.read(incomeListFilterProvider.notifier).setDate(picked);
              }
            },
          ),
        ],
      ),
      drawer: isDesktop ? null : const MyDrawer(),
      body: SafeArea(
        child: incomesAsync.when(
          data: (incomes) {
            final total = incomes.fold(0.0, (sum, i) => sum + i.totalIncome());

            return Column(
              children: [
                // Total Summary
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Column(
                    children: [
                      const Text(
                        'Total do Mês',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatKz(total),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () =>
                        ref.refresh(listIncomeStreamProvider.future),
                    child: incomes.isEmpty
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
                                itemCount: incomes.length,
                                itemBuilder: (context, index) =>
                                    CardIncome(inc: incomes[index]),
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
                                itemCount: incomes.length,
                                itemBuilder: (context, index) =>
                                    CardIncome(inc: incomes[index]),
                              ),
                              desktop: GridView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
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
          heroTag: 'income_fab',
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const IncomeForm())),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
