// Libraries
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local Imports
import '../../core/const/functions.dart';
import '../../core/const/theme.dart';
import '../../core/widgets/drop_tf.dart';
import '../../core/widgets/money_tf.dart';
import '../../core/widgets/textfield.dart';
import '../../data/controllers/category.dart';
import '../../data/controllers/finance.dart';
import '../../data/models/expense.dart';

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({super.key});

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  // Variables
  late DateTime _date;

  // Controllers
  final ctrl = Get.find<FinanceCtrl>();
  final getCtrl = Get.find<CategoryCtrl>();

  // TextControllers
  final date = TextEditingController();
  final cat = TextEditingController();
  final amount = TextEditingController();
  final origin = TextEditingController();
  final obs = TextEditingController();
  final _key = GlobalKey<FormState>();

  Expense _doc() => Expense(
    category: cat.text,
    amount: toDouble(amount.text),
    date: _date,
    originType: origin.text,
    obs: obs.text,
  );

  @override
  void initState() {
    super.initState();
    _date = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nova Despesa')),
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
                  Obx(() {
                    final categories = getCtrl.categories;
                    final List<String> cats = [];

                    for (var cat in categories) {
                      cats.add(cat.name);
                    }

                    final List<String> list = List.from(cats)
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
                  }),
                  NumberTextField(
                    controller: amount,
                    hint: 'Digite a Quantia',
                    icon: Icons.money_off_outlined,
                    label: 'Custo da Despesa',
                  ),
                  DropDownTextField(
                    ctrl: origin,
                    label: 'Origem ',
                    list: ['Numerario', 'Transferencia'],
                    icon: Icons.account_balance_outlined,
                    hint: 'Selecione a Origem',
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          ctrl.addExpense(_doc());
                          Get.back();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text('Adicionar'),
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
      Text(
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
        style: TextStyle(color: Colors.black, fontSize: 16),
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
          prefixIcon: Icon(
            Icons.calendar_month_outlined,
            color: AppTheme.primary,
          ),
          suffixIcon: Icon(
            Icons.chevron_right_outlined,
            color: AppTheme.primary,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    ],
  );
}
