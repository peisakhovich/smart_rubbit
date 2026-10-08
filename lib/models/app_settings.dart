class AppSettings {
  final int maxTasksPerStack;
  final bool showLowScore;
  final String language;

  AppSettings({
    required this.maxTasksPerStack,
    required this.showLowScore,
    required this.language,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      maxTasksPerStack: json['max_tasks_per_stack'],
      showLowScore: json['show_low_score'],
      language: json['language'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'max_tasks_per_stack': maxTasksPerStack,
      'show_low_score': showLowScore,
      'language': language,
    };
  }
}
