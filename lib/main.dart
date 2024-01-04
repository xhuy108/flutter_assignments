import 'package:bai3/screens/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF192038),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF192038),
        ),
        fontFamily: 'SF Pro Display',
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
