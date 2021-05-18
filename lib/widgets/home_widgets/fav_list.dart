import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/models/dish.dart';
import 'package:wasfat_akl/providers/dishes_preferences.dart';
import 'package:wasfat_akl/utils/navigation.dart';
import 'package:wasfat_akl/widgets/ads/banner_wrap_list.dart';
import 'package:wasfat_akl/widgets/ads/native_ad_widget.dart';
import 'package:wasfat_akl/widgets/dish_widgets/dish_tile.dart';

import '../core/confirmation_dialog.dart';
import '../core/one_card_widget.dart';

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
      height: forHomePageView ? size.height * 0.25 : size.height,
      child: BannerWrapList(
        listType: ListType.ListBuilder,
        visible: !forHomePageView,
        listBuilder: _favouritelistBuilder(preferences, animation),
      ),
    );
  }

  Widget _favouritelistBuilder(
    DishesPreferencesProvider preferences,
    Animation<double> animation,
  ) =>
      ListView.separated(
        scrollDirection: forHomePageView ? Axis.horizontal : Axis.vertical,
        itemCount: preferences.favouriteDishes.length,
        separatorBuilder: (context, index) {
          final size = context.mediaQuerySize;
          final nativeAdContainerSize = Size(size.width, 150);
          final isAdIndex = ((index + 1) % 3 == 0);
          if (isAdIndex && !forHomePageView)
            return Container(
              constraints: BoxConstraints.loose(nativeAdContainerSize),
              child: const NativeAdWidget(),
            );
          else
            return Container();
        },
        itemBuilder: (context, index) {
          final dish = preferences.favouriteDishes[index];
          return ScaleTransition(
            scale: animation,
            child: forHomePageView
                ? _homePageWidget(context, dish)
                : _favPageWidget(animation, dish, context),
          );
        },
      );

  Widget _homePageWidget(BuildContext context, Dish dish) {
    final preferences = context.watch<DishesPreferencesProvider>();

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
        size: Size(size.width * 0.5, size.height * 0.25),
        textColor: Colors.white,
      ),
    );
  }

  Widget _favPageWidget(
    Animation<double> animation,
    Dish dish,
    BuildContext context,
  ) {
    return DishTile(
      dish: dish,
      animation: animation,
    );
  }
}
