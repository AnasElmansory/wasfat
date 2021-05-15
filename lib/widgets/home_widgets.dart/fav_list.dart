import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/models/dish.dart';
import 'package:wasfat_akl/providers/dishes_preferences.dart';
import 'package:wasfat_akl/providers/food_category_provider.dart';
import 'package:wasfat_akl/utils/navigation.dart';
import 'package:wasfat_akl/widgets/cached_image.dart';

import '../core/confirmation_dialog.dart';
import '../one_card_widget.dart';

class FavList extends HookWidget {
  final bool forHomePageView;

  const FavList({Key? key, this.forHomePageView = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final animation = useAnimationController(duration: kTabScrollDuration)
      ..forward();
    final size = context.mediaQuerySize;
    final preferences = context.watch<DishesPreferencesProvider>();
    return Container(
      height: forHomePageView ? size.height * 0.2 : size.height,
      child: ListView.builder(
        scrollDirection: forHomePageView ? Axis.horizontal : Axis.vertical,
        itemCount: preferences.favouriteDishes.length,
        itemBuilder: (context, index) {
          final dish = preferences.favouriteDishes[index];
          return ScaleTransition(
            scale: animation,
            child: forHomePageView
                ? _homePageWidget(context, dish)
                : _favPageWidget(animation, dish, context),
          );
        },
      ),
    );
  }

  Widget _homePageWidget(BuildContext context, Dish dish) {
    final preferences = context.watch<DishesPreferencesProvider>();
    final categoryProvider = context.watch<FoodCategoryProvider>();

    final category = categoryProvider.getCategory(dish.categoryId.first)!;

    final size = context.mediaQuerySize;
    return InkWell(
      onTap: () async => await navigateToOneDishPage(dish),
      onLongPress: () async {
        final result = await showDialog<bool>(
          barrierDismissible: false,
          context: context,
          builder: (context) => confirmationDialog(
            'قائمه الأطباق المفضلة',
            '.هل تريد ازاله هذا الطبق من القائمة',
            true,
            context,
          ),
        );
        if (result ?? false) await preferences.removeFavouriteDish(dish);
      },
      child: OneCardWidget(
        name: dish.name,
        imageUrl: dish.dishImages?.first ?? '',
        size: Size(size.width * 0.5, size.height * 0.2),
        textColor: Colors.white,
      ),
    );
  }

  Widget _favPageWidget(
    Animation<double> animation,
    Dish dish,
    BuildContext context,
  ) {
    final prefernces = context.watch<DishesPreferencesProvider>();
    final size = context.mediaQuerySize;
    final categoryProvider = context.watch<FoodCategoryProvider>();
    final category = categoryProvider.getCategory(dish.categoryId.first);
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
          subTitle: Text(
            dish.subtitle ?? '',
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
          ),
          icon: Container(
            height: size.height * 0.2,
            width: size.width * 0.4,
            child: CachedImage(url: dish.dishImages?.first ?? ''),
          ),
          avatar: IconButton(
              icon: prefernces.favouriteDishes.contains(dish)
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
                if (prefernces.favouriteDishes.contains(dish))
                  await prefernces.removeFavouriteDish(dish);
                else
                  await prefernces.addFavouriteDish(dish);
              }),
          onTap: () async => await navigateToOneDishPage(dish)),
    );
  }
}
