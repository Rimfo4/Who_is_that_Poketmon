import 'package:flutter/material.dart';
import '../poketmon.dart';

class SilhouetteCard extends StatelessWidget {
  final Pokemon pokemon;
  final bool hintUsed;

  const SilhouetteCard({
    super.key,
    required this.pokemon,
    required this.hintUsed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF16213E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 포켓몬 번호
            Text(
              'No.${pokemon.id.toString().padLeft(3, '0')}',
              style: const TextStyle(color: Colors.white38, fontSize: 13),
            ),
            const SizedBox(height: 16),
            // 실루엣 이미지 (ColorFilter로 검정 처리)
            ColorFiltered(
              colorFilter: const ColorFilter.matrix([
                0, 0, 0, 0, 0,
                0, 0, 0, 0, 0,
                0, 0, 0, 0, 0,
                0, 0, 0, 1, 0,
              ]),
              child: Image.network(
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${pokemon.id}.png',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.catching_pokemon,
                  size: 120,
                  color: Colors.white24,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '???',
              style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}