import 'package:flutter/material.dart';

import '../const/theme.dart';

class DropDownTextField extends StatefulWidget {
  const DropDownTextField({
    super.key,
    required this.ctrl,
    required this.label,
    required this.list,
    required this.icon,
    required this.hint,
  });
  final TextEditingController ctrl;
  final String label;
  final List<String> list;
  final IconData icon;
  final String hint;

  @override
  State<DropDownTextField> createState() => _DropDownTextFieldState();
}

class _DropDownTextFieldState extends State<DropDownTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 0,
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
          controller: widget.ctrl,
          readOnly: true,
          style: TextStyle(color: Colors.black, fontSize: 16),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Preencha o campo';
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
            prefixIcon: Icon(widget.icon, color: AppTheme.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white),
            ),
            suffixIcon: PopupMenuButton<String>(
              icon: const Icon(Icons.arrow_drop_down, color: AppTheme.primary,),
              itemBuilder: (BuildContext context) => widget.list
                  .map(
                    (String value) =>
                        PopupMenuItem<String>(value: value, child: Text(value)),
                  )
                  .toList(),
              onSelected: _onChange,
            ),
          ),
        ),
      ],
    );
  }

  void _onChange(String value) {
    setState(() {
      widget.ctrl.text = value;
    });
  }
}
