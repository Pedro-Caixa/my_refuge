import 'package:flutter/material.dart';

class NoteInput extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final int? maxLines;
  final Function(String)? onChanged;

  const NoteInput({
    Key? key,
    this.labelText,
    this.hintText,
    this.maxLines = 4,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelText != null)
            Text(
              labelText!,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          if (labelText != null) const SizedBox(height: 10),
          TextField(
            maxLines: maxLines,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.black38),
              filled: true,
              fillColor: const Color(0xFFF8F9FB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
