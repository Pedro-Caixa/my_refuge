import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'views/pages/frases_page.dart';
import 'views/pages/home_page.dart';
import 'views/pages/humor_page.dart';
import 'views/pages/exercicios_page.dart';
import 'views/pages/login_page.dart';
import 'views/pages/register_page.dart';

import 'views/pages/register_page.dart';

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
