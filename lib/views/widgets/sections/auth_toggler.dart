import 'package:flutter/material.dart';

class AuthToggler extends StatelessWidget {
  final List<bool> isSelected;
  final Function(int) onPressed;

  const AuthToggler({
    Key? key,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      borderRadius: BorderRadius.circular(30),
      fillColor: Colors.white,
      selectedColor: Colors.teal,
      color: Colors.white,
      isSelected: isSelected,
      onPressed: onPressed,
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(Icons.login, size: 18),
              SizedBox(width: 6),
              Text("Entrar"),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(Icons.person_add, size: 18),
              SizedBox(width: 6),
              Text("Cadastrar"),
            ],
          ),
        ),
      ],
    );
  }
}
