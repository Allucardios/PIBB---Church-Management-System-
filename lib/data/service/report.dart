// Libraries
import 'package:get/get.dart';

// Local Imports
import '../../core/const/functions.dart';
import '../controllers/finance.dart';

class MonthReport {
  final financeCtrl = Get.find<FinanceCtrl>();
  final int month;
  final int year;

  final churchName = 'Primeira Igreja Baptista do Benfica';
  final department = 'Departamento Financeiro';

  String ref() => '${monthName(month)} / $year';

  MonthReport({required this.month, required this.year});

  double get income => financeCtrl.getMonthlyIncome(DateTime(year, month));
  double get expenses => financeCtrl.getMonthlyExpenses(DateTime(year, month));
  double get balance => financeCtrl.getMonthlyBalance(DateTime(year, month));
}
