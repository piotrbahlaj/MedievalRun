import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:medieval_runner/main.dart';

enum CharacterType { knight, mage, rogue }

class Player extends SpriteComponent with HasGameRef<MedievalRun>, CollisionCallbacks {
  static const double gravity = 1000;
  static const double jumpVelocity = -300;

  CharacterType characterType;
  Vector2 velocity = Vector2(0, 0);
  int jumpCount = 0;

  Player({required this.characterType}) : super(size: Vector2(100, 100));

  @override
  Future<void> onLoad() async {
    await _loadCharacter();
    position = Vector2(80, 230);

    add(RectangleHitbox(size: Vector2(57, 80), position: Vector2(25, 10)));
  }

  Future<void> _loadCharacter() async {
    switch (characterType) {
      case CharacterType.knight:
        sprite = await gameRef.loadSprite('character_knight.png');
        break;
      case CharacterType.mage:
        sprite = await gameRef.loadSprite('character_mage.png');
        break;
      case CharacterType.rogue:
        sprite = await gameRef.loadSprite('character_rogue.png');
        break;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (jumpCount > 0) {
      velocity.y += gravity * dt;
    }
    position += velocity * dt * 3;

    if (position.y >= 230) {
      position.y = 230;
      jumpCount = 0;
      velocity.y = 0;
    }
  }

  void jump() {
    if (jumpCount < 2) {
      velocity.y = jumpVelocity;
      jumpCount++;
      if (!gameRef.sfxMuted) {
        FlameAudio.play('jump_sound.wav');
      }
    }
  }
}
