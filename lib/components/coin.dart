import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:medieval_runner/components/player.dart';
import 'package:medieval_runner/game_setup.dart';
import 'package:medieval_runner/main.dart';

class Coin extends SpriteComponent with HasGameRef<MedievalRun>, CollisionCallbacks {
  Coin({required this.difficultyLevel}) : super(size: Vector2(60, 60));
  bool isCollected = false;
  DifficultyLevel difficultyLevel;

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('coin.png');
    position = _randomizePosition();
    anchor = Anchor.center;
    add(CircleHitbox(radius: 20, position: Vector2(10, 10)));
  }

  Vector2 _randomizePosition() {
    final random = Random();
    double randomY = 100 + Random().nextDouble() * (300 - 100);
    double randomX = gameRef.size.x + random.nextInt(500).toDouble();
    return Vector2(randomX, randomY);
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
    if (other is Player && !isCollected) {
      isCollected = true;
      gameRef.collectCoin();
      if (!gameRef.sfxMuted) {
        FlameAudio.play('coin_sound.aiff');
      }
      add(
        ScaleEffect.to(Vector2.zero(), EffectController(duration: 0.3, reverseDuration: 0)),
      );
      add(
        OpacityEffect.fadeOut(EffectController(duration: 0.3, reverseDuration: 0)),
      );

      Future.delayed(const Duration(milliseconds: 300), () {
        removeFromParent();
      });
    }
    super.onCollision(intersectionPoints, other);
  }
}
