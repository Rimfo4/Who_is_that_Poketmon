import 'package:flutter/cupertino.dart';

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