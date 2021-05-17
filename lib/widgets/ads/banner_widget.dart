import 'package:flutter/material.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';

class BannerWidget extends StatelessWidget {
  final BannerAdController controller;
  const BannerWidget(this.controller);

  @override
  Widget build(BuildContext context) {
    return BannerAd(
      unitId: BannerAdController.testUnitId,
      size: BannerSize.ADAPTIVE,
      controller: controller,
      builder: (context, child) {
        return Container(
          child: child,
        );
      },
    );
  }
}
