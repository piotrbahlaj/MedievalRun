import 'package:flutter/material.dart';
import 'package:medieval_runner/game_setup.dart';
import 'package:medieval_runner/main.dart';

class DifficultySelectionOverlay extends StatefulWidget {
  final MedievalRun game;

  const DifficultySelectionOverlay({super.key, required this.game});

  @override
  State<DifficultySelectionOverlay> createState() => _DifficultySelectionOverlayState();
}

class _DifficultySelectionOverlayState extends State<DifficultySelectionOverlay> {
  double _sliderValue = 1; // 0 for easy, 1 for medium, 2 for hard

  DifficultyLevel get _currentDifficulty {
    if (_sliderValue < 0.5) {
      return DifficultyLevel.easy;
    } else if (_sliderValue < 1.5) {
      return DifficultyLevel.medium;
    } else {
      return DifficultyLevel.hard;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Difficulty Level',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Easy', style: TextStyle(color: Colors.white)),
                Text('Medium', style: TextStyle(color: Colors.white)),
                Text('Hard', style: TextStyle(color: Colors.white)),
              ],
            ),
            Slider(
              value: _sliderValue,
              min: 0,
              max: 2,
              divisions: 2, // Ensures snapping to 0, 1, or 2
              onChanged: (value) {
                setState(() {
                  _sliderValue = value;
                });
              },
              activeColor: Colors.orange,
              inactiveColor: Colors.white,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.game.selectDifficulty(_currentDifficulty);
              },
              child: const Text('Change Difficulty'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.game.overlays.remove('DifficultySelection');
                widget.game.overlays.add('PauseMenu');
              },
              child: const Text('Back to Menu'),
            ),
          ],
        ),
      ),
    );
  }
}
