import 'package:flutter/material.dart';

class ExerciseCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String duration;
  final String level;
  final Color color;
  final VoidCallback? onStart;

  const ExerciseCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.duration,
    required this.level,
    required this.color,
    this.onStart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("$description\n$duration • $level"),
        isThreeLine: true,
        trailing: ElevatedButton(
          onPressed: onStart,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: const Text("Iniciar", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
