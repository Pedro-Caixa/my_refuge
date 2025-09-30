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
      type: BottomNavigationBarType.fixed, // permite mais de 3 itens
      currentIndex: currentIndex,
      onTap: onItemTapped,
      selectedItemColor: Colors.blue, // cor do item selecionado
      unselectedItemColor: Colors.grey, // cor dos itens não selecionados
      showUnselectedLabels: true, // mostra label nos não selecionados
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: Colors.blue),
          label: "Início",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search, color: Colors.green),
          label: "Pesquisar",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite, color: Colors.red),
          label: "Favoritos",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color: Colors.purple),
          label: "Perfil",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings, color: Colors.orange),
          label: "Configurações",
        ),
      ],
    );
  }
}
