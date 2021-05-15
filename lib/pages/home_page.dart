import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

import 'package:wasfat_akl/providers/dishes_preferences.dart';
import 'package:wasfat_akl/providers/dishes_provider.dart';
import 'package:wasfat_akl/providers/food_category_provider.dart';
import 'package:wasfat_akl/providers/slider_indicator_provider.dart';
import 'package:wasfat_akl/utils/internet_helper.dart';
import 'package:wasfat_akl/utils/navigation.dart';
import 'package:wasfat_akl/widgets/cached_image.dart';
import 'package:wasfat_akl/widgets/core/divider_widget.dart';
import 'package:wasfat_akl/widgets/home_widgets.dart/fav_list.dart';
import 'package:wasfat_akl/widgets/home_widgets.dart/home_drawer.dart';
import 'package:wasfat_akl/widgets/home_widgets.dart/last_visited_list.dart';
import 'package:wasfat_akl/widgets/home_widgets.dart/slide_show.dart';
import 'package:wasfat_akl/widgets/home_widgets.dart/slide_show_indicator.dart';

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
      body: LiquidPullToRefresh(
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
                const DividerWidget(dividerName: "أطباق جديدة", marginTop: 18),
                Container(
                  child: ChangeNotifierProvider(
                    create: (_) => SliderIndicatorProvider(),
                    builder: (context, _) {
                      final recentDishesExist =
                          dishesProvider.recentlyAddedDishes.isNotEmpty;
                      final categoriesExists =
                          foodProvider.categories.isNotEmpty;
                      return Column(
                        children: [
                          (!recentDishesExist || !categoriesExists)
                              ? Container(
                                  height: size.height * 0.3,
                                  width: size.width * 0.8,
                                  child: const Center(
                                    child: const SpinKitThreeBounce(
                                      size: 30,
                                      color: Colors.amber,
                                    ),
                                  ),
                                )
                              : const SlideShow(),
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
                  const DividerWidget(
                      dividerName: "الأطباق المفضله", marginTop: 8.0),
                if (preferences.favouriteDishes.isNotEmpty)
                  const FavList(forHomePageView: true),
                if (preferences.lastVisitedDishes.isNotEmpty)
                  const DividerWidget(dividerName: "شاهدتُ من قبل"),
                if (preferences.lastVisitedDishes.isNotEmpty)
                  const LastVisitedList()
              ],
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
  return GridView.builder(
    itemCount: 4,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                height: size.height * .25,
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
        final categorySize = Size(size.width * 0.5, size.height * 0.25);
        return InkWell(
          onTap: () async => await navigateToCategoryPage(category!.id),
          child: GridTile(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(children: [
                Positioned.fill(
                  child: CachedImage(url: category!.imageUrl),
                ),
                Positioned(
                  bottom: 0,
                  width: categorySize.width,
                  height: categorySize.height,
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                          Colors.black,
                          Colors.black54,
                          Colors.black12,
                          Color.fromRGBO(255, 255, 255, 0.2)
                        ])),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          category.name,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        );
      }
    },
  );
}
