import 'dart:io';
import '../store/folder_info.dart';

List<MyFolderInfo> parseFoldersFromDirectory(String folderPath) {
  List<MyFolderInfo> folders = [];

  final Directory directory = Directory(folderPath);
  final List<FileSystemEntity> entities = directory.listSync();

  for (final entity in entities) {
    if (entity is Directory) {
      final String folderName = entity.uri.pathSegments.length > 1
          ? entity.uri.pathSegments[entity.uri.pathSegments.length - 2]
          : entity.uri.pathSegments.last;
      final String folderPath = entity.path.replaceAll(r'\', '/');
      final List<FileSystemEntity> files = entity.listSync();
      String imgPath = '';
      if (files.isNotEmpty) {
        imgPath = files.first.path.replaceAll(r'\', '/');
      }

      folders.add(MyFolderInfo(folderName, folderPath, imgPath));
    }
  }
  return folders;
}
