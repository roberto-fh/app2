import 'package:flutter/material.dart';

class CountdownTimer extends StatelessWidget {
  const CountdownTimer({
    super.key,
    required this.seconds,
    required this.totalSeconds,
  });

  final int seconds;
  final int totalSeconds;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progress = totalSeconds > 0 ? seconds / totalSeconds : 0.0;
    final isLow = seconds <= 10;

    final color = isLow ? colorScheme.error : colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 6,
                color: color,
                backgroundColor: color.withOpacity(0.2),
              ),
              Text(
                '$seconds',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
