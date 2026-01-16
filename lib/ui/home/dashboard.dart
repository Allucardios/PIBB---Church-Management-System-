// Libraries
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// Local Imports
import '../../core/const/color.dart';
import '../../core/const/theme.dart';
import '../../core/widgets/responsive.dart';
import '../../data/providers/finance_provider.dart';
import '../view/drawer.dart';

class DashBoard extends ConsumerStatefulWidget {
  const DashBoard({super.key});

  @override
  ConsumerState<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends ConsumerState<DashBoard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("P I B B"),
        leading: isDesktop ? const SizedBox.shrink() : null,
      ),
      drawer: isDesktop ? null : const MyDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            spacing: 20,
            children: [
              _periodSelector(),

              //
              _sectionTitle('Resumo do Mês'),
              _buildMonthlyCards(),
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildMonthlyIncomeVsExpensesChart()),
                    Expanded(child: _buildExpensesByCategoryChart()),
                  ],
                )
              else ...[
                _buildMonthlyIncomeVsExpensesChart(),
                _buildExpensesByCategoryChart(),
              ],
              //
              _sectionTitle('Resumo do Ano'),
              _buildYearlyCards(),
              _buildYearlyEvolutionChart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _periodSelector() {
    final month = ref.watch(selectedMonthProvider);
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.redAccent),
              onPressed: () {
                ref
                    .read(selectedMonthProvider.notifier)
                    .setMonth(DateTime(month.year, month.month - 1));
              },
            ),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: month,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                  initialDatePickerMode: DatePickerMode.year,
                );
                if (picked != null) {
                  ref.read(selectedMonthProvider.notifier).setMonth(picked);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  DateFormat('MMMM yyyy', 'pt_PT').format(month).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Colors.blue),
              onPressed: () {
                ref
                    .read(selectedMonthProvider.notifier)
                    .setMonth(DateTime(month.year, month.month + 1));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(
    title,
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppTheme.primary,
    ),
  );

  Widget _buildMonthlyCards() {
    final month = ref.watch(selectedMonthProvider);
    final incomesAsync = ref.watch(incomeStreamProvider);
    final expensesAsync = ref.watch(expenseStreamProvider);

    if (incomesAsync.isLoading || expensesAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final incomes = incomesAsync.value ?? [];
    final expensesList = expensesAsync.value ?? [];
    final calc = ref.read(financeCalculationsProvider.notifier);

    final income = calc.getMonthlyIncome(incomes, month);
    final expenses = calc.getMonthlyExpenses(expensesList, month);
    final balance = calc.getMonthlyBalance(incomes, expensesList, month);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _statCard(
            'Receitas',
            income,
            Colors.green,
            Icons.arrow_upward,
          ),
        ),
        Expanded(
          child: _statCard(
            'Despesas',
            expenses,
            Colors.red,
            Icons.arrow_downward,
          ),
        ),
        Expanded(
          child: _statCard(
            'Saldo',
            balance,
            balance >= 0 ? Colors.blue : Colors.orange,
            Icons.account_balance_wallet,
          ),
        ),
      ],
    );
  }

  Widget _statCard(String title, double value, Color color, IconData icon) {
    final formatter = NumberFormat.currency(
      symbol: 'Kz ',
      decimalDigits: 2,
      locale: 'pt_PT',
    );

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Center(
            child: Text(
              formatter.format(value),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearlyCards() {
    final year = ref.watch(selectedYearProvider);
    final incomesAsync = ref.watch(incomeStreamProvider);
    final expensesAsync = ref.watch(expenseStreamProvider);

    if (incomesAsync.isLoading || expensesAsync.isLoading) SizedBox.shrink();

    final incomes = incomesAsync.value ?? [];
    final expensesList = expensesAsync.value ?? [];
    final calc = ref.read(financeCalculationsProvider.notifier);

    final income = calc.getYearlyIncome(incomes, year);
    final expenses = calc.getYearlyExpenses(expensesList, year);
    final balance = calc.getYearlyBalance(incomes, expensesList, year);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _statCard(
            'Receitas',
            income,
            Colors.green,
            Icons.arrow_upward,
          ),
        ),
        Expanded(
          child: _statCard(
            'Despesas',
            expenses,
            Colors.red,
            Icons.arrow_downward,
          ),
        ),
        Expanded(
          child: _statCard(
            'Saldo',
            balance,
            balance >= 0 ? Colors.blue : Colors.orange,
            Icons.account_balance_wallet,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyIncomeVsExpensesChart() {
    final month = ref.watch(selectedMonthProvider);
    final incomesAsync = ref.watch(incomeStreamProvider);
    final expensesAsync = ref.watch(expenseStreamProvider);

    if (incomesAsync.isLoading || expensesAsync.isLoading) {
      return const SizedBox.shrink();
    }

    final incomes = incomesAsync.value ?? [];
    final expensesList = expensesAsync.value ?? [];
    final calc = ref.read(financeCalculationsProvider.notifier);

    final incomeValue = calc.getMonthlyIncome(incomes, month);
    final expensesValue = calc.getMonthlyExpenses(expensesList, month);

    final data = [
      _ChartData('Receitas', incomeValue, const Color(0xFFB5EAD7)),
      _ChartData('Despesas', expensesValue, const Color(0xFFFFB3BA)),
    ];

    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .4,
        child: SfCartesianChart(
          title: const ChartTitle(
            text: 'Receitas vs Despesas ',
            textStyle: TextStyle(
              color: Colors.black45,
              fontWeight: FontWeight.bold,
            ),
          ),
          primaryXAxis: const CategoryAxis(
            labelStyle: TextStyle(color: Colors.black45),
          ),
          primaryYAxis: NumericAxis(
            numberFormat: NumberFormat.compact(),
            labelStyle: const TextStyle(color: Colors.black45),
          ),
          series: <CartesianSeries>[
            ColumnSeries<_ChartData, String>(
              dataSource: data,
              xValueMapper: (data, _) => data.category,
              yValueMapper: (data, _) => data.value,
              pointColorMapper: (data, _) => data.color,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(color: Colors.black45),
                labelPosition: ChartDataLabelPosition.outside,
              ),
            ),
            LineSeries<_ChartData, String>(
              dataSource: data,
              xValueMapper: (data, _) => data.category,
              yValueMapper: (data, _) => data.value,
              pointColorMapper: (data, _) => Colors.orangeAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesByCategoryChart() {
    final month = ref.watch(selectedMonthProvider);
    final expensesAsync = ref.watch(expenseStreamProvider);

    if (expensesAsync.isLoading) return const SizedBox.shrink();

    final expensesList = expensesAsync.value ?? [];
    final calc = ref.read(financeCalculationsProvider.notifier);
    final categoryData = calc.getExpensesByCategory(expensesList, month);

    if (categoryData.isEmpty) return const SizedBox.shrink();

    final data = categoryData.entries
        .map((e) => _PieData(e.key, e.value))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .4,
        child: SfCircularChart(
          title: const ChartTitle(
            text: 'Despesas por Categoria',
            textStyle: TextStyle(
              color: Colors.black45,
              fontWeight: FontWeight.bold,
            ),
          ),
          palette: PastelColors().pastelColorsList,
          legend: const Legend(
            isVisible: true,
            position: LegendPosition.bottom,
            overflowMode: LegendItemOverflowMode.wrap,
            textStyle: TextStyle(color: Colors.black45),
          ),
          series: <CircularSeries>[
            PieSeries<_PieData, String>(
              dataSource: data,
              xValueMapper: (d, _) => d.category,
              yValueMapper: (d, _) => d.value,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                labelPosition: ChartDataLabelPosition.outside,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYearlyEvolutionChart() {
    final year = ref.watch(selectedYearProvider);
    final incomesAsync = ref.watch(incomeStreamProvider);
    final expensesAsync = ref.watch(expenseStreamProvider);

    if (incomesAsync.isLoading || expensesAsync.isLoading) SizedBox.shrink();

    final incomes = incomesAsync.value ?? [];
    final expensesList = expensesAsync.value ?? [];
    final calc = ref.read(financeCalculationsProvider.notifier);

    final evolution = calc.getMonthlyEvolution(incomes, expensesList, year);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .4,
        child: SfCartesianChart(
          primaryXAxis: const CategoryAxis(
            labelStyle: TextStyle(color: Colors.black45),
          ),
          primaryYAxis: NumericAxis(
            numberFormat: NumberFormat.compact(),
            labelStyle: const TextStyle(color: Colors.black45),
          ),
          legend: const Legend(
            isVisible: true,
            textStyle: TextStyle(color: Colors.black45),
            position: LegendPosition.bottom,
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          title: const ChartTitle(
            text: 'Evolução Mensal',
            textStyle: TextStyle(
              color: Colors.black45,
              fontWeight: FontWeight.bold,
            ),
          ),
          series: <CartesianSeries>[
            ColumnSeries<Map<String, dynamic>, String>(
              name: 'Receitas',
              dataSource: evolution,
              xValueMapper: (data, _) =>
                  DateFormat('MMM').format(DateTime(year, data['month'])),
              yValueMapper: (data, _) => data['income'],
              color: const Color(0xFFB5EAD7),
            ),
            ColumnSeries<Map<String, dynamic>, String>(
              name: 'Despesas',
              dataSource: evolution,
              xValueMapper: (data, _) =>
                  DateFormat('MMM').format(DateTime(year, data['month'])),
              yValueMapper: (data, _) => data['expenses'],
              color: const Color(0xFFFFB3BA),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  final String category;
  final double value;
  final Color color;

  _ChartData(this.category, this.value, this.color);
}

class _PieData {
  final String category;
  final double value;

  _PieData(this.category, this.value);
}
