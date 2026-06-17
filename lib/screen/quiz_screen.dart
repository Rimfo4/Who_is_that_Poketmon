import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../quiz_provider.dart';
import '../result_provider.dart';
import 'silhouette_card.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();

    // 퀴즈 종료 시
    if (quiz.isFinished) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ResultScreen()),
        );
      });
    }

    // 정답/오답 공개 후 → 결과 화면 이동
    if (quiz.isRevealed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 기록 저장
        context.read<ResultProvider>().addResult(
          QuizResult(
            pokemon: quiz.currentPokemon,
            isCorrect: quiz.isCorrect,
            userAnswer: _controller.text,
            usedHint: quiz.hintUsed,
            timestamp: DateTime.now(),
          ),
        );
        _controller.clear();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ResultScreen()),
        );
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(
          '${quiz.currentIndex + 1} / ${quiz.totalCount}',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '연속 ${quiz.streak}',
                style: const TextStyle(
                    color: Color(0xFFFFD700), fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 진행 바
            LinearProgressIndicator(
              value: (quiz.currentIndex + 1) / quiz.totalCount,
              backgroundColor: Colors.white12,
              color: const Color(0xFFCC0000),
            ),
            const SizedBox(height: 16),
            // 안내 텍스트
            const Text(
              '이 포켓몬은 누구일까요?',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 8),
            // 스와이프 카드
            Expanded(
              child: GestureDetector(
                onLongPress: () => quiz.useHint(), // 힌트
                child: Dismissible(
                  key: ValueKey(quiz.currentPokemon.id),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      // 오른쪽 → 입력값으로 정답 체크
                      if (_controller.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('이름을 먼저 입력해주세요!')),
                        );
                        return false; // 카드 파괴하지 않고 제자리로 튕겨냄
                      } else {
                        quiz.submitAnswer(_controller.text);
                        return false; // 정답 제출 (화면이 전환되므로 카드 파괴 안 함)
                      }
                    } else {
                      // 왼쪽 → 모름
                      quiz.skipPokemon();
                      return false; // 스킵 처리 (화면이 전환되므로 카드 파괴 안 함)
                    }
                  },
                  background: _swipeBg(
                      Colors.green, '✓ 알겠어요!', Alignment.centerLeft),
                  secondaryBackground: _swipeBg(
                      Colors.red, '✗ 모르겠어요', Alignment.centerRight),
                  child: SilhouetteCard(
                    pokemon: quiz.currentPokemon,
                    hintUsed: quiz.hintUsed,
                  ),
                ),
              ),
            ),
            // 힌트 표시
            if (quiz.hintUsed)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Wrap(
                  spacing: 8,
                  children: quiz.currentPokemon.types
                      .map((t) => Chip(
                    label: Text(t),
                    backgroundColor: _typeColor(t),
                    labelStyle: const TextStyle(color: Colors.white),
                  ))
                      .toList(),
                ),
              ),
            // 스와이프 힌트 텍스트
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Text(
                '← 모르겠어요   |   알겠어요! →',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ),
            // 이름 입력
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '포켓몬 이름 입력...',
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white54),
                    onPressed: () {
                      if (_controller.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('이름을 입력해주세요!')),
                        );
                        return;
                      }
                      quiz.submitAnswer(_controller.text);
                    },
                  ),
                ),
                onSubmitted: (val) {
                  if (val.trim().isEmpty) return;
                  quiz.submitAnswer(val);
                },
              ),
            ),
            // 버튼 행
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white54,
                        side: const BorderSide(color: Colors.white24),
                      ),
                      onPressed: () => quiz.useHint(),
                      child: const Text('힌트 (타입)'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white54,
                        side: const BorderSide(color: Colors.white24),
                      ),
                      onPressed: () => quiz.skipPokemon(),
                      child: const Text('건너뛰기'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _swipeBg(Color color, String label, Alignment align) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: align,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Color _typeColor(String type) {
    const colors = {
      '불': Color(0xFFE8593C),
      '물': Color(0xFF3B8BD4),
      '풀': Color(0xFF639922),
      '전기': Color(0xFFEF9F27),
      '에스퍼': Color(0xFF993556),
      '고스트': Color(0xFF534AB7),
      '독': Color(0xFF7F77DD),
      '노말': Color(0xFF888780),
      '페어리': Color(0xFFD4537E),
      '땅' : Color(0xFF733810),
      '드래곤' : Color(0x282980FF),
    };
    return colors[type] ?? Colors.grey;
  }
}