import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/providers/banner_provider.dart';
import 'package:wasfat_akl/utils/constants.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget();

  @override
  _BannerWidgetState createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget>
    with SingleTickerProviderStateMixin {
  late BannerAdController _bannerController;
  late AnimationController _animationController;
  StreamSubscription? _subscription;
  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: kTabScrollDuration)
          ..forward();
    _bannerController = BannerAdController();
    listen();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bannerController.dispose();
    _subscription?.cancel();
    super.dispose();
  }

  void listen() {
    final bannerProvider = context.read<BannerProvider>();
    _subscription = _bannerController.onEvent.listen((event) {
      final value = event.keys.first;
      if (value == BannerAdEvent.loading) {
        bannerProvider.isloading = true;
        bannerProvider.isloaded = false;
        bannerProvider.loadingFailed = false;
      } else if (value == BannerAdEvent.loaded) {
        bannerProvider.isloaded = true;
        bannerProvider.loadingFailed = false;
        bannerProvider.isloading = false;
      } else if (value == BannerAdEvent.loadFailed) {
        bannerProvider.loadingFailed = true;
        bannerProvider.isloaded = false;
        bannerProvider.isloading = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animationController,
      child: BannerAd(
        unitId: bannerUnitId,
        size: BannerSize.ADAPTIVE,
        controller: _bannerController,
        builder: (context, child) {
          return Container(
            child: child,
          );
        },
      ),
    );
  }
}
