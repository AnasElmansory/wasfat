import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/get_it.dart';
import 'package:wasfat_akl/helper/internet_helper.dart';
import 'package:wasfat_akl/pages/food_category_page.dart';
import 'package:wasfat_akl/pages/more_category_page.dart';
import 'package:wasfat_akl/providers/food_category_provider.dart';
import 'package:wasfat_akl/providers/search_provider.dart';
import 'package:wasfat_akl/providers/shared_preferences_provider.dart';
import 'package:wasfat_akl/providers/slider_indicator_provider.dart';
import 'package:wasfat_akl/widgets/core/divider_widget.dart';
import 'package:wasfat_akl/widgets/home_widgets.dart/fav_list.dart';
import 'package:wasfat_akl/widgets/home_widgets.dart/home_drawer.dart';
import 'package:wasfat_akl/widgets/home_widgets.dart/last_visited_list.dart';
import 'package:wasfat_akl/widgets/home_widgets.dart/slide_show.dart';
import 'package:wasfat_akl/widgets/home_widgets.dart/slide_show_indicator.dart';
import 'package:wasfat_akl/widgets/one_card_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage();

  @override
  Widget build(BuildContext context) {
    final foodProvider = context.watch<FoodCategoryProvider>();
    final shared = context.watch<SharedPreferencesProvider>();
    final size = MediaQuery.of(context).size;
    getIt<InternetHelper>().checkConnectionAndFirstTimeToApp(context);
    return Scaffold(
      drawer: const HomeDrawer(),
      appBar: AppBar(
        title: const Text('وصفات',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            )),
        elevation: 0,
        actions: [
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async => await showSearch(
                    context: context,
                    delegate: FireSearch(),
                  ))
        ],
      ),
      body: LiquidPullToRefresh(
        onRefresh: () async {
          foodProvider
            ..getFoodCategory()
            ..getDishesRecentlyAdded();
        },
        backgroundColor: Colors.white,
        color: const Color(0xFFFFA000),
        child: ListView(
          children: [
            const DividerWidget("أطباق جديدة", 18.0, 0.0),
            Container(
              child: ChangeNotifierProvider(
                create: (_) => SliderIndicatorProvider(),
                builder: (context, _) {
                  return Column(
                    children: [
                      (foodProvider.dishesRecentlyAdded.isEmpty)
                          ? Container(
                              height: size.height * 0.25,
                              width: size.width * 0.8,
                              child: const Center(
                                child: const SpinKitThreeBounce(
                                  size: 30,
                                  color: Colors.amber,
                                ),
                              ),
                            )
                          : const SlideShow(),
                      const SlideShowIndicator(),
                    ],
                  );
                },
              ),
            ),
            const DividerWidget("اقسام", 2.0, 4.0),
            Container(
              height: size.height * 0.4,
              child: foodProvider.topCategories.isEmpty
                  ? const Center(
                      child: const SpinKitThreeBounce(
                        size: 30,
                        color: Colors.amber,
                      ),
                    )
                  : GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                        childAspectRatio:
                            ((size.width * 0.5) / (size.height * 0.2)),
                      ),
                      itemCount: foodProvider.topCategories.length > 3
                          ? 4
                          : foodProvider.topCategories.length,
                      itemBuilder: (context, index) {
                        if (index == 3)
                          return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MoreCategoryPage()));
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 2),
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
                              ));
                        else
                          return InkWell(
                            onTap: () async => await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => FoodCategoryPage(
                                  foodCategoryId:
                                      foodProvider.topCategories[index].id,
                                ),
                              ),
                            ),
                            child: OneCardWidget(
                              name: foodProvider.topCategories[index].name,
                              imageUrl:
                                  foodProvider.topCategories[index].imageUrl,
                              size: Size(size.width * 0.5, size.height * 0.2),
                              textColor: Colors.white,
                            ),
                          );
                      }),
            ),
            if (shared.favouriteDishes.isNotEmpty)
              const DividerWidget("الأطباق المفضله", 8, 0.0),
            if (shared.favouriteDishes.isNotEmpty)
              const FavList(isInHome: true),
            if (shared.lastVisitedDishes.isNotEmpty)
              const DividerWidget("شاهدتُ من قبل", 0, 0.0),
            if (shared.lastVisitedDishes.isNotEmpty) const LastVisitedList()
          ],
        ),
      ),
    );
  }
}
