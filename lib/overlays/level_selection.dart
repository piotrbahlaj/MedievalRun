import 'package:flutter/material.dart';
import 'package:medieval_runner/components/background.dart';
import 'package:medieval_runner/main.dart';

class LevelSelectionOverlay extends StatefulWidget {
  final MedievalRun game;

  const LevelSelectionOverlay({super.key, required this.game});

  @override
  State<LevelSelectionOverlay> createState() => _LevelSelectionOverlayState();
}

class _LevelSelectionOverlayState extends State<LevelSelectionOverlay> {
  final PageController _pageController = PageController();
  int _selectedLevel = 0;
  final List<String> levelPreviews = [
    'assets/images/background_forest.png',
    'assets/images/background_dungeon.png',
  ];
  final List<String> _getLevelName = [
    'Forest',
    'Dungeon',
  ];
  final List<LevelType> _levels = [
    LevelType.forest,
    LevelType.dungeon,
  ];

  void _selectLevel() {
    widget.game.changeLevel(_levels[_selectedLevel]);
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
              'Level Selection',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 190,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _selectedLevel = index;
                  });
                },
                itemCount: levelPreviews.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 140,
                        child: Image.asset(
                          levelPreviews[index],
                          fit: BoxFit.fill,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            color: Colors.white,
                            onPressed: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _getLevelName[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            color: Colors.white,
                            onPressed: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _selectLevel,
              child: const Text('Select Level'),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {
                widget.game.overlays.remove('LevelSelection');
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
