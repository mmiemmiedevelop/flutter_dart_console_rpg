import 'character.dart';
import 'dart:math';

class Monster {
  final String name;
  int hp;
  final int attackPower; // 랜덤으로 결정된 실제 공격력
  final int attackPowerMax; // 텍스트에서 읽어온 최대 공격력
  final int defense = 0; // 몬스터 방어력은 항상 0

  Monster(this.name, this.hp, this.attackPowerMax)
    : attackPower = Random().nextInt(attackPowerMax) + 1;

  void attackCharacter(Character character) {
    int damageDealt = character.defend(attackPower);
    print('$name이(가) ${character.name}에게 ${damageDealt}의 데미지를 입혔습니다.');
  }

  void takeDamage(int damage) {
    int actualDamage = damage - defense;
    if (actualDamage < 0) actualDamage = 0;
    hp -= actualDamage;
  }

  void showStatus() {
    print('$name - 체력: $hp, 공격력: $attackPower');
  }
}
