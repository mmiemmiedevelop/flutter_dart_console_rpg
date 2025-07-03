import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'character.dart';
import 'assetManager.dart';
import 'monster.dart';

late Character character; //전역변수 선언
late List<Monster> monsters; //전역변수 선언
late List<Monster> killedMonsters; // 죽인 몬스터 리스트

void main(List<String> arguments) {
  //게임시작 전
  String name = getCharacterName();
  loadCharacterStats(name); // 캐릭터 데이터 로드
  loadMonsterStats(); // 몬스터 데이터 로드
  killedMonsters = []; // 죽인 몬스터 리스트 초기화

  gameStart();
}

//0. 게임 시작 함수
void gameStart() {
  // 랜덤 몬스터 선택
  Monster? monster = getRandomMonster();
  print('게임을 시작합니다!');
  character.showStatus();
  print('\n새로운 몬스터가 나타났습니다!');
  monster?.showStatus(); //몬스터 널체크는 다음줄에서 하기때문에 타입캐스팅 안전함

  while (monster != null) {
    stdout.write('\n${character.name}의 턴\n행동을 선택하세요 (1. 공격  2. 방어): ');
    String? input = stdin.readLineSync();
    if (input == '1') {
      character.attackMonster(monster);
      // 몬스터가 죽었는지 체크
      if (monster.hp <= 0) {
        print('${monster.name}을(를) 물리쳤습니다!');
        killedMonsters.add(monster); // 죽인 몬스터 리스트에 추가
        if (killedMonsters.length == monsters.length) {
          print('모든 몬스터를 물리쳤습니다! 게임 클리어!');
          exit(0);
        }
        stdout.write('다음 몬스터와 싸우시겠습니까? (y/n): \n');
        String? nextInput = stdin.readLineSync();
        if (nextInput == null || nextInput.toLowerCase() != 'y') {
          exit(0);
        }
        // 새로운 몬스터 랜덤 선택 (죽인 몬스터 제외)
        monster = getRandomMonster(current: monster);
        if (monster == null) {
          print('더 이상 남은 몬스터가 없습니다!');
          exit(0);
        }
        print('\n새로운 몬스터가 나타났습니다!');
        monster.showStatus();
        continue;
      }
    } else if (input == '2') {
      int blocked = character.defend(monster.attackPower);
      print('${character.name}이(가) 방어 태세를 취하여 $blocked 만큼 피해를 막았습니다.\n');
    } else {
      print('잘못된 입력입니다. 다시 입력하세요.');
      continue;
    }

    // 몬스터가 살아있으면 자동 공격
    if (monster.hp > 0) {
      print('${monster.name}의 턴');
      monster.attackCharacter(character);
      // 캐릭터가 죽었는지 체크
      if (character.hp <= 0) {
        print('\n당신은 패배했습니다...');
        exit(0);
      }
    }
    character.showStatus();
    monster.showStatus();
  }
}

Monster? getRandomMonster({Monster? current}) {
  final random = Random();
  // 죽인 몬스터를 제외한 리스트 생성
  final available = monsters.where((m) => !killedMonsters.contains(m)).toList();
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

//1. 파일로부터 데이터 읽어오기 기능
/// 캐릭터 데이터 로드 함수
void loadCharacterStats(String name) {
  try {
    // assets/characters.txt 읽기
    final assetMgr = AssetManager();
    final file = assetMgr.getAssetFile('characters.txt');
    final contents = file.readAsStringSync().trim();

    // "HP,ATK,DEF" 형식으로 분할
    final stats = contents.split(',');
    if (stats.length != 3) {
      throw FormatException('Invalid character data: $contents');
    }

    // 파싱
    int health = int.parse(stats[0]);
    int attack = int.parse(stats[1]);
    int defense = int.parse(stats[2]);

    // 캐릭터 생성 (입력받은 이름 사용)
    character = Character(name, health, attack, defense);
  } catch (e) {
    stderr.writeln('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
  }
}

/// 몬스터 데이터 로드 함수 (리스트)
void loadMonsterStats() {
  try {
    final assetMgr = AssetManager();
    final file = assetMgr.getAssetFile('monsters.txt');

    // 파일 전체를 한 줄씩 읽어 리스트로 반환
    final lines = file
        .readAsLinesSync()
        .map((line) => line.trim())
        .where((l) => l.isNotEmpty);

    monsters = []; // 리스트 초기화

    for (var line in lines) {
      // "이름,HP,ATK" 형식으로 분할
      final parts = line.split(',');
      if (parts.length != 3) {
        throw FormatException('Invalid monster data: $line');
      }

      // 파싱
      final name = parts[0];
      final hp = int.parse(parts[1]);
      final attackPowerMax = int.parse(parts[2]);

      monsters.add(Monster(name, hp, attackPowerMax));
    }
  } catch (e) {
    stderr.writeln('몬스터 데이터를 불러오는 데 실패했습니다: $e');
  }
}

// 2. 사용자로부터 캐릭터 이름 입력받기 기능 > whil문으로 제대로 입력해야 이름 저장되고 게임시작
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
