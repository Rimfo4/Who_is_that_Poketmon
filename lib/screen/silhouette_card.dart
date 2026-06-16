import 'package:flutter/cupertino.dart';

class SilhouetteCard extends StatelessWidget {
  final Pokemon pokemon;
  final bool isRevealed;
  final bool hintUsed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          // 실루엣 이미지: ColorFilter로 검은색 처리
          ColorFiltered(
            colorFilter: isRevealed
                ? const ColorFilter.mode(Colors.transparent, BlendMode.multiply)
                : const ColorFilter.matrix([
              0, 0, 0, 0, 0,
              0, 0, 0, 0, 0,
              0, 0, 0, 0, 0,
              0, 0, 0, 1, 0,
            ]),
            child: Image.asset('assets/images/${pokemon.id}.png'),
          ),
          // 힌트: 타입 표시
          if (hintUsed)
            Row(
              children: pokemon.types
                  .map((t) => Chip(label: Text(t)))
                  .toList(),
            ),
        ],
      ),
    );
  }
}