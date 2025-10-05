import 'package:flutter/material.dart';

class DailyQuoteCard extends StatelessWidget {
  final String quote;
  final String author;
  final VoidCallback? onNewQuote;

  const DailyQuoteCard({
    Key? key,
    required this.quote,
    required this.author,
    this.onNewQuote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(
            "“$quote”",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "— $author",
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onNewQuote,
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
    );
  }
}
