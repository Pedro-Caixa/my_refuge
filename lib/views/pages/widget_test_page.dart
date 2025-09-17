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
            const Text(
              'Botão com Animação e Cor Personalizável',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Botões com Diferentes Cores'),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                MainButton(
                  text: 'Botão Azul',
                  onPressed: () => _showSnackBar('Botão Azul pressionado!'),
                  gradientColors: [Color(0xFF4AA9FF), Color(0xFF55E1D2)],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(title),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  void _simulateLoading() {
    setState(() {
      _isLoading = true;
    });

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
