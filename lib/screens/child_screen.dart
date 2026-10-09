import 'package:flutter/material.dart';

import '../app/rabbit_state.dart';
import '../localization/localization.dart';
import '../models/task.dart';
import '../services/settings_storage.dart';
import '../services/task_storage.dart';
import '../widgets/rabbit_avatar.dart';

class ChildScreen extends StatefulWidget {
  const ChildScreen({super.key});

  @override
  State<ChildScreen> createState() => _ChildScreenState();
}

class _ChildScreenState extends State<ChildScreen> {
  final TaskStorage storage = TaskStorage();
  final SettingsStorage settingsStorage = SettingsStorage();
  final TextEditingController answerController = TextEditingController();

  Task? task;
  TaskItem? currentItem;

  int currentItemIndex = 0;

  String? resultMessage;

  RabbitState rabbitState = RabbitState.calcing;

  bool taskCompleted = false;
  bool learningStageCompleted = false;
  bool showLowScore = false;

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
    final settings = await settingsStorage.loadSettings();

    final firstUnansweredIndex = loadedTask.items.indexWhere(
      (item) => item.answer == null,
    );

    if (!mounted) return;

    setState(() {
      task = loadedTask;
      showLowScore = settings.showLowScore;

      currentItemIndex = firstUnansweredIndex == -1
          ? loadedTask.items.length - 1
          : firstUnansweredIndex;

      currentItem = loadedTask.items[currentItemIndex];

      taskCompleted = loadedTask.statistics.completed;
      learningStageCompleted = false;

      if (taskCompleted) {
        rabbitState = RabbitState.bye;
        resultMessage = _completedMessage(loadedTask);
      } else {
        rabbitState = RabbitState.calcing;
        resultMessage = null;
      }
    });
  }

  String? _scoreText(Task completedTask) {
    final score = completedTask.statistics.score;

    // Если показ низких оценок выключен, оценку ниже 4 не показываем.
    if (!showLowScore && score < 4) {
      return null;
    }

    if (completedTask.statistics.correct == completedTask.items.length) {
      return '5+';
    }

    return '$score';
  }

  String _completedMessage(Task completedTask) {
    final scoreText = _scoreText(completedTask);

    if (scoreText == null) {
      return lng.childTaskCompleted;
    }

    return '${lng.childTaskCompleted}\n'
        '${lng.childScore} $scoreText';
  }

  Future<void> repeatTask() async {
    final currentTask = task!;

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

    final resetStatistics = TaskStatistics(
      completed: false,
      correct: 0,
      score: 0,
    );

    final resetTask = Task(
      number: currentTask.number,
      name: currentTask.name,
      type: currentTask.type,
      settings: currentTask.settings,
      items: resetItems,
      statistics: resetStatistics,
    );

    await storage.saveTask(resetTask);

    if (!mounted) return;

    setState(() {
      task = resetTask;
      currentItemIndex = 0;
      currentItem = resetTask.items[0];

      answerController.clear();

      resultMessage = null;
      rabbitState = RabbitState.calcing;
      taskCompleted = false;
      learningStageCompleted = false;
    });
  }

  Future<void> nextTask() async {
    final currentTask = task!;
    final allTasks = await storage.loadAllTasks();

    final nextTasks = allTasks
        .where((item) => item.number > currentTask.number)
        .toList();

    nextTasks.sort((a, b) => a.number.compareTo(b.number));

    if (nextTasks.isEmpty) {
      if (!mounted) return;

      setState(() {
        learningStageCompleted = true;
        taskCompleted = false;
        rabbitState = RabbitState.bye;
        resultMessage = null;
      });

      return;
    }

    final nextTask = nextTasks.first;

    await storage.setCurrentTask(nextTask.number);

    final settings = await settingsStorage.loadSettings();

    final firstUnansweredIndex = nextTask.items.indexWhere(
      (item) => item.answer == null,
    );

    if (!mounted) return;

    setState(() {
      task = nextTask;
      showLowScore = settings.showLowScore;

      currentItemIndex = firstUnansweredIndex == -1
          ? nextTask.items.length - 1
          : firstUnansweredIndex;

      currentItem = nextTask.items[currentItemIndex];

      answerController.clear();

      taskCompleted = nextTask.statistics.completed;
      learningStageCompleted = false;

      if (taskCompleted) {
        rabbitState = RabbitState.bye;
        resultMessage = _completedMessage(nextTask);
      } else {
        rabbitState = RabbitState.calcing;
        resultMessage = null;
      }
    });
  }

  Future<void> checkAnswer() async {
    final userAnswer = int.tryParse(answerController.text);

    if (userAnswer == null) {
      setState(() {
        resultMessage = lng.childEnterNumber;
      });
      return;
    }

    final currentTask = task!;
    final currentTaskItem = currentItem!;

    final isCorrect = userAnswer == currentTaskItem.result;

    final newCorrect = currentTask.statistics.correct + (isCorrect ? 1 : 0);

    final updatedItems = List<TaskItem>.from(currentTask.items);

    updatedItems[currentItemIndex] = TaskItem(
      number: currentTaskItem.number,
      operand1: currentTaskItem.operand1,
      operation: currentTaskItem.operation,
      operand2: currentTaskItem.operand2,
      result: currentTaskItem.result,
      answer: userAnswer,
    );

    final isLastItem = currentItemIndex == currentTask.items.length - 1;

    int newScore = 0;

    if (isLastItem) {
      newScore = ((newCorrect / updatedItems.length) * 5).round();
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

    if (!mounted) return;

    setState(() {
      task = updatedTask;
      rabbitState = isCorrect ? RabbitState.glad : RabbitState.grumpy;
      resultMessage = isCorrect ? lng.childCorrect : lng.childIncorrect;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;

      if (!isLastItem) {
        setState(() {
          currentItemIndex++;
          currentItem = task!.items[currentItemIndex];

          answerController.clear();

          resultMessage = null;
          rabbitState = RabbitState.calcing;
        });
      } else {
        setState(() {
          rabbitState = RabbitState.bye;
          resultMessage = _completedMessage(task!);
          taskCompleted = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (task == null || currentItem == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return ListenableBuilder(
      listenable: lng,
      builder: (context, child) {
        final scoreText = _scoreText(task!);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              learningStageCompleted
                  ? lng.appTitle
                  : '${lng.childTaskTitle} №${task!.number} '
                        '${task!.name} — ${task!.items.length} '
                        '${lng.childExamples}',
            ),
            centerTitle: true,
          ),
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

                    if (learningStageCompleted) ...[
                      const SizedBox(height: 20),
                      Text(
                        lng.childStageCompleted,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        lng.childAllTasksCompleted,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ],

                    if (!taskCompleted && !learningStageCompleted) ...[
                      Text(
                        '${lng.childExample} ${currentItemIndex + 1}',
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
                              style: const TextStyle(fontSize: 28),
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
                        child: Text(lng.childCheckButton),
                      ),
                      const SizedBox(height: 20),
                    ],

                    if (taskCompleted) ...[
                      const SizedBox(height: 20),
                      Text(
                        lng.childTaskCompleted,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (scoreText != null) ...[
                        const SizedBox(height: 15),
                        Text(
                          '${lng.childScore} $scoreText',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ],
                      const SizedBox(height: 25),
                      ElevatedButton(
                        onPressed: repeatTask,
                        child: Text(lng.childRepeat),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: nextTask,
                        child: Text(lng.childNext),
                      ),
                    ],

                    if (resultMessage != null &&
                        !taskCompleted &&
                        !learningStageCompleted)
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
      },
    );
  }
}
