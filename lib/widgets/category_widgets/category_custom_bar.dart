import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  double _barHeight = 0.0;
  FoodCategory get category => widget.category;

  @override
  Widget build(BuildContext context) {
    final size = context.mediaQuerySize;
    final padding = context.mediaQueryPadding;

    return SliverAppBar(
      backgroundColor: (_barHeight == (kToolbarHeight + padding.top))
          ? Colors.amber[700]
          : (_barHeight < 90)
          ? Colors.amber[500]
          : (_barHeight < 120)
          ? Colors.amber[300]
          : Colors.white70,
      expandedHeight: size.height * 0.3,
      title: Text(
        (_barHeight == (kToolbarHeight + padding.top)) ? category.name : '',
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
              setState(() => _barHeight = constraints.biggest.height);
            });
            return FlexibleSpaceBar(
              background: Stack(
                children: [
                  Positioned(
                    width: size.width,
                    height: size.height * 0.3,
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
            );
          },
        ),
      ),
    );
  }
}
