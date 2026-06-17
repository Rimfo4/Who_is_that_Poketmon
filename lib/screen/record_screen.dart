import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../result_provider.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final results = context.watch<ResultProvider>().results;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E), // 배경색 통일
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('나의 퀴즈 기록', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          // 전체 초기화 버튼
          TextButton(
            onPressed: () => _confirmClear(context),
            child: const Text('전체 초기화', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: results.isEmpty
          ? const Center(
        child: Text(
          '아직 도전한 기록이 없어요!',
          style: TextStyle(color: Colors.white54, fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final result = results[index];
          return Dismissible(
            key: ValueKey(result.timestamp),
            direction: DismissDirection.endToStart, // 왼쪽으로 스와이프해서 삭제
            background: Container(
              color: Colors.red.withOpacity(0.3),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 24),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) {
              context.read<ResultProvider>().deleteOne(index);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('기록이 삭제되었습니다.'), duration: Duration(seconds: 1)),
              );
            },
            child: ResultListItem(result: result),
          );
        },
      ),
    );
  }

  // 1. ⭐ 미구현되었던 초기화 알림창 (Dialog) 함수 추가!
  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        title: const Text('기록 초기화', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text('지금까지의 모든 퀴즈 기록을 삭제하시겠습니까?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('취소', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              // ResultProvider의 clearAll 호출하여 리스트 비우기
              context.read<ResultProvider>().clearAll();
              Navigator.pop(dialogContext);
            },
            child: const Text('삭제하기', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// 2. ⭐ 미구현되었던 리스트 아이템 UI 위젯 (ResultListItem) 추가!
class ResultListItem extends StatelessWidget {
  final QuizResult result;

  const ResultListItem({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        // 맞추면 초록색 포켓볼, 틀리면 빨간색 포켓볼 아이콘
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: result.isCorrect ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            result.isCorrect ? Icons.catching_pokemon : Icons.blur_on,
            color: result.isCorrect ? Colors.greenAccent : Colors.redAccent,
          ),
        ),
        title: Text(
          result.pokemon.name,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            result.isCorrect
                ? '정답을 맞춤! ${result.usedHint ? "(💡힌트 사용)" : ""}'
                : '내가 쓴 답: ${result.userAnswer.trim().isEmpty ? "모름(건너뛰기)" : result.userAnswer}',
            style: TextStyle(
              color: result.isCorrect ? Colors.greenAccent.withOpacity(0.7) : Colors.white54,
              fontSize: 13,
            ),
          ),
        ),
        trailing: Text(
          '${result.timestamp.hour}:${result.timestamp.minute.toString().padLeft(2, '0')}',
          style: const TextStyle(color: Colors.white30, fontSize: 12),
        ),
      ),
    );
  }
}