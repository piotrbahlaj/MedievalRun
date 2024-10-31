import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:medieval_runner/components/background.dart';
import 'package:medieval_runner/components/player.dart';
import 'package:medieval_runner/game_setup.dart';
import 'package:medieval_runner/main.dart';

class Obstacle extends SpriteComponent with HasGameRef<MedievalRun>, CollisionCallbacks {
  Obstacle({required this.levelType, required this.difficultyLevel, this.offset = 0.0});
  final LevelType levelType;
  final DifficultyLevel difficultyLevel;
  final double offset;
  @override
  Future<void> onLoad() async {
    await _loadObstacle();
    position = _randomizePosition();
  }

  Future<void> _loadObstacle() async {
    switch (levelType) {
      case LevelType.forest:
        sprite = await gameRef.loadSprite('obstacle_campfire.png');
        size = Vector2(80, 80);
        add(CircleHitbox(radius: 20, position: Vector2(17, 18)));
        break;
      case LevelType.dungeon:
        sprite = await gameRef.loadSprite('obstacle_barrel.png');
        size = Vector2(60, 80);
        add(RectangleHitbox(size: Vector2(38, 60), position: Vector2(13, 10)));
        break;
    }
  }

  Vector2 _randomizePosition() {
    final random = Random();
    double groundY = 250;
    double randomX = gameRef.size.x + offset + random.nextInt(200).toDouble();
    return Vector2(randomX, groundY);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= gameRef.componentSpeed * dt;
    if (position.x < -size.x) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      gameRef.gameOver();
      if (!gameRef.sfxMuted) {
        FlameAudio.play('game_over_sound.wav');
      }
    }
    super.onCollision(intersectionPoints, other);
  }
}
