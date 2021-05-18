import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:wasfat_akl/widgets/ads/banner_widget.dart';

class BannerWrapList extends StatefulWidget {
  final List<Widget>? pageWidgets;
  final Widget? listBuilder;
  final ListType listType;
  final ScrollController? controller;
  final bool visible;
  const BannerWrapList({
    Key? key,
    this.pageWidgets,
    this.listBuilder,
    this.visible = true,
    this.controller,
    required this.listType,
  })  : assert(pageWidgets != null || listBuilder != null),
        super(key: key);
  @override
  _BannerWrapListState createState() => _BannerWrapListState();
}

class _BannerWrapListState extends State<BannerWrapList> {
  late BannerAdController controller;
  late StreamSubscription subscription;
  late List<Widget> sliverChildren;
  late List<Widget> children;

  @override
  void initState() {
    controller = BannerAdController();
    controller.init();
    subscription = controller.onEvent.listen((event) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = context.mediaQuerySize;
    final bannerSize = Size(size.width, 60);
    if (widget.pageWidgets != null && widget.listType == ListType.Sliver)
      sliverChildren = [
        ...widget.pageWidgets!,
        if (controller.isLoaded)
          SliverToBoxAdapter(
            child: SizedBox.fromSize(size: bannerSize),
          )
      ];
    else if (widget.pageWidgets != null && widget.listType == ListType.Normal)
      children = [
        ...widget.pageWidgets!,
        if (controller.isLoaded) SizedBox.fromSize(size: bannerSize)
      ];

    Widget buildList() {
      if (widget.listType == ListType.Sliver)
        return CustomScrollView(
          controller: widget.controller,
          slivers: sliverChildren,
        );
      else if (widget.listType == ListType.ListBuilder)
        return Container(
          child: widget.listBuilder,
        );
      else
        return SingleChildScrollView(
          controller: widget.controller,
          child: Container(
            child: Column(
              children: children,
            ),
          ),
        );
    }

    return Stack(
      children: [
        Positioned.fill(
          bottom:
              (controller.isLoaded && widget.listType == ListType.ListBuilder)
                  ? bannerSize.height
                  : 0,
          child: buildList(),
        ),
        if (widget.visible)
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

enum ListType {
  Normal,
  Sliver,
  ListBuilder,
}
