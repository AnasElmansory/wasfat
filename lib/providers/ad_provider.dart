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
    this.addListener(() async {
      print('listening');
      if (this._interstitialCounter % 4 == 0) {
        await initIntersitial();
        this._interstitialCounter = 0;
      }
    });
  }

  static Future<void> showAppOpenAd() async {
    final appOpenAd = AppOpenAd(unitId: AppOpenAd.testUnitId);
    appOpenAd.init();
    await appOpenAd.load();
    await appOpenAd.show();
    appOpenAd.dispose();
  }

  void userNavigate() => interstitialCounter++;

  InterstitialAd? _interstitialAd;

  Future<void> initIntersitial() async {
    _interstitialAd = InterstitialAd(unitId: InterstitialAd.testUnitId);
    _interstitialAd!.init();
    await _interstitialAd!.load();
    await _interstitialAd!.show();
  }

  @override
  void dispose() {
    this._interstitialAd?.dispose();
    super.dispose();
  }
}
