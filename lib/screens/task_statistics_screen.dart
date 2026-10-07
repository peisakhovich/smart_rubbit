import 'package:flutter/material.dart';

import '../models/task.dart';

class TaskStatisticsScreen extends StatelessWidget {
  final Task task;

  const TaskStatisticsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Задание №${task.number}'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            task.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 15),

          Text(
            'Правильных: '
            '${task.statistics.correct} из ${task.items.length}',
            style: const TextStyle(fontSize: 20),
          ),

          const SizedBox(height: 5),

          Text(
            'Оценка: ${task.statistics.score}',
            style: const TextStyle(fontSize: 20),
          ),

          const SizedBox(height: 25),

          const Text(
            'Упражнения',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          for (int i = 0; i < task.items.length; i++) _buildItem(i),
        ],
      ),
    );
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
          '${item.operand1} ${item.operation} ${item.operand2} = ${item.answer ?? "—"}',
          style: const TextStyle(fontSize: 20),
        ),
        subtitle: isCorrect
            ? const Text('Правильно', style: TextStyle(color: Colors.green))
            : Text(
                'Правильный ответ: ${item.result}',
                style: const TextStyle(color: Colors.red),
              ),
      ),
    );
  }
}
