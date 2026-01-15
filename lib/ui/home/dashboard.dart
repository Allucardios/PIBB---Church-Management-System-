// Libraries
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// Local Imports
import '../../core/const/color.dart';
import '../../core/const/theme.dart';
import '../../data/controllers/finance.dart';
import '../view/drawer.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final _ctrl = Get.find<FinanceCtrl>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("P I B B")),
      drawer: MyDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            spacing: 20,
            children: [
              _periodSelector(),
              //
              _sectionTitle('Resumo do Mês'),
              _buildMonthlyCards(),
              _buildMonthlyIncomeVsExpensesChart(),
              _buildExpensesByCategoryChart(),
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

  Widget _periodSelector() => Card(
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left, color: Colors.redAccent),
            onPressed: () {
              final current = _ctrl.selectedMonth.value;
              _ctrl.selectedMonth.value = DateTime(
                current.year,
                current.month - 1,
              );
            },
          ),
          Obx(() {
            final month = _ctrl.selectedMonth.value;
            return Text(
              DateFormat('MMMM yyyy', 'pt_PT').format(month).toUpperCase(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            );
          }),
          IconButton(
            icon: Icon(Icons.chevron_right, color: Colors.blue),
            onPressed: () {
              final current = _ctrl.selectedMonth.value;
              _ctrl.selectedMonth.value = DateTime(
                current.year,
                current.month + 1,
              );
            },
          ),
        ],
      ),
    ),
  );

  Widget _sectionTitle(String title) => Text(
    title,
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppTheme.primary,
    ),
  );

  Widget _buildMonthlyCards() => Obx(() {
    final month = _ctrl.selectedMonth.value;
    final income = _ctrl.getMonthlyIncome(month);
    final expenses = _ctrl.getMonthlyExpenses(month);
    final balance = _ctrl.getMonthlyBalance(month);
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
  });

  Widget _statCard(String title, double value, Color color, IconData icon) {
    final formatter = NumberFormat.currency(symbol: 'AOA ', decimalDigits: 2);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
      ),
    );
  }

  Widget _buildMonthlyIncomeVsExpensesChart() => Obx(() {
    final month = _ctrl.selectedMonth.value;
    final income = _ctrl.getMonthlyIncome(month);
    final expenses = _ctrl.getMonthlyExpenses(month);

    final data = [
      _ChartData(
        'Receitas',
        income,
        const Color(0xFFB5EAD7),
      ), // Verde institucional
      _ChartData(
        'Despesas',
        expenses,
        const Color(0xFFFFB3BA),
      ), // Vermelho PIBB
    ];

    return Card(
      color: Colors.black54,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 250,
              child: SfCartesianChart(
                title: ChartTitle(
                  text: 'Receitas vs Despesas ',
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                primaryXAxis: CategoryAxis(
                  labelStyle: TextStyle(color: Colors.white),
                ),
                primaryYAxis: NumericAxis(
                  numberFormat: NumberFormat.compact(),
                  labelStyle: TextStyle(color: Colors.white),
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
                      textStyle: TextStyle(color: Colors.white),
                      labelPosition: ChartDataLabelPosition.outside,
                    ),
                  ),
                  LineSeries<_ChartData, String>(
                    dataSource: data,
                    xValueMapper: (data, _) => data.category,
                    yValueMapper: (data, _) => data.value,
                    pointColorMapper: (data, _) => Colors.blue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  });

  Widget _buildExpensesByCategoryChart() => Obx(() {
    final month = _ctrl.selectedMonth.value;
    final categoryData = _ctrl.getExpensesByCategory(month);

    if (categoryData.isEmpty) return const SizedBox.shrink();

    final data = categoryData.entries
        .map((e) => _PieData(e.key, e.value))
        .toList();

    return Card(
      color: Colors.black54,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 300,
          child: SfCircularChart(
            title: ChartTitle(
              text: 'Despesas por Categoria',
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            palette: PastelColors().pastelColorsList,
            legend: const Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              overflowMode: LegendItemOverflowMode.wrap,
              textStyle: TextStyle(color: Colors.white),
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
      ),
    );
  });

  Widget _buildYearlyCards() => Obx(() {
    final year = _ctrl.selectedYear.value;
    final income = _ctrl.getYearlyIncome(year);
    final expenses = _ctrl.getYearlyExpenses(year);
    final balance = _ctrl.getYearlyBalance(year);

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
  });

  Widget _buildYearlyEvolutionChart() => Obx(() {
    final evolution = _ctrl.getMonthlyEvolution(_ctrl.selectedYear.value);
    return Card(
      color: Colors.black54,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            SizedBox(
              height: 300,
              child: SfCartesianChart(
                primaryXAxis: const CategoryAxis(
                  labelStyle: TextStyle(color: Colors.white),
                ),
                primaryYAxis: NumericAxis(
                  numberFormat: NumberFormat.compact(),
                  labelStyle: TextStyle(color: Colors.white),
                ),
                legend: const Legend(
                  isVisible: true,
                  textStyle: TextStyle(color: Colors.white),
                  position: LegendPosition.bottom,
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                title: ChartTitle(
                  text: 'Evolução Mensal',
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                series: <CartesianSeries>[
                  ColumnSeries<Map<String, dynamic>, String>(
                    name: 'Receitas',
                    dataSource: evolution,
                    xValueMapper: (data, _) => DateFormat(
                      'MMM',
                    ).format(DateTime(_ctrl.selectedYear.value, data['month'])),
                    yValueMapper: (data, _) => data['income'],
                    color: Color(0xFFB5EAD7),
                  ),
                  ColumnSeries<Map<String, dynamic>, String>(
                    name: 'Despesas',
                    dataSource: evolution,
                    xValueMapper: (data, _) => DateFormat(
                      'MMM',
                    ).format(DateTime(_ctrl.selectedYear.value, data['month'])),
                    yValueMapper: (data, _) => data['expenses'],
                    color: Color(0xFFFFB3BA),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  });
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
