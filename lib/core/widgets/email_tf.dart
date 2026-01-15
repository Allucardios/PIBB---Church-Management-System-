import 'package:flutter/material.dart';

import '../const/theme.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    super.key,
    required this.controller,
    required this.hint,
  });
  final TextEditingController controller;
  final String hint;

  // Email validation regex
  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 0,
      children: [
        Text(
          'Email',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.primary,
            fontWeight: FontWeight.bold,
            wordSpacing: 2,
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(color: Colors.black, fontSize: 16),
          maxLines: 1,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Preencha o email';
            }
            if (!_emailRegex.hasMatch(value)) {
              return 'Email inválido';
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,

          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.black54),
            focusColor: Colors.redAccent,
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(Icons.email_outlined, color: AppTheme.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
