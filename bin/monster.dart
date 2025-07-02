import 'character.dart';
import 'dart:math';

class Monster {
  final String name;
  final int hp;
  final int attackPower; // 랜덤으로 결정된 실제 공격력
  final int attackPowerMax; // 텍스트에서 읽어온 최대 공격력

  Monster(this.name, this.hp, this.attackPowerMax)
    : attackPower = Random().nextInt(attackPowerMax) + 1; // 0이상 공격력을 위해 +1

  void attackCharacter(Character character) {}

  void showStatus() {}
}
