import 'package:flutter/foundation.dart';

class NavigationProvider extends ChangeNotifier {
  int _index = 0;

  int get index => _index;

  void setIndex(int index) {
    if (index == _index) return;
    _index = index;
    notifyListeners();
  }
}
