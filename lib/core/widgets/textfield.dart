import 'package:flutter/material.dart';

import '../const/theme.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon, required this.label,
  });
  final TextEditingController controller;
  final String hint, label;
  final IconData icon;

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
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.black, fontSize: 16),
          maxLines: 1,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Preencha o campo';
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

class MyTextFieldNoValidate extends StatelessWidget {
  const MyTextFieldNoValidate({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    required this.label,
  });
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final String label;

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
            wordSpacing: 12,
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(color: Colors.black, fontSize: 16),
          maxLines: 1,
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
