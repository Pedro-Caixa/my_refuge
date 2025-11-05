import 'package:flutter/material.dart';

class CustomFooter extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const CustomFooter({
    Key? key,
    required this.currentIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
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
          case 5:
            Navigator.pushNamed(context, '/complete-profile');
            break;
        }
        // Chama a função onItemTapped caso exista
        onItemTapped(index);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: "Diario do Humor",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.self_improvement),
          label: "Exercícios",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sunny),
          label: "Frases Motivação",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: "Marcar Consulta",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_pin_circle),
          label: "Perfil",
        ),
      ],
    );
  }
}
