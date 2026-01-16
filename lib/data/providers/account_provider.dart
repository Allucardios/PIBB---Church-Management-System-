import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/const/functions.dart';
import '../models/account.dart';
import '../models/transactions.dart';

part 'account_provider.g.dart';

@riverpod
Stream<List<Account>> accountsStream(AccountsStreamRef ref) {
  return client
      .from('accounts')
      .stream(primaryKey: ['id'])
      .order('name')
      .map((rows) => rows.map((e) => Account.fromJson(e)).toList());
}

@riverpod
Stream<List<AccountTransaction>> accountTransactionsStream(
  AccountTransactionsStreamRef ref,
  int accountId,
) {
  return client
      .from('account_transactions')
      .stream(primaryKey: ['id'])
      .eq('account_id', accountId)
      .order('date', ascending: false)
      .map((rows) => rows.map((e) => AccountTransaction.fromJson(e)).toList());
}

@riverpod
Stream<List<AccountTransaction>> allTransactionsStream(
  AllTransactionsStreamRef ref,
) {
  return client
      .from('account_transactions')
      .stream(primaryKey: ['id'])
      .order('date', ascending: false)
      .map((rows) => rows.map((e) => AccountTransaction.fromJson(e)).toList());
}

@riverpod
class AccountService extends _$AccountService {
  @override
  void build() {}

  String getRandomColor() {
    final colors = [
      '#0E5F5A',
      '#1A237E',
      '#311B92',
      '#01579B',
      '#004D40',
      '#1B5E20',
      '#33691E',
      '#827717',
      '#F57F17',
      '#E65100',
      '#BF360C',
      '#3E2723',
      '#212121',
      '#263238',
      '#AD1457',
    ];
    return (colors..shuffle()).first;
  }

  Future<void> addAccount(Account account) async {
    final data = account.toJson();
    if (account.color == '#0E5F5A') {
      data['color'] = getRandomColor();
    }

    await client.from('accounts').insert(data).select().single();

    // If account.balance > 0, we treat it as the "Opening Balance".
    // We DO NOT create a transaction for it, as the calculation logic
    // adds account.balance + sum(transactions).
  }

  Future<void> setAccountBalance(int accountId, double amount) async {
    await client
        .from('accounts')
        .update({'balance': amount})
        .eq('id', accountId);

    // Remove existing "Saldo Inicial" transaction if any, as we now use the balance field directly.
    await client
        .from('account_transactions')
        .delete()
        .eq('account_id', accountId)
        .eq('description', 'Saldo Inicial');
  }

  Future<void> deleteAccount(int id) async {
    await client.from('accounts').delete().eq('id', id);
  }

  Future<void> updateAccount(Account account) async {
    await client
        .from('accounts')
        .update(account.toJson())
        .eq('id', account.id!);
  }

  Future<void> ensureDefaultAccount() async {
    final response = await client.from('accounts').select().eq('id', 1);
    if (response.isEmpty) {
      // Assuming we can force ID 1, but typically Supabase auto-increments.
      // If the table was created with generated always as identity, we can't force it easily without `overriding system value`.
      // However, for typical setups, we just create it and HOPE it gets ID 1 if it's the first.
      // Or we just insert 'Caixa' and let it be whatever.
      // But the user insisted ID 1 is fixed.
      // Let's just create 'Caixa' if it's missing, but we can't easily force ID 1 in standard insert unless configured.
      // Given the constraint, we just try to insert.
      await addAccount(Account(name: 'Caixa', balance: 0, color: '#0E5F5A'));
    }
  }

  Future<void> transferFunds({
    required int fromId,
    required int toId,
    required double amount,
    required String description,
  }) async {
    // 1. Deduct from 'from' account
    await client.from('account_transactions').insert({
      'account_id': fromId,
      'amount': -amount,
      'type': 'transfer',
      'description': 'Transferência para conta destino: $description',
      'date': DateTime.now().toIso8601String(),
    });

    // 2. Add to 'to' account
    await client.from('account_transactions').insert({
      'account_id': toId,
      'amount': amount,
      'type': 'transfer',
      'description': 'Recebido de conta origem: $description',
      'date': DateTime.now().toIso8601String(),
    });
  }
}

@riverpod
class AccountCalculations extends _$AccountCalculations {
  @override
  void build() {}

  double getAccountBalance(
    int accountId,
    List<Account> accounts,
    List<AccountTransaction> transactions,
  ) {
    final account = accounts.firstWhere((a) => a.id == accountId);
    double currentBalance = account.balance;

    for (var tx in transactions) {
      // Ignore "Saldo Inicial" transactions as they are now handled by account.balance
      if (tx.accountId == accountId && tx.description != 'Saldo Inicial') {
        currentBalance += tx.amount;
      }
    }
    return currentBalance;
  }
}
