import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../core/const/functions.dart';
import '../../data/models/expense.dart';
import '../../data/models/income.dart';
import '../../data/providers/finance_provider.dart';

class AnnualReport {
  final List<Income> incomeList;
  final List<Expense> expenseList;
  final int year;

  AnnualReport({
    required this.incomeList,
    required this.expenseList,
    required this.year,
  });

  String get reference => 'Ano de $year';

  List<int> get _months => List.generate(12, (i) => i + 1);

  String monthName(int m) {
    if (m < 1 || m > 12) throw ArgumentError('Mês inválido');
    return months[m - 1];
  }

  List<Income> getMonthIncomes(int month) {
    return incomeList
        .where((i) => i.date.year == year && i.date.month == month)
        .toList();
  }

  List<Expense> getMonthExpenses(int month) {
    return expenseList
        .where((e) => e.date.year == year && e.date.month == month)
        .toList();
  }

  double getMonthlyIncome(int month) {
    return getMonthIncomes(month).fold(0.0, (sum, i) => sum + i.totalIncome());
  }

  double getMonthlyExpenses(int month) {
    return getMonthExpenses(month).fold(0.0, (sum, e) => sum + e.amount);
  }

  double getMonthlyBalance(int month) {
    return getMonthlyIncome(month) - getMonthlyExpenses(month);
  }

  double get yearIncome {
    return _months.fold(0.0, (sum, m) => sum + getMonthlyIncome(m));
  }

  double get yearExpenses {
    return _months.fold(0.0, (sum, m) => sum + getMonthlyExpenses(m));
  }

  double get yearBalance => yearIncome - yearExpenses;

  // Despesas por categoria no ano
  Map<String, double> get expensesByCategory {
    final Map<String, double> categoryTotals = {};

    for (final expense in expenseList.where((e) => e.date.year == year)) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }

    return categoryTotals;
  }

  // Receitas por tipo no ano
  Map<String, double> get incomesByType {
    double tithes = 0,
        offerings = 0,
        missions = 0,
        pledged = 0,
        special = 0,
        other = 0;

    for (final income in incomeList.where((i) => i.date.year == year)) {
      tithes += income.tithes;
      offerings += income.offerings;
      missions += income.missions;
      pledged += income.pledged;
      special += income.special;
      other += income.other;
    }

    return {
      'Dízimos': tithes,
      'Ofertas': offerings,
      'Missões': missions,
      'O. Alçadas': pledged,
      'O. Especiais': special,
      'Outras': other,
    };
  }

  final _currency = NumberFormat.currency(locale: 'pt_AO', symbol: 'Kz');

  String money(double v) => _currency.format(v);
}

class AnnualReportScreen extends ConsumerWidget {
  final int year;
  const AnnualReportScreen({super.key, required this.year});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incomesAsync = ref.watch(incomeStreamProvider);
    final expensesAsync = ref.watch(expenseStreamProvider);

    if (incomesAsync.isLoading || expensesAsync.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Relatório Anual')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final incomeList = incomesAsync.value ?? [];
    final expenseList = expensesAsync.value ?? [];

    final report = AnnualReport(
      incomeList: incomeList,
      expenseList: expenseList,
      year: year,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Relatório Anual')),
      body: PdfPreview(
        build: (format) => _generatePdf(report),
        allowPrinting: true,
        allowSharing: true,
      ),
    );
  }

