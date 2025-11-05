import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/user_controller.dart';

class CustomFooter extends StatefulWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const CustomFooter({
    Key? key,
    required this.currentIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  _CustomFooterState createState() => _CustomFooterState();
}

class _CustomFooterState extends State<CustomFooter> {
  bool _hasCheckedToday = true; // Assume true inicialmente para evitar mostrar notificação desnecessariamente

  @override
  void initState() {
    super.initState();
    _checkDailyCheckIn();
  }

  Future<void> _checkDailyCheckIn() async {
    final userController = Provider.of<UserController>(context, listen: false);
    final hasChecked = await userController.hasCheckedInToday();
    if (mounted) {
      setState(() {
        _hasCheckedToday = hasChecked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey,
      currentIndex: widget.currentIndex,
      onTap: (index) {
        // Navegação direta baseada no índice
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/home');
            break;
          case 1:
            Navigator.pushNamed(context, '/humor');
            break;
          case 2:
            Navigator.pushNamed(context, '/exercicios');
            break;
          case 3:
            Navigator.pushNamed(context, '/frases');
            break;
          case 4:
            Navigator.pushNamed(context, '/consulta');
            break;
        }
        // Chama a função onItemTapped caso exista
        widget.onItemTapped(index);
      },
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: _hasCheckedToday
              ? const Icon(Icons.favorite)
              : const Badge(
                  label: Text('!'),
                  child: Icon(Icons.favorite),
                ),
          label: "Diario do Humor",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.self_improvement),
          label: "Exercícios",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.sunny),
          label: "Frases Motivação",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: "Marcar Consulta",
        ),
      ],
    );
  }
}
