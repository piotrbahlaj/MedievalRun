import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:medieval_runner/components/background.dart';
import 'package:medieval_runner/components/coin.dart';
import 'package:medieval_runner/components/obstacle.dart';
import 'package:medieval_runner/components/player.dart';
import 'package:medieval_runner/components/scoreboard.dart';
import 'package:medieval_runner/game_setup.dart';

void main() {
  final game = MedievalRun();
  runApp(GameSetup(game: game));
  WidgetsFlutterBinding.ensureInitialized();
}

class MedievalRun extends FlameGame with TapDetector, HasCollisionDetection {
  late Player _player;
  late Background _background;
  late Timer _spawnObstacleTimer;
  late Timer _spawnCoinTimer;
  CharacterType selectedCharacter = CharacterType.knight;
  LevelType selectedLevel = LevelType.forest;
  DifficultyLevel difficultyLevel = DifficultyLevel.medium;
  bool isGameStarted = false;
  bool isGameOver = false;
  bool isPaused = false;
  bool bgmMuted = false;
  bool sfxMuted = false;
  int scoreboardCoins = 0;
  int collectedCoins = 0;
  double baseSpeedMultiplier = 50.0;
  double get componentSpeed => difficultyLevel.speed * baseSpeedMultiplier;

  @override
  Future<void> onLoad() async {
    // setup
    await super.onLoad();
    FlameAudio.bgm.initialize();
    Flame.device.setLandscape();

    // adds background
    _background = Background(
      levelType: selectedLevel,
      difficultyLevel: difficultyLevel,
    );
    add(_background);

    // start screen overlay
    overlays.add('StartScreen');

    // initialize player
    _player = Player(characterType: selectedCharacter);

    // initializes timer for spawning objects
    _spawnObstacleTimer = Timer(
      10 / difficultyLevel.speed,
      onTick: _spawnObstacle,
      repeat: true,
    );
    _spawnCoinTimer = Timer(
      2,
      onTick: _spawnCoin,
      repeat: true,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    _spawnObstacleTimer.update(dt);
    _spawnCoinTimer.update(dt);
  }

  void startGame() {
    isGameStarted = true;
    overlays.remove('StartScreen');
    Scoreboard scoreboard = Scoreboard();
    add(scoreboard);
    add(_player);
    _spawnObstacleTimer.start();
    _spawnCoinTimer.start();
    FlameAudio.bgm.play('background_ost_1.mp3');
  }

  void _spawnCoin() {
    if (!isGameStarted) return;
    add(Coin(difficultyLevel: difficultyLevel));
  }

  void _spawnObstacle() {
    if (!isGameStarted) return;
    final random = Random();
    int obstacleCount = random.nextInt(2) + 1;
    for (int i = 0; i < obstacleCount; i++) {
      double offset = i * random.nextInt(10).toDouble() + 40;
      add(Obstacle(
        levelType: selectedLevel,
        difficultyLevel: difficultyLevel,
        offset: offset,
      ));
    }
  }

  void selectDifficulty(DifficultyLevel selectedDifficulty) {
    difficultyLevel = selectedDifficulty;
    overlays.remove('DifficultySelection');
    resetGame();
  }

  void changeCharacterType(CharacterType characterType) {
    selectedCharacter = characterType;
    _player.removeFromParent();
    _player = Player(characterType: selectedCharacter);
    add(_player);
    overlays.remove('CharacterSelection');
    resetGame();
  }

  void changeLevel(LevelType levelType) {
    selectedLevel = levelType;
    _background.removeFromParent();
    _background = Background(
      levelType: selectedLevel,
      difficultyLevel: difficultyLevel,
    );
    add(_background);
    overlays.remove('LevelSelection');
    resetGame();
  }

  void collectCoin() {
    scoreboardCoins += 1;
  }

  void pauseGame() {
    if (!isGameStarted) return;
    isPaused = true;
    pauseEngine();
    overlays.add('PauseMenu');
  }

  void resumeGame() {
    isPaused = false;
    resumeEngine();
    overlays.remove('PauseMenu');
  }

  void toggleBGM() {
    bgmMuted = !bgmMuted;
    if (bgmMuted) {
      FlameAudio.bgm.pause();
    } else {
      FlameAudio.bgm.resume();
    }
  }

  void toggleSFX() {
    sfxMuted = !sfxMuted;
  }

  void gameOver() {
    isGameOver = true;
    pauseEngine();
    overlays.add('GameOver');
    if (!bgmMuted) {
      FlameAudio.bgm.stop();
    }
  }

  void resetGame() {
    isGameOver = false;
    collectedCoins += scoreboardCoins;
    scoreboardCoins = 0;
    overlays.remove('GameOver');
    resumeEngine();
    removeAll(children);
    add(_background);
    add(_player);
    add(Scoreboard());
    if (!bgmMuted) {
      FlameAudio.bgm.play('background_ost_1.mp3');
    }
  }

  @override
  void onTap() {
    if (!isGameOver) _player.jump();
  }
}
