import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/setup_screen.dart';
import '../../presentation/screens/team_intro_screen.dart';
import '../../presentation/screens/playing_screen.dart';
import '../../presentation/screens/turn_summary_screen.dart';
import '../../presentation/screens/game_over_screen.dart';

abstract class AppRoutes {
  static const home = '/';
  static const setup = '/setup';
  static const teamIntro = '/team-intro';
  static const playing = '/playing';
  static const turnSummary = '/turn-summary';
  static const gameOver = '/game-over';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (BuildContext context, GoRouterState state) =>
          const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.setup,
      builder: (BuildContext context, GoRouterState state) =>
          const SetupScreen(),
    ),
    GoRoute(
      path: AppRoutes.teamIntro,
      builder: (BuildContext context, GoRouterState state) =>
          const TeamIntroScreen(),
    ),
    GoRoute(
      path: AppRoutes.playing,
      builder: (BuildContext context, GoRouterState state) =>
          const PlayingScreen(),
    ),
    GoRoute(
      path: AppRoutes.turnSummary,
      builder: (BuildContext context, GoRouterState state) =>
          const TurnSummaryScreen(),
    ),
    GoRoute(
      path: AppRoutes.gameOver,
      builder: (BuildContext context, GoRouterState state) =>
          const GameOverScreen(),
    ),
  ],
);
