import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:wasfat_akl/widgets/ads/banner_widget.dart';

class AdWidget extends StatefulWidget {
  final List<Widget> pageWidgets;

  const AdWidget({Key? key, required this.pageWidgets}) : super(key: key);
  @override
  _AdWidgetState createState() => _AdWidgetState();
}

class _AdWidgetState extends State<AdWidget> {
  late BannerAdController controller;
  bool _isLoaded = false;
  StreamSubscription<Map<BannerAdEvent, dynamic>>? _bannerEventSubscription;

  @override
  void initState() {
    controller = BannerAdController();
    controller.init();
    // onBannerAdListener();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    _bannerEventSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = context.mediaQuerySize;
    final bannerSize = Size(size.width, 60);
    return Stack(
      children: [
        Positioned.fill(
          child: CustomScrollView(
            slivers: [
              ...widget.pageWidgets,
              if (controller.isLoaded)
                SliverToBoxAdapter(
                  child: SizedBox.fromSize(size: bannerSize),
                )
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            constraints: BoxConstraints.loose(bannerSize),
            child: BannerWidget(controller),
          ),
        ),
      ],
    );
  }

  void onBannerAdListener() {
    _bannerEventSubscription = controller.onEvent.listen((e) {
      final event = e.keys.first;
      switch (event) {
        case BannerAdEvent.loading:
          print('loading');
          break;
        case BannerAdEvent.loaded:
          setState(() => _isLoaded = true);
          break;
        case BannerAdEvent.loadFailed:
          final errorCode = e.values.first;
          print('loadFailed $errorCode');
          break;
        case BannerAdEvent.impression:
          print('ad rendered');
          break;
        default:
          break;
      }
    });
  }
}

abstract class BannerAdWidget {
  factory BannerAdWidget.sliverList(List<Widget> children) {
    return BannerAdForList();
  }
}

class BannerAdForList extends BannerAdWidget {
  @override
  _BannerAdForListState createState() => _BannerAdForListState();
}

class _BannerAdForListState extends State<BannerAdForList> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
