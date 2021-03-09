import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wasfat_akl/models/food_category.dart';

class OneCategoryWidget extends StatelessWidget {
  final FoodCategory categoryObj;

  OneCategoryWidget(this.categoryObj);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Stack(
        children: [
          Positioned(
            height: size.height * 0.2,
            width: size.width * 0.5,
            child: Container(
              child: ClipRRect(
                // borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: categoryObj.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            width: size.width * 0.5,
            height: size.height * 0.05,
            child: Container(
              width: size.width * 0.5,
              height: size.height * 0.05,
              color: Colors.white60,
              child: Center(
                child: Text(
                  categoryObj.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
