import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/user_controller.dart';
import '../template/main_template.dart';
import '../widgets/sections/custom_footer.dart';

class GamificationPage extends StatefulWidget {
  const GamificationPage({super.key});

  @override
  State<GamificationPage> createState() => _GamificationPageState();
}

class _GamificationPageState extends State<GamificationPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentPosition();
    });
  }

  void _scrollToCurrentPosition() {
    final userController = Provider.of<UserController>(context, listen: false);
    final currentDay = userController.currentUser?.dailyStreak ?? 0;

    if (currentDay > 3) {
      final position = (currentDay - 3) * 120.0;
      _scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      title: "Jornada de Bem-Estar",
      currentIndex: 1,
      customBottomNavigationBar: CustomFooter(
        currentIndex: 1,
        onItemTapped: (int index) {},
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFF4F8FB),
              Colors.blue.shade50,
            ],
          ),
        ),
        child: Consumer<UserController>(
          builder: (context, userController, child) {
            final currentDay = userController.currentUser?.dailyStreak ?? 0;
            final totalMilestones = 5;

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatCard(
                            icon: Icons.local_fire_department,
                            value: currentDay.toString(),
                            label: "Dias de Sequência",
                            color: Colors.orange,
                          ),
                          _buildStatCard(
                            icon: Icons.emoji_events,
                            value: (currentDay ~/ 30).toString(),
                            label: "Brindes Ganhos",
                            color: Colors.amber,
                          ),
                          _buildStatCard(
                            icon: Icons.trending_up,
                            value: "${(currentDay % 30)}/${30}",
                            label: "Próximo Brinde",
                            color: Colors.green,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildProgressBar(currentDay % 30, 30),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: SizedBox(
                        width: 300,
                        child: Column(
                          children:
                              _buildJourneyPath(currentDay, totalMilestones),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProgressBar(int current, int total) {
    final progress = current / total;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Faltam ${total - current} dias para o próximo brinde!",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            Text(
              "${(progress * 100).toInt()}%",
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.blue.shade400,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildJourneyPath(int currentDay, int totalMilestones) {
    List<Widget> pathElements = [];

    for (int milestone = 1; milestone <= totalMilestones; milestone++) {
      final milestoneDay = milestone * 30;
      final isUnlocked = currentDay >= milestoneDay;

      for (int day = (milestone - 1) * 30 + 1; day < milestoneDay; day++) {
        final isComplete = currentDay >= day;
        final isCurrent = currentDay == day;
        final isLeft = (day % 4 == 1 || day % 4 == 2);

        pathElements.add(
          _buildDayNode(
            day: day,
            isComplete: isComplete,
            isCurrent: isCurrent,
            alignLeft: isLeft,
          ),
        );

        // Adicionar linha conectora
        pathElements.add(_buildConnectorLine(isComplete, isCurrent));
      }

      pathElements.add(
        _buildMilestone(
          milestone: milestone,
          day: milestoneDay,
          isUnlocked: isUnlocked,
          isCurrent: currentDay == milestoneDay,
        ),
      );

      if (milestone < totalMilestones) {
        // Linha conectora após milestone
        pathElements
            .add(_buildConnectorLine(isUnlocked, false, isMilestoneLine: true));
      }
    }

    return pathElements;
  }

  // Nova função para criar linha conectora
  Widget _buildConnectorLine(bool isComplete, bool isCurrent,
      {bool isMilestoneLine = false}) {
    return Center(
      child: Container(
        width: 4,
        height: isMilestoneLine ? 40 : 20,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isComplete
                ? [
                    Colors.green.shade400,
                    Colors.green.shade300,
                  ]
                : isCurrent
                    ? [
                        Colors.blue.shade400,
                        Colors.blue.shade300,
                      ]
                    : [
                        Colors.grey.shade300,
                        Colors.grey.shade200,
                      ],
          ),
          borderRadius: BorderRadius.circular(2),
          boxShadow: (isComplete || isCurrent)
              ? [
                  BoxShadow(
                    color: isComplete
                        ? Colors.green.withOpacity(0.3)
                        : Colors.blue.withOpacity(0.3),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
      ),
    );
  }

  Widget _buildDayNode({
    required int day,
    required bool isComplete,
    required bool isCurrent,
    required bool alignLeft,
  }) {
    return Row(
      mainAxisAlignment:
          alignLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        if (!alignLeft) const Spacer(),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCurrent
                          ? Colors.blue.shade100
                          : isComplete
                              ? Colors.green.shade50
                              : Colors.grey.shade100,
                      border: Border.all(
                        color: isCurrent
                            ? Colors.blue
                            : isComplete
                                ? Colors.green
                                : Colors.grey.shade300,
                        width: isCurrent ? 4 : 3,
                      ),
                      boxShadow: isCurrent
                          ? [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Icon(
                        isComplete
                            ? Icons.check_circle
                            : isCurrent
                                ? Icons.favorite
                                : Icons.lock_outline,
                        color: isCurrent
                            ? Colors.blue
                            : isComplete
                                ? Colors.green
                                : Colors.grey,
                        size: 32,
                      ),
                    ),
                  ),
                  if (isCurrent)
                    Positioned(
                      top: -5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "VOCÊ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? Colors.blue
                      : isComplete
                          ? Colors.green
                          : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Dia $day",
                  style: TextStyle(
                    color: (isCurrent || isComplete)
                        ? Colors.white
                        : Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (alignLeft) const Spacer(),
      ],
    );
  }

  Widget _buildMilestone({
    required int milestone,
    required int day,
    required bool isUnlocked,
    required bool isCurrent,
  }) {
    final rewards = [
      {
        "icon": Icons.emoji_events,
        "name": "Troféu Bronze",
        "color": Colors.brown
      },
      {
        "icon": Icons.workspace_premium,
        "name": "Medalha Prata",
        "color": Colors.grey
      },
      {
        "icon": Icons.military_tech,
        "name": "Emblema Ouro",
        "color": Colors.amber
      },
      {"icon": Icons.diamond, "name": "Diamante", "color": Colors.blue},
      {"icon": Icons.star, "name": "Estrela Master", "color": Colors.purple},
    ];

    final reward = rewards[milestone - 1];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isUnlocked
              ? [
                  (reward["color"] as Color).withOpacity(0.2),
                  (reward["color"] as Color).withOpacity(0.1),
                ]
              : [Colors.grey.shade200, Colors.grey.shade100],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isUnlocked ? (reward["color"] as Color) : Colors.grey.shade400,
          width: 3,
        ),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: (reward["color"] as Color).withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              if (isUnlocked)
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (reward["color"] as Color).withOpacity(0.2),
                  ),
                ),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isUnlocked
                      ? (reward["color"] as Color)
                      : Colors.grey.shade400,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Icon(
                  reward["icon"] as IconData,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              if (!isUnlocked)
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.3),
                  ),
                  child: const Icon(
                    Icons.lock,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            reward["name"] as String,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isUnlocked
                  ? (reward["color"] as Color)
                  : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isUnlocked ? "🎉 Conquistado!" : "🔒 Bloqueado",
            style: TextStyle(
              fontSize: 14,
              color: isUnlocked ? Colors.green : Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isUnlocked
                  ? Colors.green.withOpacity(0.2)
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "Meta: $day dias",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isUnlocked ? Colors.green : Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
