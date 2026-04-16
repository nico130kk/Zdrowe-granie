import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Importujemy rdzeń Firebase
import 'firebase_options.dart'; // Importujemy wygenerowany plik z opcjami
import 'screens/main_screen.dart'; // Importujemy Twój główny ekran

void main() async {
  // 1. Zapewniamy, że silnik Fluttera jest zainicjalizowany przed Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Odpalamy połączenie z Firebase używając Twoich opcji
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zdrofit App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MainScreen(),
    );
  }
}