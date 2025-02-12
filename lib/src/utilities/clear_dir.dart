import 'dart:io';

Future<void> clearDirectory(String directoryPath) async {
  final dir = Directory(directoryPath);

  if (await dir.exists()) {
    List<FileSystemEntity> entities = await dir.list(recursive: false).toList();

    for (var entity in entities) {
      if (entity is File) {
        await entity.delete();
        print('Deleted file: ${entity.path}');
      } else if (entity is Directory) {
        await entity.delete(recursive: true);
        print('Deleted directory: ${entity.path}');
      }
    }
  } else {
    print('Directory does not exist: $directoryPath');
  }
}
