import 'package:flutter/material.dart';
import '../widgets/buttons/main_button.dart';
import '../widgets/buttons/selectable_button.dart';

class WidgetsTestPage extends StatefulWidget {
  const WidgetsTestPage({Key? key}) : super(key: key);

  @override
  State<WidgetsTestPage> createState() => _WidgetsTestPageState();
}

class _WidgetsTestPageState extends State<WidgetsTestPage> {
  bool _isEnterSelected = false;
  bool _isRegisterSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Botões de Teste'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Botões com Gradiente',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Botão normal com gradiente
            MainButton(
              text: 'Entrar',
              icon: Icons.login,
              onPressed: () => _showSnackBar('Botão Entrar pressionado!'),
              gradientColors: [Color(0xFF4AA9FF), Color(0xFF55E1D2)],
            ),
            
            const SizedBox(height: 16),

            // Botões selecionáveis
            Row(
              children: [
                Expanded(
                  child: SelectableButton(
                    text: 'Entrar',
                    icon: Icons.login,
                    isSelected: _isEnterSelected,
                    onPressed: () {
                      setState(() {
                        _isEnterSelected = !_isEnterSelected;
                        _isRegisterSelected = false;
                      });
                      _showSnackBar('Entrar ${_isEnterSelected ? "selecionado" : "desselecionado"}');
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SelectableButton(
                    text: 'Cadastrar',
                    icon: Icons.person_add,
                    isSelected: _isRegisterSelected,
                    onPressed: () {
                      setState(() {
                        _isRegisterSelected = !_isRegisterSelected;
                        _isEnterSelected = false;
                      });
                      _showSnackBar('Cadastrar ${_isRegisterSelected ? "selecionado" : "desselecionado"}');
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}