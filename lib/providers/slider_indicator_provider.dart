import 'package:flutter/material.dart';

class SliderIndicatorProvider extends ChangeNotifier {
  int _current = 0;

  int get current => _current;

  set current(int page) {
    _current = page;
    notifyListeners();
  }
}
