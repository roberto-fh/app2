import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../core/constants/k_cards.dart';
import '../domain/model/game_card.dart';
import '../domain/model/game_state.dart';

part 'game_provider.g.dart';

@Riverpod(keepAlive: true)
class Game extends _$Game {
  Timer? _timer;

  @override
  GameState build() => _initialState(30);

  GameState _initialState(int turnDuration) => GameState(
        remainingCards: const [],
        guessedThisTurn: const [],
        skippedThisTurn: const [],
        scores: const {0: 0, 1: 0},
        currentTeam: 0,
        currentCard: null,
        timeRemaining: turnDuration,
        turnDuration: turnDuration,
        phase: GamePhase.waiting,
      );

  void startGame(int turnDuration) {
    _cancelTimer();
    final shuffled = List<GameCard>.from(KCards.all)..shuffle(Random());
    state = GameState(
      remainingCards: shuffled,
      guessedThisTurn: const [],
      skippedThisTurn: const [],
      scores: const {0: 0, 1: 0},
      currentTeam: 0,
      currentCard: shuffled.first,
      timeRemaining: turnDuration,
      turnDuration: turnDuration,
      phase: GamePhase.waiting,
    );
  }

  void startTurn() {
    if (state.remainingCards.isEmpty) return;
    _cancelTimer();
    state = state.copyWith(
      phase: GamePhase.playing,
      timeRemaining: state.turnDuration,
      guessedThisTurn: [],
      skippedThisTurn: [],
      currentCard: state.remainingCards.first,
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void markCorrect() {
    if (state.phase != GamePhase.playing || state.currentCard == null) return;
    final guessed = [...state.guessedThisTurn, state.currentCard!];
    final remaining = state.remainingCards
        .where((c) => c.id != state.currentCard!.id)
        .toList();

    if (remaining.isEmpty) {
      _cancelTimer();
      state = state.copyWith(
        guessedThisTurn: guessed,
        remainingCards: remaining,
        phase: GamePhase.turnEnd,
        clearCurrentCard: true,
      );
      return;
    }

    state = state.copyWith(
      guessedThisTurn: guessed,
      remainingCards: remaining,
      currentCard: remaining.first,
    );
  }

  void skipCard() {
    if (state.phase != GamePhase.playing || state.currentCard == null) return;
    final skipped = [...state.skippedThisTurn, state.currentCard!];

    // Move skipped card to end of remaining
    final remaining = [
      ...state.remainingCards
          .where((c) => c.id != state.currentCard!.id)
          .toList(),
      state.currentCard!,
    ];

    state = state.copyWith(
      skippedThisTurn: skipped,
      remainingCards: remaining,
      currentCard: remaining.first,
    );
  }

  void endTurn() {
    _cancelTimer();
    final points = state.guessedThisTurn.length;
    final newScores = Map<int, int>.from(state.scores);
    newScores[state.currentTeam] = (newScores[state.currentTeam] ?? 0) + points;

    final nextTeam = state.currentTeam == 0 ? 1 : 0;
    final isGameOver = state.remainingCards.isEmpty;

    state = state.copyWith(
      scores: newScores,
      currentTeam: nextTeam,
      phase: isGameOver ? GamePhase.gameOver : GamePhase.waiting,
      guessedThisTurn: [],
      skippedThisTurn: [],
      currentCard: state.remainingCards.isEmpty
          ? null
          : state.remainingCards.first,
      clearCurrentCard: state.remainingCards.isEmpty,
    );
  }

  void resetGame() {
    _cancelTimer();
    state = _initialState(state.turnDuration);
  }

  void _tick() {
    if (state.timeRemaining <= 1) {
      _cancelTimer();
      state = state.copyWith(
        timeRemaining: 0,
        phase: GamePhase.turnEnd,
      );
      return;
    }
    state = state.copyWith(timeRemaining: state.timeRemaining - 1);
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}
