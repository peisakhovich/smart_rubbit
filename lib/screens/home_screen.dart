import 'package:flutter/material.dart';

import '../widgets/rabbit_avatar.dart';
import '../app/rabbit_state.dart';
import 'parent_screen.dart';
import 'child_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Умный кролик Uszko'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const RabbitAvatar(state: RabbitState.hi),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChildScreen()),
                );
              },
              child: const Text('УЧЕНИК'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ParentScreen()),
                );
              },
              child: const Text('УЧИТЕЛЬ'),
            ),
          ],
        ),
      ),
    );
  }
}
