import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/models/dish.dart';

import 'package:wasfat_akl/providers/dishes_provider.dart';
import 'package:wasfat_akl/providers/food_category_provider.dart';
import 'package:wasfat_akl/widgets/ads/banner_wrap_list.dart';
import 'package:wasfat_akl/widgets/ads/native_ad_widget.dart';
import 'package:wasfat_akl/widgets/category_widgets/category_custom_bar.dart';
import 'package:wasfat_akl/widgets/dish_widgets/dish_tile.dart';

class FoodCategoryPage extends StatefulWidget {
  final String foodCategoryId;

  const FoodCategoryPage({Key? key, required this.foodCategoryId})
      : super(key: key);

  @override
  _FoodCategoryPageState createState() => _FoodCategoryPageState();
}

class _FoodCategoryPageState extends State<FoodCategoryPage> {
  @override
  void initState() {
    context
        .read<DishesProvider>()
        .handleDishesPagination(widget.foodCategoryId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('build FoodCategoryPage');
    final dishesProvider = context.watch<DishesProvider>();
    final categoryProvider = context.watch<FoodCategoryProvider>();
    final category = categoryProvider.getCategory(widget.foodCategoryId)!;

    return Scaffold(
      body: BannerWrapList(
        listType: ListType.Sliver,
        pageWidgets: [
          CategoryCustomBar(category: category),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 8.0),
            sliver: PagedSliverList(
              pagingController: dishesProvider.getPagingController(category.id),
              builderDelegate: PagedChildBuilderDelegate<Dish>(
                itemBuilder: (context, dish, index) {
                  final size = context.mediaQuerySize;
                  final isAdIndex = index % 3 == 0 && index != 0;
                  final nativeAdContainerSize = Size(size.width, 150);
                  return Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isAdIndex)
                          Container(
                            constraints:
                                BoxConstraints.loose(nativeAdContainerSize),
                            child: const NativeAdWidget(),
                          ),
                        DishTile(dish: dish),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
