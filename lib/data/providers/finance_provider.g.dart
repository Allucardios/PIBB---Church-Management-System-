// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$incomeStreamHash() => r'f821afb4f71dd65649be7101531c552e6980d9f7';

/// Income List Stream Provider
///
/// Copied from [incomeStream].
@ProviderFor(incomeStream)
final incomeStreamProvider = AutoDisposeStreamProvider<List<Income>>.internal(
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
typedef IncomeStreamRef = AutoDisposeStreamProviderRef<List<Income>>;
String _$expenseStreamHash() => r'474e4c7533800b44fe120f41e53c3ab63f78f623';

/// Expense List Stream Provider
///
/// Copied from [expenseStream].
@ProviderFor(expenseStream)
final expenseStreamProvider = AutoDisposeStreamProvider<List<Expense>>.internal(
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
typedef ExpenseStreamRef = AutoDisposeStreamProviderRef<List<Expense>>;
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
String _$selectedYearHash() => r'795e5de848b66aeadee7923c2a91fb36151db85a';

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
String _$financeServiceHash() => r'53747378ab7a48273c6cefbef348e7696ed3abbd';

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
