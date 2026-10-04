import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gif/gif.dart';

import '../app/rabbit_state.dart';

class RabbitAvatar extends StatefulWidget {
  final RabbitState state;

  const RabbitAvatar({super.key, required this.state});

  @override
  State<RabbitAvatar> createState() => _RabbitAvatarState();
}

class _RabbitAvatarState extends State<RabbitAvatar>
    with TickerProviderStateMixin {
  late GifController gifController;
  Timer? repeatTimer;

  @override
  void initState() {
    super.initState();

    gifController = GifController(vsync: this);
    gifController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        repeatTimer = Timer(const Duration(seconds: 5), () {
          gifController.reset();
          gifController.forward();
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant RabbitAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.state != widget.state) {
      repeatTimer?.cancel();
      gifController.reset();
    }
  }

  @override
  void dispose() {
    repeatTimer?.cancel();
    gifController.dispose();
    super.dispose();
  }

  String get imagePath {
    switch (widget.state) {
      case RabbitState.bye:
        return 'assets/images/uszko/Uszko_bye.gif';

      case RabbitState.calcing:
        return 'assets/images/uszko/Uszko_calcing.gif';

      case RabbitState.fitness:
        return 'assets/images/uszko/Uszko_fitness.gif';

      case RabbitState.glad:
        return 'assets/images/uszko/Uszko_glad.gif';

      case RabbitState.grumpy:
        return 'assets/images/uszko/Uszko_grumpy.gif';

      case RabbitState.hi:
        return 'assets/images/uszko/Uszko_hi.gif';

      case RabbitState.supper:
        return 'assets/images/uszko/Uszko_supper.gif';

      case RabbitState.think:
        return 'assets/images/uszko/Uszko_think.gif';

      case RabbitState.yawns:
        return 'assets/images/uszko/Uszko_yawns.gif';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Gif(
      key: ValueKey(imagePath),
      controller: gifController,
      image: AssetImage(imagePath),
      autostart: Autostart.no,
      width: 200,
      height: 200,
      onFetchCompleted: () {
        gifController.forward();
      },
    );
  }
}
