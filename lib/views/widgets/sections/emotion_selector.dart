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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Define tamanhos responsivos baseados na largura disponível
        final width = constraints.maxWidth;
        final isSmallScreen = width < 360;
        final isMediumScreen = width >= 360 && width < 600;

        // Ajusta tamanhos de acordo com a tela
        final double emojiSize =
            isSmallScreen ? 24 : (isMediumScreen ? 28 : 32);
        final double fontSize = isSmallScreen ? 10 : (isMediumScreen ? 12 : 14);
        final double horizontalPadding = isSmallScreen ? 8 : 12;
        final double verticalPadding = isSmallScreen ? 6 : 8;
        final double spacing = isSmallScreen ? 8 : (isMediumScreen ? 12 : 16);
        final double runSpacing = isSmallScreen ? 8 : 12;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: spacing,
            runSpacing: runSpacing,
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
                  constraints: BoxConstraints(
                    minWidth: isSmallScreen ? 60 : 70,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.blue.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        mood['emoji'],
                        style: TextStyle(fontSize: emojiSize),
                      ),
                      SizedBox(height: isSmallScreen ? 4 : 6),
                      Text(
                        mood['label'],
                        style: TextStyle(fontSize: fontSize),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
