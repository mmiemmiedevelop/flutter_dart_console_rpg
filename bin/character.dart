import 'monster.dart';
import 'entity.dart';

class Character extends Entity {
  final String name;
  int hp;
  final int attackPower;
  final int defensePower;

  Character(String name, this.hp, this.attackPower, this.defensePower)
    : name = name;

  @override
  void attack(Entity target) {
    if (target is Monster) {
      print('$name이(가) ${target.name}에게 $attackPower의 데미지를 입혔습니다.');
      target.takeDamage(attackPower);
    }
  }

  void showStatus() {
    print('$name - 체력: $hp, 공격력: $attackPower, 방어력: $defensePower');
  }

  void takeDamage(int damage) {
    hp -= damage;
  }

  int defend(int damage) {
    int reduced = (damage - defensePower).clamp(0, damage);
    hp -= reduced;
    return reduced;
  }
}
