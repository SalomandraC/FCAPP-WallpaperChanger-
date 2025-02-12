import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart' show rootBundle;

class WallpaperServiceAnimated {
  Timer? _timer;
  List<String> _imagePaths = [];
  int _currentIndex = 0;
  static const int maxRetries = 8;

  Future<void> setWallpaper(String imgPath) async {
    try {
      final imageName = imgPath.split('\\').last;
      final directory = await getApplicationSupportDirectory();
      final exePath =
          p.join(directory.path, 'lib', 'src', 'plugins', 'FSCplugin.exe');
      final imagePath =
          p.join(directory.path, 'assets', 'fonsAnimated', imageName);
      if (!File(imagePath).existsSync()) {
        print('Image file not found: $imagePath');
        return;
      }
      ProcessResult result = await Process.run(exePath, [imagePath]);
      if (result.exitCode == 0) {
        print('Wallpaper set successfully!');
      } else {
        print('Failed to set wallpaper: ${result.stderr}');
      }
    } catch (e) {
      print('Ошибка при установке обоев: $e');
    }
  }

  Future<void> copyImageToTemp(String sourcePath, String destDir) async {
    final directory = Directory(destDir);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final fileName = p.basename(sourcePath);
    final destPath = p.join(destDir, fileName);

    final sourceFile = File(sourcePath);
    if (!await sourceFile.exists()) {
      print('Source file not found: $sourcePath');
      return;
    }

    await sourceFile.copy(destPath);
    print('Copied: $sourcePath to $destPath');
  }

  Future<void> startCyclicWallpaperChange(String folderPath) async {
    final appSupportDir = (await getApplicationSupportDirectory()).path;
    await copyAssetTo('lib/src/plugins/FSCplugin.exe',
        p.join(appSupportDir, 'lib', 'src', 'plugins'));
    final directory = await getApplicationSupportDirectory();
    final tempFolderPath = p.join(directory.path, 'assets', 'fonsAnimated');
    final sourceFolderPath = 'assets/fonsAnimated/$folderPath';

    final tempDir = Directory(tempFolderPath);
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
    await tempDir.create(recursive: true);

    final sourceDir = Directory(sourceFolderPath);
    if (!await sourceDir.exists()) {
      print('Source folder not found: $sourceFolderPath');
      return;
    }

    _imagePaths = sourceDir
        .listSync()
        .where((entity) => entity is File && entity.path.endsWith('.jpg'))
        .map((entity) => entity.path)
        .toList();

    if (_imagePaths.isNotEmpty) {
      _timer = Timer.periodic(Duration(milliseconds: 180), (timer) async {
        final currentImagePath = _imagePaths[_currentIndex];
        await copyImageToTemp(currentImagePath, tempFolderPath);
        final tempImagePath =
            p.join(tempFolderPath, p.basename(currentImagePath));
        await setWallpaper(tempImagePath);
        final tempImageFile = File(tempImagePath);
        if (await tempImageFile.exists()) {
          await tempImageFile.delete();
          print('Deleted: $tempImagePath');
        }
        _currentIndex = (_currentIndex + 1) % _imagePaths.length;
      });
    } else {
      print('No images found in the folder: $folderPath');
    }
  }

  void stopCyclicWallpaperChange() {
    _timer?.cancel();
    _timer = null;
    cleanUpTemporaryFiles();
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
  }

  Future<void> cleanUpTemporaryFiles() async {
    final directory = await getApplicationSupportDirectory();
    final tempFolderPath = p.join(directory.path, 'assets', 'fonsAnimated');
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        final tempDir = Directory(tempFolderPath);
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
          print('Temporary files cleaned up: $tempFolderPath');
        }
      } catch (e) {}
    }
  }
}
