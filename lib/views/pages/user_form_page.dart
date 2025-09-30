import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../controllers/user_controller.dart';
import 'package:provider/provider.dart';

class UserFormPage extends StatefulWidget {
  final UserModel? user;

  const UserFormPage({Key? key, this.user}) : super(key: key);

  @override
  _UserFormPageState createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();
  late UserController _userController;

  late TextEditingController _emailController;
  late TextEditingController _senhaController;
  late TextEditingController _nomeController;
  late TextEditingController _faixaEtariaController;
  late TextEditingController _profissaoController;
  late TextEditingController _tempoDisponivelController;
  late TextEditingController _hobbiesController;

  TipoUsuario? _tipoUsuario;
  MoraSozinho? _moraSozinho;
  Sexo? _sexo;

  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.user != null;

    // Inicializar controllers com valores do usuário se existir
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _senhaController = TextEditingController(
      text: '',
    ); // Nunca preencher a senha existente
    _nomeController = TextEditingController(text: widget.user?.nome ?? '');
    _faixaEtariaController = TextEditingController(
      text: widget.user?.faixaEtaria ?? '',
    );
    _profissaoController = TextEditingController(
      text: widget.user?.profissao ?? '',
    );
    _tempoDisponivelController = TextEditingController(
      text: widget.user?.tempoDisponivel ?? '',
    );
    _hobbiesController = TextEditingController(
      text: widget.user?.hobbies ?? '',
    );

    // Inicializar enums com valores do usuário se existir
    _tipoUsuario = widget.user?.tipoUsuario;
    _moraSozinho = widget.user?.moraSozinho;
    _sexo = widget.user?.sexo;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
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
        // Criar um novo UserModel com os dados do formulário
        final user = UserModel(
          id: widget.user?.id,
          email: _emailController.text,
          // Não incluímos a senha no modelo - ela será tratada separadamente
          tipoUsuario: _tipoUsuario,
          nome: _nomeController.text,
          faixaEtaria: _faixaEtariaController.text,
          profissao: _profissaoController.text,
          moraSozinho: _moraSozinho,
          sexo: _sexo,
          tempoDisponivel: _tempoDisponivelController.text,
          hobbies: _hobbiesController.text,
        );

        bool success;

        if (_isEditing) {
          // Atualizar usuário existente
          success = await _userController.updateUser(user);
        } else {
          // Registrar novo usuário
          success = await _userController.registerUser(
            user,
            _senhaController.text,
          );
        }

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _isEditing
                    ? 'Usuário atualizado com sucesso!'
                    : 'Usuário registrado com sucesso!',
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        } else {
          // Mostrar mensagem de erro do controller
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Usuário' : 'Novo Usuário'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Campo Email
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      enabled:
                          !_isEditing, // Não permitir editar email em usuários existentes
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um email';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Por favor, insira um email válido';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Campo Senha - apenas para novos usuários
                    if (!_isEditing) ...[
                      TextFormField(
                        controller: _senhaController,
                        decoration: const InputDecoration(labelText: 'Senha'),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira uma senha';
                          }
                          if (value.length < 6) {
                            return 'A senha deve ter pelo menos 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Campo Nome
                    TextFormField(
                      controller: _nomeController,
                      decoration: const InputDecoration(labelText: 'Nome'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um nome';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Dropdown Tipo de Usuário
                    DropdownButtonFormField<TipoUsuario>(
                      value: _tipoUsuario,
                      decoration: const InputDecoration(
                        labelText: 'Tipo de Usuário',
                      ),
                      items: TipoUsuario.values.map((TipoUsuario tipo) {
                        return DropdownMenuItem<TipoUsuario>(
                          value: tipo,
                          child: Text(_getTipoUsuarioText(tipo)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _tipoUsuario = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor, selecione um tipo de usuário';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Campo Faixa Etária
                    TextFormField(
                      controller: _faixaEtariaController,
                      decoration: const InputDecoration(
                        labelText: 'Faixa Etária',
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Campo Profissão
                    TextFormField(
                      controller: _profissaoController,
                      decoration: const InputDecoration(labelText: 'Profissão'),
                    ),

                    const SizedBox(height: 16),

                    // Dropdown Mora Sozinho
                    DropdownButtonFormField<MoraSozinho>(
                      value: _moraSozinho,
                      decoration: const InputDecoration(
                        labelText: 'Mora Sozinho',
                      ),
                      items: MoraSozinho.values.map((MoraSozinho mora) {
                        return DropdownMenuItem<MoraSozinho>(
                          value: mora,
                          child: Text(_getMoraSozinhoText(mora)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _moraSozinho = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // Dropdown Sexo
                    DropdownButtonFormField<Sexo>(
                      value: _sexo,
                      decoration: const InputDecoration(labelText: 'Sexo'),
                      items: Sexo.values.map((Sexo sexo) {
                        return DropdownMenuItem<Sexo>(
                          value: sexo,
                          child: Text(_getSexoText(sexo)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _sexo = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // Campo Tempo Disponível
                    TextFormField(
                      controller: _tempoDisponivelController,
                      decoration: const InputDecoration(
                        labelText: 'Tempo Disponível',
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Campo Hobbies
                    TextFormField(
                      controller: _hobbiesController,
                      decoration: const InputDecoration(labelText: 'Hobbies'),
                      maxLines: 3,
                    ),

                    const SizedBox(height: 24),

                    // Botão Salvar
                    ElevatedButton(
                      onPressed: _isLoading ? null : _saveForm,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text('Salvar'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  String _getTipoUsuarioText(TipoUsuario tipo) {
    switch (tipo) {
      case TipoUsuario.aluno:
        return 'Aluno';
      case TipoUsuario.colaborador:
        return 'Colaborador';
      case TipoUsuario.outro:
        return 'Outro';
    }
  }

  String _getMoraSozinhoText(MoraSozinho mora) {
    switch (mora) {
      case MoraSozinho.sim:
        return 'Sim';
      case MoraSozinho.nao:
        return 'Não';
      case MoraSozinho.vezes:
        return 'Às vezes';
    }
  }

  String _getSexoText(Sexo sexo) {
    switch (sexo) {
      case Sexo.masculino:
        return 'Masculino';
      case Sexo.feminino:
        return 'Feminino';
      case Sexo.naoBinario:
        return 'Não Binário';
      case Sexo.prefiroNaoInformar:
        return 'Prefiro não informar';
    }
  }
}
