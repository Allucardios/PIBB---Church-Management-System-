// Libraries
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Local Imports
import '../../core/const/functions.dart';
import '../../core/const/theme.dart';
import '../../core/widgets/drop_tf.dart';
import '../../core/widgets/money_tf.dart';
import '../../core/widgets/textfield.dart';
import '../../data/models/expense.dart';
import '../../data/providers/category_provider.dart';
import '../../data/providers/finance_provider.dart';
import '../../data/providers/account_provider.dart';

class ExpenseForm extends ConsumerStatefulWidget {
  const ExpenseForm({super.key, this.expense});
  final Expense? expense;

  @override
  ConsumerState<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends ConsumerState<ExpenseForm> {
  // Variables
  late DateTime _date;
  int? _selectedAccountId;

  // TextControllers
  final date = TextEditingController();
  final cat = TextEditingController();
  final amount = TextEditingController();
  final origin = TextEditingController();
  final obs = TextEditingController();
  final _key = GlobalKey<FormState>();

  Expense _doc() => Expense(
    id: widget.expense?.id,
    category: cat.text,
    amount: toDouble(amount.text),
    date: _date,
    originType: origin.text,
    accountId: _selectedAccountId,
    obs: obs.text,
  );

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _date = widget.expense!.date;
      _selectedAccountId = widget.expense!.accountId;
      cat.text = widget.expense!.category;
      amount.text = widget.expense!.amount.toString();
      origin.text = widget.expense!.originType;
      obs.text = widget.expense!.obs ?? '';
    } else {
      _date = DateTime.now();
    }
    date.text = formatDate(_date);
  }

  @override
  void dispose() {
    date.dispose();
    cat.dispose();
    amount.dispose();
    origin.dispose();
    obs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final accountsAsync = ref.watch(accountsStreamProvider);
    final isEditing = widget.expense != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Despesa' : 'Nova Despesa'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                spacing: 8,
                children: [
                  _dateTf(),
                  MyTextField(
                    controller: obs,
                    hint: 'Natureza da despesa',
                    icon: Icons.monetization_on_outlined,
                    label: 'Descrição',
                  ),
                  accountsAsync.when(
                    data: (accounts) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Conta de Origem',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          DropdownButtonFormField<int>(
                            value: _selectedAccountId,
                            items: accounts
                                .map(
                                  (a) => DropdownMenuItem(
                                    value: a.id,
                                    child: Text(a.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) =>
                                setState(() => _selectedAccountId = val),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: const Icon(
                                Icons.account_balance_wallet_outlined,
                                color: AppTheme.primary,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (val) =>
                                val == null ? 'Selecione uma conta' : null,
                          ),
                        ],
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (err, _) => Text('Erro ao carregar contas: $err'),
                  ),
                  categoriesAsync.when(
                    data: (categories) {
                      final list = categories.map((c) => c.name).toList()
                        ..sort(
                          (a, b) => a.toLowerCase().compareTo(b.toLowerCase()),
                        );

                      return DropDownTextField(
                        ctrl: cat,
                        label: 'Categoria',
                        list: list,
                        icon: Icons.category_outlined,
                        hint: 'Selecione uma Categoria',
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) =>
                        Text('Erro ao carregar categorias: $error'),
                  ),
                  NumberTextField(
                    controller: amount,
                    hint: 'Digite a Quantia',
                    icon: Icons.money_off_outlined,
                    label: 'Custo da Despesa',
                  ),
                  DropDownTextField(
                    ctrl: origin,
                    label: 'Origem ',
                    list: const ['Numerario', 'Transferencia'],
                    icon: Icons.account_balance_outlined,
                    hint: 'Selecione a Origem',
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_key.currentState!.validate()) {
                          // Check balance if not editing
                          if (!isEditing) {
                            final txs = await ref.read(
                              accountTransactionsStreamProvider(
                                _selectedAccountId!,
                              ).future,
                            );
                            final accounts = await ref.read(
                              accountsStreamProvider.future,
                            );
                            final account = accounts.firstWhere(
                              (a) => a.id == _selectedAccountId,
                            );
                            double balance = account.balance;
                            for (var tx in txs) {
                              if (tx.description != 'Saldo Inicial') {
                                balance += tx.amount;
                              }
                            }

                            if (balance < toDouble(amount.text)) {
                              if (mounted) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Saldo Insuficiente'),
                                    content: Text(
                                      'O saldo da conta selecionada é inferior ao valor da despesa.\nSaldo: $balance',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return;
                            }
                          }

                          if (isEditing) {
                            await ref
                                .read(financeServiceProvider.notifier)
                                .updateExpense(_doc());
                          } else {
                            await ref
                                .read(financeServiceProvider.notifier)
                                .addExpense(_doc());
                          }
                          if (mounted) Navigator.of(context).pop();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(isEditing ? 'Guardar' : 'Adicionar'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dateTf() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 0,
    children: [
      const Text(
        'Data',
        style: TextStyle(
          fontSize: 16,
          color: AppTheme.primary,
          fontWeight: FontWeight.bold,
          wordSpacing: 2,
        ),
      ),
      TextFormField(
        controller: date,
        readOnly: true,
        style: const TextStyle(color: Colors.black, fontSize: 16),
        validator: (value) {
          if (_date.isAfter(DateTime.now())) {
            return "A data não pode ser superior ao dia de hoje";
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: _date,
            firstDate: DateTime(2025),
            lastDate: DateTime(2100),
          );
          if (picked != null) {
            setState(() => _date = picked);
            date.text = formatDate(_date);
          }
        },
        decoration: InputDecoration(
          focusColor: Colors.redAccent,
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(
            Icons.calendar_month_outlined,
            color: AppTheme.primary,
          ),
          suffixIcon: const Icon(
            Icons.chevron_right_outlined,
            color: AppTheme.primary,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white),
          ),
        ),
      ),
    ],
  );
}
