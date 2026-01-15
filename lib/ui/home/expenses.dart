// Libraries
import 'package:app_pibb/core/widgets/admin_gate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local Imports
import '../../data/controllers/finance.dart';
import '../../data/controllers/profile.dart';
import '../card/expense.dart';
import '../form/expense.dart';
import '../view/drawer.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  final ctrl = Get.find<FinanceCtrl>();
  final prof = Get.find<ProfileCtrl>();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Despesas')),
    drawer: MyDrawer(),
    body: SafeArea(
      child: StreamBuilder(
        stream: ctrl.streamExpenses(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Sem dados'));
          }

          final map = snapshot.data!;

          return ListView.builder(
            itemCount: map.length,
            itemBuilder: (context, index) =>
                CardExpense(exp: map[index]),
          );
        },
      ),
    ),
    floatingActionButton: PermitGate(
      value: 'Manager',
      child: FloatingActionButton(
        onPressed: () => Get.to(() => ExpenseForm()),
        child: Icon(Icons.add),
      ),
    ),
  );
}
