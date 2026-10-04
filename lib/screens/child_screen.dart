import 'package:flutter/material.dart';

import '../widgets/rabbit_avatar.dart';
import '../app/rabbit_state.dart';

class ChildScreen extends StatelessWidget {
  const ChildScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ребёнок')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const RabbitAvatar(state: RabbitState.calcing),

            const SizedBox(height: 20),

            const Text('12 + 2 = ?', style: TextStyle(fontSize: 32)),

            const SizedBox(height: 20),

            SizedBox(
              width: 150,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(onPressed: () {}, child: const Text('ПРОВЕРИТЬ')),
          ],
        ),
      ),
    );
  }
}
