import 'character.dart';

class Monster {
  String name;
  int hp;
  int attackPowerMax;

  Monster(this.name, this.hp, this.attackPowerMax);

  void attackCharacter(Character character) {}

  void showStatus() {}

  @override
  String toString() {
    return 'Monster(name: $name, hp: $hp, attackPowerMax: $attackPowerMax)';
  }
}
