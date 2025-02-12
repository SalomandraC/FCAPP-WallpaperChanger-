import 'dart:io';
import 'package:flutter/material.dart';
import '../store/image_info.dart';

class MyImageProvider extends ChangeNotifier {
  List<MyImageInfo> _images = [];

  List<MyImageInfo> get images => _images;

  void setImages(List<MyImageInfo> images) {
    _images = images;
    notifyListeners();
  }

  void changeName(List<MyImageInfo> images, int index, String newName) async {
    if (index >= 0 && index < _images.length) {
      final oldImage = _images[index];
      final oldFile = File('assets/fons/${oldImage.name}');

      final directory = oldFile.parent;
      final extension = oldImage.path.split('.').last;
      final newFilePath = '${directory.path}/$newName.$extension';

      final newFile = File(newFilePath);
      if (await newFile.exists()) {
        print('Файл с именем "$newName.$extension" уже существует.');
        return;
      }

      try {
        oldFile.renameSync(newFilePath);
        _images[index].name = '$newName.$extension';
        notifyListeners();
      } catch (e) {
        print('Ошибка при переименовании файла: $e');
      }
    } else {
      throw RangeError('Index $index is out of range');
    }
  }
}
