import 'package:flutter/material.dart';

import 'english.dart';
import 'russian.dart';

class Localization extends ChangeNotifier {
  String language = 'en';

  final Map<String, dynamic> languages = {
    'en': EnglishStrings(),
    'ru': RussianStrings(),
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
}

final lng = Localization();
