import 'package:flutter/material.dart';

class BannerProvider extends ChangeNotifier {
  bool _isloaded = false;
  bool get isloaded => this._isloaded;
  set isloaded(bool value) {
    this._isloaded = value;
    notifyListeners();
  }

  bool _isloading = true;
  bool get isloading => this._isloading;
  set isloading(bool value) {
    this._isloading = value;
    notifyListeners();
  }

  bool _loadingFailed = false;
  bool get loadingFailed => this._loadingFailed;
  set loadingFailed(bool value) {
    this._loadingFailed = value;
    notifyListeners();
  }

  void resetLoadingFailed() => loadingFailed = false;
}
