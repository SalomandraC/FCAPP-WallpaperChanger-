import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart' show rootBundle;

class WallpaperService {
  static const int maxRetries = 8;
  Future<void> setWallpaper(String imageName) async {
    try {
      final directory = await getApplicationSupportDirectory();
      final exePath =
          p.join(directory.path, 'lib', 'src', 'plugins', 'FSCplugin.exe');
      final imagePath = p.join(directory.path, 'assets', 'fons', imageName);
      if (!File(imagePath).existsSync()) {
        print('Image file not found: $imagePath');
        return;
      }
      ProcessResult result = await Process.run(exePath, [imagePath]);
      if (result.exitCode == 0) {
        print('Wallpaper set successfully!');
        try {
          File(imagePath).deleteSync();
          print('Temporary image file deleted.');
        } catch (e) {
          print('Failed to delete temporary image file: $e');
        }
        try {
          File(exePath).deleteSync();
          print('Temporary EXE file deleted.');
        } catch (e) {
          print('Failed to delete temporary EXE file: $e');
        }
      } else {
        print('Failed to set wallpaper: ${result.stderr}');
      }
    } catch (e) {
      print('Ошибка при установке обоев: $e');
    }
  }

  Future<void> clearAssetsFolder() async {
    final directory = await getApplicationSupportDirectory();
    final directoryPath = p.join(directory.path, 'assets', 'fons');
    await _clearDirectory(directoryPath);
    print('Directory cleared successfully.');
  }

  Future<void> _clearDirectory(String path) async {
    final dir = Directory(path);
    if (await dir.exists()) {
      dir.delete(recursive: true);
    }
  }

  Future<void> copyAssetTo(String assetPath, String destDir) async {
    final directory = Directory(destDir);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    final fileName = p.basename(assetPath);
    final destPath = p.join(destDir, fileName);
    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List();
    final file = File(destPath);
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        final file = File(destPath);
        await file.writeAsBytes(bytes, flush: true);
        print('File copied successfully: $destPath');
        return;
      } catch (e) {
        print('Attempt $attempt failed: $e');
        if (attempt == maxRetries) {
          print('Failed to copy file after $maxRetries attempts: $e');
        }
        await Future.delayed(Duration(seconds: 1));
      }
    }
    await file.writeAsBytes(bytes, flush: true);
  }

  Future<void> copyAssets(String fileName) async {
    final appSupportDir = (await getApplicationSupportDirectory()).path;
    await copyAssetTo(
        'assets/fons/$fileName', p.join(appSupportDir, 'assets', 'fons'));
    await copyAssetTo('lib/src/plugins/FSCplugin.exe',
        p.join(appSupportDir, 'lib', 'src', 'plugins'));
  }
}
