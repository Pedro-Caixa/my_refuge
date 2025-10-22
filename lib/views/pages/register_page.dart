import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../template/auth_template.dart';
import '../widgets/sections/auth_header.dart';
import '../widgets/inputs/email_input.dart';
import '../widgets/inputs/password_input.dart';
import '../widgets/inputs/confirm_password_input.dart';
import '../widgets/inputs/text_input.dart';
import '../widgets/inputs/dropdown_input.dart';
import '../widgets/inputs/checkbox_input.dart';
import '../widgets/buttons/main_button.dart';
import '../widgets/sections/anonymous_access.dart';
import '../widgets/anonymous_login_dialog.dart';
import '../../controllers/user_controller.dart';
import '../../models/registration_data.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthTemplate(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildBackButton(context),
          const SizedBox(height: 10),
          const AuthHeader(
            title: "Bem-vindo ao My Refuge",
            subtitle: "Seu refúgio para o bem-estar emocional",
          ),
          const SizedBox(height: 20),
          _buildRegistrationForm(context),
          const SizedBox(height: 16),
          AnonymousAccessSection(
            onPressed: () async {
              // Abrir diálogo de login anônimo
              final result = await showDialog<bool>(
                context: context,
                builder: (context) => const AnonymousLoginDialog(),
              );
              
              // Se o login for bem-sucedido, navegar para a página inicial
              if (result == true && context.mounted) {
                Navigator.pushReplacementNamed(context, '/home');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        label: const Text(
          "Voltar",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildRegistrationForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildRequiredFields(context),
          const SizedBox(height: 20),
          _buildOptionalFields(context),
          const SizedBox(height: 16),
          _buildNotificationsCheckbox(context),
          const SizedBox(height: 16),
          _buildCreateAccountButton(context),
        ],
      ),
    );
  }

  Widget _buildRequiredFields(BuildContext context) {
    final registrationData =
        Provider.of<RegistrationData>(context, listen: false);

    return Column(
      children: [
        EmailInput(
          onChanged: (value) => registrationData.email = value,
        ),
        const SizedBox(height: 12),
        PasswordInput(
          onChanged: (value) => registrationData.password = value,
        ),
        const SizedBox(height: 12),
        ConfirmPasswordInput(
          onChanged: (value) => registrationData.confirmPassword = value,
        ),
        const SizedBox(height: 12),
        DropdownInput<String>(
          labelText: "Tipo de Usuário *",
          value: registrationData.userType,
          items: const [
            DropdownMenuItem(value: "paciente", child: Text("Paciente")),
            DropdownMenuItem(
                value: "profissional", child: Text("Profissional")),
          ],
          onChanged: (value) =>
              registrationData.userType = value ?? registrationData.userType,
        ),
      ],
    );
  }

  Widget _buildOptionalFields(BuildContext context) {
    final registrationData =
        Provider.of<RegistrationData>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Informações Opcionais",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        TextInput(
          labelText: "Nome",
          hintText: "Seu nome",
          onChanged: (value) => registrationData.name = value,
        ),
        const SizedBox(height: 12),
        TextInput(
          labelText: "Faixa Etária",
          hintText: "Idade",
          keyboardType: TextInputType.number,
          onChanged: (value) => registrationData.ageRange = value,
        ),
        const SizedBox(height: 12),
        TextInput(
          labelText: "Profissão",
          hintText: "Sua profissão",
          onChanged: (value) => registrationData.profession = value,
        ),
        const SizedBox(height: 12),
        DropdownInput<String>(
          labelText: "Mora Sozinho",
          value: registrationData.livesAlone,
          items: const [
            DropdownMenuItem(value: "sim", child: Text("Sim")),
            DropdownMenuItem(value: "nao", child: Text("Não")),
          ],
          onChanged: (value) => registrationData.livesAlone =
              value ?? registrationData.livesAlone,
        ),
        const SizedBox(height: 12),
        DropdownInput<String>(
          labelText: "Sexo",
          value: registrationData.gender,
          items: const [
            DropdownMenuItem(value: "masc", child: Text("Masculino")),
            DropdownMenuItem(value: "fem", child: Text("Feminino")),
            DropdownMenuItem(value: "outro", child: Text("Outro")),
          ],
          onChanged: (value) =>
              registrationData.gender = value ?? registrationData.gender,
        ),
        const SizedBox(height: 12),
        TextInput(
          labelText: "Tempo Disponível",
          hintText: "Ex: 2 horas por dia",
          onChanged: (value) => registrationData.availableTime = value,
        ),
        const SizedBox(height: 12),
        TextInput(
          labelText: "Hobbies",
          hintText: "Seus hobbies e interesses",
          onChanged: (value) => registrationData.hobbies = value,
        ),
      ],
    );
  }

  Widget _buildNotificationsCheckbox(BuildContext context) {
    final registrationData =
        Provider.of<RegistrationData>(context, listen: false);

    return CheckboxInput(
      value: registrationData.receivesNotifications,
      label: "Receber notificações para lembrá-lo do bem-estar",
      onChanged: (value) =>
          registrationData.receivesNotifications = value ?? true,
    );
  }

  Widget _buildCreateAccountButton(BuildContext context) {
    final registrationData = Provider.of<RegistrationData>(context, listen: false);
    final userController = Provider.of<UserController>(context);
    
    return userController.isLoading
        ? const CircularProgressIndicator()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MainButton(
                text: "Criar Conta",
                onPressed: () async {
                  // Validar e enviar os dados para registro
                  if (_validateRegistration(registrationData, context)) {
                    final success = await userController.registerUser(registrationData);
                    
                    if (success && context.mounted) {
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  }
                },
              ),
              if (userController.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    userController.errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          );
  }
  
  // Método para validar os dados de registro
  bool _validateRegistration(RegistrationData data, BuildContext context) {
    if (data.name.isEmpty) {
      _showValidationError(context, 'Nome é obrigatório');
      return false;
    }
    if (data.email.isEmpty || !data.email.contains('@')) {
      _showValidationError(context, 'Email inválido');
      return false;
    }
    if (data.password.isEmpty || data.password.length < 6) {
      _showValidationError(context, 'A senha deve ter pelo menos 6 caracteres');
      return false;
    }
    if (data.password != data.confirmPassword) {
      _showValidationError(context, 'As senhas não coincidem');
      return false;
    }
    return true;
  }
  
  // Método para exibir erros de validação
  void _showValidationError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
