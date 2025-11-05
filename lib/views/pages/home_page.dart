import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importante para acessar o UserController
import 'package:my_refuge/controllers/user_controller.dart';
import '../template/main_template.dart';
import '../widgets/sections/option_card.dart';
import '../widgets/sections/streak_card.dart';
import '../widgets/sections/custom_footer.dart';
import '../../controllers/user_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _notificationShown = false;

  @override
  void initState() {
    super.initState();
    _checkAndShowNotification();
  }

  Future<void> _checkAndShowNotification() async {
    final userController = Provider.of<UserController>(context, listen: false);
    
    // Aguardar um pouco para garantir que o usuário está carregado
    await Future.delayed(const Duration(seconds: 1));
    
    if (!mounted) return;
    
    final hasChecked = await userController.hasCheckedInToday();
    if (!hasChecked && !_notificationShown) {
      _notificationShown = true;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Faça o seu check-in diário!'),
          action: SnackBarAction(
            label: 'Ir',
            onPressed: () {
              Navigator.pushNamed(context, '/humor');
            },
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    final user = userController.currentUser;

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
              // Saudação dinâmica
              Text(
                user != null && !user.isAnonymous && user.name.isNotEmpty
                    ? "Olá, ${user.name} 👋"
                    : "Olá 👋",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                "Como está o seu dia?",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              Consumer<UserController>(
                builder: (context, userController, child) {
                  return StreakCard(
                    days: userController.currentUser?.dailyStreak ?? 0,
                    daysToReward: 30 - (userController.currentUser?.dailyStreak ?? 0),
                  );
                },
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
