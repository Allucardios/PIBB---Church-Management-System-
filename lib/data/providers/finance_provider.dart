// Libraries
import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Local Imports
import '../../core/const/app_config.dart';
import '../../core/const/functions.dart';
import '../models/expense.dart';
import '../models/income.dart';
import '../providers/auth_provider.dart';

part 'finance_provider.g.dart';

/// Income List Stream Provider
@riverpod
Stream<List<Income>> incomeStream(IncomeStreamRef ref) {
  return client
      .from(AppConfig.tableIncomes)
      .stream(primaryKey: ['id'])
      .order('date', ascending: false)
      .map((rows) => rows.map((e) => Income.fromJson(e)).toList())
      .handleError((err) {
        if (err.toString().contains('invalidjwttoken') ||
            err.toString().contains('JWT expired')) {
          ref.read(authServiceProvider.notifier).signOut();
        }
      });
}

/// Expense List Stream Provider
@riverpod
Stream<List<Expense>> expenseStream(ExpenseStreamRef ref) {
  return client
      .from(AppConfig.tableExpenses)
      .stream(primaryKey: ['id'])
      .order('date', ascending: false)
      .map((rows) => rows.map((e) => Expense.fromJson(e)).toList())
      .handleError((err) {
        if (err.toString().contains('invalidjwttoken') ||
            err.toString().contains('JWT expired')) {
          ref.read(authServiceProvider.notifier).signOut();
        }
      });
}

/// Selected Month Provider
@riverpod
class SelectedMonth extends _$SelectedMonth {
  @override
  DateTime build() => DateTime.now();

  void setMonth(DateTime month) => state = month;
}

/// Selected Year Provider
@riverpod
class SelectedYear extends _$SelectedYear {
  @override
  int build() {
    // Watch selectedMonthProvider to automatically sync the year
    return ref.watch(selectedMonthProvider).year;
  }

  void setYear(int year) {
    final currentMonth = ref.read(selectedMonthProvider);
    ref
        .read(selectedMonthProvider.notifier)
        .setMonth(DateTime(year, currentMonth.month));
  }
}

/// Finance Service Provider
@riverpod
class FinanceService extends _$FinanceService {
  @override
  void build() {}

  /// Create
  Future<void> addIncome(Income inc) async =>
      await client.from(AppConfig.tableIncomes).insert(inc.toJson());

  Future<void> addExpense(Expense exp) async =>
      await client.from(AppConfig.tableExpenses).insert(exp.toJson());

  /// Update
  Future<void> updateIncome(Income inc) async => await client
      .from(AppConfig.tableIncomes)
      .update(inc.toJson())
      .eq('id', inc.id!);

  Future<void> updateExpense(Expense exp) async => await client
      .from(AppConfig.tableExpenses)
      .update(exp.toJson())
      .eq('id', exp.id!);

  /// Delete
  Future<void> deleteIncome(int id) async =>
      await client.from(AppConfig.tableIncomes).delete().eq('id', id);

  Future<void> deleteExpense(int id) async =>
      await client.from(AppConfig.tableExpenses).delete().eq('id', id);
}

/// Financial Calculations Provider
@riverpod
class FinanceCalculations extends _$FinanceCalculations {
  @override
  void build() {}

  /// Monthly Calculations
  double getMonthlyIncome(List<Income> incomeList, DateTime month) => incomeList
      .where(
        (income) =>
            income.date.year == month.year && income.date.month == month.month,
      )
      .fold(0.0, (sum, income) => sum + income.totalIncome());

  double getMonthlyExpenses(List<Expense> expenseList, DateTime month) =>
      expenseList
          .where(
            (expense) =>
                expense.date.year == month.year &&
                expense.date.month == month.month,
          )
          .fold(0.0, (sum, expense) => sum + expense.amount);

  double getMonthlyBalance(
    List<Income> incomeList,
    List<Expense> expenseList,
    DateTime month,
  ) =>
      getMonthlyIncome(incomeList, month) -
      getMonthlyExpenses(expenseList, month);

  /// Yearly Calculations
  double getYearlyIncome(List<Income> incomeList, int year) => incomeList
      .where((income) => income.date.year == year)
      .fold(0.0, (sum, income) => sum + income.totalIncome());

  double getYearlyExpenses(List<Expense> expenseList, int year) => expenseList
      .where((expense) => expense.date.year == year)
      .fold(0.0, (sum, expense) => sum + expense.amount);

  double getYearlyBalance(
    List<Income> incomeList,
    List<Expense> expenseList,
    int year,
  ) => getYearlyIncome(incomeList, year) - getYearlyExpenses(expenseList, year);

  /// Expenses by Category
  Map<String, double> getExpensesByCategory(
    List<Expense> expenseList,
    DateTime month,
  ) {
    final monthExpenses = expenseList.where(
      (expense) =>
          expense.date.year == month.year && expense.date.month == month.month,
    );

    Map<String, double> categoryTotals = {};
    for (var expense in monthExpenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }
    return categoryTotals;
  }

  /// Monthly evolution for charts
  List<Map<String, dynamic>> getMonthlyEvolution(
    List<Income> incomeList,
    List<Expense> expenseList,
    int year,
  ) {
    List<Map<String, dynamic>> evolution = [];

    for (int month = 1; month <= 12; month++) {
      final date = DateTime(year, month);
      evolution.add({
        'month': month,
        'income': getMonthlyIncome(incomeList, date),
        'expenses': getMonthlyExpenses(expenseList, date),
        'balance': getMonthlyBalance(incomeList, expenseList, date),
      });
    }

    return evolution;
  }
}
