import 'package:flutter/material.dart';

class CurrentImg extends ChangeNotifier {
  String _selectIMG = 'assets/error.jpg';

  String get selectedIMG => _selectIMG;

  void updateSelectIMG(String curIMG) {
    _selectIMG = curIMG;
    notifyListeners();
  }
}
