import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screen/Home_Screen.dart';
import 'quiz_provider.dart';
import 'result_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => ResultProvider()),
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
      title: '포켓몬 실루엣 퀴즈',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFCC0000)),
        useMaterial3: true,
        fontFamily: 'pretendard',
      ),
      home: const HomeScreen(),
    );
  }
}