import 'package:flutter/material.dart';

class PhraseCard extends StatelessWidget {
  final String phrase;
  final String tag;
  final Color tagColor;

  const PhraseCard({
    Key? key,
    required this.phrase,
    required this.tag,
    required this.tagColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "“$phrase”",
            style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                "— My Refuge",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: tagColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: TextStyle(fontSize: 12, color: tagColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
