import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/k_strings.dart';
import '../../core/router/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Icon(
                Icons.timer,
                size: 100,
                color: colorScheme.onPrimary,
              ),
              const SizedBox(height: 24),
              Text(
                KStrings.homeTitle,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                KStrings.homeSubtitle,
                style: TextStyle(
                  fontSize: 18,
                  color: colorScheme.onPrimary.withValues(alpha: 0.8),
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.setup),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.onPrimary,
                  foregroundColor: colorScheme.primary,
                ),
                child: const Text(KStrings.homePlayButton),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
