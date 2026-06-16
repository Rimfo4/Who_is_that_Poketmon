import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final results = context.watch<ResultProvider>().results;

    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 기록'),
        actions: [
          // 전체 초기화 버튼 (선택 조건 충족)
          TextButton(
            onPressed: () => _confirmClear(context),
            child: const Text('초기화', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: results.isEmpty
          ? const Center(child: Text('아직 기록이 없어요!')) // 예외처리: 빈 리스트
          : ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final result = results[index];
          return Dismissible(
            key: ValueKey(result.timestamp),
            direction: DismissDirection.endToStart, // 왼쪽으로만 삭제
            background: Container(
              color: Colors.red.withOpacity(0.2),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              child: const Icon(Icons.delete, color: Colors.red),
            ),
            onDismissed: (_) =>
                context.read<ResultProvider>().deleteOne(index),
            child: ResultListItem(result: result),
          );
        },
      ),
    );
  }
}