import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/user_controller.dart';

class DailyCheckInDialog extends StatefulWidget {
  const DailyCheckInDialog({Key? key}) : super(key: key);

  @override
  _DailyCheckInDialogState createState() => _DailyCheckInDialogState();
}

class _DailyCheckInDialogState extends State<DailyCheckInDialog> {
  int? _selectedMood;
  final TextEditingController _noteController = TextEditingController();

  final List<Map<String, dynamic>> _moods = [
    {'emoji': '�', 'label': 'Ansioso', 'value': 1},
    {'emoji': '�', 'label': 'Irritado', 'value': 2},
    {'emoji': '�', 'label': 'Triste', 'value': 3},
    {'emoji': '�', 'label': 'Neutro', 'value': 4},
    {'emoji': '�', 'label': 'Calmo', 'value': 5},
    {'emoji': '�', 'label': 'Feliz', 'value': 6},
  ];

  @override
  Widget build(BuildContext context) {

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Check-in Diário',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            const Text('Como você está se sentindo hoje?'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _moods.map((mood) {
                final isSelected = _selectedMood == mood['value'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMood = mood['value'];
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(mood['emoji']!, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 5),
                        Text(mood['label']!),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text('O que ocorreu hoje? (opcional)'),
            const SizedBox(height: 10),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Conte um pouco sobre seu dia...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Pular'),
                ),
                const SizedBox(width: 10),
                Consumer<UserController>(
                  builder: (context, controller, child) {
                    return ElevatedButton(
                      onPressed: _selectedMood == null || controller.isLoading
                          ? null
                          : () async {
                              final success = await controller.saveCheckIn(
                                _selectedMood!,
                                note: _noteController.text.isEmpty ? null : _noteController.text,
                              );

                              if (success && mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Check-in salvo com sucesso!')),
                                );
                              }
                            },
                      child: controller.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Salvar'),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}