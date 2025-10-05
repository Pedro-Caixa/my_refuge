import 'package:flutter/material.dart';
import '../template/main_template.dart';
import '../widgets/sections/option_card.dart';
import '../widgets/sections/streak_card.dart';
import '../widgets/sections/custom_footer.dart'; // Importar o CustomFooter

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      title: "My Refuge",
      currentIndex: 0,
      onItemTapped: (int index) {
        // Como a navegação já é tratada no CustomFooter,
        // podemos deixar vazio ou adicionar lógica adicional se necessário
      },
      customBottomNavigationBar: CustomFooter(
        // Adicionar o CustomFooter
        currentIndex: 0, // Índice correspondente a "Home" no menu
        onItemTapped: (int index) {
          // A navegação já é tratada dentro do CustomFooter, mas você pode adicionar lógica adicional se necessário
        },
      ),
      body: Container(
        color: const Color(0xFFF4F8FB),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Olá 👋",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                "Como está o seu dia?",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              const StreakCard(
                days: 7,
                daysToReward: 43,
              ),
              const SizedBox(height: 24),
              OptionCard(
                icon: Icons.favorite,
                iconColor: Colors.blue,
                title: "Check-in Diário",
                subtitle: "Como você está se sentindo hoje?",
                onTap: () {
                  Navigator.pushNamed(context, '/humor');
                },
              ),
              OptionCard(
                icon: Icons.spa,
                iconColor: Colors.green,
                title: "Exercícios de Respiração",
                subtitle: "Encontre paz e tranquilidade",
                onTap: () {
                  Navigator.pushNamed(context, '/exercicios');
                },
              ),
              OptionCard(
                icon: Icons.format_quote,
                iconColor: Colors.orange,
                title: "Frases Motivacionais",
                subtitle: "Inspiração para o seu dia",
                onTap: () {
                  Navigator.pushNamed(context, '/frases');
                },
              ),
              OptionCard(
                icon: Icons.book,
                iconColor: Colors.purple,
                title: "Agendamento",
                subtitle: "Conecte-se com profissionais",
                onTap: () {
                  Navigator.pushNamed(context, '/consulta');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
