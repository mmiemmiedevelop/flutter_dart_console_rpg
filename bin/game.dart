import 'character.dart';
import 'monster.dart';

class Game {
  Character character;
  List<Monster> monsters;
  int killedMonsters;

  Game(this.character, this.monsters, this.killedMonsters);

  void startGame() {}

  void battle() {}

  void getRandomMonster() {}
}
