import 'package:flutter/material.dart';

class EmailInput extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final Function(String)? onChanged;

  const EmailInput({
    Key? key,
    this.labelText = "Email",
    this.hintText = "seu@email.com",
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}
