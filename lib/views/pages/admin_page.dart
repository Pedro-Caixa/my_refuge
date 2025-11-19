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
  Map<String, Color> categoryColors = {};
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

      // Crescimento de usuários (últimos 30 dias)
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
      final recentUsersSnapshot = await _firestore
          .collection('users')
          .where('createdAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(thirtyDaysAgo))
          .get();
      print('✅ Novos usuários (30 dias): ${recentUsersSnapshot.docs.length}');

      summaryData = {
        'totalUsers': totalUsers.toString(),
        'totalCheckins': totalCheckins.toString(),
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
        final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

        print(
            '📅 Buscando check-ins do dia ${date.day}/${date.month}/${date.year}');

        final snapshot = await _firestore
            .collection('checkins')
            .where('date',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
            .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
            .get();

        data.add(FlSpot(i.toDouble(), snapshot.docs.length.toDouble()));
        print('   📊 ${snapshot.docs.length} check-ins encontrados');
      }

      checkinsData = data;
      print('✅ Check-ins carregados: ${data.length} dias');
      print(
          '   Total de check-ins no período: ${data.fold(0.0, (sum, spot) => sum + spot.y)}');
    } catch (e) {
      print('❌ Erro ao carregar check-ins: $e');
    }
  }

  Future<void> _loadUserGrowthData() async {
    try {
      print('🔄 Carregando crescimento de usuários...');
      final months = 12;
      final data = <BarChartGroupData>[];
      final now = DateTime.now();

      for (int i = 0; i < months; i++) {
        // Calcular o mês correto (de 11 meses atrás até o mês atual)
        final monthsAgo = months - 1 - i;
        final targetDate = DateTime(now.year, now.month - monthsAgo, 1);

        final monthStart = DateTime(targetDate.year, targetDate.month, 1);
        final monthEnd = DateTime(targetDate.year, targetDate.month + 1, 1);

        print('📅 Buscando usuários de ${monthStart.month}/${monthStart.year}');

        final snapshot = await _firestore
            .collection('users')
            .where('createdAt',
                isGreaterThanOrEqualTo: Timestamp.fromDate(monthStart))
            .where('createdAt', isLessThan: Timestamp.fromDate(monthEnd))
            .get();

        data.add(
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: snapshot.docs.length.toDouble(),
                color: Colors.blue[700],
                width: 20,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              )
            ],
          ),
        );
        print('   📊 ${snapshot.docs.length} novos usuários');
      }

      userGrowthData = data;
      print('✅ Crescimento carregado: 12 meses');
    } catch (e) {
      print('❌ Erro ao carregar crescimento: $e');
    }
  }

  Future<void> _loadActivitiesDistribution() async {
    try {
      print('🔄 Carregando distribuição de atividades...');
      final snapshot = await _firestore.collection('checkins').get();

      if (snapshot.docs.isEmpty) {
        print('⚠️ Nenhum check-in encontrado');
        return;
      }

      // Contar por categoria
      final Map<String, int> categoryCounts = {};
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final category = data['category'] as String? ?? 'Outros';
        categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
      }

      print('✅ Total de categorias: ${categoryCounts.length}');
      categoryCounts.forEach((category, count) {
        print('   - $category: $count check-ins');
      });

      final total = snapshot.docs.length.toDouble();
      final availableColors = [
        Colors.blue[700]!,
        Colors.green[600]!,
        Colors.orange[600]!,
        Colors.purple[600]!,
        Colors.red[600]!,
        Colors.teal[600]!,
        Colors.pink[600]!,
        Colors.indigo[600]!,
      ];

      final data = <PieChartSectionData>[];
      categoryColors.clear();
      int colorIndex = 0;

      categoryCounts.forEach((category, count) {
        final percentage = (count / total * 100);
        final color = availableColors[colorIndex % availableColors.length];

        categoryColors[category] = color;

        data.add(
          PieChartSectionData(
            value: percentage,
            title: '${percentage.toStringAsFixed(0)}%',
            color: color,
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
      print('✅ Distribuição carregada com ${data.length} categorias');
    } catch (e) {
      print('❌ Erro ao carregar distribuição: $e');
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
                              // Cards de Resumo (3 cards agora)
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 3,
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
                                    'Total de Check-ins',
                                    summaryData['totalCheckins'] ?? '0',
                                    Icons.check_circle,
                                    Colors.green,
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
                                  'Crescimento de Usuários (12 meses)',
                                  _buildBarChart(),
                                  300,
                                ),
                              const SizedBox(height: 16),

                              // Gráfico de Distribuição por Categoria
                              if (activitiesData.isNotEmpty)
                                _buildChartCard(
                                  'Distribuição de Humor',
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
                  icon: Icons.home,
                  label: 'Voltar ao Início',
                  isSelected: false,
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                ),
                const Divider(height: 16),
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
                    Navigator.pushNamed(context, '/register-exercise');
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
                final now = DateTime.now();
                final monthsAgo = 11 - value.toInt();
                final targetDate = DateTime(now.year, now.month - monthsAgo, 1);

                const months = [
                  'Jan',
                  'Fev',
                  'Mar',
                  'Abr',
                  'Mai',
                  'Jun',
                  'Jul',
                  'Ago',
                  'Set',
                  'Out',
                  'Nov',
                  'Dez'
                ];

                final monthIndex = targetDate.month - 1;
                if (monthIndex >= 0 && monthIndex < months.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      months[monthIndex],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 10,
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
    if (categoryColors.isEmpty) return const SizedBox();

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: categoryColors.entries
          .map((entry) => _buildLegendItem(entry.key, entry.value))
          .toList(),
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
