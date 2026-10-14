import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class VaultStorage {
  static Future<Directory> get vaultDirectory async {
    final dir = await getApplicationDocumentsDirectory();
    final vaultDir = Directory(p.join(dir.path, 'vault_videos'));
    if (!await vaultDir.exists()) {
      await vaultDir.create(recursive: true);
    }
    return vaultDir;
  }

  static Future<List<VaultFile>> listVideos() async {
    final dir = await vaultDirectory;
    final files = dir.listSync().whereType<File>().toList();
    return files.map((f) => VaultFile(
      path: f.path,
      name: p.basename(f.path),
      size: f.lengthSync(),
      modified: f.lastModifiedSync(),
    )).toList();
  }

  static Future<void> deleteVideo(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  static Future<String> get vaultInfoPath async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, 'vault_info.json');
  }

  static Future<Map<String, dynamic>> loadInfo() async {
    final path = await vaultInfoPath;
    final file = File(path);
    if (await file.exists()) {
      return jsonDecode(await file.readAsString());
    }
    return {};
  }

  static Future<void> saveInfo(Map<String, dynamic> info) async {
    final path = await vaultInfoPath;
    final file = File(path);
    await file.writeAsString(jsonEncode(info));
  }
}

class VaultFile {
  final String path;
  final String name;
  final int size;
  final DateTime modified;

  VaultFile({required this.path, required this.name, required this.size, required this.modified});
}
