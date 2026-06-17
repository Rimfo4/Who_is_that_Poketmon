import 'package:flutter/material.dart';
import 'poketmon.dart';
import 'poketmon_data.dart';

class QuizProvider extends ChangeNotifier {
  List<Pokemon> _pokemonList = [];
  int _currentIndex = 0;
  int _score = 0;
  int _streak = 0;
  bool _isRevealed = false;
  bool _hintUsed = false;
  bool _isCorrect = false;
  bool _isFinished = false;

  List<Pokemon> get pokemonList => _pokemonList;
  Pokemon get currentPokemon => _pokemonList[_currentIndex];
  int get currentIndex => _currentIndex;
  int get score => _score;
  int get streak => _streak;
  bool get isRevealed => _isRevealed;
  bool get hintUsed => _hintUsed;
  bool get isCorrect => _isCorrect;
  bool get isFinished => _isFinished;

  // 전체 문제 수를 리스트의 길이에 맞춰 자동으로 계산 (이제 30이 될 거야!)
  int get totalCount => _pokemonList.length;

  QuizProvider() {
    _init();
  }

  void _init() {
    // 💡 핵심 수정 부분: 전체 포켓몬을 섞은 뒤, 앞에서부터 딱 30마리만 잘라옵니다!
    final shuffledList = List<Pokemon>.from(gen1Pokemon)..shuffle();
    _pokemonList = shuffledList.take(30).toList();

    _currentIndex = 0;
    _score = 0;
    _streak = 0;
    _isRevealed = false;
    _hintUsed = false;
    _isCorrect = false;
    _isFinished = false;
  }

  // 정답 제출
  void submitAnswer(String answer) {
    if (answer.trim().isEmpty) return; // 빈값 방지
    final input = answer.trim().toLowerCase();
    final targets = [
      currentPokemon.name.toLowerCase(),
      currentPokemon.nameEn.toLowerCase(),
      ...currentPokemon.aliases.map((a) => a.toLowerCase()),
    ];
    _isCorrect = targets.contains(input);
    if (_isCorrect) {
      _score += 10;
      _streak++;
    } else {
      _streak = 0;
    }
    _isRevealed = true;
    notifyListeners();
  }

  // 스와이프 왼쪽 — 모름
  void skipPokemon() {
    _isCorrect = false;
    _streak = 0;
    _isRevealed = true;
    notifyListeners();
  }

  // 다음 포켓몬
  void nextPokemon() {
    if (_currentIndex >= _pokemonList.length - 1) {
      _isFinished = true;
    } else {
      _currentIndex++;
      _isRevealed = false;
      _hintUsed = false;
      _isCorrect = false;
    }
    notifyListeners();
  }

  // 힌트 (타입 공개)
  void useHint() {
    _hintUsed = true;
    notifyListeners();
  }

  // 퀴즈 초기화
  void resetQuiz() {
    _init();
    notifyListeners();
  }
}