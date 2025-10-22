import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../template/auth_template.dart';
import '../widgets/sections/auth_header.dart';
import '../widgets/sections/auth_toggler.dart';
import '../widgets/inputs/email_input.dart';
import '../widgets/inputs/password_input.dart';
import '../widgets/buttons/main_button.dart';
import '../widgets/sections/anonymous_access.dart';
import '../widgets/anonymous_login_dialog.dart';
import '../../controllers/user_controller.dart';

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
          // Utiliza o UserController para login anônimo
          AnonymousAccessSection(
            onPressed: () async {
              // Abrir diálogo de login anônimo
              final result = await showDialog<bool>(
                context: context,
                builder: (context) => const AnonymousLoginDialog(),
              );
              
              // Se o login for bem-sucedido, navegar para a página inicial
              if (result == true && mounted) {
                Navigator.pushReplacementNamed(context, '/home');
              }
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

  // Controllers para capturar os valores dos campos
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildLoginForm() {
    final userController = Provider.of<UserController>(context);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          EmailInput(
            controller: _emailController,
          ),
          const SizedBox(height: 15),
          PasswordInput(
            controller: _passwordController,
            obscurePassword: _obscurePassword,
            onToggleVisibility: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          if (userController.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                userController.errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          const SizedBox(height: 20),
          userController.isLoading
              ? const CircularProgressIndicator()
              : MainButton(
                  text: "Entrar",
                  onPressed: () async {
                    // Realizar login utilizando o controlador
                    final success = await userController.login(
                      _emailController.text.trim(),
                      _passwordController.text,
                    );
                    
                    if (success && mounted) {
                      Navigator.pushReplacementNamed(context, '/home');
                    }
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
