import 'package:flutter/material.dart';
import '../../core/constants/k_strings.dart';

class ScoreBoard extends StatelessWidget {
  const ScoreBoard({
    super.key,
    required this.scores,
    this.currentTeam,
  });

  final Map<int, int> scores;
  final int? currentTeam;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final teamNames = [KStrings.team1Name, KStrings.team2Name];

    return Row(
      children: List.generate(2, (i) {
        final isActive = currentTeam == i;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: isActive
                  ? colorScheme.primaryContainer
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: isActive
                  ? Border.all(color: colorScheme.primary, width: 2)
                  : null,
            ),
            child: Column(
              children: [
                Text(
                  teamNames[i],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isActive
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${scores[i] ?? 0}',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isActive
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
