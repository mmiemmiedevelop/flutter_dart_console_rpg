import 'character.dart';

class Monster {
  String name;
  int hp;
  int attackPower;
  int defensePower;

  Monster(this.name, this.hp, this.attackPower, this.defensePower);

  void attackCharacter(Character character) {}

  void showStatus() {}
}
