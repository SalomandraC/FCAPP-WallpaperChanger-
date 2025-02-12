import 'package:flutter/material.dart';

class PageState extends ChangeNotifier {
  int _selectedPage = 0;

  int get selectedPage => _selectedPage;

  void updateSelectedPage(int newPage) {
    _selectedPage = newPage;
    notifyListeners();
  }
}
