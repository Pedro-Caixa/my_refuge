import 'package:flutter/material.dart';
import '../../models/registration_data.dart';
import '../../controllers/user_controller.dart';
import 'package:provider/provider.dart';
import '../widgets/inputs/email_input_form.dart';
import '../widgets/inputs/password_input_form.dart';
import '../widgets/inputs/text_input_form.dart';
import '../widgets/inputs/dropdown_input_form.dart';
import '../widgets/buttons/main_button.dart';
import '../template/main_template.dart';

class UserFormPage extends StatefulWidget {
  final RegistrationData? registrationData;

  const UserFormPage({Key? key, this.registrationData}) : super(key: key);

  @override
  _UserFormPageState createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();
  late UserController _userController;

  late TextEditingController _emailController;
  late TextEditingController _senhaController;
  late TextEditingController _confirmSenhaController;
  late TextEditingController _nomeController;
  late TextEditingController _faixaEtariaController;
  late TextEditingController _profissaoController;
  late TextEditingController _tempoDisponivelController;
  late TextEditingController _hobbiesController;

  String _userType = 'Estudante';
  String _livesAlone = 'nao';
  String _gender = 'masc';
  bool _receivesNotifications = true;

  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.registrationData != null;

    // Inicializar controllers com valores do registrationData se existir
    _emailController =
        TextEditingController(text: widget.registrationData?.email ?? '');
    _senhaController = TextEditingController(text: '');
    _confirmSenhaController = TextEditingController(text: '');
    _nomeController =
        TextEditingController(text: widget.registrationData?.name ?? '');
    _faixaEtariaController =
        TextEditingController(text: widget.registrationData?.ageRange ?? '');
    _profissaoController =
        TextEditingController(text: widget.registrationData?.profession ?? '');
    _tempoDisponivelController = TextEditingController(
        text: widget.registrationData?.availableTime ?? '');
    _hobbiesController =
        TextEditingController(text: widget.registrationData?.hobbies ?? '');

    // Inicializar variáveis com valores do registrationData se existir
    _userType = widget.registrationData?.userType ?? 'Estudante';
    _livesAlone = widget.registrationData?.livesAlone ?? 'nao';
    _gender = widget.registrationData?.gender ?? 'masc';
    _receivesNotifications =
        widget.registrationData?.receivesNotifications ?? true;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _confirmSenhaController.dispose();
    _nomeController.dispose();
    _faixaEtariaController.dispose();
    _profissaoController.dispose();
    _tempoDisponivelController.dispose();
    _hobbiesController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userController = Provider.of<UserController>(context);
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final registrationData = RegistrationData()
          ..email = _emailController.text
          ..password = _senhaController.text
          ..confirmPassword = _confirmSenhaController.text
          ..userType = _userType
          ..name = _nomeController.text
          ..ageRange = _faixaEtariaController.text
          ..profession = _profissaoController.text
          ..livesAlone = _livesAlone
          ..gender = _gender
          ..availableTime = _tempoDisponivelController.text
          ..hobbies = _hobbiesController.text
          ..receivesNotifications = _receivesNotifications;

        bool success;

        if (_isEditing) {
          success = await _userController.updateUser(registrationData);
        } else {
          success = await _userController.registerUser(registrationData);
        }

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _isEditing
                    ? 'Dados atualizados com sucesso!'
                    : 'Usuário registrado com sucesso!',
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_userController.errorMessage ?? 'Ocorreu um erro'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      title: _isEditing ? 'Editar Perfil' : 'Novo Usuário',
      currentIndex: 0,
      onItemTapped: (index) {},
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildEmailField(),
                    const SizedBox(height: 16),
                    if (!_isEditing) ...[
                      _buildPasswordField(),
                      const SizedBox(height: 16),
                      _buildConfirmPasswordField(),
                      const SizedBox(height: 16),
                    ],
                    _buildNameField(),
                    const SizedBox(height: 16),
                    _buildUserTypeDropdown(),
                    const SizedBox(height: 16),
                    _buildAgeRangeField(),
                    const SizedBox(height: 16),
                    _buildProfessionField(),
                    const SizedBox(height: 16),
                    _buildLivesAloneDropdown(),
                    const SizedBox(height: 16),
                    _buildGenderDropdown(),
                    const SizedBox(height: 16),
                    _buildAvailableTimeField(),
                    const SizedBox(height: 16),
                    _buildHobbiesField(),
                    const SizedBox(height: 16),
                    _buildNotificationsCheckbox(),
                    const SizedBox(height: 24),
                    _buildSaveButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildEmailField() {
    return EmailInputForm(
      controller: _emailController,
      enabled: !_isEditing,
    );
  }

  Widget _buildPasswordField() {
    return PasswordInputForm(
      controller: _senhaController,
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmSenhaController,
      decoration: const InputDecoration(
        labelText: 'Confirmar Senha',
      ),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, confirme sua senha';
        }
        if (value != _senhaController.text) {
          return 'As senhas não coincidem';
        }
        return null;
      },
    );
  }

  Widget _buildNameField() {
    return TextInputForm(
      controller: _nomeController,
      labelText: 'Nome',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira um nome';
        }
        return null;
      },
    );
  }

  Widget _buildUserTypeDropdown() {
    return DropdownInputForm<String>(
      value: _userType,
      labelText: 'Tipo de Usuário',
      items: const [
        DropdownMenuItem(value: 'Estudante', child: Text('Estudante')),
        DropdownMenuItem(value: 'Colaborador', child: Text('Colaborador')),
      ],
      onChanged: (value) {
        setState(() {
          _userType = value ?? 'Estudante';
        });
      },
    );
  }

  Widget _buildAgeRangeField() {
    return TextInputForm(
      controller: _faixaEtariaController,
      labelText: 'Faixa Etária',
    );
  }

  Widget _buildProfessionField() {
    return TextInputForm(
      controller: _profissaoController,
      labelText: 'Profissão',
    );
  }

  Widget _buildLivesAloneDropdown() {
    return DropdownInputForm<String>(
      value: _livesAlone,
      labelText: 'Mora Sozinho',
      items: const [
        DropdownMenuItem(value: 'sim', child: Text('Sim')),
        DropdownMenuItem(value: 'nao', child: Text('Não')),
        DropdownMenuItem(value: 'vezes', child: Text('Às vezes')),
      ],
      onChanged: (value) {
        setState(() {
          _livesAlone = value ?? 'nao';
        });
      },
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownInputForm<String>(
      value: _gender,
      labelText: 'Sexo',
      items: const [
        DropdownMenuItem(value: 'masc', child: Text('Masculino')),
        DropdownMenuItem(value: 'fem', child: Text('Feminino')),
        DropdownMenuItem(value: 'outro', child: Text('Outro')),
      ],
      onChanged: (value) {
        setState(() {
          _gender = value ?? 'masc';
        });
      },
    );
  }

  Widget _buildAvailableTimeField() {
    return TextInputForm(
      controller: _tempoDisponivelController,
      labelText: 'Tempo Disponível',
    );
  }

  Widget _buildHobbiesField() {
    return TextInputForm(
      controller: _hobbiesController,
      labelText: 'Hobbies',
      maxLines: 3,
    );
  }

  Widget _buildNotificationsCheckbox() {
    return CheckboxListTile(
      title: const Text('Receber notificações'),
      value: _receivesNotifications,
      onChanged: (value) {
        setState(() {
          _receivesNotifications = value ?? true;
        });
      },
    );
  }

  Widget _buildSaveButton() {
    return MainButton(
      text: 'Salvar',
      onPressed: _isLoading ? null : _saveForm,
      child: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : null,
    );
  }
}
