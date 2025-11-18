import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_refuge/controllers/user_controller.dart';
import '../template/main_template.dart';
import '../widgets/sections/option_card.dart';
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

  void _showDevPanel(BuildContext context, UserController userController) {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.developer_board, color: Colors.teal),
              SizedBox(width: 8),
              Text('Painel Dev'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Digite o email do usuário para promover a Admin:',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email do usuário',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              Text(
                '⚠️ Apenas desenvolvedores podem promover usuários',
                style: TextStyle(fontSize: 12, color: Colors.orange),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (emailController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Digite um email válido')),
                  );
                  return;
                }

                Navigator.of(context).pop();

                final success = await userController
                    .promoteUserToAdmin(emailController.text.trim());
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Usuário promovido a admin com sucesso!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Erro: ${userController.errorMessage}')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: Text('Promover a Admin'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    final user = userController.currentUser;

    return MainTemplate(
      title: "My Refuge",
      currentIndex: 0,
      onItemTapped: (int index) {},
      customBottomNavigationBar: CustomFooter(
        currentIndex: 0,
        onItemTapped: (int index) {},
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
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                "Como está o seu dia?",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),

              // StreakCard com botão de navegação
              Consumer<UserController>(
                builder: (context, userController, child) {
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/gamification');
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF9C27B0), Color(0xFFBA68C8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Sequência Atual",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              // Botão de seta para navegação
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Continue sua jornada!",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              // Ícone de fogo
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.local_fire_department,
                                  color: Colors.orange,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Informações de dias
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${userController.currentUser?.dailyStreak ?? 0} dias",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "${30 - (userController.currentUser?.dailyStreak ?? 0) % 30} dias para o primeiro brinde especial 🎁",
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              if (!userController.isAdmin &&
                  userController.currentUser?.email ==
                      "marquinhotavares03@gmail.com") ...[
                Card(
                  color: Colors.orange[50],
                  child: ListTile(
                    leading:
                        Icon(Icons.admin_panel_settings, color: Colors.orange),
                    title: Text('Promover a Admin'),
                    subtitle: Text('Clique para se tornar administrador'),
                    onTap: () async {
                      final success =
                          await userController.promoteCurrentUserToAdmin();
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Promovido a admin com sucesso!')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Erro: ${userController.errorMessage}')),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],

              if (userController.isAdmin || userController.isDev) ...[
                OptionCard(
                  icon: Icons.dashboard,
                  iconColor: Colors.purple,
                  title: "Dashboard Admin",
                  subtitle: "Acesse o painel administrativo",
                  backgroundColor: const Color.fromARGB(255, 219, 119, 236),
                  onTap: () {
                    Navigator.pushNamed(context, '/admin');
                  },
                ),
                const SizedBox(height: 16),
              ],

              if (userController.isDev) ...[
                OptionCard(
                  icon: Icons.developer_board,
                  iconColor: Colors.teal,
                  title: "Painel Dev",
                  subtitle: "Gerencie usuários e promoções",
                  backgroundColor: const Color.fromARGB(255, 146, 209, 203),
                  onTap: () {
                    _showDevPanel(context, userController);
                  },
                ),
                const SizedBox(height: 16),
              ],

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
