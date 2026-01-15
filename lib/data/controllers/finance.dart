// Libraries
import 'dart:async';
import 'package:get/get.dart';

// Local Imports
import '../../core/const/app_config.dart';
import '../../core/const/functions.dart';
import '../models/expense.dart';
import '../models/income.dart';

class FinanceCtrl extends GetxController {

  // Raw data
  final RxList<Income> incomeList = <Income>[].obs;
  final RxList<Expense> expenseList = <Expense>[].obs;

  // Current period filters
  final Rx<DateTime> selectedMonth = DateTime.now().obs;
  final RxInt selectedYear = DateTime.now().year.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  /// CRUD
  /// Create
  Future<void> addIncome(Income inc) async =>
      await client.from(AppConfig.tableIncomes).insert(inc.toJson());

  Future<void> addExpense(Expense exp) async =>
      await client.from(AppConfig.tableExpenses).insert(exp.toJson());

  /// Read
  Stream<List<Expense>> streamExpenses() => client
      .from(AppConfig.tableExpenses)
      .stream(primaryKey: ['id'])
      .order('date', ascending: false)
      .map((rows) => rows.map((e) => Expense.fromJson(e)).toList());

  Stream<List<Income>> streamIncomes() => client
      .from(AppConfig.tableIncomes)
      .stream(primaryKey: ['id'])
      .order('date', ascending: false)
      .map((rows) => rows.map((e) => Income.fromJson(e)).toList());

  /// Delete
  Future<void> deleteIncome(int id) async =>
      await client.from(AppConfig.tableIncomes).delete().eq('id', id);

  Future<void> deleteExpense(int id) async =>
      await client.from(AppConfig.tableExpenses).delete().eq('id', id);

  /// Financial Calculations - Monthly
  double getMonthlyIncome(DateTime month) => incomeList
      .where(
        (income) =>
            income.date.year == month.year && income.date.month == month.month,
      )
      .fold(0.0, (sum, income) => sum + income.totalIncome());

  double getMonthlyExpenses(DateTime month) => expenseList
      .where(
        (expense) =>
            expense.date.year == month.year &&
            expense.date.month == month.month,
      )
      .fold(0.0, (sum, expense) => sum + expense.amount);

  double getMonthlyBalance(DateTime month) =>
      getMonthlyIncome(month) - getMonthlyExpenses(month);

  /// Financial Calculations - Yearly
  double getYearlyIncome(int year) => incomeList
      .where((income) => income.date.year == year)
      .fold(0.0, (sum, income) => sum + income.totalIncome());

  double getYearlyExpenses(int year) => expenseList
      .where((expense) => expense.date.year == year)
      .fold(0.0, (sum, expense) => sum + expense.amount);

  double getYearlyBalance(int year) =>
      getYearlyIncome(year) - getYearlyExpenses(year);

  /// Expenses by Category
  Map<String, double> getExpensesByCategory(DateTime month) {
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
  List<Map<String, dynamic>> getMonthlyEvolution(int year) {
    List<Map<String, dynamic>> evolution = [];

    for (int month = 1; month <= 12; month++) {
      final date = DateTime(year, month);
      evolution.add({
        'month': month,
        'income': getMonthlyIncome(date),
        'expenses': getMonthlyExpenses(date),
        'balance': getMonthlyBalance(date),
      });
    }

    return evolution;
  }

  /// Load Data
  Future<void> loadData() async {
    /// 1. Stream de Receitas (Incomes)
    streamIncomes().listen((list) {
      incomeList.assignAll(list);
    });

    /// 2. Stream de Despesas (Expenses)
    streamExpenses().listen((list) {
      expenseList.assignAll(list);
    });
  }
}
