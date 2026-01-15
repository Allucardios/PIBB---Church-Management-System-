// Libraries

import 'package:app_pibb/core/widgets/admin_gate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local Imports
import '../../core/const/functions.dart';
import '../../core/const/theme.dart';
import '../../data/controllers/finance.dart';
import '../../data/controllers/profile.dart';
import '../../data/models/income.dart';

class ViewIncome extends StatelessWidget {
  const ViewIncome({super.key, required this.inc});
  final Income inc;

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<FinanceCtrl>();
    final prof = Get.find<ProfileCtrl>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes da Receita"),
        centerTitle: true,
        actions: [
          PermitGate(
            value: 'Manager',
            child: IconButton(
              onPressed: () async {
                final confirmed = await showYesNoDialog(
                  title: "Confirmação",
                  message: "Tem certeza que deseja apagar este item?",
                );
                if (confirmed) {
                  ctrl.deleteIncome(inc.id!);
                  Get.back();
                }
              },
              icon: Icon(Icons.delete_outline, color: Colors.redAccent),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            spacing: 8,
            children: [_headerCard(context), _amountsCard(), _obsCard()],
          ),
        ),
      ),
    );
  }

  // ---------------------------
  Widget _headerCard(BuildContext ctx) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(
          Icons.calendar_month_outlined,
          size: 40,
          color: AppTheme.primary,
        ),
        title: Text(formatDate(inc.date), style: TextStyle(fontSize: 16)),
        subtitle: Text("Registro Nº ${inc.id}", style: TextStyle(fontSize: 14)),
      ),
    );
  }

  // ---------------------------
  Widget _amountsCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Wrap(
            children: [
              _valueTile("Dízimos", inc.tithes),
              _valueTile("Ofertas", inc.offerings),
              _valueTile("Missões", inc.missions),
              _valueTile("Ofertas Alçadas", inc.pledged),
              _valueTile("Ofertas Especiais", inc.special),
              _valueTile("Outros", inc.other),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  "Total: ${formatKwanza(inc.totalIncome())}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _obsCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Observação:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                inc.obs?.isNotEmpty == true
                    ? '=> ${inc.obs!}'
                    : "Nenhuma observação.",
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _valueTile(String label, double value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: Get.width * .43,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.secondary.withOpacity(.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 14, color: Colors.grey)),
            Text(
              "${formatKwanza(value)} ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
