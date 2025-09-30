import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Importando as telas da pasta 'screens'
import 'screens/frases_page.dart';
import 'screens/home_page.dart';
import 'screens/humor_page.dart';
import 'screens/exercicios_page.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';

// Importa o modelo de dados de registro
import 'screens/register_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => RegistrationData(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Refuge',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/humor': (context) => const CheckInPage(),
        '/exercicios': (context) => const ExerciciosPage(),
        '/frases': (context) => const MotivationalPage(),
      },
    );
  }
}
