import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/app_settings.dart';

class SettingsStorage {
  Future<File> getSettingsFile() async {
    final appDirectory = await getApplicationDocumentsDirectory();

    return File('${appDirectory.path}/settings.json');
  }

  Future<AppSettings> loadSettings() async {
    final file = await getSettingsFile();

    if (!await file.exists()) {
      final settings = AppSettings(
        maxTasksPerStack: 10,
        showLowScore: false,
        language: 'en',
      );

      await saveSettings(settings);

      return settings;
    }

    final jsonString = await file.readAsString();
    final json = jsonDecode(jsonString);

    return AppSettings.fromJson(json);
  }

  Future<void> saveSettings(AppSettings settings) async {
    final file = await getSettingsFile();

    final json = jsonEncode(settings.toJson());

    await file.writeAsString(json);
  }
}
