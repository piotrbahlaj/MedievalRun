import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:medieval_runner/game_setup.dart';
import 'package:medieval_runner/main.dart';

enum LevelType { forest, dungeon }

class Background extends ParallaxComponent with HasGameRef {
  LevelType levelType;
  DifficultyLevel difficultyLevel;
  Background({required this.levelType, required this.difficultyLevel});

  late Parallax _parallax;

  @override
  Future<void> onLoad() async {
    final MedievalRun game = gameRef as MedievalRun;
    _parallax = await gameRef.loadParallax(
      await backgrounds(),
      baseVelocity: Vector2(game.componentSpeed, 0),
      velocityMultiplierDelta: Vector2(1.0, 1.0),
    );
    parallax = _parallax;
  }

  @override
  void update(double dt) {
    super.update(dt);
    final MedievalRun game = gameRef as MedievalRun;
    _parallax.baseVelocity = Vector2(game.componentSpeed, 0);
  }

  Future<List<ParallaxImageData>> backgrounds() async {
    switch (levelType) {
      case LevelType.forest:
        return [ParallaxImageData('background_forest.png')];
      case LevelType.dungeon:
        return [ParallaxImageData('background_dungeon.png')];
    }
  }
}
