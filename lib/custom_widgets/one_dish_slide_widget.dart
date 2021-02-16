import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wasfat_akl/models/dish.dart';

class OneDishSlideWidget extends StatelessWidget {
  final Dish dishObj;
  final Size size;

  const OneDishSlideWidget({Key key, this.dishObj, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        width: size.width,
        child: Stack(
          children: [
            Positioned(
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: dishObj.dishImages[0],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: size.width,
                height: size.height * 0.05,
                color: Colors.white54,
                child: Center(
                  child: Text(dishObj.name),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
