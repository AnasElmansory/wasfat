import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// const _bannerUnitIdTest = 'ca-app-pub-3940256099942544/6300978111';
// const _interstitialUnitIdTest = 'ca-app-pub-3940256099942544/1033173712';

class Ads extends ChangeNotifier {
  InterstitialAd? _interstitialAd;
  BannerAd? bannerAd;

  bool _isBannerAdLoaded = false;
  bool get isBannerAdLoaded => this._isBannerAdLoaded;
  set isBannerAdLoaded(bool value) {
    this._isBannerAdLoaded = value;
    notifyListeners();
  }

  static const bannerAdHeight = 60;

  BannerAd loadBannerAd(int width) {
    final adSize = AdSize(
      width: width,
      height: bannerAdHeight,
    );
    final bannerAdListener = AdListener(
      onAdLoaded: (ad) async {
        final isLoaded = await ad.isLoaded();
        isBannerAdLoaded = isLoaded;
      },
      onAdFailedToLoad: (ad, error) async {
        print(error.message);
      },
      onAdOpened: (ad) {
        print('adopened');
      },
      onAdClosed: (ad) {
        print('adclosed');
      },
    );

    bannerAd = BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: adSize,
      request: const AdRequest(),
      listener: bannerAdListener,
    );
    bannerAd!.load();
    return bannerAd!;
  }

  InterstitialAd loadInterstitialAd() {
    final interstitialAdListener = AdListener(
      onAdLoaded: (ad) async {
        final isLoaded = await ad.isLoaded();
        if (isLoaded) _interstitialAd?.show();
      },
      onAdFailedToLoad: (ad, error) async {
        print(error.message);
      },
      onAdOpened: (ad) async {
        print('adopened');
      },
      onAdClosed: (ad) async {
        print('adclosed');
      },
    );
    _interstitialAd = InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      request: const AdRequest(),
      listener: interstitialAdListener,
    );
    _interstitialAd!.load();
    notifyListeners();
    return _interstitialAd!;
  }

  void disposeBanner() {
    bannerAd?.dispose();
    bannerAd = null;
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    bannerAd?.dispose();
    super.dispose();
  }
}
