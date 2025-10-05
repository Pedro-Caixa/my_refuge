import 'package:flutter/material.dart';

class StreakCard extends StatelessWidget {
  final int days;
  final int daysToReward;

  const StreakCard({
    Key? key,
    required this.days,
    required this.daysToReward,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7E57C2), Color(0xFFAB47BC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Sequência Atual",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Continue sua jornada!",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$days dias",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(
                Icons.local_fire_department,
                color: Colors.orangeAccent,
                size: 32,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "$daysToReward dias para o primeiro brinde especial 🎁",
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
