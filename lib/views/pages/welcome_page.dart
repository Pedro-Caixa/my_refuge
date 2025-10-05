import 'package:flutter/material.dart';
import '../template/auth_template.dart';
import '../widgets/sections/auth_header.dart';
import '../widgets/sections/auth_toggler.dart';
import '../widgets/inputs/email_input.dart';
import '../widgets/inputs/password_input.dart';
import '../widgets/buttons/main_button.dart';
import '../widgets/sections/anonymous_access.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _obscurePassword = true;
  final List<bool> _selection = [true, false];

  @override
  Widget build(BuildContext context) {
    return AuthTemplate(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildBackButton(),
          const SizedBox(height: 10),
          const AuthHeader(
            title: "Bem-vindo ao My Refuge",
            subtitle: "Seu refúgio para o bem-estar emocional",
          ),
          const SizedBox(height: 20),
          AuthToggler(
            isSelected: _selection,
            onPressed: (index) {
              setState(() {
                for (int i = 0; i < _selection.length; i++) {
                  _selection[i] = i == index;
                }
              });
              if (index == 1) {
                Navigator.pushNamed(context, '/register');
              }
            },
          ),
          const SizedBox(height: 25),
          _buildLoginForm(),
          const SizedBox(height: 25),
          // Corrigido: adicionando a ação para o botão "Usar Anonimamente"
          AnonymousAccessSection(
            onPressed: () {
              // Navega para a tela inicial quando o botão for pressionado
              Navigator.pushNamed(context, '/home');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.topLeft,
      child: TextButton(
        onPressed: () {
          if (Navigator.of(context).canPop()) {
            Navigator.pop(context);
          }
        },
        child: const Text(
          "← Voltar",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const EmailInput(),
          const SizedBox(height: 15),
          PasswordInput(
            obscurePassword: _obscurePassword,
            onToggleVisibility: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          const SizedBox(height: 20),
          MainButton(
            text: "Entrar",
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Refuge Home'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF80DEEA), Color(0xFF4DD0E1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const Center(
          child: Text(
            'Bem-vindo ao seu refúgio!',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
