import 'package:flutter/material.dart';

class CheckboxInput extends StatelessWidget {
  final bool value;
  final String label;
  final Function(bool?)? onChanged;

  const CheckboxInput({
    Key? key,
    required this.value,
    required this.label,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        Expanded(
          child: Text(label),
        ),
      ],
    );
  }
}
