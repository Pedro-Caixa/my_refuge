import 'package:flutter/material.dart';

class DropdownInputForm<T> extends StatelessWidget {
  final T? value;
  final String labelText;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;

  const DropdownInputForm({
    Key? key,
    required this.value,
    required this.labelText,
    required this.items,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(labelText: labelText),
      items: items,
      onChanged: onChanged,
      validator: validator,
    );
  }
}
