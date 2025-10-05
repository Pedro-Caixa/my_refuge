import 'package:flutter/material.dart';
import '../buttons/selectable_button.dart';

class AnonymousAccessSection extends StatelessWidget {
  final VoidCallback? onPressed; // Adicione o '?' para tornar opcional

  const AnonymousAccessSection({
    Key? key,
    this.onPressed, // Agora pode ser nulo
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            "Prefere não criar uma conta?",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10),
          SelectableButton(
            text: "Usar Anonimamente",
            isSelected: false,
            onPressed: onPressed, // Se for nulo, o botão será desabilitado
          ),
        ],
      ),
    );
  }
}
