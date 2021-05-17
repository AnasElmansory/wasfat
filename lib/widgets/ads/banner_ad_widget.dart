import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:wasfat_akl/widgets/ads/banner_widget.dart';

class BannerAdForSliverList extends StatefulWidget {
  final List<Widget> pageWidgets;

  const BannerAdForSliverList({Key? key, required this.pageWidgets})
      : super(key: key);
  @override
  _BannerAdForSliverListState createState() => _BannerAdForSliverListState();
}

class _BannerAdForSliverListState extends State<BannerAdForSliverList> {
  late BannerAdController controller;
  @override
  void initState() {
    controller = BannerAdController();
    controller.init();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
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
}

class BannerAdWidget {
  static sliverList(List<Widget> children) {
    return BannerAdForList();
  }

  static list(List<Widget> children) {
    return BannerAdForSliverList(pageWidgets: children);
  }
}
