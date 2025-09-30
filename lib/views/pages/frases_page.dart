import 'package:flutter/material.dart';

class MotivationalPage extends StatelessWidget {
  const MotivationalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      appBar: AppBar(
        title: const Text("Frases Motivacionais"),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7E57C2), Color(0xFF64B5F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite, color: Colors.white, size: 32),
                  const SizedBox(height: 10),
                  const Text(
                    "Frase do Dia",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "“Você é mais forte do que imagina e mais capaz do que acredita.”",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "— My Refuge",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text("Nova Frase"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Frases Recentes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildPhraseCard(
              phrase:
                  "“Você é mais forte do que imagina e mais capaz do que acredita.”",
              tag: "força",
              tagColor: Colors.blue,
            ),
            _buildPhraseCard(
              phrase:
                  "“Cada pequeno passo em direção ao autocuidado é uma vitória.”",
              tag: "autocuidado",
              tagColor: Colors.green,
            ),
            _buildPhraseCard(
              phrase:
                  "“Suas emoções são válidas. Permita-se senti-las sem julgamento.”",
              tag: "aceitação",
              tagColor: Colors.teal,
            ),
            _buildPhraseCard(
              phrase:
                  "“O progresso não é linear. Cada dia é uma nova oportunidade.”",
              tag: "progresso",
              tagColor: Colors.orange,
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dica de Bem-estar",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Comece o dia lendo uma frase motivacional. Isso pode ajudar a definir um tom positivo para suas próximas horas e lembrar você de que é capaz de superar qualquer desafio.",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhraseCard({
    required String phrase,
    required String tag,
    required Color tagColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            phrase,
            style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                "— My Refuge",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: tagColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: TextStyle(fontSize: 12, color: tagColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
