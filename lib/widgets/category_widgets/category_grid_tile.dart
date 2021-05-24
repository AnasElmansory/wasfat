import 'package:flutter/material.dart';
import 'package:wasfat_akl/models/food_category.dart';
import 'package:wasfat_akl/widgets/core/cached_image.dart';

class CategoryGridTile extends StatelessWidget {
  final FoodCategory category;
  final Size? size;
  const CategoryGridTile({Key? key, required this.category, this.size})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    print('build gridTile');
    return GridTile(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(children: [
          Positioned.fill(child: CachedImage(url: category.imageUrl)),
          Positioned(
            bottom: 0,
            width: size?.width,
            height: size?.height,
            child: Container(
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                    Colors.black,
                    Colors.black54,
                    Colors.black12,
                    Color.fromRGBO(255, 255, 255, 0.2)
                  ])),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    category.name,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
