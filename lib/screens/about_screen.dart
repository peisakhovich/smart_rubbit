import 'package:flutter/material.dart';

import '../app/rabbit_state.dart';
import '../widgets/rabbit_avatar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const Color cloverGreen = Color(0xFF55A94F);
  static const Color lightGreen = Color(0xFFF0F8ED);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),

            // Clover Lab logo
            Center(
              child: Image.asset(
                'assets/images/branding/clover_lab_logo.png',
                height: 100,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'CLOVER LAB',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: cloverGreen,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              'PRESENTS',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 4,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Uszko — Smart Rabbit',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              'Learn to calculate.\n'
              'Learn to think.\n'
              'Grow together!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                height: 1.5,
                color: cloverGreen,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 28),

            const _SectionTitle(title: 'Meet the Team'),

            const SizedBox(height: 12),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _TeamCard(
                    name: 'Grigorii Peisakhovich',
                    role: 'Developer',
                    joke: '"It works on my machine!"',
                    state: RabbitState.programming,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TeamCard(
                    name: 'Dasha Peisakhovich',
                    role: 'Tester',
                    joke: '"Not on mine!"',
                    state: RabbitState.testing,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            const _SectionTitle(title: 'Get in Touch'),

            const SizedBox(height: 12),

            const _QrPlaceholder(
              title: 'Email',
              description: 'Scan to contact the developer',
            ),

            const SizedBox(height: 12),

            const _QrPlaceholder(
              title: 'Telegram Feedback',
              description: 'Scan to send feedback and suggestions',
            ),

            const SizedBox(height: 28),

            const _SectionTitle(title: 'Get Uszko'),

            const SizedBox(height: 12),

            const _QrPlaceholder(
              title: 'Download the App',
              description: 'Scan to open the latest release on GitHub',
            ),

            const SizedBox(height: 24),

            const Text(
              'Made with care by CLOVER LAB',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
    );
  }
}

class _TeamCard extends StatelessWidget {
  final String name;
  final String role;
  final String joke;
  final RabbitState state;

  const _TeamCard({
    required this.name,
    required this.role,
    required this.joke,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AboutScreen.lightGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: RabbitAvatar(state: state),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),

          const SizedBox(height: 4),

          Text(
            role,
            style: const TextStyle(
              color: AboutScreen.cloverGreen,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            joke,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}

class _QrPlaceholder extends StatelessWidget {
  final String title;
  final String description;

  const _QrPlaceholder({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AboutScreen.lightGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AboutScreen.cloverGreen.withValues(alpha: 0.4),
              ),
            ),
            child: const Icon(
              Icons.qr_code_2,
              size: 58,
              color: AboutScreen.cloverGreen,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  description,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
