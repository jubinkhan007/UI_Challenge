import 'package:flutter/material.dart';
import 'package:ui_challenger/screens/daily_goal_screen.dart';
import 'package:ui_challenger/screens/journal_screen.dart';

import 'screens/dailyGoal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health UI Challenge',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6A4C93)),
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Dailygoal(),
        '/journal': (context) => const JournalScreen(),
      },
    );
  }
}
