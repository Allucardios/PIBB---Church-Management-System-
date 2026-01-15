// Libraries
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Local Imports
import '../../core/const/functions.dart';
import '../../core/const/theme.dart';
import '../report/anual.dart';
import '../report/month.dart';
import '../report/quaterly.dart';

import '../../core/widgets/responsive.dart';

//enum
enum PeriodType { mensal, trimestral, anual }

class ReportPage extends ConsumerStatefulWidget {
  const ReportPage({super.key});

  @override
  ConsumerState<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends ConsumerState<ReportPage> {
  final _formKey = GlobalKey<FormState>();

  PeriodType? _selectedType;

  final _monthCtrl = TextEditingController();
  final _quarterCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();

  @override
  void dispose() {
    _monthCtrl.dispose();
    _quarterCtrl.dispose();
    _yearCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório'),
        leading: isDesktop ? const SizedBox.shrink() : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<PeriodType>(
                    decoration: InputDecoration(
                      labelText: 'Tipo de Período',
                      hintStyle: const TextStyle(color: Colors.black54),
                      focusColor: Colors.grey.shade200,
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.calendar_month,
                        color: AppTheme.primary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                    value: _selectedType,
                    validator: (value) {
                      if (value == null) {
                        return 'Selecione o tipo de período';
                      }
                      return null;
                    },
                    items: const [
                      DropdownMenuItem(
                        value: PeriodType.mensal,
                        child: Text('Mensal'),
                      ),
                      DropdownMenuItem(
                        value: PeriodType.trimestral,
                        child: Text('Trimestral'),
                      ),
                      DropdownMenuItem(
                        value: PeriodType.anual,
                        child: Text('Anual'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value;
                        _monthCtrl.clear();
                        _quarterCtrl.clear();
                        _yearCtrl.clear();
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  if (_selectedType == PeriodType.mensal) ...[
                    TextFormField(
                      controller: _monthCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Mês (1–12)',
                        hintText: '1',
                        hintStyle: const TextStyle(color: Colors.black54),
                        focusColor: Colors.redAccent,
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          Icons.calendar_month,
                          color: AppTheme.primary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: (value) {
                        if (_selectedType != PeriodType.mensal) return null;
                        if (value == null || value.isEmpty) {
                          return 'Informe o mês';
                        }
                        final m = int.tryParse(value);
                        if (m == null || m < 1 || m > 12) {
                          return 'Mês inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _yearCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Ano',
                        hintText: 'Informe o ano',
                        hintStyle: const TextStyle(color: Colors.black54),
                        focusColor: Colors.redAccent,
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          Icons.calendar_month,
                          color: AppTheme.primary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: _yearValidator,
                    ),
                  ],

                  if (_selectedType == PeriodType.trimestral) ...[
                    TextFormField(
                      controller: _quarterCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Trimestre (1–4)',
                        hintText: '3',
                        hintStyle: const TextStyle(color: Colors.black54),
                        focusColor: Colors.redAccent,
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          Icons.calendar_month,
                          color: AppTheme.primary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: (value) {
                        if (_selectedType != PeriodType.trimestral) return null;
                        if (value == null || value.isEmpty) {
                          return 'Informe o trimestre';
                        }
                        final q = int.tryParse(value);
                        if (q == null || q < 1 || q > 4) {
                          return 'Trimestre inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _yearCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Ano',
                        hintText: 'Informe o ano',
                        hintStyle: const TextStyle(color: Colors.black54),
                        focusColor: Colors.redAccent,
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          Icons.calendar_month,
                          color: AppTheme.primary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: _yearValidator,
                    ),
                  ],

                  if (_selectedType == PeriodType.anual) ...[
                    TextFormField(
                      controller: _yearCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Ano',
                        hintText: 'Informe o ano',
                        hintStyle: const TextStyle(color: Colors.black54),
                        focusColor: Colors.redAccent,
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          Icons.calendar_month,
                          color: AppTheme.primary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: _yearValidator,
                    ),
                  ],

                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_selectedType == PeriodType.mensal) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => MonthlyReportScreen(
                                month: toInt(_monthCtrl.text),
                                year: toInt(_yearCtrl.text),
                              ),
                            ),
                          );
                        }
                        if (_selectedType == PeriodType.trimestral) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => QuarterlyReportScreen(
                                quarter: toInt(_quarterCtrl.text),
                                year: toInt(_yearCtrl.text),
                              ),
                            ),
                          );
                        }
                        if (_selectedType == PeriodType.anual) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AnnualReportScreen(
                                year: toInt(_yearCtrl.text),
                              ),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('Gerar Relatório'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =========================
  // VALIDATOR DO ANO
  // =========================
  String? _yearValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe o ano';
    }
    final y = int.tryParse(value);
    if (y == null || y < 2000 || y > DateTime.now().year + 1) {
      return 'Ano inválido';
    }
    return null;
  }
}
