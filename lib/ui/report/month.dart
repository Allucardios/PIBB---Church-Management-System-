import 'dart:typed_data';
import 'package:app_pibb/core/const/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../data/models/expense.dart';
import '../../data/models/income.dart';
import '../../data/providers/finance_provider.dart';

class Report {
  final List<Income> incomeList;
  final List<Expense> expenseList;
  final int ref;
  final int year;

  Report({
    required this.incomeList,
    required this.expenseList,
    required this.ref,
    required this.year,
  });

  String monthName(int m) {
    if (m < 1 || m > 12) throw ArgumentError('Mês inválido');
    return months[m - 1];
  }

  String get reference => '${monthName(ref)} de $year';

  List<Income> get _monthIncomes => incomeList
      .where((i) => i.date.year == year && i.date.month == ref)
      .toList();

  List<Expense> get expensesList => expenseList
      .where((e) => e.date.year == year && e.date.month == ref)
      .toList();

  List<DateTime> get incomeDates {
    final set = <DateTime>{};
    for (final i in _monthIncomes) {
      set.add(DateTime(i.date.year, i.date.month, i.date.day));
    }
    final list = set.toList()..sort();
    return list;
  }

  Map<String, Map<DateTime, double>> get incomeTable {
    final map = {
      'Ofertas': <DateTime, double>{},
      'Dízimos': <DateTime, double>{},
      'Missões': <DateTime, double>{},
      'O. Alçadas': <DateTime, double>{},
      'O. Especiais': <DateTime, double>{},
      'Outras': <DateTime, double>{},
    };

    for (final i in _monthIncomes) {
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

  double get income {
    return _monthIncomes.fold(0.0, (sum, i) => sum + i.totalIncome());
  }

  double get expenses {
    return expensesList.fold(0.0, (sum, e) => sum + e.amount);
  }

  double get balance => income - expenses;

  final _currency = NumberFormat.currency(locale: 'pt_AO', symbol: 'Kz');

  String money(double v) => _currency.format(v);
  String date(DateTime d) => DateFormat('dd/MM/yy').format(d);
  String dateShort(DateTime d) => DateFormat('dd/MM/yy').format(d);
}

class MonthlyReportScreen extends ConsumerWidget {
  const MonthlyReportScreen({
    super.key,
    required this.month,
    required this.year,
  });

  final int month;
  final int year;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observar streams de dados
    final incomesAsync = ref.watch(incomeStreamProvider);
    final expensesAsync = ref.watch(expenseStreamProvider);

    // Verificar se os dados estão carregados
    if (!incomesAsync.hasValue || !expensesAsync.hasValue) {
      return Scaffold(
        appBar: AppBar(title: Text('Carregando...')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Criar relatório com os dados
    final report = Report(
      incomeList: incomesAsync.value ?? [],
      expenseList: expensesAsync.value ?? [],
      ref: month,
      year: year,
    );

    return Scaffold(
      appBar: AppBar(title: Text(report.reference)),
      body: PdfPreview(
        build: (format) => _generatePdf(report),
        allowPrinting: true,
        allowSharing: true,
      ),
    );
  }

  Future<Uint8List> _generatePdf(Report report) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(57, 57, 57, 40),
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
                  'Relatório Mensal',
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

          // Receitas do Mês
          pw.Text(
            'Receitas do Mês',
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          _buildIncomeTable(report),
          pw.SizedBox(height: 20),

          // Despesas do Mês
          pw.Text(
            'Despesas do Mês',
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          _buildExpenseTable(report),
          pw.SizedBox(height: 40),
          // Resumo Mensal
          pw.Text(
            'Resumo Mensal:',
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Receitas = ${report.money(report.income)}',
            style: const pw.TextStyle(fontSize: 10),
          ),
          pw.Text(
            'Despesas = ${report.money(report.expenses)}',
            style: const pw.TextStyle(fontSize: 10),
          ),
          pw.Text(
            'Saldo = ${report.money(report.balance)}',
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

  pw.Widget _buildIncomeTable(Report report) {
    final dates = report.incomeDates;
    final table = report.incomeTable;

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.green50),
          children: [
            _cell('Descrição', bold: true),
            ...dates.map((d) => _cell(report.dateShort(d), bold: true)),
            _cell('Total Geral', bold: true),
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
          decoration: const pw.BoxDecoration(color: PdfColors.grey50),
          children: [
            _cell('Total', bold: true),
            ...dates.map((d) {
              final total = table.values.fold(
                0.0,
                (sum, map) => sum + (map[d] ?? 0),
              );
              return _cell(report.money(total), bold: true);
            }),
            _cell(report.money(report.income), bold: true),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildExpenseTable(Report report) {
    final expenses = report.expensesList;

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
            _cell(report.money(report.expenses), bold: true),
          ],
        ),
      ],
    );
  }

  pw.Widget _cell(String text, {bool bold = false}) {
    return pw.Padding(
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
}
