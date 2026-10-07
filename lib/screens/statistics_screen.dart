import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/task_storage.dart';
import 'task_statistics_screen.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final TaskStorage storage = TaskStorage();

  List<Task> tasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadStatistics();
  }

  Future<void> loadStatistics() async {
    final loadedTasks = await storage.loadAllTasks();

    if (!mounted) return;

    setState(() {
      tasks = loadedTasks;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final completedTasks = tasks
        .where((task) => task.statistics.completed)
        .length;

    return Scaffold(
      appBar: AppBar(title: const Text('Статистика'), centerTitle: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tasks.isEmpty
          ? const Center(
              child: Text('Заданий пока нет', style: TextStyle(fontSize: 22)),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Всего заданий: ${tasks.length}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Выполнено: $completedTasks',
                  style: const TextStyle(fontSize: 20),
                ),

                const SizedBox(height: 20),

                for (final task in tasks)
                  Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(
                        '№${task.number} — ${task.name}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: task.statistics.completed
                          ? Text(
                              'Правильных: '
                              '${task.statistics.correct} из '
                              '${task.items.length}\n'
                              'Оценка: ${task.statistics.score}',
                              style: const TextStyle(fontSize: 17),
                            )
                          : const Text(
                              'Не выполнено',
                              style: TextStyle(fontSize: 17),
                            ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TaskStatisticsScreen(task: task),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
    );
  }
}
