import 'package:flutter/material.dart';

import '../widgets/rabbit_avatar.dart';
import '../app/rabbit_state.dart';
import '../services/task_storage.dart';
import '../models/task.dart';
import '../localization/localization.dart';
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

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(lng.parentNoCurrentTask)));
      return;
    }

    await storage.deleteTask(currentNumber);
    await storage.clearCurrentTask();

    if (!context.mounted) return;

    await loadTasks();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${lng.parentTaskDeleted} №$currentNumber')),
    );
  }

  Future<void> deleteAllTasks(BuildContext dialogContext) async {
    Navigator.pop(dialogContext);

    if (!mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(lng.parentDeleteAllQuestion),
          content: Text(lng.parentDeleteAllMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(lng.parentCancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(lng.parentDeleteAllConfirm),
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
        .showSnackBar(SnackBar(content: Text(lng.parentAllTasksDeleted)));
  }

  void showDeleteDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          title: Text(lng.parentDeleteDialogTitle),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: ElevatedButton(
                onPressed: () async {
                  await deleteCurrentTask(dialogContext);
                },
                child: Text(lng.parentDeleteCurrent),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: ElevatedButton(
                onPressed: () async {
                  await deleteAllTasks(dialogContext);
                },
                child: Text(lng.parentDeleteAll),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: Text(lng.parentCancel),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: lng,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(title: Text(lng.parentTitle), centerTitle: true),
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
                  child: Text(lng.parentCreateTask),
                ),

                const SizedBox(height: 15),

                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return SimpleDialog(
                          title: Text(lng.parentChooseTask),
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
                  child: Text(lng.parentSelectTask),
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
                              ? lng.parentNoCurrentTask
                              : '${lng.parentCurrentTaskPrefix} №$number',
                        ),
                      ),
                    );
                  },
                  child: Text(lng.parentCurrentTask),
                ),

                const SizedBox(height: 15),

                ElevatedButton(
                  onPressed: showDeleteDialog,
                  child: Text(lng.parentDeleteTask),
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
                  child: Text(lng.parentStatistics),
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
                  child: Text(lng.parentSettings),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
