import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../template/main_template.dart';
import '../widgets/sections/emotion_selector.dart';
import '../widgets/sections/note_input.dart';
import '../widgets/sections/history_card.dart';
import '../widgets/buttons/save_button.dart';
import '../widgets/sections/custom_footer.dart';
import '../../controllers/user_controller.dart';

class CheckInPage extends StatefulWidget {
  const CheckInPage({super.key});

  @override
  _CheckInPageState createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  int? _selectedMood;
  String _note = '';

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);

    return MainTemplate(
      title: "Check-in Diário",
      currentIndex: 1,
      onItemTapped: (int index) {
        // Lógica de navegação se necessário
      },
      backgroundColor: const Color(0xFFE8F2F9),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color.fromARGB(221, 255, 255, 255)),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      customBottomNavigationBar: CustomFooter(
        currentIndex: 1,
        onItemTapped: (int index) {
          // Lógica adicional se necessário
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Como você está se sentindo hoje?",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            EmotionSelector(
              onMoodSelected: (mood) {
                setState(() {
                  _selectedMood = mood;
                });
              },
            ),
            const SizedBox(height: 20),
            NoteInput(
              labelText: "O que aconteceu hoje? (Opcional)",
              hintText: "Compartilhe algo sobre o seu dia...",
              onChanged: (value) {
                setState(() {
                  _note = value;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Histórico Recente",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const HistoryCard(
              day: "Ontem",
              status: "Bem",
              icon: Icons.favorite_border,
              color: Colors.green,
            ),
            const HistoryCard(
              day: "Anteontem",
              status: "Excelente",
              icon: Icons.sentiment_satisfied,
              color: Colors.green,
            ),
            const SizedBox(height: 30),
            SaveButton(
              onPressed: _selectedMood == null || userController.isLoading
                  ? null
                  : () async {
                      final success = await userController.saveCheckIn(
                        _selectedMood!,
                        note: _note.isEmpty ? null : _note,
                      );

                      if (success && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Check-in salvo com sucesso!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // Limpar os campos após salvar
                        setState(() {
                          _selectedMood = null;
                          _note = '';
                        });
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}
