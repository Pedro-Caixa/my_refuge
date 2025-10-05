import 'package:flutter/material.dart';
import '../template/main_template.dart';
import '../widgets/cards/daily_quote_card.dart';
import '../widgets/cards/phrase_card.dart';
import '../widgets/cards/wellness_tip_card.dart';
import '../widgets/sections/custom_footer.dart';

class MotivationalPage extends StatelessWidget {
  const MotivationalPage({super.key});

  // Método para lidar com a geração de nova frase
  void _handleNewQuote(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nova frase gerada!'),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      title: "Frases Motivacionais",
      currentIndex: 3, // Índice correspondente a "Frases Motivação" no menu
      onItemTapped: (int index) {
        // A navegação já é tratada no CustomFooter, mas você pode adicionar lógica adicional se necessário
      },
      backgroundColor: const Color(0xFFF5F8FC),
      customBottomNavigationBar: CustomFooter(
        currentIndex: 3, // Índice correspondente a "Frases Motivação" no menu
        onItemTapped: (int index) {
          // A navegação já é tratada dentro do CustomFooter, mas você pode adicionar lógica adicional se necessário
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Inspiração para o seu dia",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            DailyQuoteCard(
              quote:
                  "Você é mais forte do que imagina e mais capaz do que acredita.",
              author: "My Refuge",
              onNewQuote: () => _handleNewQuote(context),
            ),
            const SizedBox(height: 24),
            const Text(
              "Frases Recentes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const PhraseCard(
              phrase:
                  "Você é mais forte do que imagina e mais capaz do que acredita.",
              tag: "força",
              tagColor: Colors.blue,
            ),
            const PhraseCard(
              phrase:
                  "Cada pequeno passo em direção ao autocuidado é uma vitória.",
              tag: "autocuidado",
              tagColor: Colors.green,
            ),
            const PhraseCard(
              phrase:
                  "Suas emoções são válidas. Permita-se senti-las sem julgamento.",
              tag: "aceitação",
              tagColor: Colors.teal,
            ),
            const PhraseCard(
              phrase:
                  "O progresso não é linear. Cada dia é uma nova oportunidade.",
              tag: "progresso",
              tagColor: Colors.orange,
            ),
            const SizedBox(height: 24),
            const WellnessTipCard(
              title: "Dica de Bem-estar",
              content:
                  "Comece o dia lendo uma frase motivacional. Isso pode ajudar a definir um tom positivo para suas próximas horas e lembrar você de que é capaz de superar qualquer desafio.",
            ),
          ],
        ),
      ),
    );
  }
}
