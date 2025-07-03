import 'dart:io';
import 'character.dart';
import 'assetManager.dart';
import 'monster.dart';

late Character character; //전역변수 선언
late List<Monster> monsters; //전역변수 선언

void main(List<String> arguments) {
  String name = getCharacterName();
  loadCharacterStats(name); // 캐릭터 데이터 로드
  loadMonsterStats(); // 몬스터 데이터 로드
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
