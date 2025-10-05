import 'package:flutter/material.dart';
import '../template/auth_template.dart';
import '../widgets/sections/auth_header.dart';
import '../widgets/inputs/email_input.dart';
import '../widgets/inputs/password_input.dart';
import '../widgets/buttons/main_button.dart'; // Importar o MainButton
import '../widgets/buttons/selectable_button.dart'; // Importar o SelectableButton
import '../widgets/sections/anonymous_access.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _selectedAuthMode = 0; // 0 para Login, 1 para Cadastro

  @override
  Widget build(BuildContext context) {
    return AuthTemplate(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: TextButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: const Text(
                "← Voltar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const AuthHeader(
            title: "Bem-vindo ao My Refuge",
            subtitle: "Seu refúgio para o bem-estar emocional",
          ),
          const SizedBox(height: 20),
          // Substituindo AuthToggler por dois SelectableButton
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SelectableButton(
                text: "Entrar",
                icon: Icons.login,
                isSelected: _selectedAuthMode == 0,
                onPressed: () {
                  setState(() {
                    _selectedAuthMode = 0;
                  });
                },
              ),
              const SizedBox(width: 16),
              SelectableButton(
                text: "Cadastrar",
                icon: Icons.person_add,
                isSelected: _selectedAuthMode == 1,
                onPressed: () {
                  setState(() {
                    _selectedAuthMode = 1;
                    Navigator.pushNamed(context, '/register');
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const EmailInput(),
                const SizedBox(height: 15),
                const PasswordInput(),
                const SizedBox(height: 20),
                // Substituindo PrimaryButton por MainButton
                MainButton(
                  text: "Entrar",
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  // Você pode personalizar as cores do gradiente se desejar
                  // gradientColors: [Color(0xFF4DD0E1), Color(0xFF80DEEA)],
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          AnonymousAccessSection(
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
        ],
      ),
    );
  }
}
