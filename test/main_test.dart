import 'package:test/test.dart';
import '../bin/character.dart';
import '../bin/monster.dart';

void main() {
  group('Character', () {
    test('공격 시 몬스터 HP 감소', () {
      final c = Character('용사', 30, 10, 5);
      final m = Monster('고블린', 20, 10, 0);
      c.attack(m);
      expect(m.hp, lessThan(20));
    });

    test('방어 시 체력 회복', () {
      final c = Character('용사', 10, 10, 5);
      final heal = c.defend(15); // 몬스터 공격력 15
      expect(heal, 10);
      expect(c.hp, 20);
    });

    test('특수 아이템 사용 시 공격력 2배', () {
      final c = Character('용사', 30, 10, 5);
      final m = Monster('슬라임', 20, 10, 0);
      c.useSpecialItem();
      c.attack(m);
      // 첫 공격은 20 데미지, 이후 아이템 비활성화
      expect(m.hp, 0);
      expect(c.isItemActive, isFalse);
      expect(c.isItemOnlyOnce, isTrue);
    });

    test('HP가 0 이하로 떨어지면 죽은 상태로 간주', () {
      final c = Character('용사', 5, 10, 5);
      final m = Monster('고블린', 20, 10, 0);
      m.attack(c);
      m.attack(c);
      expect(c.hp, lessThanOrEqualTo(0));
    });

    test('방어력이 몬스터 공격력보다 높으면 회복 없음', () {
      final c = Character('용사', 10, 10, 20);
      final heal = c.defend(5); // 몬스터 공격력 5, 방어력 20
      expect(heal, 0);
      expect(c.hp, 10);
    });

    test('특수 아이템 중복 사용 불가', () {
      final c = Character('용사', 30, 10, 5);
      c.useSpecialItem();
      c.useSpecialItem(); // 두 번째 사용 시 효과 없음
      expect(c.isItemActive, isTrue); // 두 번째 호출은 상태 변화 없음
      c.attack(Monster('슬라임', 20, 10, 0));
      expect(c.isItemActive, isFalse);
      expect(c.isItemOnlyOnce, isTrue);
      c.useSpecialItem(); // 이미 사용했으므로 불가
      expect(c.isItemActive, isFalse);
    });
  });

  group('Monster', () {
    test('공격 시 캐릭터 HP 감소', () {
      final c = Character('용사', 30, 10, 5);
      final m = Monster('오크', 20, 10, 0);
      m.attack(c);
      expect(c.hp, lessThan(30));
    });

    test('3턴마다 방어력 증가', () {
      final m = Monster('드래곤', 100, 20, 0);
      expect(m.defense, 0);
      m.increaseDefenseIfNeeded();
      m.increaseDefenseIfNeeded();
      m.increaseDefenseIfNeeded();
      expect(m.defense, 2);
      m.increaseDefenseIfNeeded();
      m.increaseDefenseIfNeeded();
      m.increaseDefenseIfNeeded();
      expect(m.defense, 4);
    });

    test('방어력 증가 후 공격 시 데미지 변화', () {
      final c = Character('용사', 30, 10, 5);
      final m = Monster('드래곤', 100, 20, 0);
      m.increaseDefenseIfNeeded();
      m.increaseDefenseIfNeeded();
      m.increaseDefenseIfNeeded(); // 방어력 2 증가
      final prevHp = c.hp;
      m.attack(c);
      expect(c.hp, lessThan(prevHp));
    });

    test('몬스터가 데미지를 받아 HP가 0이 되면 죽음', () {
      final m = Monster('좀비', 10, 5, 0);
      m.takeDamage(5);
      expect(m.hp, 5);
      m.takeDamage(5);
      expect(m.hp, 0);
      m.takeDamage(10);
      expect(m.hp, lessThanOrEqualTo(0));
    });
  });
}
