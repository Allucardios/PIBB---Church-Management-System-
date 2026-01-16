// Libraries
import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Local Imports
import '../../core/const/app_config.dart';
import '../../core/const/functions.dart';
import '../models/expense.dart';
import '../models/income.dart';

part 'finance_provider.g.dart';

/// Income List Provider (Yearly for Dashboard) - Server Side Filtered
@riverpod
Future<List<Income>> incomeStream(IncomeStreamRef ref) async {
  final year = ref.watch(selectedYearProvider);
  final startOfYear = DateTime(year, 1, 1).toIso8601String();
  final endOfYear = DateTime(year, 12, 31, 23, 59, 59).toIso8601String();

  final data = await client
      .from(AppConfig.tableIncomes)
      .select()
      .gte('date', startOfYear)
      .lte('date', endOfYear)
      .order('date', ascending: false);

  return data.map((e) => Income.fromJson(e)).toList();
}

/// Independent Date Filter for Income List (Month/Year)
@riverpod
class IncomeListFilter extends _$IncomeListFilter {
  @override
  DateTime build() => DateTime.now();
  void setDate(DateTime date) => state = date;
}

/// Income List Provider (Monthly for List) - Server Side Filtered
@riverpod
Future<List<Income>> listIncomeStream(ListIncomeStreamRef ref) async {
  final date = ref.watch(incomeListFilterProvider);
  final startOfMonth = DateTime(date.year, date.month, 1).toIso8601String();
  // Calculate last day of month
  final endOfMonth = DateTime(
    date.year,
    date.month + 1,
    0,
    23,
    59,
    59,
  ).toIso8601String();

  final data = await client
      .from(AppConfig.tableIncomes)
      .select()
      .gte('date', startOfMonth)
      .lte('date', endOfMonth)
      .order('date', ascending: false);

  return data.map((e) => Income.fromJson(e)).toList();
}

/// Independent Date Filter for Expense List (Month/Year)
@riverpod
class ExpenseListFilter extends _$ExpenseListFilter {
  @override
  DateTime build() => DateTime.now();
  void setDate(DateTime date) => state = date;
}

/// Expense List Provider (Monthly for List) - Server Side Filtered
@riverpod
Future<List<Expense>> listExpenseStream(ListExpenseStreamRef ref) async {
  final date = ref.watch(expenseListFilterProvider);
  final startOfMonth = DateTime(date.year, date.month, 1).toIso8601String();
  final endOfMonth = DateTime(
    date.year,
    date.month + 1,
    0,
    23,
    59,
    59,
  ).toIso8601String();

  final data = await client
      .from(AppConfig.tableExpenses)
      .select()
      .gte('date', startOfMonth)
      .lte('date', endOfMonth)
      .order('date', ascending: false);

  return data.map((e) => Expense.fromJson(e)).toList();
}

/// Expense List Provider (Yearly for Dashboard) - Server Side Filtered
@riverpod
Future<List<Expense>> expenseStream(ExpenseStreamRef ref) async {
  final year = ref.watch(selectedYearProvider);
  final startOfYear = DateTime(year, 1, 1).toIso8601String();
  final endOfYear = DateTime(year, 12, 31, 23, 59, 59).toIso8601String();

  final data = await client
      .from(AppConfig.tableExpenses)
      .select()
      .gte('date', startOfYear)
      .lte('date', endOfYear)
      .order('date', ascending: false);

  return data.map((e) => Expense.fromJson(e)).toList();
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
  Future<void> addIncome(Income inc) async {
    // 1. Use fixed ID 1 for "Caixa"
    const caixaId = 1;

    // 2. Add Income with account_id
    final incData = inc.toJson();
    incData['account_id'] = caixaId;

    final insertedIncome = await client
        .from(AppConfig.tableIncomes)
        .insert(incData)
        .select()
        .single();

    // 3. Create Transaction
    await client.from('account_transactions').insert({
      'account_id': caixaId,
      'amount': inc.totalIncome(),
      'type': 'income',
      'description': 'Entrada de Receita: ${formatDate(inc.date)}',
      'date': inc.date.toIso8601String(),
      'reference_id': insertedIncome['id'],
    });

    // Invalidate Providers to Refresh UI
    ref.invalidate(incomeStreamProvider);
    ref.invalidate(listIncomeStreamProvider);
  }

  Future<void> addExpense(Expense exp) async {
    // 1. Add Expense
    final insertedExpense = await client
        .from(AppConfig.tableExpenses)
        .insert(exp.toJson())
        .select()
        .single();

    // 2. Create Transaction (Negative amount)
    if (exp.accountId != null) {
      await client.from('account_transactions').insert({
        'account_id': exp.accountId,
        'amount': -exp.amount,
        'type': 'expense',
        'description': 'Saída de Despesa: ${exp.category}',
        'date': exp.date.toIso8601String(),
        'reference_id': insertedExpense['id'],
      });
    }

    // Invalidate Providers
    ref.invalidate(expenseStreamProvider);
    ref.invalidate(listExpenseStreamProvider);
  }

  /// Update
  Future<void> updateIncome(Income inc) async {
    await client
        .from(AppConfig.tableIncomes)
        .update(inc.toJson())
        .eq('id', inc.id!);

    // Update Transaction amount and account
    if (inc.accountId != null) {
      await client
          .from('account_transactions')
          .update({'amount': inc.totalIncome(), 'account_id': inc.accountId})
          .eq('type', 'income')
          .eq('reference_id', inc.id!);
    } else {
      await client
          .from('account_transactions')
          .update({'amount': inc.totalIncome()})
          .eq('type', 'income')
          .eq('reference_id', inc.id!);
    }

    // Invalidate Providers
    ref.invalidate(incomeStreamProvider);
    ref.invalidate(listIncomeStreamProvider);
  }

  Future<void> updateExpense(Expense exp) async {
    await client
        .from(AppConfig.tableExpenses)
        .update(exp.toJson())
        .eq('id', exp.id!);

    // Update Transaction amount and account
    if (exp.accountId != null) {
      await client
          .from('account_transactions')
          .update({'amount': -exp.amount, 'account_id': exp.accountId})
          .eq('type', 'expense')
          .eq('reference_id', exp.id!);
    }

    // Invalidate Providers
    ref.invalidate(expenseStreamProvider);
    ref.invalidate(listExpenseStreamProvider);
  }

  /// Delete
  Future<void> deleteIncome(int id) async {
    await client.from(AppConfig.tableIncomes).delete().eq('id', id);
    await client
        .from('account_transactions')
        .delete()
        .eq('type', 'income')
        .eq('reference_id', id);

    // Invalidate Providers
    ref.invalidate(incomeStreamProvider);
    ref.invalidate(listIncomeStreamProvider);
  }

  Future<void> deleteExpense(int id) async {
    await client.from(AppConfig.tableExpenses).delete().eq('id', id);
    await client
        .from('account_transactions')
        .delete()
        .eq('type', 'expense')
        .eq('reference_id', id);

    // Invalidate Providers
    ref.invalidate(expenseStreamProvider);
    ref.invalidate(listExpenseStreamProvider);
  }
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
