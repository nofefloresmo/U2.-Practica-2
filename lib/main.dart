import 'package:flutter/material.dart';
import 'package:dam_u2_p2_lettertecbox/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LetterTecBox',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Roboto",
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 232, 57, 115),
          secondary: Color.fromARGB(255, 3, 169, 244),
          background: Color.fromARGB(255, 11, 7, 21),
          surface: Color(0xFF252525),
          onPrimary: Color(0xFF000000),
          onSecondary: Color(0xFF000000),
          error: Color(0xFFB00020),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
