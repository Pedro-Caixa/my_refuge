import 'package:flutter/material.dart';

class EmailInput extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final Function(String)? onChanged;
  final TextEditingController? controller;

  const EmailInput({
    Key? key,
    this.labelText = "Email",
    this.hintText = "seu@email.com",
    this.onChanged,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
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
