import 'package:flutter/material.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';

class NativeAdWidget extends StatefulWidget {
  const NativeAdWidget();

  @override
  _NativeAdWidgetState createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  late NativeAdController _nativeAdController;

  @override
  void initState() {
    _nativeAdController = NativeAdController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: NativeAd(
        unitId: NativeAdController.testUnitId,
        buildLayout: smallAdTemplateLayoutBuilder,
        controller: _nativeAdController,
        builder: (context, child) {
          return Container(
            child: child,
          );
        },
      ),
    );
  }
}
