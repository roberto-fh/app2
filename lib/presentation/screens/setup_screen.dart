import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/k_strings.dart';
import '../../core/router/app_router.dart';
import '../../providers/game_setup_provider.dart';
import '../../providers/game_provider.dart';

class SetupScreen extends ConsumerWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final duration = ref.watch(gameSetupProvider);
    return _SetupContent(
      duration: duration,
      onDurationChanged: (v) =>
          ref.read(gameSetupProvider.notifier).setDuration(v.round()),
      onStart: () {
        ref.read(gameProvider.notifier).startGame(duration);
        context.go(AppRoutes.teamIntro);
      },
    );
  }
}

class _SetupContent extends StatelessWidget {
  const _SetupContent({
    required this.duration,
    required this.onDurationChanged,
    required this.onStart,
  });

  final int duration;
  final ValueChanged<double> onDurationChanged;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(KStrings.setupTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              KStrings.setupTurnDurationLabel,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                '$duration ${KStrings.setupSeconds}',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Slider(
              value: duration.toDouble(),
              min: 15,
              max: 120,
              divisions: 21,
              label: '$duration s',
              onChanged: onDurationChanged,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('15 s'),
                Text('120 s'),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: onStart,
              child: const Text(KStrings.setupStartButton),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
