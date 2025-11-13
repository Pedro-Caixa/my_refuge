import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';

import 'views/pages/welcome_page.dart';
import 'views/pages/register_page.dart';
import 'views/pages/admin_page.dart';
import 'views/pages/home_page.dart';
import 'views/pages/humor_page.dart';
import 'views/pages/exercicios_page.dart';
import 'views/pages/frases_page.dart';
import 'views/pages/consulta_page.dart';
import 'views/pages/profile_page.dart';
import './views/pages/game_page.dart'; // ← Nova página de gamificação
import 'models/registration_data.dart';
import 'controllers/user_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("Iniciando aplicativo My Refuge");
  print("Plataforma: ${defaultTargetPlatform.toString()}");

  // Carregar variáveis do .env
  try {
    await dotenv.load(fileName: ".env");
    print(".env carregado com sucesso");
  } catch (e) {
    print("Erro ao carregar .env: $e");
  }

  // Configuração do Firebase usando variáveis do .env
  final firebaseConfig = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_API_KEY']!,
    appId: dotenv.env['FIREBASE_APP_ID']!,
    messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
    projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
    authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN']!,
    storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET']!,
  );

  // Inicializar Firebase com tratamento de erros
  try {
    await Firebase.initializeApp(options: firebaseConfig);
    print("Firebase inicializado com sucesso!");
  } catch (e) {
    print("Erro ao inicializar Firebase: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RegistrationData()),
        ChangeNotifierProvider(create: (context) => UserController()),
      ],
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
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomePage(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomePage(),
        '/humor': (context) => const CheckInPage(),
        '/exercicios': (context) => const ExerciciosPage(),
        '/frases': (context) => const MotivationalPage(),
        '/consulta': (context) => const ConsultaPage(),
        '/complete-profile': (context) => const CompleteProfilePage(),
        '/gamification': (context) => const GamificationPage(), // ← Nova rota
        '/admin': (context) => const AdminReportsScreen(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const WelcomePage());
      },
    );
  }
}
