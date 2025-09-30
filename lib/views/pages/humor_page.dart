import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Check-in App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const CheckInPage(),
      routes: {'/humor': (context) => const CheckInPage()},
    );
  }
}

class CheckInPage extends StatelessWidget {
  const CheckInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F2F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8F2F9),
        elevation: 0,
        title: const Text(
          "Check-in Diário",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            // Ação de retorno para a tela anterior
            Navigator.of(context).pop();
          },
        ),
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
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _buildEmotion("😊", "Feliz"),
                  _buildEmotion("😐", "Indiferente"),
                  _buildEmotion("😢", "Triste"),
                  _buildEmotion("😠", "Irritado"),
                  _buildEmotion("😰", "Ansioso"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "O que aconteceu hoje? (Opcional)",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Compartilhe algo sobre o seu dia...",
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
            ),
            const SizedBox(height: 20),
            const Text(
              "Histórico Recente",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildHistoryCard(
              "Ontem",
              "Bem",
              Icons.favorite_border,
              Colors.green.shade400,
            ),
            _buildHistoryCard(
              "Anteontem",
              "Excelente",
              Icons.sentiment_satisfied,
              Colors.green.shade600,
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C6BFF),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  "Salvar",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: 0,
        onTap: (int index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/humor');
          } else if (index == 1) {
            // Navigator.pushNamed(context, '/resumos');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: "Check-in",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart_outlined),
            label: "Resumos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            label: "Motivações",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Relatórios",
          ),
        ],
      ),
    );
  }

  Widget _buildEmotion(String emoji, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildHistoryCard(
    String day,
    String status,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(day, style: const TextStyle(color: Colors.black54)),
              Text(
                status,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
