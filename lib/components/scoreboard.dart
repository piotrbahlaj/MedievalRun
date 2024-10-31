import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:medieval_runner/main.dart';

class Scoreboard extends PositionComponent with HasGameRef<MedievalRun> {
  late TextComponent scoreText;
  late SpriteComponent coinIcon;

  @override
  void onLoad() async {
    await super.onLoad();
    final coin = await gameRef.loadSprite('coin.png');
    coinIcon = SpriteComponent(
      sprite: coin,
      size: Vector2(40, 40),
    )..position = Vector2(10, 25);
    add(coinIcon);
    scoreText = TextComponent(
      text: 'x 0',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    )..position = Vector2(60, 30);
    add(scoreText);
  }

  @override
  void update(double dt) {
    super.update(dt);
    scoreText.text = 'x ${gameRef.scoreboardCoins}';
  }
}
