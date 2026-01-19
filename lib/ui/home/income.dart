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
        title: Text('R E C E I T A S'),
        leading: isDesktop ? const SizedBox.shrink() : null,
      ),
      drawer: isDesktop ? null : const MyDrawer(),
      body: SafeArea(
        child: incomesAsync.when(
          data: (incomes) {
            final total = incomes.fold(0.0, (sum, i) => sum + i.totalIncome());
            return Column(
              children: [
                // Data
                _periodSelector(ref, context, total),
                // Lista de Receitas
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
                                      crossAxisCount: 3,
                                      childAspectRatio: 4.0,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                itemCount: incomes.length,
                                itemBuilder: (context, index) => SizedBox(
                                  height: 80,
                                  width: 150,
                                  child: CardIncome(inc: incomes[index]),
                                ),
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

  Widget _periodSelector(WidgetRef ref, BuildContext context, total) {
    final date = ref.watch(incomeListFilterProvider);

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
              ref.read(incomeListFilterProvider.notifier).setDate(newDate);
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
              ref.read(incomeListFilterProvider.notifier).setDate(newDate);
            },
          ),
        ],
      ),
    );
  }
}
