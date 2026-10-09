import 'package:flutter/material.dart';

import 'english.dart';
import 'russian.dart';
import 'ukrainian.dart';
import 'polish.dart';
import 'french.dart';
import 'german.dart';
import 'romanian.dart';

class Localization extends ChangeNotifier {
  String language = 'en';

  final Map<String, dynamic> languages = {
    'en': EnglishStrings(),
    'ru': RussianStrings(),
    'uk': UkrainianStrings(),
    'pl': PolishStrings(),
    'fr': FrenchStrings(),
    'de': GermanStrings(),
    'ro': RomanianStrings(),
  };

  void setLanguage(String language) {
    if (!languages.containsKey(language)) {
      language = 'en';
    }

    if (this.language == language) {
      return;
    }

    this.language = language;

    notifyListeners();
  }

  String get appTitle => languages[language]!.appTitle;

  String get homeTitle => languages[language]!.homeTitle;
  String get homeStudentButton => languages[language]!.homeStudentButton;
  String get homeTeacherButton => languages[language]!.homeTeacherButton;

  String get settingsTitle => languages[language]!.settingsTitle;
  String get settingsTaskCount => languages[language]!.settingsTaskCount;
  String get settingsShowLowScore => languages[language]!.settingsShowLowScore;
  String get settingsLanguage => languages[language]!.settingsLanguage;
  String get settingsSelectedLanguage =>
      languages[language]!.settingsSelectedLanguage;

  String get parentTitle => languages[language]!.parentTitle;
  String get parentCreateTask => languages[language]!.parentCreateTask;
  String get parentSelectTask => languages[language]!.parentSelectTask;
  String get parentCurrentTask => languages[language]!.parentCurrentTask;
  String get parentDeleteTask => languages[language]!.parentDeleteTask;
  String get parentStatistics => languages[language]!.parentStatistics;
  String get parentSettings => languages[language]!.parentSettings;

  String get parentChooseTask => languages[language]!.parentChooseTask;
  String get parentNoCurrentTask => languages[language]!.parentNoCurrentTask;
  String get parentCurrentTaskPrefix =>
      languages[language]!.parentCurrentTaskPrefix;

  String get parentDeleteDialogTitle =>
      languages[language]!.parentDeleteDialogTitle;
  String get parentDeleteCurrent => languages[language]!.parentDeleteCurrent;
  String get parentDeleteAll => languages[language]!.parentDeleteAll;
  String get parentCancel => languages[language]!.parentCancel;
  String get parentDeleteAllQuestion =>
      languages[language]!.parentDeleteAllQuestion;
  String get parentDeleteAllMessage =>
      languages[language]!.parentDeleteAllMessage;
  String get parentDeleteAllConfirm =>
      languages[language]!.parentDeleteAllConfirm;
  String get parentTaskDeleted => languages[language]!.parentTaskDeleted;
  String get parentAllTasksDeleted =>
      languages[language]!.parentAllTasksDeleted;

  String get createTaskTitle => languages[language]!.createTaskTitle;
  String get createTaskGreeting => languages[language]!.createTaskGreeting;

  String get createTaskName => languages[language]!.createTaskName;
  String get createTaskNameHint => languages[language]!.createTaskNameHint;
  String get createTaskType => languages[language]!.createTaskType;
  String get createTaskArithmetic => languages[language]!.createTaskArithmetic;
  String get createTaskArithmeticDescription =>
      languages[language]!.createTaskArithmeticDescription;
  String get createTaskMultiplicationTable =>
      languages[language]!.createTaskMultiplicationTable;
  String get createTaskMultiplicationDescription =>
      languages[language]!.createTaskMultiplicationDescription;

  String get createTaskArithmeticParameters =>
      languages[language]!.createTaskArithmeticParameters;
  String get createTaskCount => languages[language]!.createTaskCount;
  String get createTaskFirstNumberFrom =>
      languages[language]!.createTaskFirstNumberFrom;
  String get createTaskFirstNumberTo =>
      languages[language]!.createTaskFirstNumberTo;
  String get createTaskSecondNumberFrom =>
      languages[language]!.createTaskSecondNumberFrom;
  String get createTaskSecondNumberTo =>
      languages[language]!.createTaskSecondNumberTo;

  String get createTaskTableParameters =>
      languages[language]!.createTaskTableParameters;
  String get createTaskTableFactor =>
      languages[language]!.createTaskTableFactor;
  String get createTaskExamplesPreview =>
      languages[language]!.createTaskExamplesPreview;

  String get createTaskOperations => languages[language]!.createTaskOperations;
  String get createTaskAddition => languages[language]!.createTaskAddition;
  String get createTaskSubtraction =>
      languages[language]!.createTaskSubtraction;
  String get createTaskMultiplication =>
      languages[language]!.createTaskMultiplication;
  String get createTaskDivision => languages[language]!.createTaskDivision;
  String get createTaskDivisionWithoutRemainder =>
      languages[language]!.createTaskDivisionWithoutRemainder;

  String get createTaskEnterName => languages[language]!.createTaskEnterName;
  String get createTaskMaximumReached =>
      languages[language]!.createTaskMaximumReached;
  String get createTaskCreated => languages[language]!.createTaskCreated;
  String get createTaskButton => languages[language]!.createTaskButton;
  String get statisticsTitle => languages[language]!.statisticsTitle;
  String get statisticsNoTasks => languages[language]!.statisticsNoTasks;
  String get statisticsTotalTasks => languages[language]!.statisticsTotalTasks;
  String get statisticsCompleted => languages[language]!.statisticsCompleted;
  String get statisticsCorrect => languages[language]!.statisticsCorrect;
  String get statisticsScore => languages[language]!.statisticsScore;
  String get statisticsNotCompleted =>
      languages[language]!.statisticsNotCompleted;

  String get taskStatsTitle => languages[language]!.taskStatsTitle;
  String get taskStatsCorrect => languages[language]!.taskStatsCorrect;
  String get taskStatsScore => languages[language]!.taskStatsScore;
  String get taskStatsExercises => languages[language]!.taskStatsExercises;
  String get taskStatsCorrectAnswer =>
      languages[language]!.taskStatsCorrectAnswer;
  String get taskStatsCorrectStatus =>
      languages[language]!.taskStatsCorrectStatus;

  String get childTaskTitle => languages[language]!.childTaskTitle;
  String get childExamples => languages[language]!.childExamples;
  String get childExample => languages[language]!.childExample;
  String get childCheckButton => languages[language]!.childCheckButton;
  String get childTaskCompleted => languages[language]!.childTaskCompleted;
  String get childScore => languages[language]!.childScore;
  String get childRepeat => languages[language]!.childRepeat;
  String get childNext => languages[language]!.childNext;
  String get childStageCompleted => languages[language]!.childStageCompleted;
  String get childAllTasksCompleted =>
      languages[language]!.childAllTasksCompleted;
  String get childEnterNumber => languages[language]!.childEnterNumber;
  String get childCorrect => languages[language]!.childCorrect;
  String get childIncorrect => languages[language]!.childIncorrect;
}

final lng = Localization();
