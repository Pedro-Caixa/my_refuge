import 'package:flutter/material.dart';
import '../../models/userModel.dart';
import '../../controllers/userController.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

class UserFormPage extends StatefulWidget {
  final UserModel? user;

  const UserFormPage({Key? key, this.user}) : super(key: key);

  @override
  _UserFormPageState createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();

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

  @override
  void initState() {
    super.initState();

    // Inicializar controllers com valores do usuário se existir
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _senhaController = TextEditingController(text: widget.user?.senha ?? '');
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

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      // Criar um novo UserModel com os dados do formulário
      final user = UserModel(
        id: widget.user?.id,
        email: _emailController.text,
        senha: _senhaController.text,
        tipoUsuario: _tipoUsuario,
        nome: _nomeController.text,
        faixaEtaria: _faixaEtariaController.text,
        profissao: _profissaoController.text,
        moraSozinho: _moraSozinho,
        sexo: _sexo,
        tempoDisponivel: _tempoDisponivelController.text,
        hobbies: _hobbiesController.text,
      );

      // Aqui você pode chamar um controller para salvar o usuário
      // Exemplo: UserController().saveUser(user);

      Navigator.of(context).pop(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? 'Novo Usuário' : 'Editar Usuário'),
      ),
      body: SingleChildScrollView(
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

              // Campo Senha
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
                decoration: const InputDecoration(labelText: 'Tipo de Usuário'),
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
                decoration: const InputDecoration(labelText: 'Faixa Etária'),
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
                decoration: const InputDecoration(labelText: 'Mora Sozinho'),
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
              ElevatedButton(onPressed: _saveForm, child: const Text('Salvar')),
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