  Future<Uint8List> _generatePdf(AnnualReport report) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(57),
        build: (context) => [
          // Header
          pw.Center(
            child: pw.Column(
              children: [
                pw.Text(
                  'Primeira Igreja Baptista do Benfica',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Departamento de Finanças',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Relatório Anual',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  'Referencia: ${report.reference}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 30),

          // RESUMO MENSAL
          pw.Text(
            'RESUMO MENSAL',
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 12),
          _buildMonthlySummary(report),
          pw.SizedBox(height: 30),

          // RECEITAS POR TIPO
          pw.Text(
            'RECEITAS POR TIPO',
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 12),
          _buildIncomesByType(report),
          pw.SizedBox(height: 30),

          // DESPESAS POR CATEGORIA
          pw.Text(
            'DESPESAS POR CATEGORIA',
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 12),
          _buildExpensesByCategory(report),
          pw.SizedBox(height: 30),

          // RESUMO GERAL DO ANO
          pw.Text(
            'RESUMO GERAL DO ANO',
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            'Total de Receitas: ${report.money(report.yearIncome)}',
            style: const pw.TextStyle(fontSize: 10),
          ),
          pw.Text(
            'Total de Despesas: ${report.money(report.yearExpenses)}',
            style: const pw.TextStyle(fontSize: 10),
          ),
          pw.Text(
            'Saldo do Ano: ${report.money(report.yearBalance)}',
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
        ],
        footer: (context) => pw.Container(
          margin: const pw.EdgeInsets.only(top: 8),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              pw.Text(
                'Documento gerado eletronicamente pelo software PIBB 1.0.1',
                style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey),
              ),
              pw.Text(
                '${formatDateComplete(DateTime.now())} - Pág ${context.pageNumber} de ${context.pagesCount}',
                style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey),
              ),
            ],
          ),
        ),
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildMonthlySummary(AnnualReport report) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blue50),
          children: [
            _cell('Mês', bold: true),
            _cell('Receitas', bold: true),
            _cell('Despesas', bold: true),
            _cell('Saldo', bold: true),
          ],
        ),
        // Rows por mês
        ...report._months.map((month) {
          final income = report.getMonthlyIncome(month);
          final expenses = report.getMonthlyExpenses(month);
          final balance = report.getMonthlyBalance(month);

          return pw.TableRow(
            children: [
              _cell(report.monthName(month)),
              _cell(report.money(income)),
              _cell(report.money(expenses)),
              _cell(
                report.money(balance),
                bold: balance < 0,
                color: balance < 0 ? PdfColors.red : null,
              ),
            ],
          );
        }),
        // Total do ano
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey50),
          children: [
            _cell('TOTAL DO ANO', bold: true),
            _cell(report.money(report.yearIncome), bold: true),
            _cell(report.money(report.yearExpenses), bold: true),
            _cell(report.money(report.yearBalance), bold: true),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildIncomesByType(AnnualReport report) {
    final incomes = report.incomesByType;
    final entries = incomes.entries.where((e) => e.value > 0).toList();

    if (entries.isEmpty) {
      return pw.Text(
        'Sem receitas registradas',
        style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey),
      );
    }

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.green50),
          children: [
            _cell('Tipo', bold: true),
            _cell('Valor', bold: true),
            _cell('% do Total', bold: true),
          ],
        ),
        // Rows
        ...entries.map((entry) {
          final percentage = (entry.value / report.yearIncome) * 100;
          return pw.TableRow(
            children: [
              _cell(entry.key),
              _cell(report.money(entry.value)),
              _cell('${percentage.toStringAsFixed(1)}%'),
            ],
          );
        }),
        // Total
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey50),
          children: [
            _cell('TOTAL', bold: true),
            _cell(report.money(report.yearIncome), bold: true),
            _cell('100%', bold: true),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildExpensesByCategory(AnnualReport report) {
    final expenses = report.expensesByCategory;
    final entries = expenses.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (entries.isEmpty) {
      return pw.Text(
        'Sem despesas registradas',
        style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey),
      );
    }

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.red50),
          children: [
            _cell('Categoria', bold: true),
            _cell('Valor', bold: true),
            _cell('% do Total', bold: true),
          ],
        ),
        // Rows
        ...entries.map((entry) {
          final percentage = (entry.value / report.yearExpenses) * 100;
          return pw.TableRow(
            children: [
              _cell(entry.key),
              _cell(report.money(entry.value)),
              _cell('${percentage.toStringAsFixed(1)}%'),
            ],
          );
        }),
        // Total
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey50),
          children: [
            _cell('TOTAL', bold: true),
            _cell(report.money(report.yearExpenses), bold: true),
            _cell('100%', bold: true),
          ],
        ),
      ],
    );
  }

  pw.Widget _cell(String text, {bool bold = false, PdfColor? color}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 8,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: color,
        ),
      ),
    );
  }
}
