import 'package:flutter/material.dart';
import 'package:medieval_runner/components/player.dart';
import 'package:medieval_runner/main.dart';

class CharacterSelectionOverlay extends StatefulWidget {
  const CharacterSelectionOverlay({super.key, required this.game});

  final MedievalRun game;

  @override
  State<CharacterSelectionOverlay> createState() => _CharacterSelectionOverlayState();
}

class _CharacterSelectionOverlayState extends State<CharacterSelectionOverlay> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  final List<CharacterType> _characters = [
    CharacterType.knight,
    CharacterType.mage,
    CharacterType.rogue,
  ];

  void _selectCharacter() {
    widget.game.changeCharacterType(_characters[_currentPage]);
  }

  final List<String> _getCharacterName = ['Knight', 'Mage', 'Rogue'];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Character',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (_currentPage > 0) {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 195,
                  width: 150,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _characters.length,
                    onPageChanged: (int index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Image.asset(
                            _getCharacterImage(_characters[index]),
                            fit: BoxFit.contain,
                          ),
                          Text(
                            _getCharacterName[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (_currentPage < _characters.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _selectCharacter,
              child: const Text('Select Character'),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {
                widget.game.overlays.remove('CharacterSelection');
                widget.game.overlays.add('PauseMenu');
              },
              child: const Text('Back to Menu'),
            ),
          ],
        ),
      ),
    );
  }

  String _getCharacterImage(CharacterType type) {
    switch (type) {
      case CharacterType.knight:
        return 'assets/images/character_knight.png';
      case CharacterType.mage:
        return 'assets/images/character_mage.png';
      case CharacterType.rogue:
        return 'assets/images/character_rogue.png';
    }
  }
}
