import 'dart:io';
import 'dart:math';
import 'assetManager.dart';
import 'character.dart';
import 'monster.dart';

class Game {
  late Character character;
  late List<Monster> monsters;
  late List<Monster> killedMonsters;

  Game();

  void start() {
    loadCharacterStats();
    loadMonsterStats();
    killedMonsters = [];
    gameLoop();
  }

  // 0. 게임 로직 함수
  void gameLoop() {
    Monster? monster = getRandomMonster();
    print('게임을 시작합니다!');
    character.showStatus();
    print('\n새로운 몬스터가 나타났습니다!');
    monster?.showStatus();

    while (monster != null) {
      stdout.write('\n${character.name}의 턴\n행동을 선택하세요 (1. 공격  2. 방어): ');
      String? input = stdin.readLineSync();
      if (input == '1') {
        character.attack(monster);
        if (monster.hp <= 0) {
          print('${monster.name}을(를) 물리쳤습니다!');
          killedMonsters.add(monster);
          if (killedMonsters.length == monsters.length) {
            print('모든 몬스터를 물리쳤습니다! 게임 클리어!');
            gameEndisSaveFile();
            break;
          }
          stdout.write('다음 몬스터와 싸우시겠습니까? (y/n): \n');
          while (true) {
            String? nextInput = stdin.readLineSync();
            if (nextInput == null) {
              stderr.writeln('입력이 올바르지 않습니다.');
              continue;
            }
            nextInput = nextInput.trim().toLowerCase();
            if (nextInput == 'y') {
              monster = getRandomMonster(current: monster);
              if (monster == null) {
                print('더 이상 남은 몬스터가 없습니다!');
                gameEndisSaveFile();
                break;
              }
              print('\n새로운 몬스터가 나타났습니다!');
              monster.showStatus();
              break;
            } else if (nextInput == 'n') {
              gameEndisSaveFile();
              break;
            } else {
              stderr.writeln('y 또는 n으로 입력해주세요.');
            }
          }
          if (monster == null || character.hp <= 0) {
            break;
          }
          continue;
        }
      } else if (input == '2') {
        int blocked = character.defend(monster.attackPower);
        print('${character.name}이(가) 방어 태세를 취하여 $blocked 만큼 피해를 막았습니다.\n');
      } else {
        print('잘못된 입력입니다. 다시 입력하세요.');
        continue;
      }
      if (monster.hp > 0) {
        print('\n${monster.name}의 턴');
        monster.attack(character);
        if (character.hp <= 0) {
          print('\n당신은 패배했습니다...................');
          gameEndisSaveFile();
          break;
        }
      }
      character.showStatus();
      monster.showStatus();
    }
  }

  //0. 몬스터 랜덤 선택 함수(죽은 몬스터 제외)
  Monster? getRandomMonster({Monster? current}) {
    final random = Random();
    final available = monsters
        .where((m) => !killedMonsters.contains(m))
        .toList();
    if (available.isEmpty) {
      return null;
    }
    if (current == null || available.length == 1) {
      return available[random.nextInt(available.length)];
    }
    Monster newMonster;
    do {
      newMonster = available[random.nextInt(available.length)];
    } while (newMonster == current && available.length > 1);
    return newMonster;
  }

  // 1. 파일로부터 캐릭터 데이터 읽어오기 기능(캐릭터 객체 생성)
  void loadCharacterStats() {
    try {
      final assetMgr = AssetManager();
      final file = assetMgr.getAssetFile('characters.txt');
      final contents = file.readAsStringSync().trim();
      final stats = contents.split(',');
      if (stats.length != 3) {
        throw FormatException('Invalid character data: $contents');
      }
      int health = int.parse(stats[0]);
      int attack = int.parse(stats[1]);
      int defense = int.parse(stats[2]);
      String name = getCharacterName();
      character = Character(name, health, attack, defense);
      addBonusHp(); //30% 확률로 캐릭터 체력 보너스 부여
    } catch (e) {
      stderr.writeln('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
    }
  }

  // 1. 파일로부터 몬스터 데이터 읽어오기 기능(리스트 형태로 저장)
  void loadMonsterStats() {
    try {
      final assetMgr = AssetManager();
      final file = assetMgr.getAssetFile('monsters.txt');
      final lines = file
          .readAsLinesSync()
          .map((line) => line.trim())
          .where((l) => l.isNotEmpty);
      monsters = [];
      for (var line in lines) {
        final parts = line.split(',');
        if (parts.length != 3) {
          throw FormatException('Invalid monster data: $line');
        }
        final name = parts[0];
        final hp = int.parse(parts[1]);
        final attackPowerMax = int.parse(parts[2]);
        monsters.add(Monster(name, hp, attackPowerMax));
      }
    } catch (e) {
      stderr.writeln('몬스터 데이터를 불러오는 데 실패했습니다: $e');
    }
  }

  // 2. 사용자로부터 캐릭터 이름 입력받기 기능
  String getCharacterName() {
    String name = '';
    while (true) {
      stdout.write('캐릭터 이름을 입력하세요: ');
      String? input = stdin.readLineSync();
      if (input == null || input.trim().isEmpty) {
        stderr.writeln('이름을 올바르게 입력하세요.');
        continue;
      }
      if (!RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(input.trim())) {
        stderr.writeln('이름은 영문 또는 한글만 입력 가능합니다.');
        continue;
      }
      name = input.trim();
      break;
    }
    return name;
  }

  // 3. 게임 종료 후 결과를 파일에 저장하는 기능
  void gameEndisSaveFile() {
    while (true) {
      stdout.write('결과를 저장하시겠습니까? (y/n): ');
      String? input = stdin.readLineSync();
      if (input == null) {
        stderr.writeln('입력이 올바르지 않습니다.');
        continue;
      }
      input = input.trim().toLowerCase();
      if (input == 'y') {
        try {
          final file = File('result.txt');
          file.writeAsStringSync(
            '캐릭터 이름: ${character.name}, 남은 체력: ${character.hp}, 게임 결과: ${character.hp > 0 ? '승리' : '패배'}\n',
            mode: FileMode.append,
          );
          print('결과가 저장되었습니다.');
        } catch (e) {
          stderr.writeln('결과 저장에 실패했습니다: \\${e.toString()}');
        }
        break;
      } else if (input == 'n') {
        print('결과를 저장하지 않습니다.');
        break;
      } else {
        stderr.writeln('y 또는 n으로 입력해주세요.');
      }
    }
    exit(0);
  }

  // 30% 확률로 캐릭터 체력 보너스 부여
  void addBonusHp() {
    final random = Random();
    if (random.nextDouble() < 0.3) {
      character.hp += 10;
      print('보너스 체력을 얻었습니다! 현재 체력: ${character.hp}');
    }
  }
}
