import 'package:flutter/material.dart';
import '../template/main_template.dart';
import '../widgets/sections/emotion_selector.dart';
import '../widgets/sections/note_input.dart';
import '../widgets/sections/history_card.dart';
import '../widgets/buttons/save_button.dart';
import '../widgets/sections/custom_footer.dart';

class CheckInPage extends StatelessWidget {
  const CheckInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      title: "Check-in Diário",
      currentIndex: 0,
      onItemTapped: (int index) {
        if (index == 0) {
          Navigator.pushNamed(context, '/humor');
        } else if (index == 1) {
          // Navigator.pushNamed(context, '/resumos');
        }

        // Corrigido: alterado de 'customBottomNavigationBar' para 'bottomNavigationBa
      },
      backgroundColor: const Color(0xFFE8F2F9),
      transparentAppBar: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      customBottomNavigationBar: CustomFooter(
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
              "Como você está se sentindo hoje?",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            const EmotionSelector(),
            const SizedBox(height: 20),
            const NoteInput(
              labelText: "O que aconteceu hoje? (Opcional)",
              hintText: "Compartilhe algo sobre o seu dia...",
            ),
            const SizedBox(height: 20),
            const Text(
              "Histórico Recente",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const HistoryCard(
              day: "Ontem",
              status: "Bem",
              icon: Icons.favorite_border,
              color: Colors.green,
            ),
            const HistoryCard(
              day: "Anteontem",
              status: "Excelente",
              icon: Icons.sentiment_satisfied,
              color: Colors.green,
            ),
            const SizedBox(height: 30),
            SaveButton(
              onPressed: () {
                // Lógica para salvar o check-in
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Check-in salvo com sucesso!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
