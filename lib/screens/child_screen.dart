import 'dart:async';

import 'package:flutter/material.dart';

import '../app/rabbit_state.dart';
import '../models/task.dart';
import '../services/task_storage.dart';
import '../widgets/rabbit_avatar.dart';

class ChildScreen extends StatefulWidget {
  const ChildScreen({super.key});

  @override
  State<ChildScreen> createState() => _ChildScreenState();
}

class _ChildScreenState extends State<ChildScreen> {
  final TaskStorage storage = TaskStorage();
  final TextEditingController answerController = TextEditingController();

  Task? task;
  TaskItem? currentItem;

  int currentItemIndex = 0;

  String? resultMessage;

  RabbitState rabbitState = RabbitState.calcing;

  bool taskCompleted = false;

  @override
  void initState() {
    super.initState();

    loadCurrentTask();
  }

  @override
  void dispose() {
    answerController.dispose();

    super.dispose();
  }

  Future<void> loadCurrentTask() async {
    final taskNumber = await storage.getCurrentTask();
    final loadedTask = await storage.loadTask(taskNumber);

    // Ищем первый пример, на который ещё не был дан ответ.
    final firstUnansweredIndex = loadedTask.items.indexWhere(
      (item) => item.answer == null,
    );

    setState(() {
      task = loadedTask;

      if (firstUnansweredIndex == -1) {
        // Все примеры уже имеют ответ.
        // Показываем последний пример.
        currentItemIndex = loadedTask.items.length - 1;
      } else {
        // Продолжаем с первого нерешённого примера.
        currentItemIndex = firstUnansweredIndex;
      }

      currentItem = loadedTask.items[currentItemIndex];

      taskCompleted = loadedTask.statistics.completed;

      if (taskCompleted) {
        rabbitState = RabbitState.bye;

        final scoreText =
            loadedTask.statistics.correct == loadedTask.items.length
                ? '5+'
                : '${loadedTask.statistics.score}';

        resultMessage =
            'Задание выполнено\nОценка: $scoreText';
      } else {
        rabbitState = RabbitState.calcing;
        resultMessage = null;
      }
    });
  }

  Future<void> repeatTask() async {
    final currentTask = task!;

    // Создаём новые элементы задания,
    // но стираем все предыдущие ответы.
    final resetItems = currentTask.items.map((item) {
      return TaskItem(
        number: item.number,
        operand1: item.operand1,
        operation: item.operation,
        operand2: item.operand2,
        result: item.result,
        answer: null,
      );
    }).toList();

    // Полностью сбрасываем статистику.
    final resetStatistics = TaskStatistics(
      completed: false,
      correct: 0,
      score: 0,
    );

    // Создаём новое состояние задания.
    final resetTask = Task(
      number: currentTask.number,
      name: currentTask.name,
      type: currentTask.type,
      settings: currentTask.settings,
      items: resetItems,
      statistics: resetStatistics,
    );

    // Сохраняем новую попытку в JSON.
    await storage.saveTask(resetTask);

    // Показываем первый пример.
    setState(() {
      task = resetTask;

      currentItemIndex = 0;
      currentItem = resetTask.items[0];

      answerController.clear();

      resultMessage = null;

      rabbitState = RabbitState.calcing;

      taskCompleted = false;
    });
  }

  Future<void> checkAnswer() async {
    final userAnswer = int.tryParse(answerController.text);

    if (userAnswer == null) {
      setState(() {
        resultMessage = 'Введите число';
      });
      return;
    }

    final currentTask = task!;
    final currentTaskItem = currentItem!;

    final isCorrect = userAnswer == currentTaskItem.result;

    final newCorrect =
        currentTask.statistics.correct + (isCorrect ? 1 : 0);

    final updatedItems = List<TaskItem>.from(currentTask.items);

    updatedItems[currentItemIndex] = TaskItem(
      number: currentTaskItem.number,
      operand1: currentTaskItem.operand1,
      operation: currentTaskItem.operation,
      operand2: currentTaskItem.operand2,
      result: currentTaskItem.result,
      answer: userAnswer,
    );

    final isLastItem =
        currentItemIndex == currentTask.items.length - 1;

    int newScore = 0;

    if (isLastItem) {
      newScore =
          ((newCorrect / updatedItems.length) * 5).round();
    }

    final updatedStatistics = TaskStatistics(
      completed: isLastItem,
      correct: newCorrect,
      score: newScore,
    );

    final updatedTask = Task(
      number: currentTask.number,
      name: currentTask.name,
      type: currentTask.type,
      settings: currentTask.settings,
      items: updatedItems,
      statistics: updatedStatistics,
    );

    await storage.saveTask(updatedTask);

    task = updatedTask;

    if (isCorrect) {
      rabbitState = RabbitState.glad;
    } else {
      rabbitState = RabbitState.grumpy;
    }

    if (!isLastItem) {
      setState(() {
        resultMessage =
            isCorrect ? 'Правильно!' : 'Неправильно';
      });

      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;

        setState(() {
          currentItemIndex++;
          currentItem = task!.items[currentItemIndex];

          answerController.clear();

          resultMessage = null;
          rabbitState = RabbitState.calcing;
        });
      });
    } else {
      setState(() {
        resultMessage =
            isCorrect ? 'Правильно!' : 'Неправильно';
      });

      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;

        final scoreText =
            task!.statistics.correct == task!.items.length
                ? '5+'
                : '${task!.statistics.score}';

        setState(() {
          rabbitState = RabbitState.bye;
          resultMessage =
              'Задание выполнено\nОценка: $scoreText';
          taskCompleted = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (task == null || currentItem == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Задание №${task!.number}'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                RabbitAvatar(
                  state: rabbitState,
                ),

                const SizedBox(height: 20),

                if (!taskCompleted) ...[
                  Text(
                    'Пример ${currentItemIndex + 1} '
                    'из ${task!.items.length}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${currentItem!.operand1} '
                        '${currentItem!.operation} '
                        '${currentItem!.operand2} = ',
                        style: const TextStyle(
                          fontSize: 32,
                        ),
                      ),

                      Container(
                        width: 90,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: answerController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontSize: 28,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  ElevatedButton(
                    onPressed: checkAnswer,
                    child: const Text('ПРОВЕРИТЬ'),
                  ),

                  const SizedBox(height: 20),
                ],

                if (taskCompleted) ...[
                  const SizedBox(height: 20),

                  Text(
                    'Задание выполнено',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    task!.statistics.correct == task!.items.length
                        ? 'Оценка: 5+'
                        : 'Оценка: ${task!.statistics.score}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  ),

                  const SizedBox(height: 25),

                  ElevatedButton(
                    onPressed: repeatTask,
                    child: const Text('ПОВТОРИТЬ'),
                  ),

                  const SizedBox(height: 15),

                  ElevatedButton(
                    onPressed: () {
                      // Пока ничего не делаем.
                    },
                    child: const Text('СЛЕДУЮЩЕЕ'),
                  ),
                ],

                if (resultMessage != null && !taskCompleted)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Text(
                      resultMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}