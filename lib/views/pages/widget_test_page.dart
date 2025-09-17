import 'package:flutter/material.dart';
import '../widgets/buttons/main_button.dart';

class WidgetsTestPage extends StatefulWidget {
  const WidgetsTestPage({Key? key}) : super(key: key);

  @override
  State<WidgetsTestPage> createState() => _WidgetsTestPageState();
}

class _WidgetsTestPageState extends State<WidgetsTestPage> {
  bool _isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Botão Animado Personalizável'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título da página
            const Text(
              'Botão com Animação e Cor Personalizável',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 24),
            
            // Navigation section to CustomButton test
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nova Funcionalidade',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Confira o novo CustomButton widget com recursos avançados!',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  MainButton(
                    text: 'Ver CustomButton',
                    icon: Icons.arrow_forward,
                    backgroundColor: Colors.blue,
                    onPressed: () => Navigator.pushNamed(context, '/custom-button-test'),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Seção 1: Botões com diferentes cores
            _buildSectionTitle('Botões com Diferentes Cores'),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                // Botão azul (padrão)
                MainButton(
                  text: 'Botão Azul',
                  onPressed: () => _showSnackBar('Botão Azul pressionado!'),
                ),
                
                // Botão verde
                MainButton(
                  text: 'Botão Verde',
                  onPressed: () => _showSnackBar('Botão Verde pressionado!'),
                  backgroundColor: Colors.green,
                ),
                
                // Botão vermelho
                MainButton(
                  text: 'Botão Vermelho',
                  onPressed: () => _showSnackBar('Botão Vermelho pressionado!'),
                  backgroundColor: Colors.red,
                ),
                
                // Botão amarelo
                MainButton(
                  text: 'Botão Amarelo',
                  onPressed: () => _showSnackBar('Botão Amarelo pressionado!'),
                  backgroundColor: Colors.amber,
                  textColor: Colors.black,
                ),
                
                // Botão roxo
                MainButton(
                  text: 'Botão Roxo',
                  onPressed: () => _showSnackBar('Botão Roxo pressionado!'),
                  backgroundColor: Colors.purple,
                ),
                
                // Botão laranja
                MainButton(
                  text: 'Botão Laranja',
                  onPressed: () => _showSnackBar('Botão Laranja pressionado!'),
                  backgroundColor: Colors.orange,
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Seção 2: Botões com diferentes tamanhos
            _buildSectionTitle('Botões com Diferentes Tamanhos'),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                // Botão pequeno
                MainButton(
                  text: 'Pequeno',
                  onPressed: () => _showSnackBar('Botão Pequeno pressionado!'),
                  width: 100,
                  height: 36,
                  textSize: 14,
                ),
                
                // Botão médio (padrão)
                MainButton(
                  text: 'Médio',
                  onPressed: () => _showSnackBar('Botão Médio pressionado!'),
                ),
                
                // Botão grande
                MainButton(
                  text: 'Grande',
                  onPressed: () => _showSnackBar('Botão Grande pressionado!'),
                  width: 200,
                  height: 60,
                  textSize: 20,
                ),
                
                // Botão extra grande
                MainButton(
                  text: 'Extra Grande',
                  onPressed: () => _showSnackBar('Botão Extra Grande pressionado!'),
                  width: 250,
                  height: 70,
                  textSize: 24,
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Seção 3: Botões com ícones
            _buildSectionTitle('Botões com Ícones'),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                // Botão com ícone de adição
                MainButton(
                  text: 'Adicionar',
                  onPressed: () => _showSnackBar('Botão Adicionar pressionado!'),
                  icon: Icons.add,
                ),
                
                // Botão com ícone de salvar
                MainButton(
                  text: 'Salvar',
                  onPressed: () => _showSnackBar('Botão Salvar pressionado!'),
                  icon: Icons.save,
                  backgroundColor: Colors.green,
                ),
                
                // Botão com ícone de delete
                MainButton(
                  text: 'Excluir',
                  onPressed: () => _showSnackBar('Botão Excluir pressionado!'),
                  icon: Icons.delete,
                  backgroundColor: Colors.red,
                ),
                
                // Botão com ícone de download
                MainButton(
                  text: 'Download',
                  onPressed: () => _showSnackBar('Botão Download pressionado!'),
                  icon: Icons.download,
                  backgroundColor: Colors.blue,
                ),
                
                // Botão com ícone de compartilhar
                MainButton(
                  text: 'Compartilhar',
                  onPressed: () => _showSnackBar('Botão Compartilhar pressionado!'),
                  icon: Icons.share,
                  backgroundColor: Colors.purple,
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Seção 4: Botões com diferentes bordas arredondadas
            _buildSectionTitle('Botões com Diferentes Bordas Arredondadas'),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                // Botão com borda quadrada
                MainButton(
                  text: 'Quadrado',
                  onPressed: () => _showSnackBar('Botão Quadrado pressionado!'),
                  borderRadius: 0,
                ),
                
                // Botão com borda levemente arredondada
                MainButton(
                  text: 'Levemente Arredondado',
                  onPressed: () => _showSnackBar('Botão Levemente Arredondado pressionado!'),
                  borderRadius: 4,
                ),
                
                // Botão com borda arredondada padrão
                MainButton(
                  text: 'Arredondado',
                  onPressed: () => _showSnackBar('Botão Arredondado pressionado!'),
                  borderRadius: 8,
                ),
                
                // Botão com borda muito arredondada
                MainButton(
                  text: 'Muito Arredondado',
                  onPressed: () => _showSnackBar('Botão Muito Arredondado pressionado!'),
                  borderRadius: 16,
                ),
                
                // Botão com borda completamente arredondada
                MainButton(
                  text: 'Completamente Arredondado',
                  onPressed: () => _showSnackBar('Botão Completamente Arredondado pressionado!'),
                  borderRadius: 30,
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Seção 5: Botões com estado de carregamento
            _buildSectionTitle('Botões com Estado de Carregamento'),
            Column(
              children: [
                MainButton(
                  text: _isLoading ? 'Carregando...' : 'Simular Carregamento',
                  onPressed: _isLoading ? null : _simulateLoading,
                  isLoading: _isLoading,
                  backgroundColor: Colors.teal,
                ),
                
                const SizedBox(height: 16),
                
                // Botão com carregamento e ícone
                MainButton(
                  text: _isLoading ? 'Enviando...' : 'Enviar Dados',
                  onPressed: _isLoading ? null : _simulateLoading,
                  icon: Icons.send,
                  isLoading: _isLoading,
                  backgroundColor: Colors.indigo,
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Seção 6: Botões desabilitados
            _buildSectionTitle('Botões Desabilitados'),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                // Botão desabilitado simples
                const MainButton(
                  text: 'Desabilitado',
                  onPressed: null,
                ),
                
                // Botão desabilitado com ícone
                const MainButton(
                  text: 'Desabilitado',
                  onPressed: null,
                  icon: Icons.block,
                  backgroundColor: Colors.red,
                ),
                
                // Botão desabilitado grande
                const MainButton(
                  text: 'Desabilitado',
                  onPressed: null,
                  width: 200,
                  height: 60,
                  backgroundColor: Colors.green,
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Seção 7: Demonstração de animação
            _buildSectionTitle('Demonstração de Animação'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pressione e segure o botão para ver a animação:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: MainButton(
                      text: 'Pressione e Segure',
                      onPressed: () => _showSnackBar('Animação demonstrada!'),
                      backgroundColor: Colors.deepPurple,
                      width: 200,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
  
  // Widget auxiliar para criar títulos de seção
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
  
  // Método para mostrar um SnackBar quando um botão é pressionado
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
  
  // Método para simular um carregamento
  void _simulateLoading() {
    setState(() {
      _isLoading = true;
    });
    
    // Simula uma operação que leva 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar('Operação concluída!');
      }
    });
  }
}