import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/task.dart';

class TaskStorage {
  Future<Directory> getTasksDirectory() async {
    final appDirectory = await getApplicationDocumentsDirectory();

    final tasksDirectory = Directory('${appDirectory.path}/tasks');

    await tasksDirectory.create(recursive: true);

    return tasksDirectory;
  }

  Future<void> saveTask(Task task) async {
    final tasksDirectory = await getTasksDirectory();

    final fileName = '${task.number.toString().padLeft(4, '0')}.json';

    final file = File('${tasksDirectory.path}/$fileName');

    final json = jsonEncode(task.toJson());

    await file.writeAsString(json);
  }

  Future<Task> loadTask(int number) async {
    final tasksDirectory = await getTasksDirectory();

    final fileName = '${number.toString().padLeft(4, '0')}.json';

    final file = File('${tasksDirectory.path}/$fileName');

    final jsonString = await file.readAsString();

    final json = jsonDecode(jsonString);

    return Task.fromJson(json);
  }

  Future<List<Task>> loadAllTasks() async {
    final tasksDirectory = await getTasksDirectory();

    final files = await tasksDirectory
        .list()
        .where((entity) => entity is File && entity.path.endsWith('.json'))
        .toList();

    final tasks = <Task>[];

    for (final entity in files) {
      final file = File(entity.path);

      final jsonString = await file.readAsString();
      final json = jsonDecode(jsonString);

      tasks.add(Task.fromJson(json));
    }

    tasks.sort((a, b) => a.number.compareTo(b.number));

    return tasks;
  }

  Future<void> setCurrentTask(int number) async {
    final appDirectory = await getApplicationDocumentsDirectory();

    final file = File('${appDirectory.path}/current_task.json');

    final json = jsonEncode({'number': number});

    await file.writeAsString(json);
  }

  Future<int> getCurrentTask() async {
    final appDirectory = await getApplicationDocumentsDirectory();

    final file = File('${appDirectory.path}/current_task.json');

    final jsonString = await file.readAsString();

    final json = jsonDecode(jsonString);

    return json['number'];
  }
}
