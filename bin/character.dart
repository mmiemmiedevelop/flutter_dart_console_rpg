import 'monster.dart';

class Character {
  final String name;
  final int hp;
  final int attackPower;
  final int defensePower;

  Character(this.name, this.hp, this.attackPower, this.defensePower);

  void attackMonster(Monster monster) {}

  void defend(int damage) {}

  void showStatus() {}
}
