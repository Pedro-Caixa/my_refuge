import 'package:flutter/material.dart';
import '../widgets/buttons/custom_button.dart';

/// Example usage of CustomButton in a login/registration form context
class CustomButtonExampleUsage extends StatefulWidget {
  const CustomButtonExampleUsage({Key? key}) : super(key: key);

  @override
  State<CustomButtonExampleUsage> createState() => _CustomButtonExampleUsageState();
}

class _CustomButtonExampleUsageState extends State<CustomButtonExampleUsage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() => _isLoading = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login realizado com sucesso!')),
      );
    }
  }

  void _handleSocialLogin(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login com $provider')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Example'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo/Title area
              const SizedBox(height: 40),
              const Icon(
                Icons.home,
                size: 80,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 16),
              const Text(
                'Bem-vindo ao My Refuge',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 40),

              // Email field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Por favor, insira seu email';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),

              // Password field
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Por favor, insira sua senha';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Primary login button - using CustomButton
              CustomButton(
                text: 'Entrar',
                icon: Icons.login,
                backgroundColor: Colors.deepPurple,
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _handleLogin,
              ),

              const SizedBox(height: 16),

              // Secondary action buttons
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Esqueci a senha',
                      backgroundColor: Colors.grey.shade200,
                      textColor: Colors.grey.shade700,
                      elevation: 1,
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Recuperar senha')),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: 'Criar conta',
                      icon: Icons.person_add,
                      backgroundColor: Colors.green,
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Criar nova conta')),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Social login section
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('ou continue com'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 16),

              // Social login buttons - icon only examples
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    icon: Icons.g_mobiledata, // Google icon placeholder
                    backgroundColor: Colors.red,
                    onPressed: () => _handleSocialLogin('Google'),
                    semanticLabel: 'Login com Google',
                  ),
                  CustomButton(
                    icon: Icons.facebook, // Facebook icon
                    backgroundColor: Colors.blue.shade800,
                    onPressed: () => _handleSocialLogin('Facebook'),
                    semanticLabel: 'Login com Facebook',
                  ),
                  CustomButton(
                    icon: Icons.apple, // Apple icon
                    backgroundColor: Colors.black,
                    onPressed: () => _handleSocialLogin('Apple'),
                    semanticLabel: 'Login com Apple',
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Action buttons section
              const Text(
                'Ações rápidas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Quick action buttons
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  CustomButton(
                    icon: Icons.support_agent,
                    text: 'Suporte',
                    backgroundColor: Colors.orange,
                    fontSize: 14,
                    onPressed: () => _handleSocialLogin('Suporte'),
                  ),
                  CustomButton(
                    icon: Icons.info,
                    text: 'Sobre',
                    backgroundColor: Colors.teal,
                    fontSize: 14,
                    onPressed: () => _handleSocialLogin('Sobre'),
                  ),
                  CustomButton(
                    icon: Icons.settings,
                    text: 'Configurações',
                    backgroundColor: Colors.grey.shade600,
                    fontSize: 14,
                    onPressed: () => _handleSocialLogin('Configurações'),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}