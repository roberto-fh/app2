import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/k_strings.dart';
import '../../core/router/app_router.dart';
import '../../domain/model/game_state.dart';
import '../../providers/game_provider.dart';
import '../widgets/card_display.dart';
import '../widgets/countdown_timer.dart';
import '../widgets/score_board.dart';

class PlayingScreen extends ConsumerWidget {
  const PlayingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameProvider);

    // Navigate when turn ends
    ref.listen<GameState>(gameProvider, (previous, next) {
      if (next.phase == GamePhase.turnEnd || next.phase == GamePhase.gameOver) {
        context.go(AppRoutes.turnSummary);
      }
    });

    return _PlayingContent(
      state: state,
      onCorrect: () => ref.read(gameProvider.notifier).markCorrect(),
      onSkip: () => ref.read(gameProvider.notifier).skipCard(),
    );
  }
}

class _PlayingContent extends StatelessWidget {
  const _PlayingContent({
    required this.state,
    required this.onCorrect,
    required this.onSkip,
  });

  final GameState state;
  final VoidCallback onCorrect;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final teamNames = [KStrings.team1Name, KStrings.team2Name];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ScoreBoard(scores: state.scores, currentTeam: state.currentTeam),
              const SizedBox(height: 8),
              Text(
                teamNames[state.currentTeam],
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              if (state.currentCard != null)
                CardDisplay(cardName: state.currentCard!.name),
              const SizedBox(height: 16),
              Text(
                '${state.remainingCards.length} ${KStrings.playingCardsLeft}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
              CountdownTimer(
                seconds: state.timeRemaining,
                totalSeconds: state.turnDuration,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onSkip,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(KStrings.playingSkip),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: onCorrect,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.tertiary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onTertiary,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text(KStrings.playingCorrect),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
