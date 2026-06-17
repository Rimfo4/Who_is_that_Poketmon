import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../quiz_provider.dart';
import 'Home_Screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();

    // 1. 퀴즈 전체 종료 화면 (10마리 모두 풀었을 때)
    if (quiz.isFinished) {
      return Scaffold(
        backgroundColor: const Color(0xFF1A1A2E),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_events, size: 80, color: Color(0xFFFFD700)),
                const SizedBox(height: 16),
                const Text('퀴즈 완료!',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('최종 점수: ${quiz.score}점',
                    style: const TextStyle(color: Color(0xFFFFD700), fontSize: 20)),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCC0000),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
                  ),
                  child: const Text('홈으로', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 2. 한 문제 풀 때마다 나오는 결과 화면
    final pokemon = quiz.currentPokemon;
    final isCorrect = quiz.isCorrect;

    return Scaffold(
      // ⭐ 기획 반영: 맞으면 초록색 바탕, 틀리거나 패스하면 빨간색 바탕!
      backgroundColor: isCorrect ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // 정답/오답 텍스트 표시
              Text(
                isCorrect ? '정답!' : '다음에 꼭 맞추쇼',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              // 포켓몬 이미지 (실루엣이 해제된 원래 컬러 일러스트 공개)
              Image.network(
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${pokemon.id}.png',
                width: 180,
                height: 180,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.catching_pokemon, size: 120, color: Colors.white54),
              ),
              const SizedBox(height: 16),
              // 포켓몬 이름 및 정보
              Text(
                pokemon.name,
                style: const TextStyle(
                    fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                'No.${pokemon.id.toString().padLeft(3, '0')} · ${pokemon.types.join('/')} 타입',
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 16),
              // 도감 설명 박스
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  pokemon.description,
                  style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.6),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              // 끊겼던 점수 및 연속 정답수 표시 파트 완벽 보강!
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ScoreBox(label: '점수', value: '${quiz.score}'),
                  const SizedBox(width: 16),
                  _ScoreBox(label: '연속', value: '${quiz.streak}'),
                ],
              ),
              const Spacer(),
              // 다음 문제 진행 버튼 ("다음으로 넘어갑니다" 메시지 반영)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: isCorrect ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    // 다음 포켓몬 인덱스로 넘겨주고 결과창을 닫아 퀴즈 화면으로 컴백!
                    Navigator.pop(context);

                    // 2. 화면이 닫히는 애니메이션(약 100밀리초)을 기다렸다가 다음 문제를 세팅합니다. <= 스포일러 당함.
                    Future.delayed(const Duration(milliseconds: 100), () {
                      context.read<QuizProvider>().nextPokemon();
                    });
                  },
                  child: const Text('다음으로 넘어갑니다 ➔',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// 점수판을 이쁘게 그려줄 하단 컴포넌트 위젯
class _ScoreBox extends StatelessWidget {
  final String label;
  final String value;

  const _ScoreBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(width: 8),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}