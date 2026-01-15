// Libraries
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// Local Imports
import '../../core/const/functions.dart';
import '../../data/models/expense.dart';
import '../../data/models/income.dart';
import '../../data/providers/finance_provider.dart';

class QuarterReport {
  final List<Income> incomeList;
  final List<Expense> expenseList;
  final int quarter;
  final int year;

  QuarterReport({
    required this.incomeList,
    required this.expenseList,
    required this.quarter,
    required this.year,
  }) {
    if (quarter < 1 || quarter > 4) {
      throw ArgumentError('Trimestre deve ser entre 1 e 4. Recebido: $quarter');
    }
  }

  String get quarterName {
    return '$quarterº Trimestre';
  }

  String get reference => '$quarterName $year';

  List<int> get _months {
    if (quarter == 1) return [1, 2, 3]; // Jan, Fev, Mar
    if (quarter == 2) return [4, 5, 6]; // Abr, Mai, Jun
    if (quarter == 3) return [7, 8, 9]; // Jul, Ago, Set
    if (quarter == 4) return [10, 11, 12]; // Out, Nov, Dez

    throw ArgumentError('Trimestre inválido: $quarter');
  }

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

  List<DateTime> getIncomeDates(int month) {
    final set = <DateTime>{};
    for (final i in getMonthIncomes(month)) {
      set.add(DateTime(i.date.year, i.date.month, i.date.day));
    }
    final list = set.toList()..sort();
    return list;
  }

  Map<String, Map<DateTime, double>> getIncomeTable(int month) {
    final map = {
      'Ofertas': <DateTime, double>{},
      'Dízimos': <DateTime, double>{},
      'Missões': <DateTime, double>{},
      'O. Alçadas': <DateTime, double>{},
      'O. Especiais': <DateTime, double>{},
      'Outras': <DateTime, double>{},
    };

    for (final i in getMonthIncomes(month)) {
      final d = DateTime(i.date.year, i.date.month, i.date.day);
      map['Ofertas']![d] = (map['Ofertas']![d] ?? 0) + i.offerings;
      map['Dízimos']![d] = (map['Dízimos']![d] ?? 0) + i.tithes;
      map['Missões']![d] = (map['Missões']![d] ?? 0) + i.missions;
      map['O. Alçadas']![d] = (map['O. Alçadas']![d] ?? 0) + i.pledged;
      map['O. Especiais']![d] = (map['O. Especiais']![d] ?? 0) + i.special;
      map['Outras']![d] = (map['Outras']![d] ?? 0) + i.other;
    }
    return map;
  }

  double getMonthlyIncome(int month) {
    return getMonthIncomes(month).fold(0.0, (sum, i) => sum + i.totalIncome());
  }

  double getMonthlyExpenses(int month) {
    return getMonthExpenses(month).fold(0.0, (sum, e) => sum + e.amount);
  }

  double get quarterIncome {
    return _months.fold(0.0, (sum, m) => sum + getMonthlyIncome(m));
  }

  double get quarterExpenses {
    return _months.fold(0.0, (sum, m) => sum + getMonthlyExpenses(m));
  }

  double get quarterBalance => quarterIncome - quarterExpenses;

  final _currency = NumberFormat.currency(locale: 'pt_AO', symbol: 'Kz');

  String money(double v) => _currency.format(v);
  String date(DateTime d) => DateFormat('dd/MM/yy').format(d);
}

class QuarterlyReportScreen extends ConsumerWidget {
  final int quarter;
  final int year;
  const QuarterlyReportScreen({
    super.key,
    required this.quarter,
    required this.year,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incomesAsync = ref.watch(incomeStreamProvider);
    final expensesAsync = ref.watch(expenseStreamProvider);

    if (incomesAsync.isLoading || expensesAsync.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Relatório Trimestral')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final incomeList = incomesAsync.value ?? [];
    final expenseList = expensesAsync.value ?? [];

    final report = QuarterReport(
      incomeList: incomeList,
      expenseList: expenseList,
      quarter: quarter,
      year: year,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Relatório Trimestral')),
      body: PdfPreview(
        build: (format) => _generatePdf(report),
        allowPrinting: true,
        allowSharing: true,
      ),
    );
  }

  Future<Uint8List> _generatePdf(QuarterReport report) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
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
                  'Relatório Trimestral',
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
          pw.SizedBox(height: 20),

          // RECEITAS
          pw.Text(
            'RECEITAS DO TRIMESTRE',
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 12),

          // Tabelas de Receitas por mês
          ...report._months.map(
            (month) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Mês: ${report.monthName(month)}',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 6),
                _buildIncomeTable(report, month),
                pw.SizedBox(height: 16),
              ],
            ),
          ),

          // Resumo de Receitas
          pw.Text(
            'Resumo de Receitas',
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),
          _buildIncomeSummary(report),
          pw.SizedBox(height: 24),

          // DESPESAS
          pw.Text(
            'DESPESAS DO TRIMESTRE',
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 12),

