import 'package:flutter/material.dart';

import '../widgets/rabbit_avatar.dart';
import '../app/rabbit_state.dart';
import '../services/task_storage.dart';
import '../models/task.dart';

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

    setState(() {
      tasks = loadedTasks;
    });
  }

  @override
  void initState() {
    super.initState();

    loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Взрослый')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const RabbitAvatar(state: RabbitState.think),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {},
              child: const Text('СОЗДАТЬ ЗАДАНИЕ'),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: const Text('Выберите задание'),
                      children: [
                        for (final task in tasks)
                          SimpleDialogOption(
                            onPressed: () async {
                              await storage.setCurrentTask(task.number);

                              if (!context.mounted) return;

                              Navigator.pop(context);
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
                final storage = TaskStorage();

                await storage.setCurrentTask(1);

                final number = await storage.getCurrentTask();

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Текущее задание: №$number')),
                );
              },
              child: const Text('ТЕКУЩЕЕ ЗАДАНИЕ'),
            ),
          ],
        ),
      ),
    );
  }
}
