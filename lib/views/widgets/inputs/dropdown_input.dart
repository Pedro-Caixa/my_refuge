import 'package:flutter/material.dart';

class DropdownInput<T> extends StatelessWidget {
  final String? labelText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final Function(T?)? onChanged;

  const DropdownInput({
    Key? key,
    this.labelText,
    this.value,
    required this.items,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      value: value,
      items: items,
      onChanged: onChanged,
    );
  }
}
