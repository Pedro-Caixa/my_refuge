import 'package:flutter/material.dart';

class TextInputForm extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final int? maxLines;
  final TextInputType? keyboardType;

  const TextInputForm({
    Key? key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.maxLines = 1,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      validator: validator,
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }
}
