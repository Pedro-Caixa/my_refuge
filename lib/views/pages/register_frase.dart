import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPhraseScreen extends StatefulWidget {
  const RegisterPhraseScreen({Key? key}) : super(key: key);

  @override
  State<RegisterPhraseScreen> createState() => _RegisterPhraseScreenState();
}

class _RegisterPhraseScreenState extends State<RegisterPhraseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phraseController = TextEditingController();
  final _authorController = TextEditingController();
  final _tagController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  // Cores disponíveis para as tags
  final List<Map<String, dynamic>> _availableColors = [
    {'name': 'Azul', 'color': Colors.blue},
    {'name': 'Verde', 'color': Colors.green},
    {'name': 'Roxo', 'color': Colors.purple},
    {'name': 'Laranja', 'color': Colors.orange},
    {'name': 'Rosa', 'color': Colors.pink},
    {'name': 'Turquesa', 'color': Colors.teal},
    {'name': 'Âmbar', 'color': Colors.amber},
    {'name': 'Índigo', 'color': Colors.indigo},
  ];

  Color _selectedColor = Colors.blue;

  @override
  void dispose() {
    _phraseController.dispose();
    _authorController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  Future<void> _savePhrase() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Converter cor para formato armazenável
        final colorValue = _selectedColor.value;

        await _firestore.collection('phrases').add({
          'phrase': _phraseController.text.trim(),
          'author': _authorController.text.trim().isEmpty
              ? 'My Refuge'
              : _authorController.text.trim(),
          'tag': _tagController.text.trim(),
          'colorValue': colorValue,
          'createdAt': Timestamp.now(),
          'isActive': true,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Frase cadastrada com sucesso!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );

          // Limpar os campos
          _phraseController.clear();
          _authorController.clear();
          _tagController.clear();
          setState(() => _selectedColor = Colors.blue);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Erro ao cadastrar: $e'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Row(
        children: [
          // Sidebar de Navegação
          _buildSidebar(),

          // Conteúdo Principal
          Expanded(
            child: Column(
              children: [
                // AppBar
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue[700],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pushReplacementNamed(
                              context, '/admin-reports'),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Cadastrar Frase Motivacional',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Conteúdo do Formulário
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 800),
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header do Formulário
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.purple[50],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.format_quote,
                                      color: Colors.purple[700],
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Nova Frase Motivacional',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Adicione mensagens inspiradoras para os usuários',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),

                              // Frase
                              const Text(
                                'Frase Motivacional',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _phraseController,
                                decoration: InputDecoration(
                                  hintText:
                                      'Ex: Você é mais forte do que imagina...',
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(bottom: 60),
                                    child: Icon(Icons.format_quote,
                                        color: Colors.purple[700]),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.grey[300]!),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.grey[300]!),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Colors.blue[700]!, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                ),
                                maxLines: 4,
                                maxLength: 200,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Por favor, insira a frase motivacional';
                                  }
                                  if (value.trim().length < 10) {
                                    return 'A frase deve ter pelo menos 10 caracteres';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),

                              // Autor
                              const Text(
                                'Autor (Opcional)',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _authorController,
                                decoration: InputDecoration(
                                  hintText: 'Padrão: My Refuge',
                                  prefixIcon: Icon(Icons.person_outline,
                                      color: Colors.blue[700]),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.grey[300]!),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.grey[300]!),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Colors.blue[700]!, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Tag
                              const Text(
                                'Tag/Categoria',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _tagController,
                                decoration: InputDecoration(
                                  hintText: 'Ex: força, autocuidado, coragem',
                                  prefixIcon: Icon(Icons.label_outline,
                                      color: Colors.blue[700]),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.grey[300]!),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.grey[300]!),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Colors.blue[700]!, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Por favor, insira uma tag';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),

                              // Seleção de Cor
                              const Text(
                                'Cor da Tag',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: _availableColors.map((colorData) {
                                  final isSelected =
                                      _selectedColor == colorData['color'];
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedColor =
                                            colorData['color'] as Color;
                                      });
                                    },
                                    child: Container(
                                      width: 80,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                        color: colorData['color'],
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.black
                                              : Colors.transparent,
                                          width: 3,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          if (isSelected)
                                            const Icon(Icons.check,
                                                color: Colors.white, size: 20),
                                          const SizedBox(height: 4),
                                          Text(
                                            colorData['name'] as String,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 32),

                              // Preview da Frase
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.visibility,
                                            color: Colors.grey[600], size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Preview',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      _phraseController.text.isEmpty
                                          ? 'Sua frase aparecerá aqui...'
                                          : _phraseController.text,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        color: _phraseController.text.isEmpty
                                            ? Colors.grey[400]
                                            : Colors.grey[800],
                                      ),
                                    ),
                                    if (_tagController.text.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color:
                                              _selectedColor.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border:
                                              Border.all(color: _selectedColor),
                                        ),
                                        child: Text(
                                          _tagController.text,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: _selectedColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Botões de Ação
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: _isLoading
                                          ? null
                                          : () {
                                              _phraseController.clear();
                                              _authorController.clear();
                                              _tagController.clear();
                                              setState(() =>
                                                  _selectedColor = Colors.blue);
                                            },
                                      icon: const Icon(Icons.clear),
                                      label: const Text('Limpar'),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        side: BorderSide(
                                            color: Colors.grey[400]!),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    flex: 2,
                                    child: ElevatedButton.icon(
                                      onPressed:
                                          _isLoading ? null : _savePhrase,
                                      icon: _isLoading
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Icon(
                                              Icons.check_circle_outline),
                                      label: Text(
                                        _isLoading
                                            ? 'Cadastrando...'
                                            : 'Cadastrar Frase',
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.purple[700],
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        elevation: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[700],
            ),
            child: const Row(
              children: [
                Icon(Icons.admin_panel_settings, color: Colors.white, size: 28),
                SizedBox(width: 12),
                Text(
                  'Admin Panel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildMenuItem(
                  icon: Icons.home,
                  label: 'Voltar ao Início',
                  isSelected: false,
                  onTap: () => Navigator.pushReplacementNamed(context, '/home'),
                ),
                const Divider(height: 16),
                _buildMenuItem(
                  icon: Icons.dashboard,
                  label: 'Relatórios',
                  isSelected: false,
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, '/admin-reports'),
                ),
                _buildMenuItem(
                  icon: Icons.fitness_center,
                  label: 'Cadastrar Exercício',
                  isSelected: false,
                  onTap: () => Navigator.pushReplacementNamed(
                      context, '/register-exercise'),
                ),
                _buildMenuItem(
                  icon: Icons.format_quote,
                  label: 'Cadastrar Frase',
                  isSelected: true,
                  onTap: () {},
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'v1.0.0',
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: Colors.blue[700]!, width: 2)
              : null,
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isSelected ? Colors.blue[700] : Colors.grey[600],
                size: 22),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.blue[700] : Colors.grey[700],
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
