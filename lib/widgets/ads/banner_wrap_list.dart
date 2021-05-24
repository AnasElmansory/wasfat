import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/providers/banner_provider.dart';
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
  late List<Widget> sliverChildren;
  late List<Widget> children;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      context.read<BannerProvider>().resetLoadingFailed();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bannerProvider = context.watch<BannerProvider>();
    final size = context.mediaQuerySize;
    final bannerSize = Size(size.width, 60);

    final loadFailed = bannerProvider.loadingFailed;
    final loaded = bannerProvider.isloaded;
    final loading = bannerProvider.isloading;

    if (widget.pageWidgets != null && widget.listType == ListType.Sliver)
      sliverChildren = [
        ...widget.pageWidgets!,
        if (loaded || loading)
          SliverToBoxAdapter(
            child: SizedBox.fromSize(size: bannerSize),
          )
      ];
    else if (widget.pageWidgets != null && widget.listType == ListType.Normal)
      children = [
        ...widget.pageWidgets!,
        if (loaded || loading) SizedBox.fromSize(size: bannerSize)
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
          bottom: ((loaded || loading) &&
                  widget.visible &&
                  widget.listType == ListType.ListBuilder)
              ? bannerSize.height
              : 0,
          child: buildList(),
        ),
        if (widget.visible && !loadFailed)
          Positioned(
            bottom: 0,
            child: Container(
              constraints: BoxConstraints.loose(bannerSize),
              child: const BannerWidget(),
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
