import 'dart:math';
import 'monster.dart';
import 'entity.dart';

class Character extends Entity {
  final String name;
  int hp;
  final int attackPower;
  final int defensePower;
  bool isItemActive = false; // 한번만 사용했는지 확인
  bool isItemOnlyOnce = false; // 전체 게임에서 한 번 사용

  Character(String name, this.hp, this.attackPower, this.defensePower)
    : name = name;

  @override
  void attack(Entity target) {
    if (target is Monster) {
      int power = attackPower; //isItemActive ? attackPower * 2 : attackPower;
      print('$name이(가) ${target.name}에게 $power의 데미지를 입혔습니다.');
      target.takeDamage(power);
      if (isItemActive) {
        isItemActive = false;
        isItemOnlyOnce = true; // 아이템 사용
      }
    }
  }

  void showStatus() {
    print('$name - 체력: $hp, 공격력: $attackPower, 방어력: $defensePower');
  }

  void takeDamage(int damage) {
    hp -= damage;
  }

  int defend(int monsterAttackPower) {
    int heal = max(0, monsterAttackPower - defensePower);
    if (heal > 0) {
      hp += heal;
      return heal;
    }
    return 0;
  }

  // 특수 아이템 사용 기능(추가기능)
  void useSpecialItem() {
    if (isItemOnlyOnce) {
      print('특수 아이템은 한 번만 사용할 수 있습니다.');
      return;
    }
    if (!isItemActive) {
      isItemActive = true;
      print('특수 아이템을 사용했습니다! 이번 턴만 공격력이 두 배가 됩니다.');
    } else {
      print('이미 아이템을 사용했습니다.');
    }
  }
}
