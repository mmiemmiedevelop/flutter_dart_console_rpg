import 'character.dart';
import 'entity.dart';
import 'dart:math';

class Monster extends Entity {
  final String name;
  int hp;
  final int attackPower; // 랜덤으로 결정된 실제 공격력
  final int attackPowerMax; // 텍스트에서 읽어온 최대 공격력
  final int defense = 0; // 몬스터 방어력은 항상 0

  Monster(String name, this.hp, this.attackPowerMax, int characterDefensePower)
    : name = name,
      attackPower = max(
        Random().nextInt(attackPowerMax) + 1,
        characterDefensePower,
      );

  @override
  void attack(Entity target) {
    if (target is Character) {
      int damageDealt = max(0, attackPower - target.defensePower);
      print('$name이(가) ${target.name}에게 ${damageDealt}의 데미지를 입혔습니다.');
      target.takeDamage(damageDealt);
    }
  }

  void showStatus() {
    print('$name - 체력: $hp, 공격력: $attackPower');
  }

  void takeDamage(int damage) {
    hp -= damage;
  }
}
