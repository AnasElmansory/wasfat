import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/providers/dish_comments_provider.dart';

class RatingBarWidget extends StatelessWidget {
  const RatingBarWidget();

  @override
  Widget build(BuildContext context) {
    final size = context.mediaQuerySize;
    final commentProvider = context.watch<DishCommentProvider>();
    return Container(
      margin: const EdgeInsets.all(12.0),
      width: size.width,
      child: Column(
        children: [
          RatingBar.builder(
            initialRating: commentProvider.getRateValue.toDouble(),
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: const Color(0xFFFFA000),
            ),
            onRatingUpdate: (rating) =>
                commentProvider.setRateValue = rating.floor(),
          ),
        ],
      ),
    );
  }
}
