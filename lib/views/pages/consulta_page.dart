import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/sections/custom_footer.dart';

class ConsultaPage extends StatelessWidget {
  const ConsultaPage({super.key});

  // Método para abrir o WhatsApp
  Future<void> _openWhatsApp() async {
    final Uri whatsappUri = Uri.parse(
      'https://wa.me/5511999999999?text=Olá! Gostaria de marcar uma consulta.',
    );

    if (!await launchUrl(whatsappUri)) {
      // Se não conseguir abrir o WhatsApp, mostra uma mensagem de erro
      throw Exception('Não foi possível abrir o WhatsApp');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marcar Consulta'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),

      // Corrigido: alterado de 'customBottomNavigationBar' para 'bottomNavigationBar'
      bottomNavigationBar: CustomFooter(
        currentIndex: 0,
        onItemTapped: (int index) {
          // Lógica adicional se necessário
        },
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Agende sua consulta',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Estamos aqui para ajudar você. Clique no botão abaixo para falar conosco diretamente pelo WhatsApp e agendar sua consulta.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: const Icon(
                      Icons.phone,
                      size: 60,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Fale conosco pelo WhatsApp',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Horário de atendimento: Seg-Sex, 9h-18h',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _openWhatsApp,
                icon: const Icon(Icons.phone),
                label: const Text('Abrir WhatsApp'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
