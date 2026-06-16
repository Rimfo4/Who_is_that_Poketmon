import 'package:flutter/cupertino.dart';

class QuizScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    final pokemon = quiz.currentPokemon;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(quiz),
            Expanded(
              child: GestureDetector(
                onLongPress: () => quiz.useHint(),      // 힌트
                onDoubleTap: () => quiz.skipPokemon(),  // 건너뛰기
                child: Dismissible(
                  key: ValueKey(pokemon.id),
                  // ✅ 오른쪽 → 정답 시도
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd) {
                      quiz.submitAnswer(_controller.text);
                    } else {
                      quiz.skipPokemon(); // 왼쪽 → 모름
                    }
                  },
                  // 스와이프 배경 (좌/우 색상)
                  background: _buildSwipeBg(Colors.green, '알겠어요!', true),
                  secondaryBackground: _buildSwipeBg(Colors.red, '모르겠어요', false),
                  child: SilhouetteCard(
                    pokemon: pokemon,
                    isRevealed: quiz.isRevealed,
                    hintUsed: quiz.hintUsed,
                  ),
                ),
              ),
            ),
            // 이름 직접 입력 TextField
            AnswerInput(
              controller: _controller,
              onSubmit: (val) {
                if (val.trim().isEmpty) return; // 빈값 방지 예외처리
                quiz.submitAnswer(val.trim());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeBg(Color color, String label, bool isLeft) {
    return Container(
      color: color.withOpacity(0.2),
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(label, style: TextStyle(color: color, fontSize: 18)),
    );
  }
}