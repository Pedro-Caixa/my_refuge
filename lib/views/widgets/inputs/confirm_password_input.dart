import 'package:flutter/material.dart';

class ConfirmPasswordInput extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final Function(String)? onChanged;

  const ConfirmPasswordInput({
    Key? key,
    this.labelText = "Confirmar Senha",
    this.hintText = "Confirme sua senha",
    this.onChanged,
  }) : super(key: key);

  @override
  _ConfirmPasswordInputState createState() => _ConfirmPasswordInputState();
}

class _ConfirmPasswordInputState extends State<ConfirmPasswordInput> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: widget.onChanged,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
