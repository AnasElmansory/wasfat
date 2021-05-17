import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/get_it.dart';
import 'package:wasfat_akl/providers/ad_provider.dart';

import 'package:wasfat_akl/providers/dishes_preferences.dart';
import 'package:wasfat_akl/providers/dishes_provider.dart';
import 'package:wasfat_akl/providers/food_category_provider.dart';
import 'package:wasfat_akl/providers/slider_indicator_provider.dart';
import 'package:wasfat_akl/utils/internet_helper.dart';
import 'package:wasfat_akl/utils/navigation.dart';
import 'package:wasfat_akl/widgets/ads/banner_widget.dart';
import 'package:wasfat_akl/widgets/category_widgets/category_grid_tile.dart';
import 'package:wasfat_akl/widgets/core/divider_widget.dart';
import 'package:wasfat_akl/widgets/home_widgets/fav_list.dart';
import 'package:wasfat_akl/widgets/home_widgets/home_drawer.dart';
import 'package:wasfat_akl/widgets/home_widgets/last_visited_list.dart';
import 'package:wasfat_akl/widgets/home_widgets/slide_show.dart';
import 'package:wasfat_akl/widgets/home_widgets/slide_show_indicator.dart';

class HomePage extends StatelessWidget {
  const HomePage();

  @override
  Widget build(BuildContext context) {
    final foodProvider = context.watch<FoodCategoryProvider>();
    final dishesProvider = context.watch<DishesProvider>();
    final preferences = context.watch<DishesPreferencesProvider>();
    final size = context.mediaQuerySize;
    checkConnectionAndFirstTimeToApp(context);

    return Scaffold(
      drawer: const HomeDrawer(),
      appBar: AppBar(
        title: const Text(
          'وصفات',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        height: size.height,
        child: LiquidPullToRefresh(
          onRefresh: () async {
            await foodProvider.getFoodCategories();
            await dishesProvider.getDishesRecentlyAdded();
          },
          backgroundColor: Colors.white,
          color: const Color(0xFFFFA000),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  const DividerWidget(
                      dividerName: "أطباق جديدة", marginTop: 18),
                  Container(
                    child: ChangeNotifierProvider(
                      create: (_) => SliderIndicatorProvider(),
                      builder: (context, _) {
                        final recentDishesExist =
                            dishesProvider.recentlyAddedDishes.isNotEmpty;
                        final categoriesExists =
                            foodProvider.categories.isNotEmpty;
                        if (!recentDishesExist || !categoriesExists)
                          return Container(
                            // 18 to compensate sizedbox and indicators heights till i find another way :)
                            height: (size.height * 0.3) + 18,
                            width: size.width * 0.8,
                            child: const Center(
                              child: const SpinKitThreeBounce(
                                size: 30,
                                color: Colors.amber,
                              ),
                            ),
                          );
                        else
                          return Column(
                            children: [
                              const SlideShow(),
                              const SizedBox(height: 8),
                              const SlideShowIndicator(),
                            ],
                          );
                      },
                    ),
                  ),
                  const DividerWidget(
                    dividerName: "اقسام",
                    marginTop: 2.0,
                    marginBottom: 4.0,
                  ),
                  Container(
                    height: size.height * .5,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: foodProvider.topCategories.isEmpty
                        ? const Center(
                            child: const SpinKitThreeBounce(
                              size: 30,
                              color: Colors.amber,
                            ),
                          )
                        : _buildCategories(context),
                  ),
                  if (preferences.favouriteDishes.isNotEmpty)
                    const DividerWidget(dividerName: "الأطباق المفضله"),
                  if (preferences.favouriteDishes.isNotEmpty)
                    const FavList(forHomePageView: true),
                  if (preferences.lastVisitedDishes.isNotEmpty)
                    const DividerWidget(dividerName: "شاهدتُ من قبل"),
                  if (preferences.lastVisitedDishes.isNotEmpty)
                    const LastVisitedList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildCategories(BuildContext context) {
  final foodProvider = context.watch<FoodCategoryProvider>();
  final size = context.mediaQuerySize;
  final categorySize = Size.square(size.width * 0.5);
  return GridView.builder(
    itemCount: 4,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
    ),
    itemBuilder: (context, index) {
      final category = (index != 3) ? foodProvider.topCategories[index] : null;
      if (index == 3)
        return InkWell(
            onTap: () async => await navigateToMoreCategoriesPage(),
            child: GridTile(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFFFA000),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add,
                      size: 40,
                      color: Colors.white,
                    ),
                    const Text(
                      'المزيد',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ));
      else {
        return InkWell(
          onTap: () async => await navigateToCategoryPage(category!.id),
          child: CategoryGridTile(
            category: category!,
            size: categorySize,
          ),
        );
      }
    },
  );
}
