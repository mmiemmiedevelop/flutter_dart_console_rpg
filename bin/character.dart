import 'monster.dart';

class Character {
  String name;
  int hp;
  int attackPower;
  int defensePower;

  Character(this.name, this.hp, this.attackPower, this.defensePower);

  void attackMonster(Monster monster) {}

  void defend(int damage) {}

  void showStatus() {}
}
