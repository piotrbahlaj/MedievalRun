import 'package:flutter/material.dart';
import 'package:medieval_runner/main.dart';

class StartScreenOverlay extends StatelessWidget {
  const StartScreenOverlay({super.key, required this.game});
  final MedievalRun game;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.black.withOpacity(0.5),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Medieval Run',
              style: TextStyle(
                fontSize: 48,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                game.startGame();
              },
              child: const Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }
}
