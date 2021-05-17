import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/models/dish.dart';
import 'package:wasfat_akl/providers/ad_provider.dart';

import 'package:wasfat_akl/providers/dishes_provider.dart';
import 'package:wasfat_akl/providers/food_category_provider.dart';
import 'package:wasfat_akl/utils/ad_widget.dart';
import 'package:wasfat_akl/widgets/ads/banner_widget.dart';
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

class _FoodCategoryPageState extends State<FoodCategoryPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    context
        .read<DishesProvider>()
        .handleDishesPagination(widget.foodCategoryId);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dishesProvider = context.watch<DishesProvider>();
    final categoryProvider = context.watch<FoodCategoryProvider>();
    final category = categoryProvider.getCategory(widget.foodCategoryId)!;

    return Scaffold(
      body: AdWidget(
        pageWidgets: [
          CategoryCustomBar(category: category),
          PagedSliverList(
            pagingController: dishesProvider.getPagingController(category.id),
            builderDelegate: PagedChildBuilderDelegate<Dish>(
              itemBuilder: (context, dish, index) {
                final size = context.mediaQuerySize;
                final isAdIndex = index % 5 == 0;
                return Container(
                  child: Column(
                    children: [
                      if (isAdIndex)
                        Container(
                          height: size.height * .2,
                          child: const NativeAdWidget(),
                        ),
                      DishTile(dish: dish, animation: _controller),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
