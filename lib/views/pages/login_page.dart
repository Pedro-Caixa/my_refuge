import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../template/auth_template.dart';
import '../widgets/sections/auth_header.dart';
import '../widgets/inputs/email_input.dart';
import '../widgets/inputs/password_input.dart';
import '../widgets/buttons/main_button.dart';
import '../widgets/buttons/selectable_button.dart';
import '../widgets/sections/anonymous_access.dart';
import '../widgets/anonymous_login_dialog.dart';
import '../../controllers/user_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _selectedAuthMode = 0; // 0 para Login, 1 para Cadastro
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
            child: Consumer<UserController>(
              builder: (context, userController, _) {
                return Column(
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
                );
              }
            ),
          ),
          const SizedBox(height: 25),
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
}
