import 'package:flutter/material.dart';
import 'package:sugarcane_detection/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LeafGuru',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF34a203)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
