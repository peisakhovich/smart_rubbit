import 'package:flutter/material.dart';

import '../localization/localization.dart';
import '../models/task.dart';

class TaskStatisticsScreen extends StatelessWidget {
  final Task task;

  const TaskStatisticsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: lng,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${lng.taskStatsTitle}${task.number}'),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                task.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                '${lng.taskStatsCorrect} '
                '${task.statistics.correct} '
                '${_ofWord()} ${task.items.length}',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 5),
              Text(
                '${lng.taskStatsScore} ${task.statistics.score}',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 25),
              Text(
                lng.taskStatsExercises,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              for (int i = 0; i < task.items.length; i++) _buildItem(i),
            ],
          ),
        );
      },
    );
  }

  String _ofWord() {
    return lng.language == 'ru' ? 'из' : 'of';
  }

  Widget _buildItem(int index) {
    final item = task.items[index];

    final isAnswered = item.answer != null;
    final isCorrect = isAnswered && item.answer == item.result;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: !isAnswered
              ? const Color.fromARGB(255, 236, 218, 48)
              : isCorrect
              ? Colors.green
              : Colors.red,
          child: Text(
            '${index + 1}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          '${item.operand1} ${item.operation} '
          '${item.operand2} = ${item.answer ?? "—"}',
          style: const TextStyle(fontSize: 20),
        ),
        subtitle: isCorrect
            ? Text(
                lng.taskStatsCorrectStatus,
                style: const TextStyle(color: Colors.green),
              )
            : Text(
                '${lng.taskStatsCorrectAnswer} ${item.result}',
                style: const TextStyle(color: Colors.red),
              ),
      ),
    );
  }
}
