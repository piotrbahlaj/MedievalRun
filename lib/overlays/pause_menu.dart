import 'package:flutter/material.dart';
import 'package:medieval_runner/main.dart';

class PauseMenuOverlay extends StatelessWidget {
  const PauseMenuOverlay({super.key, required this.game});
  final MedievalRun game;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                game.resumeGame();
              },
              child: const Text('Resume'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                game.overlays.remove('PauseMenu');
                game.overlays.add('CharacterSelection');
              },
              child: const Text('Change Character'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                game.overlays.remove('PauseMenu');
                game.overlays.add('LevelSelection');
              },
              child: const Text('Change Level'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                game.overlays.remove('PauseMenu');
                game.overlays.add('DifficultySelection');
              },
              child: const Text('Change Difficulty'),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Row(
                  children: [
                    StatefulBuilder(
                      builder: (context, setState) => Checkbox(
                        side: const BorderSide(color: Colors.white),
                        value: game.bgmMuted,
                        onChanged: (bool? value) {
                          setState(() {
                            game.toggleBGM();
                          });
                        },
                      ),
                    ),
                    const Text(
                      'Mute BGM',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 20),
                    Row(
                      children: [
                        StatefulBuilder(
                          builder: (context, setState) => Checkbox(
                            side: const BorderSide(color: Colors.white),
                            value: game.sfxMuted,
                            onChanged: (bool? value) {
                              setState(() {
                                game.toggleSFX();
                              });
                            },
                          ),
                        ),
                        const Text(
                          'Mute SFX',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 60,
                  width: 60,
                  child: Image.asset('assets/images/coin.png'),
                ),
                Text(
                  'Coins collected: ${game.collectedCoins}',
                  style: const TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 60,
                  width: 60,
                  child: Image.asset('assets/images/coin.png'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
