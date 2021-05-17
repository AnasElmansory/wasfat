import 'package:flutter/material.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';

class AdmobProvider extends ChangeNotifier {
  int _interstitialCounter = 0;
  int get interstitialCounter => this._interstitialCounter;
  set interstitialCounter(int value) {
    this._interstitialCounter = value;
    notifyListeners();
  }

  AdmobProvider() {
    initIntersitial();
    this.addListener(() {
      if (this._interstitialCounter == 5) {
        if (this._interstitialAd.isLoaded) this._interstitialAd.show();
        this._interstitialCounter = 0;
      }
    });
  }

  void userNavigate() => this._interstitialCounter++;

  final _interstitialAd = InterstitialAd(unitId: InterstitialAd.testUnitId);
  InterstitialAd get interstitialAd => this._interstitialAd;
  Future<void> initIntersitial() async {
    _interstitialAd.init();
    await _interstitialAd.load();
  }

  @override
  void dispose() {
    this._interstitialAd.dispose();
    super.dispose();
  }
}
