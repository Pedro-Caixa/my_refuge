import 'package:flutter/material.dart';
import 'dart:math';
import '../template/main_template.dart';
import '../widgets/cards/daily_quote_card.dart';
import '../widgets/cards/phrase_card.dart';
import '../widgets/cards/wellness_tip_card.dart';
import '../widgets/sections/custom_footer.dart';

class MotivationalPage extends StatefulWidget {
  const MotivationalPage({super.key});

  @override
  State<MotivationalPage> createState() => _MotivationalPageState();
}

class _MotivationalPageState extends State<MotivationalPage> {
  final Random _random = Random();

  // Lista de frases motivacionais
  final List<Map<String, String>> _quotes = [
    {
      'quote': 'Você é mais forte do que imagina e mais capaz do que acredita.',
      'author': 'My Refuge'
    },
    {
      'quote':
          'A coragem não é a ausência do medo, mas a decisão de que algo é mais importante que o medo.',
      'author': 'My Refuge'
    },
    {
      'quote':
          'Cada dia é uma nova página em branco. Escreva uma história linda.',
      'author': 'My Refuge'
    },
    {
      'quote':
          'Sua jornada é única. Não compare seu progresso com o dos outros.',
      'author': 'My Refuge'
    },
    {
      'quote': 'Pequenos passos ainda são progresso. Continue caminhando.',
      'author': 'My Refuge'
    },
    {
      'quote': 'Você merece todo o amor e cuidado que oferece aos outros.',
      'author': 'My Refuge'
    },
    {
      'quote': 'A esperança é uma força poderosa. Nunca pare de acreditar.',
      'author': 'My Refuge'
    },
    {
      'quote': 'Seus sonhos são válidos. Não desista deles.',
      'author': 'My Refuge'
    },
  ];

  // Lista de frases recentes com tags
  final List<Map<String, dynamic>> _recentPhrases = [
    {
      'phrase':
          'Você é mais forte do que imagina e mais capaz do que acredita.',
      'tag': 'força',
      'color': Colors.blue,
    },
    {
      'phrase': 'Cada pequeno passo em direção ao autocuidado é uma vitória.',
      'tag': 'autocuidado',
      'color': Colors.green,
    },
    {
      'phrase':
          'Suas emoções são válidas. Permita-se senti-las sem julgamento.',
      'tag': 'aceitação',
      'color': Colors.teal,
    },
    {
      'phrase': 'O progresso não é linear. Cada dia é uma nova oportunidade.',
      'tag': 'progresso',
      'color': Colors.orange,
    },
    {
      'phrase': 'Respire fundo. Você está fazendo o melhor que pode.',
      'tag': 'calma',
      'color': Colors.purple,
    },
    {
      'phrase': 'Sua saúde mental importa. Cuide dela com carinho.',
      'tag': 'saúde mental',
      'color': Colors.pink,
    },
    {
      'phrase': 'Seja gentil consigo mesmo. Você está aprendendo e crescendo.',
      'tag': 'gentileza',
      'color': Colors.amber,
    },
    {
      'phrase': 'Não há problema em pedir ajuda. Isso é sinal de força.',
      'tag': 'apoio',
      'color': Colors.indigo,
    },
  ];

  int _currentQuoteIndex = 0;
  late int _currentTipIndex;

  @override
  void initState() {
    super.initState();
    // Seleciona uma dica aleatória ao iniciar
    _currentTipIndex = _random.nextInt(_wellnessTips.length);
  }

  // Lista de dicas de bem-estar
  final List<Map<String, String>> _wellnessTips = [
    {
      'title': 'Dica de Bem-estar',
      'content':
          'Comece o dia lendo uma frase motivacional. Isso pode ajudar a definir um tom positivo para suas próximas horas e lembrar você de que é capaz de superar qualquer desafio.',
    },
    {
      'title': 'Respiração Consciente',
      'content':
          'Pratique respiração profunda por 5 minutos. Inspire contando até 4, segure por 4 segundos e expire contando até 6. Isso ajuda a reduzir a ansiedade e acalmar a mente.',
    },
    {
      'title': 'Gratidão Diária',
      'content':
          'Antes de dormir, liste 3 coisas pelas quais você é grato hoje. Essa prática simples pode melhorar significativamente seu bem-estar emocional e qualidade do sono.',
    },
    {
      'title': 'Movimento é Vida',
      'content':
          'Faça uma caminhada de 10 minutos ao ar livre. A exposição à luz natural e o movimento ajudam a liberar endorfinas e melhorar seu humor.',
    },
    {
      'title': 'Hidratação',
      'content':
          'Beba um copo de água ao acordar. A hidratação adequada melhora o funcionamento do cérebro, aumenta a energia e ajuda na concentração.',
    },
    {
      'title': 'Pausas Regulares',
      'content':
          'A cada hora, faça uma pausa de 5 minutos. Levante-se, alongue-se e descanse seus olhos. Isso previne fadiga e melhora a produtividade.',
    },
    {
      'title': 'Conecte-se',
      'content':
          'Envie uma mensagem para alguém querido. Manter conexões sociais é fundamental para a saúde mental e pode transformar o dia de ambos.',
    },
    {
      'title': 'Sono Reparador',
      'content':
          'Estabeleça uma rotina de sono. Durma e acorde nos mesmos horários diariamente. Um sono de qualidade é essencial para a saúde física e mental.',
    },
  ];

  // Método para gerar uma nova frase
  void _handleNewQuote() {
    setState(() {
      int newIndex;
      do {
        newIndex = _random.nextInt(_quotes.length);
      } while (newIndex == _currentQuoteIndex && _quotes.length > 1);

      _currentQuoteIndex = newIndex;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nova frase gerada!'),
        backgroundColor: Colors.deepPurple,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Seleciona 4 frases aleatórias para exibir (ou menos se a lista for menor)
    final displayPhrases = _recentPhrases.length <= 4
        ? _recentPhrases
        : (_recentPhrases..shuffle()).take(4).toList();

    return MainTemplate(
      title: "Frases Motivacionais",
      currentIndex: 3,
      onItemTapped: (int index) {},
      backgroundColor: const Color(0xFFF5F8FC),
      customBottomNavigationBar: CustomFooter(
        currentIndex: 3,
        onItemTapped: (int index) {},
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
              quote: _quotes[_currentQuoteIndex]['quote']!,
              author: _quotes[_currentQuoteIndex]['author']!,
              onNewQuote: _handleNewQuote,
            ),
            const SizedBox(height: 24),
            const Text(
              "Frases Recentes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...displayPhrases.map((phraseData) => PhraseCard(
                  phrase: phraseData['phrase'] as String,
                  tag: phraseData['tag'] as String,
                  tagColor: phraseData['color'] as Color,
                )),
            const SizedBox(height: 24),
            WellnessTipCard(
              title: _wellnessTips[_currentTipIndex]['title']!,
              content: _wellnessTips[_currentTipIndex]['content']!,
            ),
          ],
        ),
      ),
    );
  }
}