          // Tabelas de Despesas por mês
          ...report._months.map(
            (month) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Mês: ${report.monthName(month)}',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 6),
                _buildExpenseTable(report, month),
                pw.SizedBox(height: 16),
              ],
            ),
          ),

          // Resumo de Despesas
          pw.Text(
            'Resumo de Despesas',
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),
          _buildExpenseSummary(report),
          pw.SizedBox(height: 24),

          // RESUMO GERAL DO TRIMESTRE
          pw.Text(
            'RESUMO GERAL DO TRIMESTRE',
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            'Total de Receitas: ${report.money(report.quarterIncome)}',
            style: const pw.TextStyle(fontSize: 10),
          ),
          pw.Text(
            'Total de Despesas: ${report.money(report.quarterExpenses)}',
            style: const pw.TextStyle(fontSize: 10),
          ),
          pw.Text(
            'Saldo do Trimestre: ${report.money(report.quarterBalance)}',
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

  pw.Widget _buildIncomeTable(QuarterReport report, int month) {
    final dates = report.getIncomeDates(month);
    final table = report.getIncomeTable(month);

    if (dates.isEmpty) {
      return pw.Text(
        'Sem receitas registradas',
        style: const pw.TextStyle(fontSize: 8, color: PdfColors.green50),
      );
    }

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.green50),
          children: [
            _cell('Descrição', bold: true),
            ...dates.map((d) => _cell(report.date(d), bold: true)),
            _cell('Total', bold: true),
          ],
        ),
        // Rows
        ...table.entries.map((entry) {
          final category = entry.key;
          final values = entry.value;
          final total = values.values.fold(0.0, (sum, v) => sum + v);

          return pw.TableRow(
            children: [
              _cell(category),
              ...dates.map((d) => _cell(report.money(values[d] ?? 0))),
              _cell(report.money(total), bold: true),
            ],
          );
        }),
        // Total Row
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey100),
          children: [
            _cell('Total', bold: true),
            ...dates.map((d) {
              final total = table.values.fold(
                0.0,
                (sum, map) => sum + (map[d] ?? 0),
              );
              return _cell(report.money(total), bold: true);
            }),
            _cell(report.money(report.getMonthlyIncome(month)), bold: true),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildExpenseTable(QuarterReport report, int month) {
    final expenses = report.getMonthExpenses(month);

    if (expenses.isEmpty) {
      return pw.Text(
        'Sem despesas registradas',
        style: const pw.TextStyle(fontSize: 8, color: PdfColors.red50),
      );
    }

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
      columnWidths: {
        0: const pw.FixedColumnWidth(30),
        1: const pw.FlexColumnWidth(3),
        2: const pw.FlexColumnWidth(2),
        3: const pw.FlexColumnWidth(2),
      },
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.red50),
          children: [
            _cell('#', bold: true),
            _cell('Descrição', bold: true),
            _cell('Data', bold: true),
            _cell('Valor', bold: true),
          ],
        ),
        // Rows
        ...expenses.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final expense = entry.value;

          return pw.TableRow(
            children: [
              _cell('$index'),
              _cell(expense.category),
              _cell(report.date(expense.date)),
              _cell(report.money(expense.amount)),
            ],
          );
        }),
        // Total Row
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey50),
          children: [
            pw.Container(),
            pw.Container(),
            _cell('Total', bold: true),
            _cell(report.money(report.getMonthlyExpenses(month)), bold: true),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildIncomeSummary(QuarterReport report) => pw.Table(
    border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
    children: [
      // Header
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.green50),
        children: [
          _cell('Mês', bold: true),
          _cell('Total de Receitas', bold: true),
        ],
      ),
      // Rows por mês
      ...report._months.map(
        (month) => pw.TableRow(
          children: [
            _cell(report.monthName(month)),
            _cell(report.money(report.getMonthlyIncome(month))),
          ],
        ),
      ),
      // Total do trimestre
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.grey50),
        children: [
          _cell('Total do Trimestre', bold: true),
          _cell(report.money(report.quarterIncome), bold: true),
        ],
      ),
    ],
  );

  pw.Widget _buildExpenseSummary(QuarterReport report) => pw.Table(
    border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
    children: [
      // Header
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.red50),
        children: [
          _cell('Mês', bold: true),
          _cell('Total de Despesas', bold: true),
        ],
      ),
      // Rows por mês
      ...report._months.map(
        (month) => pw.TableRow(
          children: [
            _cell(report.monthName(month)),
            _cell(report.money(report.getMonthlyExpenses(month))),
          ],
        ),
      ),
      // Total do trimestre
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.red50),
        children: [
          _cell('Total do Trimestre', bold: true),
          _cell(report.money(report.quarterExpenses), bold: true),
        ],
      ),
    ],
  );

  pw.Widget _cell(String text, {bool bold = false}) => pw.Padding(
    padding: const pw.EdgeInsets.all(4),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 8,
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
      ),
    ),
  );
}
