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

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({Key? key}) : super(key: key);

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers para os campos de texto
  late TextEditingController _emailController;
  late TextEditingController _nameController;
  late TextEditingController _professionController;
  late TextEditingController _availableTimeController;
  late TextEditingController _hobbiesController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _dateController;

  // Valores dos dropdowns
  String? _selectedUserType;
  DateTime? _birthDate;
  String? _selectedLivesAlone;
  String? _selectedGender;
  bool _receivesNotifications = true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadUserData();
  }

  void _initializeControllers() {
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _professionController = TextEditingController();
    _availableTimeController = TextEditingController();
    _hobbiesController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _dateController = TextEditingController();
  }

  void _loadUserData() {
    final userController = Provider.of<UserController>(context, listen: false);
    final user = userController.currentUser;

    if (user != null && !user.isAnonymous) {
      setState(() {
        _emailController.text = user.email ?? '';
        _nameController.text = user.name;
        _professionController.text = user.profession ?? '';
        _availableTimeController.text = user.availableTime ?? '';
        _hobbiesController.text = user.hobbies ?? '';
        _selectedUserType = user.userType.isNotEmpty ? user.userType : null;

        // Tenta carregar a data de nascimento se estiver no formato ISO
        if (user.ageRange.isNotEmpty) {
          try {
            _birthDate = DateTime.parse(user.ageRange);
            _dateController.text =
                '${_birthDate!.day.toString().padLeft(2, '0')}/${_birthDate!.month.toString().padLeft(2, '0')}/${_birthDate!.year}';
          } catch (e) {
            // Se não for uma data válida, mantém vazio
            _dateController.text = '';
          }
        }

        _selectedLivesAlone = user.livesAlone;
        _selectedGender = user.gender;
        _receivesNotifications = user.receivesNotifications;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2000),
      firstDate: DateTime(1924),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
        _dateController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _professionController.dispose();
    _availableTimeController.dispose();
    _hobbiesController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    final isAnonymous = userController.currentUser?.isAnonymous ?? true;

    return MainTemplate(
      title: isAnonymous ? "Completar Perfil" : "Meu Perfil",
      currentIndex: 5,
      onItemTapped: (int index) {},
      backgroundColor: const Color(0xFFF5F8FC),
      customBottomNavigationBar: CustomFooter(
        currentIndex: 5,
        onItemTapped: (int index) {},
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(isAnonymous),
              const SizedBox(height: 20),
              _buildProfileForm(context, isAnonymous),
              const SizedBox(height: 16),
              if (isAnonymous) _buildContinueAnonymousButton(context),
              if (!isAnonymous) _buildLogoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isAnonymous) {
    final userController = Provider.of<UserController>(context);
    final userName = userController.currentUser?.name ?? "Usuário";

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
        children: [
          Icon(
            isAnonymous ? Icons.person_add : Icons.account_circle,
            color: Colors.white,
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            isAnonymous ? "Complete seu Perfil" : "Olá, $userName!",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isAnonymous
                ? "Salve seus dados para não perder seu progresso e personalizar sua experiência no My Refuge"
                : "Gerencie suas informações e preferências",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileForm(BuildContext context, bool isAnonymous) {
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
          _buildRequiredFields(context, isAnonymous),
          const SizedBox(height: 20),
          _buildOptionalFields(context),
          const SizedBox(height: 16),
          _buildNotificationsCheckbox(),
          const SizedBox(height: 16),
          _buildSaveButton(context, isAnonymous),
        ],
      ),
    );
  }

  Widget _buildRequiredFields(BuildContext context, bool isAnonymous) {
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
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: "Email *",
            hintText: "seu@email.com",
            prefixIcon: const Icon(Icons.email),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          enabled: isAnonymous,
        ),
        const SizedBox(height: 12),
        if (isAnonymous) ...[
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: "Senha *",
              hintText: "Mínimo 6 caracteres",
              prefixIcon: const Icon(Icons.lock),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              labelText: "Confirmar Senha *",
              hintText: "Digite a senha novamente",
              prefixIcon: const Icon(Icons.lock_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 12),
        ],
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: "Tipo de Usuário *",
            prefixIcon: const Icon(Icons.badge),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          value: _selectedUserType,
          items: const [
            DropdownMenuItem(value: "Estudante", child: Text("Estudante")),
            DropdownMenuItem(value: "Colaborador", child: Text("Colaborador")),
          ],
          onChanged: (value) => setState(() => _selectedUserType = value),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: "Nome *",
            hintText: "Seu nome",
            prefixIcon: const Icon(Icons.person),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _dateController,
          decoration: InputDecoration(
            labelText: 'Data de Nascimento *',
            hintText: 'DD/MM/AAAA',
            prefixIcon: const Icon(Icons.cake),
            suffixIcon: const Icon(Icons.calendar_today),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          readOnly: true,
          onTap: () => _selectDate(context),
        ),
      ],
    );
  }

  Widget _buildOptionalFields(BuildContext context) {
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
        TextFormField(
          controller: _professionController,
          decoration: InputDecoration(
            labelText: "Profissão",
            hintText: "Sua profissão",
            prefixIcon: const Icon(Icons.work),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: "Mora Sozinho",
            prefixIcon: const Icon(Icons.home),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          value: _selectedLivesAlone,
          items: const [
            DropdownMenuItem(value: "sim", child: Text("Sim")),
            DropdownMenuItem(value: "nao", child: Text("Não")),
          ],
          onChanged: (value) => setState(() => _selectedLivesAlone = value),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: "Sexo",
            prefixIcon: const Icon(Icons.person_outline),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          value: _selectedGender,
          items: const [
            DropdownMenuItem(value: "masc", child: Text("Masculino")),
            DropdownMenuItem(value: "fem", child: Text("Feminino")),
            DropdownMenuItem(value: "outro", child: Text("Outro")),
          ],
          onChanged: (value) => setState(() => _selectedGender = value),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _availableTimeController,
          decoration: InputDecoration(
            labelText: "Tempo Disponível",
            hintText: "Ex: 2 horas por dia",
            prefixIcon: const Icon(Icons.access_time),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _hobbiesController,
          decoration: InputDecoration(
            labelText: "Hobbies",
            hintText: "Seus hobbies e interesses",
            prefixIcon: const Icon(Icons.favorite),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildNotificationsCheckbox() {
    return CheckboxListTile(
      value: _receivesNotifications,
      onChanged: (value) =>
          setState(() => _receivesNotifications = value ?? true),
      title: const Text("Receber notificações para lembrá-lo do bem-estar"),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Colors.deepPurple,
    );
  }

  Widget _buildSaveButton(BuildContext context, bool isAnonymous) {
    final userController = Provider.of<UserController>(context);

    return userController.isLoading
        ? const Center(child: CircularProgressIndicator())
        : SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => _saveProfile(context, isAnonymous),
              icon: const Icon(Icons.save),
              label: Text(isAnonymous ? "Salvar Perfil" : "Atualizar Perfil"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
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

  Widget _buildLogoutButton(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        child: ElevatedButton.icon(
          onPressed: () => _showLogoutDialog(context),
          icon: const Icon(Icons.logout),
          label: const Text("Sair da Conta"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Sair da Conta"),
          content: const Text("Tem certeza que deseja sair da sua conta?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _performLogout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text("Sair"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performLogout(BuildContext context) async {
    final userController = Provider.of<UserController>(context, listen: false);

    await userController.logout();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logout realizado com sucesso!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
    }
  }

  Future<void> _saveProfile(BuildContext context, bool isAnonymous) async {
    final userController = Provider.of<UserController>(context, listen: false);
    final registrationData =
        Provider.of<RegistrationData>(context, listen: false);

    // Preencher o RegistrationData com os dados do formulário
    registrationData.email = _emailController.text;
    registrationData.name = _nameController.text;
    registrationData.password = _passwordController.text;
    registrationData.confirmPassword = _confirmPasswordController.text;
    registrationData.userType = _selectedUserType ?? '';
    registrationData.ageRange = _birthDate?.toIso8601String() ?? '';
    registrationData.profession = _professionController.text;
    registrationData.livesAlone = _selectedLivesAlone ?? '';
    registrationData.gender = _selectedGender ?? '';
    registrationData.availableTime = _availableTimeController.text;
    registrationData.hobbies = _hobbiesController.text;
    registrationData.receivesNotifications = _receivesNotifications;

    if (_validateRegistration(registrationData, context, isAnonymous)) {
      final success = isAnonymous
          ? await userController.completeAnonymousProfile(registrationData)
          : await userController.updateUserProfile(registrationData);

      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isAnonymous
                ? 'Perfil salvo com sucesso! 🎉'
                : 'Perfil atualizado com sucesso! ✅'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        if (isAnonymous) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else if (userController.errorMessage != null && context.mounted) {
        _showValidationError(context, userController.errorMessage!);
      }
    }
  }

  bool _validateRegistration(
      RegistrationData data, BuildContext context, bool isAnonymous) {
    if (data.userType.isEmpty) {
      _showValidationError(context, 'Tipo de usuário é obrigatório');
      return false;
    }
    if (data.name.isEmpty) {
      _showValidationError(context, 'Nome é obrigatório');
      return false;
    }
    if (_birthDate == null || data.ageRange.isEmpty) {
      _showValidationError(context, 'Data de nascimento é obrigatória');
      return false;
    }
    if (data.email.isEmpty || !data.email.contains('@')) {
      _showValidationError(context, 'Email inválido');
      return false;
    }

    if (isAnonymous) {
      if (data.password.isEmpty || data.password.length < 6) {
        _showValidationError(
            context, 'A senha deve ter pelo menos 6 caracteres');
        return false;
      }
      if (data.password != data.confirmPassword) {
        _showValidationError(context, 'As senhas não coincidem');
        return false;
      }
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
