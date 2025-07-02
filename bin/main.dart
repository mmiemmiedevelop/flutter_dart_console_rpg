import 'dart:io';
import 'character.dart';
import 'assetManager.dart';
import 'monster.dart';

late Character character; //전역변수 선언
late List<Monster> monsters; //전역변수 선언

void main(List<String> arguments) {
  loadCharacterStats(); //캐릭터 데이터 로드
  loadMonsterStats(); //몬스터 데이터 로드
}

/// 캐릭터 데이터 로드 함수
void loadCharacterStats() {
  try {
    // assets/characters.txt 읽기
    final assetMgr = AssetManager();
    final file = assetMgr.getAssetFile('characters.txt');
    final contents = file.readAsStringSync().trim();

    // “HP,ATK,DEF” 형식으로 분할
    final stats = contents.split(',');
    if (stats.length != 3) {
      throw FormatException('Invalid character data: $contents');
    }

    // 파싱
    int health = int.parse(stats[0]);
    int attack = int.parse(stats[1]);
    int defense = int.parse(stats[2]);

    // 캐릭터 생성 (이름은 직접 지정 또는 추가 로직으로 가져오기)
    const String name = 'Hero'; //    String name = getCharacterName();
    character = Character(name, health, attack, defense);
  } catch (e) {
    stderr.writeln('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
    exit(1);
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
      // “이름,HP,ATK” 형식으로 분할
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
    exit(1);
  }
}
