// Libraries

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local Imports
import '../../core/widgets/admin_gate.dart';
import '../../data/controllers/finance.dart';
import '../../data/models/income.dart';
import '../card/income.dart';
import '../form/income.dart';
import '../view/drawer.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Receitas')),
    drawer: MyDrawer(),
    body: SafeArea(
      child: StreamBuilder<List<Income>>(
        stream: FinanceCtrl().streamIncomes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(child: Text('Sem dados'));
          }

          final map = snapshot.data!;

          return ListView.builder(
            itemCount: map.length,
            itemBuilder: (context, index) => CardIncome(inc: map[index]),
          );
        },
      ),
    ),
    floatingActionButton: PermitGate(
      value: 'Manager',
      child: FloatingActionButton(
        onPressed: () => Get.to(() => IncomeForm()),
        child: Icon(Icons.add),
      ),
    ),
  );
}
