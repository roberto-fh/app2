import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/k_strings.dart';
import '../../core/router/app_router.dart';
import '../../providers/game_provider.dart';

class TeamIntroScreen extends ConsumerWidget {
  const TeamIntroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameProvider);
    final teamNames = [KStrings.team1Name, KStrings.team2Name];
    final currentTeamName = teamNames[state.currentTeam];
    final colorScheme = Theme.of(context).colorScheme;

    return _TeamIntroContent(
      teamName: currentTeamName,
      colorScheme: colorScheme,
      cardsLeft: state.remainingCards.length,
      scores: state.scores,
      onStart: () {
        ref.read(gameProvider.notifier).startTurn();
        context.go(AppRoutes.playing);
      },
    );
  }
}

class _TeamIntroContent extends StatelessWidget {
  const _TeamIntroContent({
    required this.teamName,
    required this.colorScheme,
    required this.cardsLeft,
    required this.scores,
    required this.onStart,
  });

  final String teamName;
  final ColorScheme colorScheme;
  final int cardsLeft;
  final Map<int, int> scores;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.secondary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Icon(Icons.groups, size: 80, color: colorScheme.onSecondary),
              const SizedBox(height: 24),
              Text(
                KStrings.teamIntroReady,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${KStrings.teamIntroTurn} $teamName',
                style: TextStyle(
                  fontSize: 24,
                  color: colorScheme.onSecondary.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '$cardsLeft ${KStrings.playingCardsLeft}',
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSecondary.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                KStrings.teamIntroHide,
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: colorScheme.onSecondary.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: onStart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.onSecondary,
                  foregroundColor: colorScheme.secondary,
                ),
                child: const Text(KStrings.teamIntroStartButton),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
