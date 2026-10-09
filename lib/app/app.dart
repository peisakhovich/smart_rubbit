import 'package:flutter/material.dart';

import '../localization/localization.dart';
import '../screens/home_screen.dart';
import '../services/settings_storage.dart';

class SmartRabbitApp extends StatefulWidget {
  const SmartRabbitApp({super.key});

  @override
  State<SmartRabbitApp> createState() => _SmartRabbitAppState();
}

class _SmartRabbitAppState extends State<SmartRabbitApp> {
  final SettingsStorage storage = SettingsStorage();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final settings = await storage.loadSettings();

    lng.setLanguage(settings.language);

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: lng,
      builder: (context, child) {
        return MaterialApp(
          title: lng.appTitle,
          home: const HomeScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
