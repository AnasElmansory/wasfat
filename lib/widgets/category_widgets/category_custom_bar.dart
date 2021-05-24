import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:wasfat_akl/models/food_category.dart';
import 'package:wasfat_akl/widgets/core/cached_image.dart';
import 'package:wasfat_akl/widgets/core/show_image_dialog.dart';

class CategoryCustomBar extends StatefulWidget {
  final FoodCategory category;
  const CategoryCustomBar({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  _CategoryCustomBarState createState() => _CategoryCustomBarState();
}

class _CategoryCustomBarState extends State<CategoryCustomBar> {
  FoodCategory get category => widget.category;

  @override
  Widget build(BuildContext context) {
    final size = context.mediaQuerySize;

    final imageBottomMargin = 24.0;
    final expandedHeight = size.height * .3;
    return SliverLayoutBuilder(
      builder: (BuildContext context, SliverConstraints constraints) {
        final height = constraints.scrollOffset;
        final isExpanded = height <= (expandedHeight * 0.5);

        return SliverAppBar(
          backgroundColor:
              isExpanded ? Colors.white : Colors.amber[800],
          expandedHeight: expandedHeight,
          title: Text(
            isExpanded ? '' : category.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          pinned: true,
          stretch: true,
          flexibleSpace: InkWell(
            onTap: () async => await showDialog(
              context: context,
              builder: (_) => ShowImageDialog(
                photoUrl: category.imageUrl,
              ),
            ),
            child: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Positioned.fill(
                    bottom: imageBottomMargin,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: const Radius.circular(100),
                      ),
                      child: CachedImage(url: category.imageUrl),
                    ),
                  ),
                  Positioned(
                    height: size.height * 0.06,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: const Radius.circular(30),
                            bottomLeft: const Radius.circular(30)),
                        color: Colors.amber[700],
                      ),
                      child: Center(
                        child: Text(
                          category.name,
                          textDirection: TextDirection.rtl,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
