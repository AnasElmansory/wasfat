import 'dart:async';

import 'package:flutter/material.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:wasfat_akl/utils/constants.dart';

class NativeAdWidget extends StatefulWidget {
  const NativeAdWidget();

  @override
  _NativeAdWidgetState createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late NativeAdController _nativeAdController;
  late StreamSubscription _subscription;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: kTabScrollDuration,
    )..forward();
    _nativeAdController = NativeAdController();
    _subscription = _nativeAdController.onEvent.listen((event) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _nativeAdController.dispose();
    _subscription.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animationController,
      child: Container(
        child: NativeAd(
          unitId: nativeUnitId,
          buildLayout: smallAdTemplateLayoutBuilder,
          controller: _nativeAdController,
          builder: (context, child) {
            return Container(
              height: !_nativeAdController.isLoaded ? 0 : null,
              child: child,
            );
          },
        ),
      ),
    );
  }
}
