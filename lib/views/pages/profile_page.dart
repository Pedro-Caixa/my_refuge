import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../template/main_template.dart';
import '../widgets/inputs/email_input.dart';
import '../widgets/inputs/password_input.dart';
import '../widgets/inputs/confirm_password_input.dart';
import '../widgets/inputs/text_input.dart';
import '../widgets/inputs/checkbox_input.dart';
import '../widgets/buttons/save_button.dart';
import '../widgets/sections/custom_footer.dart';
import '../../controllers/user_controller.dart';
import '../../models/registration_data.dart';

class CompleteProfilePage extends StatelessWidget {
  const CompleteProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      title: "Completar Perfil",
      currentIndex: 4,
      onItemTapped: (int index) {},
      backgroundColor: const Color(0xFFF5F8FC),
      customBottomNavigationBar: CustomFooter(
        currentIndex: 4,
        onItemTapped: (int index) {},
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildProfileForm(context),
            const SizedBox(height: 16),
            _buildContinueAnonymousButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade400, Colors.deepPurple.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.person_add, color: Colors.white, size: 40),
          SizedBox(height: 12),
          Text(
            "Complete seu Perfil",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Salve seus dados para não perder seu progresso e personalizar sua experiência no My Refuge",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildRequiredFields(context),
          const SizedBox(height: 20),
          _buildOptionalFields(context),
          const SizedBox(height: 16),
          _buildNotificationsCheckbox(context),
          const SizedBox(height: 16),
          _buildSaveButton(context),
        ],
      ),
    );
  }

  Widget _buildRequiredFields(BuildContext context) {
    final registrationData =
        Provider.of<RegistrationData>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Informações de Acesso *",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 12),
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
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: "Tipo de Usuário *",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          value: registrationData.userType.isEmpty
              ? null
              : registrationData.userType,
          items: const [
            DropdownMenuItem(value: "Estudante", child: Text("Estudante")),
            DropdownMenuItem(value: "Colaborador", child: Text("Colaborador")),
          ],
          onChanged: (value) =>
              registrationData.userType = value ?? registrationData.userType,
        ),
        const SizedBox(height: 12),
        TextInput(
          labelText: "Nome *",
          hintText: "Seu nome",
          onChanged: (value) => registrationData.name = value,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: "Faixa Etária *",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          value: registrationData.ageRange.isEmpty
              ? null
              : registrationData.ageRange,
          items: const [
            DropdownMenuItem(value: '18-25', child: Text('18-25 anos')),
            DropdownMenuItem(value: '26-35', child: Text('26-35 anos')),
            DropdownMenuItem(value: '36-45', child: Text('36-45 anos')),
            DropdownMenuItem(value: '46-60', child: Text('46-60 anos')),
            DropdownMenuItem(value: '61+', child: Text('61+ anos')),
          ],
          onChanged: (value) =>
              registrationData.ageRange = value ?? registrationData.ageRange,
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
          labelText: "Profissão",
          hintText: "Sua profissão",
          onChanged: (value) => registrationData.profession = value,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: "Mora Sozinho",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          value: registrationData.livesAlone,
          items: const [
            DropdownMenuItem(value: "sim", child: Text("Sim")),
            DropdownMenuItem(value: "nao", child: Text("Não")),
          ],
          onChanged: (value) => registrationData.livesAlone =
              value ?? registrationData.livesAlone,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: "Sexo",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
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

  Widget _buildSaveButton(BuildContext context) {
    final registrationData =
        Provider.of<RegistrationData>(context, listen: false);
    final userController = Provider.of<UserController>(context);

    return userController.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              SaveButton(
                text: "Salvar Perfil",
                onPressed: () async {
                  if (_validateRegistration(registrationData, context)) {
                    final success = await userController
                        .completeAnonymousProfile(registrationData);

                    if (success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Perfil salvo com sucesso! 🎉'),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ),
                      );
                      Navigator.pushReplacementNamed(context, '/home');
                    } else if (userController.errorMessage != null &&
                        context.mounted) {
                      _showValidationError(
                          context, userController.errorMessage!);
                    }
                  }
                },
              ),
            ],
          );
  }

  Widget _buildContinueAnonymousButton(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text(
          "Continuar como anônimo",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  bool _validateRegistration(RegistrationData data, BuildContext context) {
    if (data.userType.isEmpty) {
      _showValidationError(context, 'Tipo de usuário é obrigatório');
      return false;
    }
    if (data.name.isEmpty) {
      _showValidationError(context, 'Nome é obrigatório');
      return false;
    }
    if (data.ageRange.isEmpty) {
      _showValidationError(context, 'Faixa etária é obrigatória');
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
