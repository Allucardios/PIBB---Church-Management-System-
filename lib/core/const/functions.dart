//Libraries
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//Local Imports
import 'theme.dart';

const months = [
  'Janeiro',
  'Fevereiro',
  'Março',
  'Abril',
  'Maio',
  'Junho',
  'Julho',
  'Agosto',
  'Setembro',
  'Outubro',
  'Novembro',
  'Dezembro',
];

void errorDialog(BuildContext context, String title, String sms, Color cor) {
  showDialog(
    context: context,
    builder: (_) =>
        AlertDialog(
          title: Text(title),
          content: Text(sms),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                  'Cancelar', style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        ),
  );
}

void snackDialog(BuildContext context, String sms, Color cor) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: cor,
      closeIconColor: Colors.white,
      showCloseIcon: true,
      content: Text(sms),
    ),
  );
}

String formatDate(DateTime date) {
  const weekdays = [
    "Segunda-Feira",
    "Terça-Feira",
    "Quarta-Feira",
    "Quinta-Feira",
    "Sexta-Feira",
    "Sábado",
    "Domingo",
  ];

  final weekdayName = weekdays[date.weekday - 1];
  return "$weekdayName, ${date.day.toString().padLeft(2, '0')}/${date.month
      .toString().padLeft(2, '0')}/${date.year}";
}

String formatDateComplete(DateTime date) {
  const weekdays = [
    "Segunda-Feira",
    "Terça-Feira",
    "Quarta-Feira",
    "Quinta-Feira",
    "Sexta-Feira",
    "Sábado",
    "Domingo",
  ];

  final weekdayName = weekdays[date.weekday - 1];
  return "$weekdayName, ${date.day.toString().padLeft(2, '0')} de ${months[date
      .month - 1]} de ${date.year}";
}

String formatDateTF(DateTime date) {
  return " ${date.day.toString().padLeft(2, '0')}/${date.month
      .toString()
      .padLeft(2, '0')}/${date.year}";
}

String formatKwanza(double value) {
  final parts = value.toStringAsFixed(2).split('.');
  String integerPart = parts[0];
  final decimalPart = parts[1];

  final buffer = StringBuffer();
  for (int i = 0; i < integerPart.length; i++) {
    final reverseIndex = integerPart.length - i;
    buffer.write(integerPart[i]);
    if (reverseIndex > 1 && reverseIndex % 3 == 1) {
      buffer.write('.');
    }
  }

  return "${buffer.toString()},$decimalPart Kz";
}

double toDouble(String? value) {
  if (value == null || value.isEmpty) return 0;
  // remove vírgulas e espaços, caso o usuário use "1.234,56"
  final cleaned = value.replaceAll(".", "").replaceAll(",", ".");
  try {
    return double.parse(cleaned);
  } catch (e) {
    return 0;
  }
}

Future<bool> showYesNoDialog({
  required BuildContext context,
  required String title,
  required String message,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Não', style: TextStyle(color: Colors.redAccent)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(backgroundColor: AppTheme.primary),
            child: Text('Sim', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );

  return result ?? false;
}

final client = Supabase.instance.client;

String get uid => client.auth.currentUser!.id;

String monthName(int month) {
  if (month < 1 || month > 12) {
    throw ArgumentError('Mês inválido: $month');
  }
  return months[month - 1];
}

int monthNumber(String monthName) {
  // Converte o nome do mês para minúsculas para uma comparação segura
  final index = months.indexOf(monthName.toLowerCase());
  // Se o mês for encontrado, retorna o número (índice + 1). Caso contrário, retorna 0.
  if (index != -1) {
    return index + 1;
  }
  return 0; // Retorna 0 se o nome do mês for inválido
}

int toInt(String? value) {
  if (value == null || value.isEmpty) return 0;
  final cleaned = value.replaceAll(RegExp(r'[\.\s,]'), '');
  try {
    return int.parse(cleaned);
  } catch (e) {
    return 0;
  }
}

void getTo(context, route) =>
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => route));
