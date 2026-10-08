import 'package:flutter/material.dart';

import '../models/app_settings.dart';
import '../services/settings_storage.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsStorage storage = SettingsStorage();

  AppSettings? settings;

  static const languages = [
    ('en', 'English'),
    ('ru', 'Русский'),
    ('pl', 'Polski'),
    ('fr', 'Français'),
    ('de', 'Deutsch'),
    ('ro', 'Română'),
  ];

  @override
  void initState() {
    super.initState();

    loadSettings();
  }

  Future<void> loadSettings() async {
    final loadedSettings = await storage.loadSettings();

    if (!mounted) return;

    setState(() {
      settings = loadedSettings;
    });
  }

  Future<void> saveSettings() async {
    await storage.saveSettings(settings!);
  }

  void updateSettings({
    int? maxTasksPerStack,
    bool? showLowScore,
    String? language,
  }) {
    setState(() {
      settings = AppSettings(
        maxTasksPerStack: maxTasksPerStack ?? settings!.maxTasksPerStack,
        showLowScore: showLowScore ?? settings!.showLowScore,
        language: language ?? settings!.language,
      );
    });
  }

  String getLanguageName(String code) {
    for (final language in languages) {
      if (language.$1 == code) {
        return language.$2;
      }
    }

    return code;
  }

  @override
  Widget build(BuildContext context) {
    if (settings == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('НАСТРОЙКИ'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Количество заданий в стеке',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: Slider(
                  min: 1,
                  max: 20,
                  divisions: 19,
                  value: settings!.maxTasksPerStack.toDouble(),
                  label: '${settings!.maxTasksPerStack}',
                  onChanged: (value) {
                    updateSettings(maxTasksPerStack: value.round());
                  },
                  onChangeEnd: (_) async {
                    await saveSettings();
                  },
                ),
              ),

              SizedBox(
                width: 40,
                child: Text(
                  '${settings!.maxTasksPerStack}',
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Показывать ребёнку результат ниже 4 баллов'),
            value: settings!.showLowScore,
            onChanged: (value) async {
              updateSettings(showLowScore: value);

              await saveSettings();
            },
          ),

          const SizedBox(height: 20),

          const Text(
            'Язык интерфейса',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          DropdownButtonFormField<String>(
            initialValue: settings!.language,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: [
              for (final language in languages)
                DropdownMenuItem(value: language.$1, child: Text(language.$2)),
            ],
            onChanged: (value) async {
              if (value == null) return;

              updateSettings(language: value);

              await saveSettings();
            },
          ),

          const SizedBox(height: 10),

          Text(
            'Выбранный язык: ${getLanguageName(settings!.language)}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
