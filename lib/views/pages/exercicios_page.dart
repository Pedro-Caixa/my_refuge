import 'package:flutter/material.dart';
import '../template/main_template.dart';
import '../widgets/cards/exercise_card.dart';
import '../widgets/cards/tips_card.dart';
import '../widgets/sections/custom_footer.dart'; // Importar o CustomFooter

class ExerciciosPage extends StatelessWidget {
  const ExerciciosPage({Key? key}) : super(key: key);

  void _handleStartExercise(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Iniciando exercício: $title'),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      title: "Exercícios de Respiração",
      currentIndex: 2, // Índice correspondente a "Exercícios" no menu
      onItemTapped: (int index) {
        // A navegação já é tratada no CustomFooter, mas você pode adicionar lógica adicional se necessário
      },
      backgroundColor: const Color(0xFFF5F8FC),
      customBottomNavigationBar: CustomFooter(
        // Adicionar o CustomFooter
        currentIndex: 2, // Índice correspondente a "Exercícios" no menu
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
              "Encontre paz e tranquilidade",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Text(
              "Exercícios Guiados",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ExerciseCard(
              icon: Icons.play_circle_fill,
              title: "Respiração 4-7-8",
              description: "Técnica relaxante para reduzir ansiedade",
              duration: "5 min",
              level: "Iniciante",
              color: Colors.blue,
              onStart: () => _handleStartExercise(context, "Respiração 4-7-8"),
            ),
            // ... outros componentes
          ],
        ),
      ),
    );
  }
}
