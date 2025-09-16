class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _profissaoController = TextEditingController();
  final _tempoDisponivelController = TextEditingController();
  final _hobbiesController = TextEditingController();

  TipoUsuario? _tipoUsuario;
  String? _faixaEtaria;
  MoraSozinho? _moraSozinho;
  Sexo? _sexo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Conta'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Consumer<UserController>(
        builder: (context, userController, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Icon(Icons.person_add, size: 60, color: Colors.blue.shade800),
                  SizedBox(height: 24),

                  // Nome
                  TextFormField(
                    controller: _nomeController,
                    decoration: InputDecoration(
                      labelText: 'Nome Completo',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Campo obrigatório';
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Email
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Campo obrigatório';
                      if (!value!.contains('@')) return 'Email inválido';
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Senha
                  TextFormField(
                    controller: _senhaController,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Campo obrigatório';
                      if (value!.length < 4) return 'Mínimo 4 caracteres';
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Tipo de Usuário
                  DropdownButtonFormField<TipoUsuario>(
                    value: _tipoUsuario,
                    decoration: InputDecoration(
                      labelText: 'Tipo de Usuário',
                      prefixIcon: Icon(Icons.work),
                      border: OutlineInputBorder(),
                    ),
                    items: TipoUsuario.values.map((tipo) {
                      return DropdownMenuItem(
                        value: tipo,
                        child: Text(tipo.name.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _tipoUsuario = value),
                    validator: (value) {
                      if (value == null) return 'Campo obrigatório';
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Faixa Etária
                  DropdownButtonFormField<String>(
                    value: _faixaEtaria,
                    decoration: InputDecoration(
                      labelText: 'Faixa Etária',
                      prefixIcon: Icon(Icons.cake),
                      border: OutlineInputBorder(),
                    ),
                    items: ['18-25', '26-35', '36-45', '46-60', '60+'].map((
                      faixa,
                    ) {
                      return DropdownMenuItem(value: faixa, child: Text(faixa));
                    }).toList(),
                    onChanged: (value) => setState(() => _faixaEtaria = value),
                  ),
                  SizedBox(height: 16),

                  // Profissão
                  TextFormField(
                    controller: _profissaoController,
                    decoration: InputDecoration(
                      labelText: 'Profissão',
                      prefixIcon: Icon(Icons.work_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Mora Sozinho
                  DropdownButtonFormField<MoraSozinho>(
                    value: _moraSozinho,
                    decoration: InputDecoration(
                      labelText: 'Mora Sozinho?',
                      prefixIcon: Icon(Icons.home),
                      border: OutlineInputBorder(),
                    ),
                    items: MoraSozinho.values.map((mora) {
                      String label = mora.name == 'sim'
                          ? 'Sim'
                          : mora.name == 'nao'
                          ? 'Não'
                          : 'Às vezes';
                      return DropdownMenuItem(value: mora, child: Text(label));
                    }).toList(),
                    onChanged: (value) => setState(() => _moraSozinho = value),
                  ),
                  SizedBox(height: 16),

                  // Sexo
                  DropdownButtonFormField<Sexo>(
                    value: _sexo,
                    decoration: InputDecoration(
                      labelText: 'Sexo',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    items: Sexo.values.map((sexo) {
                      String label = sexo.name == 'masculino'
                          ? 'Masculino'
                          : sexo.name == 'feminino'
                          ? 'Feminino'
                          : sexo.name == 'naoBinario'
                          ? 'Não-binário'
                          : 'Prefiro não informar';
                      return DropdownMenuItem(value: sexo, child: Text(label));
                    }).toList(),
                    onChanged: (value) => setState(() => _sexo = value),
                  ),
                  SizedBox(height: 16),

                  // Tempo Disponível
                  TextFormField(
                    controller: _tempoDisponivelController,
                    decoration: InputDecoration(
                      labelText: 'Tempo Disponível (ex: 2 horas por dia)',
                      prefixIcon: Icon(Icons.access_time),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Hobbies
                  TextFormField(
                    controller: _hobbiesController,
                    decoration: InputDecoration(
                      labelText: 'Hobbies (separados por vírgula)',
                      prefixIcon: Icon(Icons.sports_esports),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  SizedBox(height: 24),

                  // Mensagem de erro
                  if (userController.errorMessage != null)
                    Container(
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        border: Border.all(color: Colors.red.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        userController.errorMessage!,
                        style: TextStyle(color: Colors.red.shade800),
                      ),
                    ),

                  // Botão de registrar
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: userController.isLoading
                          ? null
                          : () => _register(userController),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade800,
                        foregroundColor: Colors.white,
                      ),
                      child: userController.isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Criar Conta'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _register(UserController userController) async {
    if (_formKey.currentState!.validate()) {
      final user = UserModel(
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        senha: _senhaController.text,
        tipoUsuario: _tipoUsuario,
        faixaEtaria: _faixaEtaria,
        profissao: _profissaoController.text.trim(),
        moraSozinho: _moraSozinho,
        sexo: _sexo,
        tempoDisponivel: _tempoDisponivelController.text.trim(),
        hobbies: _hobbiesController.text.trim(),
      );

      final success = await userController.registerUser(user);

      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Conta criada com sucesso!')));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _profissaoController.dispose();
    _tempoDisponivelController.dispose();
    _hobbiesController.dispose();
    super.dispose();
  }
}
