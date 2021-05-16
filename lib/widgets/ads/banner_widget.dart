import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wasfat_akl/providers/ad_provider.dart';

class BannerWidget extends StatefulWidget {
  final int width;
  const BannerWidget(this.width);
  @override
  _BannerWidgetState createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  late BannerAd _bannerAd;
  @override
  void initState() {
    _bannerAd = context.read<Ads>().loadBannerAd(widget.width);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = context.mediaQuerySize.width;
    print(_bannerAd.size.height);
    return Container(
      constraints: BoxConstraints.loose(Size(width, 60)),
      child: AdWidget(ad: _bannerAd),
    );
  }
}
