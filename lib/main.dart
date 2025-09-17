import 'package:flutter/material.dart';
import 'views/pages/widget_test_page.dart';
import 'views/pages/user_form_page.dart';
import 'views/pages/custom_button_test_page.dart';
import 'views/pages/custom_button_example_usage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Refuge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) =>
            const WidgetsTestPage(), // Página placeholder para testar widgets :D
        '/inicio': (context) => const UserFormPage(),
        '/custom-button-test': (context) => const CustomButtonTestPage(),
        '/custom-button-example': (context) => const CustomButtonExampleUsage(),
      },
    );
  }
}
