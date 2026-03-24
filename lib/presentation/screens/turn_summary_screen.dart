import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/k_strings.dart';
import '../../core/router/app_router.dart';
import '../../domain/model/game_card.dart';
import '../../domain/model/game_state.dart';
import '../../providers/game_provider.dart';
import '../widgets/score_board.dart';

class TurnSummaryScreen extends ConsumerWidget {
  const TurnSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameProvider);
    final teamNames = [KStrings.team1Name, KStrings.team2Name];
    final isGameOver = state.phase == GamePhase.gameOver;

    return _TurnSummaryContent(
      teamName: teamNames[state.phase == GamePhase.gameOver
          ? (state.currentTeam == 0 ? 1 : 0)
          : (state.currentTeam == 0 ? 1 : 0)],
      guessed: state.guessedThisTurn,
      skipped: state.skippedThisTurn,
      scores: state.scores,
      isGameOver: isGameOver,
      onContinue: () {
        ref.read(gameProvider.notifier).endTurn();
        if (isGameOver) {
          context.go(AppRoutes.gameOver);
        } else {
          context.go(AppRoutes.teamIntro);
        }
      },
    );
  }
}

class _TurnSummaryContent extends StatelessWidget {
  const _TurnSummaryContent({
    required this.teamName,
    required this.guessed,
    required this.skipped,
    required this.scores,
    required this.isGameOver,
    required this.onContinue,
  });

  final String teamName;
  final List<GameCard> guessed;
  final List<GameCard> skipped;
  final Map<int, int> scores;
  final bool isGameOver;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(KStrings.turnSummaryTitle),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScoreBoard(scores: scores),
            const SizedBox(height: 24),
            Text(
              '$teamName — ${guessed.length} ${KStrings.turnSummaryPoints}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _SectionTitle(
              icon: Icons.check_circle,
              color: Theme.of(context).colorScheme.tertiary,
              label:
                  '${KStrings.turnSummaryGuessed} (${guessed.length})',
            ),
            ...guessed.map((c) => _CardTile(name: c.name, correct: true)),
            const SizedBox(height: 8),
            if (skipped.isNotEmpty) ...[
              _SectionTitle(
                icon: Icons.skip_next,
                color: Theme.of(context).colorScheme.outline,
                label: '${KStrings.turnSummarySkipped} (${skipped.length})',
              ),
              ...skipped.map((c) => _CardTile(name: c.name, correct: false)),
            ],
            const Spacer(),
            ElevatedButton(
              onPressed: onContinue,
              child: Text(
                isGameOver ? KStrings.gameOverFinalScore : KStrings.turnSummaryContinue,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

class _CardTile extends StatelessWidget {
  const _CardTile({required this.name, required this.correct});

  final String name;
  final bool correct;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Text(
        '• $name',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: correct
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.outline,
            ),
      ),
    );
  }
}
