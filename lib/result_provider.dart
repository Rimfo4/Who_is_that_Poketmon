import 'package:flutter/material.dart';
import 'poketmon.dart';

class QuizResult {
  final Pokemon pokemon;
  final bool isCorrect;
  final String userAnswer;
  final bool usedHint;
  final DateTime timestamp;

  QuizResult({
    required this.pokemon,
    required this.isCorrect,
    required this.userAnswer,
    required this.usedHint,
    required this.timestamp,
  });
}

class ResultProvider extends ChangeNotifier {
  final List<QuizResult> _results = [];

  List<QuizResult> get results => List.unmodifiable(_results);
  int get totalCorrect => _results.where((r) => r.isCorrect).length;
  int get totalCount => _results.length;
  double get accuracy =>
      _results.isEmpty ? 0 : totalCorrect / totalCount * 100;

  void addResult(QuizResult result) {
    _results.add(result);
    notifyListeners();
  }

  void deleteOne(int index) {
    _results.removeAt(index);
    notifyListeners();
  }

  void clearAll() {
    _results.clear();
    notifyListeners();
  }
}