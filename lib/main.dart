import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(MyRefugeApp());
}

class MyRefugeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Refuge',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Roboto'),
      home: WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
