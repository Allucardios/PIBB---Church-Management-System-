// Libraries
// Local Imports
import '../../core/const/functions.dart';
import '../models/income.dart';
import '../models/expense.dart';

class MonthReport {
  final List<Income> incomes;
  final List<Expense> expensesList;
  final int month;
  final int year;

  final churchName = 'Primeira Igreja Baptista do Benfica';
  final department = 'Departamento Financeiro';

  String ref() => '${monthName(month)} / $year';

  MonthReport({
    required this.incomes,
    required this.expensesList,
    required this.month,
    required this.year,
  });

  double get income {
    final monthDate = DateTime(year, month);
    return incomes
        .where(
          (i) =>
              i.date.year == monthDate.year && i.date.month == monthDate.month,
        )
        .fold(0.0, (sum, income) => sum + income.totalIncome());
  }

  double get expenses {
    final monthDate = DateTime(year, month);
    return expensesList
        .where(
          (e) =>
              e.date.year == monthDate.year && e.date.month == monthDate.month,
        )
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  double get balance => income - expenses;
}
