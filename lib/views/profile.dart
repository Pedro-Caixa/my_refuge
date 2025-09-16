class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              context.read<UserController>().logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Consumer<UserController>(
        builder: (context, userController, child) {
          final user = userController.currentUser;
          
          if (user == null) {
            return Center(child: Text('Nenhum usuário logado'));
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue.shade800,
                        child: Text(
                          user.nome?.substring(0, 1).toUpperCase() ?? 'U',
                          style: TextStyle(fontSize: 36, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        user.nome ?? 'Nome não informado',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        user.email ?? 'Email não informado',
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                _buildInfoCard('Informações Pessoais', [
                  _buildInfoRow('Tipo de Usuário', user.tipoUsuario?.name.toUpperCase()),
                  _buildInfoRow('Faixa Etária', user.faixaEtaria),
                  _buildInfoRow('Profissão', user.profissao),
                  _buildInfoRow('Sexo', _getSexoLabel(user.sexo)),
                ]),
                SizedBox(height: 16),
                _buildInfoCard('Estilo de Vida', [
                  _buildInfoRow('Mora Sozinho', _getMoraSozinhoLabel(user.moraSozinho)),
                  _buildInfoRow('Tempo Disponível', user.tempoDisponivel),
                  _buildInfoRow('Hobbies', user.hobbies),
                ]),
                SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    onPressed: () => userController.printAllUsers(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade600,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Debug: Mostrar todos os usuários no console'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,