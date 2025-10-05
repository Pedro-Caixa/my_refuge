import 'package:flutter/material.dart';

class TipsCard extends StatelessWidget {
  final String title;
  final List<String> tips;
  final IconData? icon;
  final Color? iconColor;

  const TipsCard({
    Key? key,
    required this.title,
    required this.tips,
    this.icon,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon ?? Icons.lightbulb, color: iconColor ?? Colors.amber),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...tips
              .map((tip) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text("• $tip"),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
