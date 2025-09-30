import 'package:flutter/material.dart';

class ExerciciosPage extends StatelessWidget {
  const ExerciciosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Exercícios de Respiração",
          style: TextStyle(color: Colors.white),
        ),
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
              "Encontre paz e tranquilidade",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Text(
              "Exercícios Guiados",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildExerciseCard(
              icon: Icons.play_circle_fill,
              title: "Respiração 4-7-8",
              description: "Técnica relaxante para reduzir ansiedade",
              duration: "5 min",
              level: "Iniciante",
              color: Colors.blue,
            ),
            _buildExerciseCard(
              icon: Icons.play_circle_fill,
              title: "Respiração Quadrada",
              description: "Equilibre sua mente e corpo",
              duration: "3 min",
              level: "Iniciante",
              color: Colors.pink,
            ),
            _buildExerciseCard(
              icon: Icons.play_circle_fill,
              title: "Respiração Profunda",
              description: "Para momentos de estresse",
              duration: "10 min",
              level: "Intermediário",
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            const Text(
              "Áudios Relaxantes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildAudioCard(
              "Sons da Natureza - Oceano",
              "Ondas relaxantes para meditação",
            ),
            _buildAudioCard(
              "Música Instrumental Calma",
              "Melodias suaves para relaxar",
            ),
            _buildAudioCard(
              "Chuva na Floresta",
              "Sons naturais para concentração",
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.amber),
                      SizedBox(width: 8),
                      Text(
                        "Dicas para uma boa prática",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text("• Encontre um lugar quieto e confortável"),
                  Text("• Mantenha a coluna reta e relaxe os ombros"),
                  Text("• Comece com exercícios mais curtos"),
                  Text("• Pratique regularmente, mesmo que por poucos minutos"),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        currentIndex: 1,
        onTap: (int index) {
          // Ação de navegação para as outras telas do BottomNavigationBar
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favoritos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: "Exercícios",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement),
            label: "Meditar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: "Áudios",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }

  Widget _buildExerciseCard({
    required IconData icon,
    required String title,
    required String description,
    required String duration,
    required String level,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("$description\n$duration • $level"),
        isThreeLine: true,
        trailing: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: const Text("Iniciar", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildAudioCard(String title, String description) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.deepPurple,
          child: Icon(Icons.headphones, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: const Text("Abrir", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
