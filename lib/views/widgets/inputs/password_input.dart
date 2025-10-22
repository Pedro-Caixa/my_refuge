import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final Function(String)? onChanged;
  final bool obscurePassword;
  final VoidCallback? onToggleVisibility;
  final TextEditingController? controller;

  const PasswordInput({
    Key? key,
    this.labelText = "Senha",
    this.hintText = "Sua senha",
    this.onChanged,
    this.obscurePassword = true,
    this.onToggleVisibility,
    this.controller,
  }) : super(key: key);

  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  late bool _obscurePassword;

  @override
  void initState() {
    super.initState();
    _obscurePassword = widget.obscurePassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
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
            widget.onToggleVisibility?.call();
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
