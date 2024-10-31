import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:medieval_runner/main.dart';
import 'package:medieval_runner/overlays/character_selection.dart';
import 'package:medieval_runner/overlays/difficulty_selection.dart';
import 'package:medieval_runner/overlays/game_over.dart';
import 'package:medieval_runner/overlays/level_selection.dart';
import 'package:medieval_runner/overlays/pause_menu.dart';
import 'package:medieval_runner/overlays/start_screen.dart';

enum DifficultyLevel {
  easy(7.0),
  medium(10.0),
  hard(13.0);

  final double speed;
  const DifficultyLevel(this.speed);
}

class GameSetup extends StatelessWidget {
  const GameSetup({super.key, required this.game});
  final MedievalRun game;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            GameWidget(
              game: game,
              overlayBuilderMap: {
                'GameOver': (BuildContext context, MedievalRun game) {
                  return GameOverOverlay(game: game);
                },
                'PauseMenu': (BuildContext context, MedievalRun game) {
                  return PauseMenuOverlay(game: game);
                },
                'StartScreen': (BuildContext context, MedievalRun game) {
                  return StartScreenOverlay(game: game);
                },
                'CharacterSelection': (BuildContext context, MedievalRun game) {
                  return CharacterSelectionOverlay(game: game);
                },
                'LevelSelection': (BuildContext context, MedievalRun game) {
                  return LevelSelectionOverlay(game: game);
                },
                'DifficultySelection': (BuildContext context, MedievalRun game) {
                  return DifficultySelectionOverlay(game: game);
                }
              },
              initialActiveOverlays: const ['StartScreen'],
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.pause, size: 40, color: Colors.white),
                onPressed: () {
                  game.pauseGame();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
