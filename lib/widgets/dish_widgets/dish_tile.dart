import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/models/dish.dart';
import 'package:wasfat_akl/providers/dishes_preferences.dart';
import 'package:wasfat_akl/utils/navigation.dart';
import 'package:wasfat_akl/widgets/core/cached_image.dart';

class DishTile extends StatelessWidget {
  final Dish dish;
  final Animation<double> animation;

  const DishTile({Key? key, required this.dish, required this.animation})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = context.mediaQuerySize;
    final preferences = context.watch<DishesPreferencesProvider>();
    return ScaleTransition(
      scale: animation,
      child: GFListTile(
          margin: const EdgeInsets.all(0),
          padding: const EdgeInsets.all(2),
          title: Align(
            alignment: Alignment.centerRight,
            child: Text(
              dish.name,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subTitle: AutoSizeText(
            dish.subtitle ?? '',
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
          ),
          icon: Container(
            height: size.height * 0.2,
            width: size.width * 0.4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedImage(
                url: dish.dishImages?.first ?? '',
              ),
            ),
          ),
          avatar: IconButton(
              icon: preferences.favouriteDishes.contains(dish)
                  ? const Icon(
                      Icons.favorite,
                      size: 30,
                      color: Colors.red,
                    )
                  : const Icon(
                      Icons.favorite_border,
                      color: Colors.grey,
                      size: 30,
                    ),
              onPressed: () async {
                if (preferences.favouriteDishes.contains(dish))
                  await preferences.removeFavouriteDish(dish);
                else
                  await preferences.addFavouriteDish(dish);
              }),
          onTap: () async => await navigateToOneDishPage(dish)),
    );
  }
}
