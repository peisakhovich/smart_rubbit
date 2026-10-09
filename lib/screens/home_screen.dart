import 'package:flutter/material.dart';

import '../widgets/rabbit_avatar.dart';
import '../app/rabbit_state.dart';
import '../localization/localization.dart';
import 'parent_screen.dart';
import 'child_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: lng,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(title: Text(lng.homeTitle), centerTitle: true),
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
                      MaterialPageRoute(
                        builder: (context) => const ChildScreen(),
                      ),
                    );
                  },
                  child: Text(lng.homeStudentButton),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ParentScreen(),
                      ),
                    );
                  },
                  child: Text(lng.homeTeacherButton),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
