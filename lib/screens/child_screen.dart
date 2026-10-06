import 'package:flutter/material.dart';

import '../widgets/rabbit_avatar.dart';
import '../app/rabbit_state.dart';
import '../services/task_storage.dart';
import '../models/task.dart';

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
        // Временно начинаем с последнего примера.
        currentItemIndex = loadedTask.items.length - 1;
      } else {
        // Продолжаем с первого нерешённого примера.
        currentItemIndex = firstUnansweredIndex;
      }

      currentItem = loadedTask.items[currentItemIndex];

      rabbitState = RabbitState.calcing;
      taskCompleted = loadedTask.statistics.completed;
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

    // Количество правильных ответов после текущего примера.
    final newCorrect = currentTask.statistics.correct + (isCorrect ? 1 : 0);

    // Создаём копию списка примеров.
    final updatedItems = List<TaskItem>.from(currentTask.items);

    // Записываем ответ ребёнка в текущий пример.
    updatedItems[currentItemIndex] = TaskItem(
      number: currentTaskItem.number,
      operand1: currentTaskItem.operand1,
      operation: currentTaskItem.operation,
      operand2: currentTaskItem.operand2,
      result: currentTaskItem.result,
      answer: userAnswer,
    );

    // Последний ли это пример?
    final isLastItem = currentItemIndex == currentTask.items.length - 1;

    // Пока задание не закончено, оценка ещё не выставляется.
    int newScore = 0;

    if (isLastItem) {
      newScore = ((newCorrect / updatedItems.length) * 5).round();
    }

    // Создаём новую статистику.
    final updatedStatistics = TaskStatistics(
      completed: isLastItem,
      correct: newCorrect,
      score: newScore,
    );

    // Создаём обновлённое задание.
    final updatedTask = Task(
      number: currentTask.number,
      name: currentTask.name,
      type: currentTask.type,
      settings: currentTask.settings,
      items: updatedItems,
      statistics: updatedStatistics,
    );

    // Сохраняем обновлённое задание в JSON.
    await storage.saveTask(updatedTask);

    // Обновляем данные задания в памяти.
    task = updatedTask;

    // Меняем настроение кролика.
    if (isCorrect) {
      rabbitState = RabbitState.glad;
    } else {
      rabbitState = RabbitState.grumpy;
    }

    if (!isLastItem) {
      setState(() {
        resultMessage = isCorrect ? 'Правильно!' : 'Неправильно';
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
        resultMessage = isCorrect ? 'Правильно!' : 'Неправильно';
      });

      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;

        final scoreText = task!.statistics.correct == task!.items.length
            ? '5+'
            : '${task!.statistics.score}';

        setState(() {
          rabbitState = RabbitState.bye;
          resultMessage = 'Задание выполнено\nОценка: $scoreText';
          taskCompleted = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (task == null || currentItem == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text('Задание №${task!.number}')),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                RabbitAvatar(state: rabbitState),

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
                        style: const TextStyle(fontSize: 32),
                      ),

                      SizedBox(
                        width: 90,
                        child: TextField(
                          controller: answerController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 28),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 4,
                            ),
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

                if (resultMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      resultMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24),
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
