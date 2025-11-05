import 'package:flutter/material.dart';

class EmotionSelector extends StatefulWidget {
  final Function(int)? onMoodSelected;

  const EmotionSelector({
    Key? key,
    this.onMoodSelected,
  }) : super(key: key);

  @override
  _EmotionSelectorState createState() => _EmotionSelectorState();
}

class _EmotionSelectorState extends State<EmotionSelector> {
  int? _selectedMood;

  final List<Map<String, dynamic>> _moods = [
    {'emoji': '😰', 'label': 'Ansioso', 'value': 1},
    {'emoji': '😠', 'label': 'Irritado', 'value': 2},
    {'emoji': '😢', 'label': 'Triste', 'value': 3},
    {'emoji': '😐', 'label': 'Neutro', 'value': 4},
    {'emoji': '😊', 'label': 'Feliz', 'value': 5},
    {'emoji': '😌', 'label': 'Calmo', 'value': 6},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 16,
        runSpacing: 12,
        children: _moods.map((mood) {
          final isSelected = _selectedMood == mood['value'];
          return InkWell(
            onTap: () {
              setState(() {
                _selectedMood = mood['value'];
              });
              widget.onMoodSelected?.call(mood['value']);
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Text(mood['emoji'], style: const TextStyle(fontSize: 28)),
                  const SizedBox(height: 6),
                  Text(mood['label'], style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
