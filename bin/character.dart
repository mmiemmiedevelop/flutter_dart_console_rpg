import 'monster.dart';

class Character {
  final String name;
  int hp;
  final int attackPower;
  final int defensePower;

  Character(this.name, this.hp, this.attackPower, this.defensePower);

  void attackMonster(Monster monster) {
    print('$name이(가) ${monster.name}에게 ${attackPower}의 데미지를 입혔습니다.\n');
    monster.takeDamage(attackPower);
  }

  int defend(int damage) {
    int reduced = (damage - defensePower).clamp(0, damage);
    hp -= reduced;
    return reduced;
  }

  void showStatus() {
    print('$name - 체력: $hp, 공격력: $attackPower, 방어력: $defensePower');
  }
}
