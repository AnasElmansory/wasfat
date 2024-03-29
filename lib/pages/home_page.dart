import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

import 'package:wasfat_akl/providers/dishes_preferences.dart';
import 'package:wasfat_akl/providers/dishes_provider.dart';
import 'package:wasfat_akl/providers/food_category_provider.dart';
import 'package:wasfat_akl/providers/search_provider.dart';
import 'package:wasfat_akl/providers/slider_indicator_provider.dart';
import 'package:wasfat_akl/utils/internet_helper.dart';
import 'package:wasfat_akl/widgets/ads/banner_wrap_list.dart';
import 'package:wasfat_akl/widgets/core/divider_widget.dart';
import 'package:wasfat_akl/widgets/home_widgets/fav_list.dart';
import 'package:wasfat_akl/widgets/home_widgets/home_drawer.dart';
import 'package:wasfat_akl/widgets/home_widgets/last_visited_list.dart';
import 'package:wasfat_akl/widgets/home_widgets/slide_show.dart';
import 'package:wasfat_akl/widgets/home_widgets/slide_show_indicator.dart';
import 'package:wasfat_akl/widgets/home_widgets/top_categories.dart';

class HomePage extends StatelessWidget {
  const HomePage();

  @override
  Widget build(BuildContext context) {
    print('build home');
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
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              await showSearch(
                context: context,
                delegate: DishSearchDelegate(foodProvider.categories),
              );
            },
          )
        ],
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
          child: ChangeNotifierProvider(
            create: (_) => SliderIndicatorProvider(),
            builder: (context, _) {
              final recentDishesExist =
                  dishesProvider.recentlyAddedDishes.isNotEmpty;
              final categoriesExists = foodProvider.categories.isNotEmpty;

              return BannerWrapList(
                listType: ListType.Normal,
                pageWidgets: [
                  const DividerWidget(
                    dividerName: "أطباق جديدة",
                    marginTop: 18,
                  ),
                  Container(
                    child: (!recentDishesExist || !categoriesExists)
                        ? // 18 to compensate sizedbox and indicators heights till i find another way :)
                        Container(
                            height: (size.height * 0.3) + 18,
                            width: size.width * 0.8,
                            child: const Center(
                              child: const SpinKitThreeBounce(
                                size: 30,
                                color: Colors.amber,
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              const SlideShow(),
                              const SizedBox(height: 8),
                              const SlideShowIndicator(),
                            ],
                          ),
                  ),
                  const DividerWidget(
                    dividerName: "اقسام",
                    marginTop: 2.0,
                    marginBottom: 4.0,
                  ),
                  Container(
                    height: size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: foodProvider.topCategories.isEmpty
                        ? const Center(
                            child: const SpinKitThreeBounce(
                              size: 30,
                              color: Colors.amber,
                            ),
                          )
                        : const TopCategories(),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
