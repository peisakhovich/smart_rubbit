class Task {
  final int number;
  final String name;
  final String type;

  final TaskSettings settings;
  final List<TaskItem> items;
  final TaskStatistics statistics;

  Task({
    required this.number,
    required this.name,
    required this.type,
    required this.settings,
    required this.items,
    required this.statistics,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      number: json['number'],
      name: json['name'],
      type: json['type'],
      settings: TaskSettings.fromJson(json['settings']),
      items: (json['items'] as List)
          .map((item) => TaskItem.fromJson(item))
          .toList(),
      statistics: TaskStatistics.fromJson(json['statistics']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
      'type': type,
      'settings': settings.toJson(),
      'items': items.map((item) => item.toJson()).toList(),
      'statistics': statistics.toJson(),
    };
  }
}

class TaskSettings {
  final int count;

  final int operand1Min;
  final int operand1Max;

  final int operand2Min;
  final int operand2Max;

  final bool addition;
  final bool subtraction;
  final bool multiplication;
  final bool division;

  final bool divisionMultiples;
  final int multiplicationFactor;

  TaskSettings({
    required this.count,
    required this.operand1Min,
    required this.operand1Max,
    required this.operand2Min,
    required this.operand2Max,
    required this.addition,
    required this.subtraction,
    required this.multiplication,
    required this.division,
    required this.divisionMultiples,
    required this.multiplicationFactor,
  });

  factory TaskSettings.fromJson(Map<String, dynamic> json) {
    return TaskSettings(
      count: json['count'],
      operand1Min: json['operand1_min'],
      operand1Max: json['operand1_max'],
      operand2Min: json['operand2_min'],
      operand2Max: json['operand2_max'],
      addition: json['addition'],
      subtraction: json['subtraction'],
      multiplication: json['multiplication'],
      division: json['division'],
      divisionMultiples: json['division_multiples'],
      multiplicationFactor: json['multiplication_factor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'operand1_min': operand1Min,
      'operand1_max': operand1Max,
      'operand2_min': operand2Min,
      'operand2_max': operand2Max,
      'addition': addition,
      'subtraction': subtraction,
      'multiplication': multiplication,
      'division': division,
      'division_multiples': divisionMultiples,
      'multiplication_factor': multiplicationFactor,
    };
  }
}

class TaskItem {
  final int number;
  final int operand1;
  final String operation;
  final int operand2;
  final int result;
  final int? answer;

  TaskItem({
    required this.number,
    required this.operand1,
    required this.operation,
    required this.operand2,
    required this.result,
    this.answer,
  });

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      number: json['number'],
      operand1: json['operand1'],
      operation: json['operation'],
      operand2: json['operand2'],
      result: json['result'],
      answer: json['answer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'operand1': operand1,
      'operation': operation,
      'operand2': operand2,
      'result': result,
      'answer': answer,
    };
  }
}

class TaskStatistics {
  final bool completed;
  final int correct;
  final int score;

  TaskStatistics({
    required this.completed,
    required this.correct,
    required this.score,
  });

  factory TaskStatistics.fromJson(Map<String, dynamic> json) {
    return TaskStatistics(
      completed: json['completed'],
      correct: json['correct'],
      score: json['score'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'completed': completed, 'correct': correct, 'score': score};
  }
}
