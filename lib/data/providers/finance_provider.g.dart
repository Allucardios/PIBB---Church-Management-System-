// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$incomeStreamHash() => r'd624b2ee670b36ea405d89b5394ebcec06847b3a';

/// Income List Provider (Yearly for Dashboard) - Server Side Filtered
///
/// Copied from [incomeStream].
@ProviderFor(incomeStream)
final incomeStreamProvider = AutoDisposeFutureProvider<List<Income>>.internal(
  incomeStream,
  name: r'incomeStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$incomeStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IncomeStreamRef = AutoDisposeFutureProviderRef<List<Income>>;
String _$listIncomeStreamHash() => r'75e89b7be2333afa0127b43d040dc9e96cce0927';

/// Income List Provider (Monthly for List) - Server Side Filtered
///
/// Copied from [listIncomeStream].
@ProviderFor(listIncomeStream)
final listIncomeStreamProvider =
    AutoDisposeFutureProvider<List<Income>>.internal(
      listIncomeStream,
      name: r'listIncomeStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$listIncomeStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ListIncomeStreamRef = AutoDisposeFutureProviderRef<List<Income>>;
String _$listExpenseStreamHash() => r'e3d765fcadf9a522714f31fc0a1ba47292ff7c7a';

/// Expense List Provider (Monthly for List) - Server Side Filtered
///
/// Copied from [listExpenseStream].
@ProviderFor(listExpenseStream)
final listExpenseStreamProvider =
    AutoDisposeFutureProvider<List<Expense>>.internal(
      listExpenseStream,
      name: r'listExpenseStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$listExpenseStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ListExpenseStreamRef = AutoDisposeFutureProviderRef<List<Expense>>;
String _$expenseStreamHash() => r'14fcddb18299f69d36f8b08b862080a804ee9da7';

/// Expense List Provider (Yearly for Dashboard) - Server Side Filtered
///
/// Copied from [expenseStream].
@ProviderFor(expenseStream)
final expenseStreamProvider = AutoDisposeFutureProvider<List<Expense>>.internal(
  expenseStream,
  name: r'expenseStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$expenseStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExpenseStreamRef = AutoDisposeFutureProviderRef<List<Expense>>;
String _$incomeListFilterHash() => r'772f3b027c7a1a98bc0bcdc91d5808bcdd113d95';

/// Independent Date Filter for Income List (Month/Year)
///
/// Copied from [IncomeListFilter].
@ProviderFor(IncomeListFilter)
final incomeListFilterProvider =
    AutoDisposeNotifierProvider<IncomeListFilter, DateTime>.internal(
      IncomeListFilter.new,
      name: r'incomeListFilterProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$incomeListFilterHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$IncomeListFilter = AutoDisposeNotifier<DateTime>;
String _$expenseListFilterHash() => r'8501659d145e05a3f3cdbfe21be31b49d705f469';

/// Independent Date Filter for Expense List (Month/Year)
///
/// Copied from [ExpenseListFilter].
@ProviderFor(ExpenseListFilter)
final expenseListFilterProvider =
    AutoDisposeNotifierProvider<ExpenseListFilter, DateTime>.internal(
      ExpenseListFilter.new,
      name: r'expenseListFilterProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$expenseListFilterHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ExpenseListFilter = AutoDisposeNotifier<DateTime>;
String _$selectedMonthHash() => r'699be852aa020a908de00d43afdec0f9c535f81a';

/// Selected Month Provider
///
/// Copied from [SelectedMonth].
@ProviderFor(SelectedMonth)
final selectedMonthProvider =
    AutoDisposeNotifierProvider<SelectedMonth, DateTime>.internal(
      SelectedMonth.new,
      name: r'selectedMonthProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedMonthHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedMonth = AutoDisposeNotifier<DateTime>;
String _$selectedYearHash() => r'14bb43e7a1f590e0d860f69af6a73051e8667643';

/// Selected Year Provider
///
/// Copied from [SelectedYear].
@ProviderFor(SelectedYear)
final selectedYearProvider =
    AutoDisposeNotifierProvider<SelectedYear, int>.internal(
      SelectedYear.new,
      name: r'selectedYearProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedYearHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedYear = AutoDisposeNotifier<int>;
String _$financeServiceHash() => r'9ac47febebab235abdd31f9c5cd69a6b3b04fbf2';

/// Finance Service Provider
///
/// Copied from [FinanceService].
@ProviderFor(FinanceService)
final financeServiceProvider =
    AutoDisposeNotifierProvider<FinanceService, void>.internal(
      FinanceService.new,
      name: r'financeServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$financeServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FinanceService = AutoDisposeNotifier<void>;
String _$financeCalculationsHash() =>
    r'03431a57d8f2c0e3275a3df59133b5dd22cf9ce0';

/// Financial Calculations Provider
///
/// Copied from [FinanceCalculations].
@ProviderFor(FinanceCalculations)
final financeCalculationsProvider =
    AutoDisposeNotifierProvider<FinanceCalculations, void>.internal(
      FinanceCalculations.new,
      name: r'financeCalculationsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$financeCalculationsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FinanceCalculations = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
