import 'package:flutter/material.dart';

import '../widgets/rabbit_avatar.dart';
import '../app/rabbit_state.dart';
import '../services/task_storage.dart';
import '../models/task.dart';
import 'create_task_screen.dart';
import 'statistics_screen.dart';
import 'settings_screen.dart';

class ParentScreen extends StatefulWidget {
  const ParentScreen({super.key});

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  List<Task> tasks = [];
  final TaskStorage storage = TaskStorage();

  Future<void> loadTasks() async {
    final loadedTasks = await storage.loadAllTasks();

    if (!mounted) return;

    setState(() {
      tasks = loadedTasks;
    });
  }

  @override
  void initState() {
    super.initState();

    loadTasks();
  }

  Future<void> deleteCurrentTask(BuildContext dialogContext) async {
    final currentNumber = await storage.getCurrentTask();

    if (!dialogContext.mounted) return;

    Navigator.pop(dialogContext);

    if (currentNumber == 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Текущее задание не выбрано')),
      );
      return;
    }

    await storage.deleteTask(currentNumber);
    await storage.clearCurrentTask();

    if (!context.mounted) return;

    await loadTasks();

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Задание №$currentNumber удалено')));
  }

  Future<void> deleteAllTasks(BuildContext dialogContext) async {
    Navigator.pop(dialogContext);

    if (!mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Удалить все задания?'),
          content: const Text(
            'Все созданные задания и их статистика будут удалены.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('ОТМЕНА'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('УДАЛИТЬ ВСЁ'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) return;

    await storage.deleteAllTasks();
    await storage.clearCurrentTask();

    if (!mounted) return;

    await loadTasks();

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Все задания удалены')));
  }

  void showDeleteDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          title: const Text('Удаление задания'),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: ElevatedButton(
                onPressed: () async {
                  await deleteCurrentTask(dialogContext);
                },
                child: const Text('УДАЛИТЬ ТЕКУЩЕЕ'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: ElevatedButton(
                onPressed: () async {
                  await deleteAllTasks(dialogContext);
                },
                child: const Text('УДАЛИТЬ ВСЕ'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text('ОТМЕНА'),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Учитель'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const RabbitAvatar(state: RabbitState.think),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateTaskScreen(),
                  ),
                );

                if (!mounted) return;

                await loadTasks();
              },
              child: const Text('СОЗДАТЬ ЗАДАНИЕ'),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return SimpleDialog(
                      title: const Text('Выберите задание'),
                      children: [
                        for (final task in tasks)
                          SimpleDialogOption(
                            onPressed: () async {
                              await storage.setCurrentTask(task.number);

                              if (!dialogContext.mounted) return;

                              Navigator.pop(dialogContext);
                            },
                            child: Text('№${task.number} — ${task.name}'),
                          ),
                      ],
                    );
                  },
                );
              },
              child: const Text('ВЫБРАТЬ ЗАДАНИЕ'),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () async {
                final number = await storage.getCurrentTask();

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      number == 0
                          ? 'Текущее задание не выбрано'
                          : 'Текущее задание: №$number',
                    ),
                  ),
                );
              },
              child: const Text('ТЕКУЩЕЕ ЗАДАНИЕ'),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: showDeleteDialog,
              child: const Text('УДАЛИТЬ ЗАДАНИЕ'),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StatisticsScreen(),
                  ),
                );
              },
              child: const Text('СТАТИСТИКА'),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
              child: const Text('НАСТРОЙКИ'),
            ),
          ],
        ),
      ),
    );
  }
}
