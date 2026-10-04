import 'package:flutter/material.dart';

import '../screens/home_screen.dart';

class SmartRabbitApp extends StatelessWidget {
  const SmartRabbitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Умный кролик', home: const HomeScreen());
  }
}
