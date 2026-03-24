import 'game_card.dart';

enum GamePhase { waiting, playing, turnEnd, gameOver }

class GameState {
  const GameState({
    required this.remainingCards,
    required this.guessedThisTurn,
    required this.skippedThisTurn,
    required this.scores,
    required this.currentTeam,
    required this.currentCard,
    required this.timeRemaining,
    required this.turnDuration,
    required this.phase,
  });

  final List<GameCard> remainingCards;
  final List<GameCard> guessedThisTurn;
  final List<GameCard> skippedThisTurn;
  final Map<int, int> scores;
  final int currentTeam;
  final GameCard? currentCard;
  final int timeRemaining;
  final int turnDuration;
  final GamePhase phase;

  GameState copyWith({
    List<GameCard>? remainingCards,
    List<GameCard>? guessedThisTurn,
    List<GameCard>? skippedThisTurn,
    Map<int, int>? scores,
    int? currentTeam,
    GameCard? currentCard,
    bool clearCurrentCard = false,
    int? timeRemaining,
    int? turnDuration,
    GamePhase? phase,
  }) {
    return GameState(
      remainingCards: remainingCards ?? this.remainingCards,
      guessedThisTurn: guessedThisTurn ?? this.guessedThisTurn,
      skippedThisTurn: skippedThisTurn ?? this.skippedThisTurn,
      scores: scores ?? this.scores,
      currentTeam: currentTeam ?? this.currentTeam,
      currentCard: clearCurrentCard ? null : (currentCard ?? this.currentCard),
      timeRemaining: timeRemaining ?? this.timeRemaining,
      turnDuration: turnDuration ?? this.turnDuration,
      phase: phase ?? this.phase,
    );
  }
}
