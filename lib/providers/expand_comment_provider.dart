import 'package:flutter/cupertino.dart';

class ExpandCommentProvider extends ChangeNotifier {
  bool _isAllExpanded = true;
  bool get isAllExpanded => _isAllExpanded;
  set isAllExpanded(bool value) {
    _isAllExpanded = value;
    notifyListeners();
  }
}
