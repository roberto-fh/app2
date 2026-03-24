import 'package:flutter/material.dart';

class CardDisplay extends StatelessWidget {
  const CardDisplay({super.key, required this.cardName});

  final String cardName;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.primaryContainer,
      child: SizedBox(
        width: double.infinity,
        height: 200,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              cardName,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimaryContainer,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
