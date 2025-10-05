import 'package:flutter/material.dart';

class AudioCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onPlay;

  const AudioCard({
    Key? key,
    required this.title,
    required this.description,
    this.onPlay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.deepPurple,
          child: Icon(Icons.headphones, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: ElevatedButton(
          onPressed: onPlay,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: const Text("Abrir", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
