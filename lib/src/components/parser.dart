import 'dart:io';
import '../store/image_info.dart';

List<MyImageInfo> parseImagesFromFolder(String folderPath) {
  List<MyImageInfo> images = [];

  final Directory directory = Directory(folderPath);
  final List<FileSystemEntity> files = directory.listSync();

  for (final file in files) {
    if (file is File && file.path.endsWith('.jpg')) {
      final String fileName = file.uri.pathSegments.last;
      final String filePath = file.path.replaceAll(r'\', '/');
      images.add(MyImageInfo(fileName, filePath));
    }
  }
  return images;
}
