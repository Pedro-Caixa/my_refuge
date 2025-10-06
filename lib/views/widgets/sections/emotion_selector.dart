import 'package:flutter/material.dart';

class EmotionSelector extends StatelessWidget {
  final Function(String, String)? onEmotionSelected;

  const EmotionSelector({
    Key? key,
    this.onEmotionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildEmotion("😊", "Feliz"),
          _buildEmotion("😐", "Indiferente"),
          _buildEmotion("😢", "Triste"),
          _buildEmotion("😠", "Irritado"),
          _buildEmotion("😰", "Ansioso"),
        ],
      ),
    );
  }

  Widget _buildEmotion(String emoji, String label) {
    return InkWell(
      onTap: () => onEmotionSelected?.call(emoji, label),
      borderRadius: BorderRadius.circular(8),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
