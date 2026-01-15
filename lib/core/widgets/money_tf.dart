import 'package:flutter/material.dart';

import '../const/theme.dart';

class NumberTextField extends StatelessWidget {
  const NumberTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    required this.label, this.limit,
  });
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final String label;
  final int? limit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 0,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.primary,
            fontWeight: FontWeight.bold,
            wordSpacing: 2,
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType:TextInputType.numberWithOptions(decimal: true, signed: true),
          style: TextStyle(color: Colors.black, fontSize: 16),
          maxLength: limit,
          maxLines: 1,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Preencha o campo';
            return null;
          },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.black54),
            focusColor: Colors.redAccent,
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(icon, color: AppTheme.primary),
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
