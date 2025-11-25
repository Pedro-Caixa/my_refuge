import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../template/main_template.dart';
import '../widgets/cards/exercise_card.dart';
import '../widgets/sections/custom_footer.dart';

class ExerciciosPage extends StatefulWidget {
  const ExerciciosPage({Key? key}) : super(key: key);

  @override
  State<ExerciciosPage> createState() => _ExerciciosPageState();
}

class _ExerciciosPageState extends State<ExerciciosPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _exercises = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    try {
      setState(() => _isLoading = true);

      final snapshot = await _firestore
          .collection('exercises')
          .orderBy('createdAt', descending: true)
          .get();

      final exercises = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'] ?? 'Sem nome',
          'category': data['category'] ?? 'Geral',
          'description': data['description'] ?? '',
          'duration': data['duration'] ?? '5 min',
          'level': data['level'] ?? 'Iniciante',
          'youtubeUrl': data['youtubeUrl'] ?? '',
        };
      }).toList();

      setState(() {
        _exercises = exercises;
        _isLoading = false;
      });

      print('✅ ${exercises.length} exercícios carregados');
    } catch (e) {
      print('❌ Erro ao carregar exercícios: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleStartExercise(
      BuildContext context, Map<String, dynamic> exercise) async {
    final youtubeUrl = exercise['youtubeUrl'] as String;

    if (youtubeUrl.isNotEmpty) {
      try {
        final uri = Uri.parse(youtubeUrl);

        // Tentar abrir a URL
        if (await canLaunchUrl(uri)) {
          await launchUrl(
            uri,
            mode: LaunchMode
                .externalApplication, // Abre no app do YouTube ou navegador
          );

          print('✅ Abrindo vídeo: $youtubeUrl');
        } else {
          throw 'Não foi possível abrir o vídeo';
        }
      } catch (e) {
        print('❌ Erro ao abrir vídeo: $e');

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao abrir o vídeo: $e'),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Este exercício não possui vídeo cadastrado'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'relaxamento':
        return Colors.blue;
      case 'respiração':
        return Colors.purple;
      case 'meditação':
        return Colors.deepPurple;
      case 'yoga':
        return Colors.teal;
      case 'fitness':
        return Colors.orange;
      case 'cardio':
        return Colors.red;
      case 'força':
        return Colors.indigo;
      default:
        return Colors.blueGrey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'relaxamento':
        return Icons.spa;
      case 'respiração':
        return Icons.air;
      case 'meditação':
        return Icons.self_improvement;
      case 'yoga':
        return Icons.sports_gymnastics;
      case 'fitness':
        return Icons.fitness_center;
      case 'cardio':
        return Icons.favorite;
      case 'força':
        return Icons.sports_martial_arts;
      default:
        return Icons.play_circle_fill;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      title: "Exercícios de Respiração",
      currentIndex: 2,
      onItemTapped: (int index) {},
      backgroundColor: const Color(0xFFF5F8FC),
      customBottomNavigationBar: CustomFooter(
        currentIndex: 2,
        onItemTapped: (int index) {},
      ),
      body: RefreshIndicator(
        onRefresh: _loadExercises,
        child: _isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Carregando exercícios...',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            : _exercises.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.fitness_center,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum exercício cadastrado',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Cadastre exercícios no painel admin',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _loadExercises,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Recarregar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Encontre paz e tranquilidade",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Exercícios Guiados",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: _loadExercises,
                              icon: const Icon(Icons.refresh, size: 18),
                              label: const Text('Atualizar'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.deepPurple,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${_exercises.length} exercício${_exercises.length != 1 ? 's' : ''} disponível${_exercises.length != 1 ? 'is' : ''}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Lista de exercícios
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _exercises.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final exercise = _exercises[index];
                            final category = exercise['category'] as String;

                            return ExerciseCard(
                              icon: _getCategoryIcon(category),
                              title: exercise['name'] as String,
                              description: exercise['description'] as String,
                              duration: exercise['duration'] as String,
                              level: exercise['level'] as String,
                              color: _getCategoryColor(category),
                              onStart: () =>
                                  _handleStartExercise(context, exercise),
                            );
                          },
                        ),

                        const SizedBox(height: 24),

                        // Card de dica
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue[100]!),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                color: Colors.blue[700],
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Dica',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[900],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Pratique os exercícios regularmente para melhores resultados!',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.blue[800],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
