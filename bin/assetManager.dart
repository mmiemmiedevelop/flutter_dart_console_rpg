import 'dart:io';

/// AssetManager: assets 폴더 파싱
class AssetManager {
  /// 프로젝트 루트를 기준으로 assets 디렉터리 경로 계산
  final Directory assetsDir;

  AssetManager()
    : assetsDir = Directory(
        '${Directory.current.path}${Platform.pathSeparator}assets',
      );

  /// 모든 파일 반환
  List<File> listAllAssets() {
    if (!assetsDir.existsSync()) {
      stderr.writeln('ERROR: assets 폴더(${assetsDir.path})를 찾을 수 없습니다.');
      exit(1);
    }
    return assetsDir.listSync(recursive: true).whereType<File>().toList();
  }

  /// 확장자 필터: .txt 파일만
  List<File> listTxtFiles() =>
      listAllAssets().where((f) => f.path.endsWith('.txt')).toList();

  /// 특정 파일 이름으로 File 객체 반환 > 재사용 가능
  File getAssetFile(String name) {
    try {
      return listTxtFiles().firstWhere(
        (f) => f.path.split(Platform.pathSeparator).last == name,
      );
    } catch (e) {
      stderr.writeln('ERROR: assets/$name 파일을 찾을 수 없습니다.');
      exit(1);
    }
  }
}
