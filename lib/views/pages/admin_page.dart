import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({Key? key}) : super(key: key);

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  String selectedPeriod = 'Últimos 7 dias';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Dados carregados
  Map<String, dynamic> summaryData = {};
  List<FlSpot> checkinsData = [];
  List<BarChartGroupData> userGrowthData = [];
  List<PieChartSectionData> activitiesData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);

    try {
      await Future.wait([
        _loadSummaryData(),
        _loadCheckinsData(),
        _loadUserGrowthData(),
        _loadActivitiesDistribution(),
      ]);
    } catch (e) {
      print('Erro ao carregar dados: $e');
    }

    setState(() => isLoading = false);
  }

  Future<void> _loadSummaryData() async {
    try {
      print('🔄 Carregando dados do resumo...');

      // Total de usuários cadastrados
      final usersSnapshot = await _firestore.collection('users').get();
      final totalUsers = usersSnapshot.docs.length;
      print('✅ Usuários cadastrados: $totalUsers');

      // Total de check-ins feitos
      final allCheckinsSnapshot = await _firestore.collection('checkins').get();
      final totalCheckins = allCheckinsSnapshot.docs.length;
      print('✅ Total de check-ins: $totalCheckins');

      // Check-ins hoje
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final checkinsToday = await _firestore
          .collection('checkins')
          .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
          .get();
      print('✅ Check-ins hoje: ${checkinsToday.docs.length}');

      // Crescimento de usuários (últimos 30 dias)
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
      final recentUsersSnapshot = await _firestore
          .collection('users')
          .where('createdAt', isGreaterThanOrEqualTo: thirtyDaysAgo)
          .get();
      print('✅ Novos usuários (30 dias): ${recentUsersSnapshot.docs.length}');

      summaryData = {
        'totalUsers': totalUsers.toString(),
        'totalCheckins': totalCheckins.toString(),
        'checkinsToday': checkinsToday.docs.length.toString(),
        'newUsers': recentUsersSnapshot.docs.length.toString(),
      };

      print('✅ Resumo carregado com sucesso!');
    } catch (e) {
      print('❌ Erro ao carregar resumo: $e');
    }
  }

  Future<void> _loadCheckinsData() async {
    try {
      print('🔄 Carregando dados de check-ins...');
      final days = _getDaysForPeriod();
      final data = <FlSpot>[];

      for (int i = 0; i < days; i++) {
        final date = DateTime.now().subtract(Duration(days: days - 1 - i));
        final startOfDay = DateTime(date.year, date.month, date.day);
        final endOfDay = startOfDay.add(const Duration(days: 1));

        final snapshot = await _firestore
            .collection('checkins')
            .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
            .where('timestamp', isLessThan: endOfDay)
            .get();

        data.add(FlSpot(i.toDouble(), snapshot.docs.length.toDouble()));
        print('📅 Dia ${i + 1}: ${snapshot.docs.length} check-ins');
      }

      checkinsData = data;
      print('✅ Check-ins carregados: ${data.length} dias');
    } catch (e) {
      print('❌ Erro ao carregar check-ins: $e');
    }
  }

  Future<void> _loadUserGrowthData() async {
    try {
      final months = 6;
      final data = <BarChartGroupData>[];

      for (int i = 0; i < months; i++) {
        final now = DateTime.now();
        final monthStart = DateTime(now.year, now.month - (months - 1 - i), 1);
        final monthEnd = DateTime(now.year, now.month - (months - 2 - i), 1);

        final snapshot = await _firestore
            .collection('users')
            .where('createdAt', isGreaterThanOrEqualTo: monthStart)
            .where('createdAt', isLessThan: monthEnd)
            .get();

        data.add(
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: snapshot.docs.length.toDouble(),
                color: Colors.blue[700],
                width: 20,
              )
            ],
          ),
        );
      }

      userGrowthData = data;
    } catch (e) {
      print('Erro ao carregar crescimento: $e');
    }
  }

  Future<void> _loadActivitiesDistribution() async {
    try {
      final snapshot = await _firestore.collection('checkins').get();

      // Contar por categoria
      final Map<String, int> categoryCounts = {};
      for (var doc in snapshot.docs) {
        final category = doc.data()['category'] as String? ?? 'Outros';
        categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
      }

      final total = snapshot.docs.length.toDouble();
      final colors = [
        Colors.blue[700]!,
        Colors.green[600]!,
        Colors.orange[600]!,
        Colors.purple[600]!,
      ];

      final data = <PieChartSectionData>[];
      int colorIndex = 0;

      categoryCounts.forEach((category, count) {
        final percentage = (count / total * 100);
        data.add(
          PieChartSectionData(
            value: percentage,
            title: '${percentage.toStringAsFixed(0)}%',
            color: colors[colorIndex % colors.length],
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
        colorIndex++;
      });

      activitiesData = data;
    } catch (e) {
      print('Erro ao carregar distribuição: $e');
    }
  }

  int _getDaysForPeriod() {
    switch (selectedPeriod) {
      case 'Últimos 7 dias':
        return 7;
      case 'Últimos 30 dias':
        return 30;
      case 'Últimos 3 meses':
        return 90;
      default:
        return 7;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Row(
        children: [
          // Sidebar de Navegação
          _buildSidebar(),

          // Conteúdo Principal
          Expanded(
            child: Column(
              children: [
                // AppBar
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue[700],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Relatórios',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            PopupMenuButton<String>(
                              initialValue: selectedPeriod,
                              onSelected: (value) {
                                setState(() {
                                  selectedPeriod = value;
                                });
                                _loadData();
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                    value: 'Últimos 7 dias',
                                    child: Text('Últimos 7 dias')),
                                const PopupMenuItem(
                                    value: 'Últimos 30 dias',
                                    child: Text('Últimos 30 dias')),
                                const PopupMenuItem(
                                    value: 'Últimos 3 meses',
                                    child: Text('Últimos 3 meses')),
                              ],
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      selectedPeriod,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.arrow_drop_down,
                                        color: Colors.white),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.refresh,
                                  color: Colors.white),
                              onPressed: _loadData,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Conteúdo Scrollável
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Cards de Resumo
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                childAspectRatio: 1.5,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                children: [
                                  _buildSummaryCard(
                                    'Usuários Cadastrados',
                                    summaryData['totalUsers'] ?? '0',
                                    Icons.people,
                                    Colors.blue,
                                  ),
                                  _buildSummaryCard(
                                    'Check-ins Feitos',
                                    summaryData['totalCheckins'] ?? '0',
                                    Icons.check_circle,
                                    Colors.green,
                                  ),
                                  _buildSummaryCard(
                                    'Check-ins Hoje',
                                    summaryData['checkinsToday'] ?? '0',
                                    Icons.today,
                                    Colors.orange,
                                  ),
                                  _buildSummaryCard(
                                    'Crescimento (30d)',
                                    '+${summaryData['newUsers'] ?? '0'}',
                                    Icons.trending_up,
                                    Colors.purple,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Gráfico de Check-ins Diários
                              if (checkinsData.isNotEmpty)
                                _buildChartCard(
                                  'Check-ins Diários',
                                  _buildLineChart(),
                                  300,
                                ),
                              const SizedBox(height: 16),

                              // Gráfico de Crescimento de Usuários
                              if (userGrowthData.isNotEmpty)
                                _buildChartCard(
                                  'Crescimento de Usuários',
                                  _buildBarChart(),
                                  300,
                                ),
                              const SizedBox(height: 16),

                              // Gráfico de Distribuição por Categoria
                              if (activitiesData.isNotEmpty)
                                _buildChartCard(
                                  'Distribuição de Atividades',
                                  _buildPieChart(),
                                  350,
                                ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header do Sidebar
          Container(
            height: 60,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[700],
            ),
            child: const Row(
              children: [
                Icon(Icons.admin_panel_settings, color: Colors.white, size: 28),
                SizedBox(width: 12),
                Text(
                  'Admin Panel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildMenuItem(
                  icon: Icons.dashboard,
                  label: 'Relatórios',
                  isSelected: true,
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.fitness_center,
                  label: 'Cadastrar Exercício',
                  isSelected: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterExerciseScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'v1.0.0',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: Colors.blue[700]!, width: 2)
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blue[700] : Colors.grey[600],
              size: 22,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.blue[700] : Colors.grey[700],
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(String title, Widget chart, double height) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: height,
            child: chart,
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart() {
    if (checkinsData.isEmpty) return const SizedBox();

    final maxY = checkinsData.map((e) => e.y).reduce((a, b) => a > b ? a : b);

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[200],
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= checkinsData.length) return const Text('');
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'D${value.toInt() + 1}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (checkinsData.length - 1).toDouble(),
        minY: 0,
        maxY: maxY > 0 ? maxY * 1.2 : 10,
        lineBarsData: [
          LineChartBarData(
            spots: checkinsData,
            isCurved: true,
            color: Colors.blue[700],
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue[100]?.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    if (userGrowthData.isEmpty) return const SizedBox();

    final maxY = userGrowthData
        .map((e) => e.barRods.first.toY)
        .reduce((a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY > 0 ? maxY * 1.2 : 10,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const months = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun'];
                if (value.toInt() >= 0 && value.toInt() < months.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      months[value.toInt()],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[200],
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(show: false),
        barGroups: userGrowthData,
      ),
    );
  }

  Widget _buildPieChart() {
    if (activitiesData.isEmpty) return const SizedBox();

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 60,
              sections: activitiesData,
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildLegend(),
      ],
    );
  }

  Widget _buildLegend() {
    final categories = ['Fitness', 'Yoga', 'Corrida', 'Natação'];
    final colors = [
      Colors.blue[700]!,
      Colors.green[600]!,
      Colors.orange[600]!,
      Colors.purple[600]!,
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: List.generate(
        categories.length,
        (index) => _buildLegendItem(categories[index], colors[index]),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}

// Tela de Cadastro de Exercício
class RegisterExerciseScreen extends StatefulWidget {
  const RegisterExerciseScreen({Key? key}) : super(key: key);

  @override
  State<RegisterExerciseScreen> createState() => _RegisterExerciseScreenState();
}

class _RegisterExerciseScreenState extends State<RegisterExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveExercise() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        await _firestore.collection('exercises').add({
          'name': _nameController.text,
          'category': _categoryController.text,
          'description': _descriptionController.text,
          'createdAt': Timestamp.now(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Exercício cadastrado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao cadastrar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Cadastrar Exercício'),
        backgroundColor: Colors.blue[700],
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.fitness_center,
                          color: Colors.blue[700], size: 32),
                      const SizedBox(width: 12),
                      const Text(
                        'Novo Exercício',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Preencha os dados para cadastrar um novo exercício',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Nome do Exercício
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nome do Exercício *',
                      hintText: 'Ex: Flexão de braço',
                      prefixIcon: const Icon(Icons.label),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o nome do exercício';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Categoria
                  TextFormField(
                    controller: _categoryController,
                    decoration: InputDecoration(
                      labelText: 'Categoria *',
                      hintText: 'Ex: Fitness, Yoga, Corrida, Natação',
                      prefixIcon: const Icon(Icons.category),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a categoria';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Descrição
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Descrição',
                      hintText: 'Descreva o exercício e como executá-lo',
                      prefixIcon: const Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      alignLabelWithHint: true,
                    ),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 32),

                  // Botões
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed:
                              _isLoading ? null : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveExercise,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Cadastrar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    final categories = ['Fitness', 'Yoga', 'Corrida', 'Natação'];
    final colors = [
      Colors.blue[700]!,
      Colors.green[600]!,
      Colors.orange[600]!,
      Colors.purple[600]!,
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: List.generate(
        categories.length,
        (index) => _buildLegendItem(categories[index], colors[index]),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
