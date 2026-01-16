import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/const/functions.dart';
import '../../core/const/theme.dart';
import '../../core/widgets/money_tf.dart';
import '../../core/widgets/textfield.dart';
import '../../data/models/income.dart';
import '../../data/providers/finance_provider.dart';

class IncomeForm extends ConsumerStatefulWidget {
  const IncomeForm({super.key, this.income});
  final Income? income;

  @override
  ConsumerState<IncomeForm> createState() => _IncomeFormState();
}

class _IncomeFormState extends ConsumerState<IncomeForm> {
  late DateTime _date;
  final key = GlobalKey<FormState>();

  final tithes = TextEditingController();
  final offerings = TextEditingController();
  final date = TextEditingController();
  final missions = TextEditingController();
  final pledged = TextEditingController();
  final special = TextEditingController();
  final other = TextEditingController();
  final obs = TextEditingController();

  // Clean the TextFields
  void clean() {
    tithes.clear();
    offerings.clear();
    date.clear();
    missions.clear();
    pledged.clear();
    special.clear();
    other.clear();
    obs.clear();
  }

  // Populate the document income
  Income doc() => Income(
    id: widget.income?.id,
    accountId: widget.income?.accountId,
    date: _date,
    tithes: toDouble(tithes.text),
    offerings: toDouble(offerings.text),
    missions: toDouble(missions.text),
    pledged: toDouble(pledged.text),
    special: toDouble(special.text),
    other: toDouble(other.text),
    obs: obs.text,
  );

  @override
  void initState() {
    super.initState();
    if (widget.income != null) {
      _date = widget.income!.date;
      tithes.text = widget.income!.tithes.toString();
      offerings.text = widget.income!.offerings.toString();
      missions.text = widget.income!.missions.toString();
      pledged.text = widget.income!.pledged.toString();
      special.text = widget.income!.special.toString();
      other.text = widget.income!.other.toString();
      obs.text = widget.income!.obs ?? '';
    } else {
      _date = DateTime.now();
    }
    date.text = formatDate(_date);
  }

  @override
  void dispose() {
    tithes.dispose();
    offerings.dispose();
    date.dispose();
    missions.dispose();
    pledged.dispose();
    special.dispose();
    other.dispose();
    obs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isEditing = widget.income != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Receita' : 'Nova Receita'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: key,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              spacing: 8,
              children: [
                dateTf(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: size.width * .45,
                      child: NumberTextField(
                        controller: offerings,
                        hint: 'Oferta do Dia',
                        icon: Icons.volunteer_activism_outlined,
                        label: 'Ofertas',
                      ),
                    ),
                    SizedBox(
                      width: size.width * .45,
                      child: NumberTextField(
                        controller: tithes,
                        hint: 'Dizimos do Dia',
                        icon: Icons.card_giftcard_outlined,
                        label: 'Dizimo',
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: size.width * .45,
                      child: NumberTextField(
                        controller: missions,
                        hint: 'Missões Provinciais / Nacionais',
                        icon: Icons.public,
                        label: 'Missões',
                      ),
                    ),
                    SizedBox(
                      width: size.width * .45,
                      child: NumberTextField(
                        controller: pledged,
                        hint: 'Ofertas Alçadas',
                        icon: Icons.handshake_outlined,
                        label: 'Ofertas Alçadas',
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: size.width * .45,
                      child: NumberTextField(
                        controller: special,
                        hint: 'Ofertas Especial',
                        icon: Icons.star_border_sharp,
                        label: 'Ofertas Especial',
                      ),
                    ),
                    SizedBox(
                      width: size.width * .45,
                      child: NumberTextField(
                        controller: other,
                        hint: 'Outras Ofertas',
                        icon: Icons.category_outlined,
                        label: 'Outras Ofertas',
                      ),
                    ),
                  ],
                ),
                MyTextFieldNoValidate(
                  controller: obs,
                  hint: 'Observação da Receita',
                  icon: Icons.warning_amber_outlined,
                  label: 'Observação',
                ),

                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (key.currentState!.validate()) {
                        if (isEditing) {
                          await ref
                              .read(financeServiceProvider.notifier)
                              .updateIncome(doc());
                        } else {
                          await ref
                              .read(financeServiceProvider.notifier)
                              .addIncome(doc());
                        }
                        clean();
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
    );
  }

  Widget dateTf() => Column(
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
