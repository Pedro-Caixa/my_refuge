import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../template/main_template.dart';
import '../widgets/sections/emotion_selector.dart';
import '../widgets/sections/note_input.dart';
import '../widgets/sections/history_card.dart';
import '../widgets/buttons/save_button.dart';
import '../widgets/sections/custom_footer.dart';
import '../../controllers/user_controller.dart';
import '../../models/check_in.dart';

class CheckInPage extends StatefulWidget {
  const CheckInPage({super.key});

  @override
  _CheckInPageState createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  int? _selectedMood;
  String _note = '';
  List<CheckIn> _recentCheckIns = [];
  bool _isLoadingHistory = true;

  @override
  void initState() {
    super.initState();
    _loadCheckInHistory();
  }

  Future<void> _loadCheckInHistory() async {
    final userController = Provider.of<UserController>(context, listen: false);
    try {
      final checkIns = await userController.getCheckIns(limit: 7); // Últimos 7 dias
      setState(() {
        _recentCheckIns = checkIns;
        _isLoadingHistory = false;
      });
    } catch (e) {
      print('Erro ao carregar histórico: $e');
      setState(() {
        _isLoadingHistory = false;
      });
    }
  }

  String _getMoodText(int mood) {
    switch (mood) {
      case 1: return 'Ansioso';
      case 2: return 'Irritado';
      case 3: return 'Triste';
      case 4: return 'Neutro';
      case 5: return 'Calmo';
      case 6: return 'Feliz';
      default: return 'Desconhecido';
    }
  }

  IconData _getMoodIcon(int mood) {
    switch (mood) {
      case 1: return Icons.sentiment_very_dissatisfied; // Ansioso
      case 2: return Icons.sentiment_dissatisfied; // Irritado
      case 3: return Icons.sentiment_dissatisfied; // Triste
      case 4: return Icons.sentiment_neutral; // Neutro
      case 5: return Icons.sentiment_satisfied; // Calmo
      case 6: return Icons.sentiment_very_satisfied; // Feliz
      default: return Icons.sentiment_neutral;
    }
  }

  Color _getMoodColor(int mood) {
    switch (mood) {
      case 1: return Colors.red; // Ansioso
      case 2: return Colors.orange; // Irritado
      case 3: return Colors.orange; // Triste
      case 4: return Colors.yellow; // Neutro
      case 5: return Colors.lightGreen; // Calmo
      case 6: return Colors.green; // Feliz
      default: return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final checkInDate = DateTime(date.year, date.month, date.day);
    
    final difference = today.difference(checkInDate).inDays;
    
    switch (difference) {
      case 0: return 'Hoje';
      case 1: return 'Ontem';
      case 2: return 'Anteontem';
      default: return '${difference} dias atrás';
    }
  }

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
            _isLoadingHistory
                ? const Center(child: CircularProgressIndicator())
                : _recentCheckIns.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhum check-in encontrado ainda.\nFaça seu primeiro check-in hoje!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : Column(
                        children: _recentCheckIns.map((checkIn) {
                          return HistoryCard(
                            day: _formatDate(checkIn.date),
                            status: _getMoodText(checkIn.mood),
                            icon: _getMoodIcon(checkIn.mood),
                            color: _getMoodColor(checkIn.mood),
                            note: checkIn.note,
                          );
                        }).toList(),
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
                        // Recarregar histórico para mostrar o novo check-in
                        _loadCheckInHistory();
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}
