import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Listas dinâmicas do Firestore
  List<Map<String, dynamic>> _quotes = [];
  List<Map<String, dynamic>> _recentPhrases = [];

  bool _isLoadingQuotes = true;
  bool _isLoadingPhrases = true;

  Map<String, dynamic>? _currentQuote;
  late int _currentTipIndex;

  @override
  void initState() {
    super.initState();
    _currentTipIndex = _random.nextInt(_wellnessTips.length);
    _loadQuotes();
    _loadRecentPhrases();
  }

  Future<void> _loadQuotes() async {
    try {
      setState(() => _isLoadingQuotes = true);

      // ✅ SEM ÍNDICE: Apenas ordenar, filtrar depois no código
      final snapshot = await _firestore
          .collection('phrases')
          .orderBy('createdAt', descending: true)
          .get();

      // Filtrar isActive no código
      final quotes = snapshot.docs.where((doc) {
        final data = doc.data();
        return data['isActive'] == true; // Filtra aqui
      }).map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'quote': data['phrase'] ?? '',
          'author': data['author'] ?? 'My Refuge',
          'tag': data['tag'] ?? '',
          'colorValue': data['colorValue'] ?? Colors.blue.value,
        };
      }).toList();

      setState(() {
        _quotes = quotes;
        _isLoadingQuotes = false;

        // Seleciona uma frase aleatória
        if (_quotes.isNotEmpty) {
          _currentQuote = _quotes[_random.nextInt(_quotes.length)];
        }
      });

      print('✅ ${quotes.length} frases carregadas');
    } catch (e) {
      print('❌ Erro ao carregar frases: $e');
      setState(() => _isLoadingQuotes = false);
    }
  }

  Future<void> _loadRecentPhrases() async {
    try {
      setState(() => _isLoadingPhrases = true);

      // ✅ SEM ÍNDICE: Buscar mais docs e filtrar no código
      final snapshot = await _firestore
          .collection('phrases')
          .orderBy('createdAt', descending: true)
          .limit(20) // Busca mais para compensar filtro
          .get();

      // Filtrar isActive e pegar apenas 8
      final phrases = snapshot.docs
          .where((doc) {
            final data = doc.data();
            return data['isActive'] == true;
          })
          .take(8) // Pega apenas 8 após filtrar
          .map((doc) {
            final data = doc.data();
            final colorValue = data['colorValue'] as int? ?? Colors.blue.value;

            return {
              'id': doc.id,
              'phrase': data['phrase'] ?? '',
              'tag': data['tag'] ?? '',
              'color': Color(colorValue),
            };
          })
          .toList();

      setState(() {
        _recentPhrases = phrases;
        _isLoadingPhrases = false;
      });

      print('✅ ${phrases.length} frases recentes carregadas');
    } catch (e) {
      print('❌ Erro ao carregar frases recentes: $e');
      setState(() => _isLoadingPhrases = false);
    }
  }

  // Lista de dicas de bem-estar (mantida local)
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

  void _handleNewQuote() {
    if (_quotes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Nenhuma frase disponível. Cadastre frases no painel admin!'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() {
      Map<String, dynamic>? newQuote;

      // Seleciona uma frase diferente da atual
      if (_quotes.length > 1) {
        do {
          newQuote = _quotes[_random.nextInt(_quotes.length)];
        } while (newQuote?['id'] == _currentQuote?['id']);
      } else {
        newQuote = _quotes[0];
      }

      _currentQuote = newQuote;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✨ Nova frase gerada!'),
        backgroundColor: Colors.deepPurple,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Seleciona 4 frases aleatórias para exibir
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
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            _loadQuotes(),
            _loadRecentPhrases(),
          ]);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Inspiração para o seu dia",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Card da frase do dia
              _isLoadingQuotes
                  ? Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _currentQuote == null || _quotes.isEmpty
                      ? Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.format_quote,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Nenhuma frase cadastrada',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Cadastre frases no painel admin',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        )
                      : DailyQuoteCard(
                          quote: _currentQuote!['quote'] as String,
                          author: _currentQuote!['author'] as String,
                          onNewQuote: _handleNewQuote,
                        ),

              const SizedBox(height: 24),

              // Frases Recentes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Frases Recentes",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (!_isLoadingPhrases && _recentPhrases.isNotEmpty)
                    TextButton.icon(
                      onPressed: _loadRecentPhrases,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Atualizar'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.deepPurple,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              _isLoadingPhrases
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : displayPhrases.isEmpty
                      ? Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Nenhuma frase recente',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                      : Column(
                          children: displayPhrases.map((phraseData) {
                            return PhraseCard(
                              phrase: phraseData['phrase'] as String,
                              tag: phraseData['tag'] as String,
                              tagColor: phraseData['color'] as Color,
                            );
                          }).toList(),
                        ),

              const SizedBox(height: 24),

              // Dica de Bem-estar
              WellnessTipCard(
                title: _wellnessTips[_currentTipIndex]['title']!,
                content: _wellnessTips[_currentTipIndex]['content']!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
