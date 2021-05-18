import 'dart:collection';

import 'package:flutter/cupertino.dart';

class ExpandCommentProvider extends ChangeNotifier {
  // bool _isAllExpanded = false;
  // bool get isAllExpanded => _isAllExpanded;
  // set isAllExpanded(bool value) {
  //   _isAllExpanded = value;
  //   notifyListeners();
  // }
  HashMap<String, bool> _commentExpanstion = HashMap();

  bool isAllExpanded() {
    final value = this._commentExpanstion.isEmpty
        ? true
        : this._commentExpanstion.containsValue(true);
    notifyListeners();
    return value;
  }

  void expandAll() {
    this._commentExpanstion.updateAll((key, value) => true);
    notifyListeners();
  }

  void collapseAll() {
    this._commentExpanstion.updateAll((key, value) => false);
    notifyListeners();
  }

  void expandOneComment(String commentId) {
    this._commentExpanstion.update(commentId, (value) => true);
    notifyListeners();
  }

  void collapseOneComment(String commentId) {
    this._commentExpanstion.update(commentId, (value) => false);
    notifyListeners();
  }

  bool isExpanded(String commentId, bool inCommentPage) {
    return this._commentExpanstion.putIfAbsent(commentId, () => inCommentPage);
  }
}
