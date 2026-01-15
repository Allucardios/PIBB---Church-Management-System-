import 'package:flutter/material.dart';

import '../const/theme.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.label,
  });

  final TextEditingController controller;
  final String hint, label;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscure = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.primary,
            fontWeight: FontWeight.bold,
            wordSpacing: 2,
          ),
        ),
        TextFormField(
          obscureText: _obscure,
          controller: widget.controller,
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.black, fontSize: 16),
          maxLines: 1,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Insira a palavra-passe';
            }
            if (value.length < 8) {
              return 'A palavra-passe deve ter pelo menos 8 caracteres';
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(color: Colors.black54),
            focusColor: Colors.redAccent,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white),
            ),
            prefixIcon: Icon(Icons.lock_outline, color: AppTheme.primary),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscure = !_obscure;
                });
              },
              icon: _obscure
                  ? Icon(Icons.visibility_outlined, color: AppTheme.primary)
                  : Icon(
                      Icons.visibility_off_outlined,
                      color: AppTheme.primary,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
