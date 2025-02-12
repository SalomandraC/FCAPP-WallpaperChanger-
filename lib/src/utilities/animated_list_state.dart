import 'dart:io';
import 'package:flutter/material.dart';
import '../store/folder_info.dart';

class MyFolderImageProvider extends ChangeNotifier {
  List<MyFolderInfo> _animatedList = [];
  List<MyFolderInfo> get animatedList => _animatedList;

  void setAnimatedList(List<MyFolderInfo> animatedList) {
    _animatedList = animatedList;
    notifyListeners();
  }

  void changeName(
      List<MyFolderInfo> animatedList, int index, String newName) async {
    if (index >= 0 && index < animatedList.length) {
      final oldFolderInfo = animatedList[index];
      final oldDirectory =
          Directory('assets/fonsAnimated/${oldFolderInfo.name}');
      if (!await oldDirectory.exists()) {
        print('Старая директория не существует.');
        return;
      }
      final newDirectoryPath = 'assets/fonsAnimated/$newName';
      final newDirectory = Directory(newDirectoryPath);
      if (await newDirectory.exists()) {
        print('Директория с именем "$newName" уже существует.');
        return;
      }
      try {
        await oldDirectory.rename(newDirectoryPath);
        animatedList[index].name = newName;
      } catch (e) {
        print('Ошибка при переименовании директории: $e');
      }
    } else {
      throw RangeError('Index $index is out of range');
    }
  }
}
