import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

Future<File> generateFinancePdf({
  required double totalIncome,
  required double totalExpense,
  required Map<String, double> categoryExpenses,
}) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      build: (context) => [
        pw.Header(level: 0, child: pw.Text("Relatório Financeiro da Igreja")),
        pw.SizedBox(height: 12),

        pw.Text(
          "Resumo Mensal",
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.Text("Total de Receitas: ${totalIncome.toStringAsFixed(2)} Kz"),
        pw.Text("Total de Despesas: ${totalExpense.toStringAsFixed(2)} Kz"),

        pw.SizedBox(height: 20),
        pw.Text(
          "Despesas por Categoria",
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),

        pw.Table.fromTextArray(
          headers: ["Categoria", "Total (Kz)"],
          data: categoryExpenses.entries
              .map((e) => [e.key, e.value.toStringAsFixed(2)])
              .toList(),
        ),
      ],
    ),
  );

  final dir = await getTemporaryDirectory();
  final file = File("${dir.path}/relatorio_financeiro.pdf");

  await file.writeAsBytes(await pdf.save());
  return file;
}

void printPdf(File pdfFile) {
  Printing.layoutPdf(onLayout: (_) => pdfFile.readAsBytes());
}

Future<void> sharePdf(File pdfFile) async {
  await Share.shareXFiles([
    XFile(pdfFile.path),
  ], text: "Relatório Financeiro da Igreja");
}
