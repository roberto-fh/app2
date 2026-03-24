import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/k_strings.dart';
import '../../core/router/app_router.dart';
import '../../providers/game_provider.dart';
import '../../providers/game_setup_provider.dart';

class GameOverScreen extends ConsumerWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameProvider);
    final duration = ref.watch(gameSetupProvider);
    final score0 = state.scores[0] ?? 0;
    final score1 = state.scores[1] ?? 0;

    String winnerText;
    if (score0 > score1) {
      winnerText = '${KStrings.team1Name} ${KStrings.gameOverWinner}';
    } else if (score1 > score0) {
      winnerText = '${KStrings.team2Name} ${KStrings.gameOverWinner}';
    } else {
      winnerText = KStrings.gameOverTie;
    }

    return _GameOverContent(
      scores: state.scores,
      winnerText: winnerText,
      onPlayAgain: () {
        ref.read(gameProvider.notifier).startGame(duration);
        context.go(AppRoutes.teamIntro);
      },
      onHome: () => context.go(AppRoutes.home),
    );
  }
}

class _GameOverContent extends StatelessWidget {
  const _GameOverContent({
    required this.scores,
    required this.winnerText,
    required this.onPlayAgain,
    required this.onHome,
  });

  final Map<int, int> scores;
  final String winnerText;
  final VoidCallback onPlayAgain;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final teamNames = [KStrings.team1Name, KStrings.team2Name];

    return Scaffold(
      backgroundColor: colorScheme.primaryContainer,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Icon(Icons.emoji_events, size: 100, color: Colors.amber),
              const SizedBox(height: 16),
              Text(
                KStrings.gameOverTitle,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                winnerText,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        KStrings.gameOverFinalScore,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(2, (i) {
                          return Column(
                            children: [
                              Text(
                                teamNames[i],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${scores[i] ?? 0}',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: onPlayAgain,
                child: const Text(KStrings.gameOverPlayAgain),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: onHome,
                child: Text(
                  KStrings.homeTitle,
                  style: TextStyle(color: colorScheme.onPrimaryContainer),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
