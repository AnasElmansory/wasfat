import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:wasfat_akl/custom_widgets/divider_widget.dart';
import 'package:wasfat_akl/custom_widgets/one_card_widget.dart';
import 'package:wasfat_akl/custom_widgets/confirmation_dialog.dart';
import 'package:wasfat_akl/get_it.dart';
import 'package:wasfat_akl/helper/internet_helper.dart';
import 'package:wasfat_akl/pages/favourite_dishlist_page.dart';
import 'package:wasfat_akl/pages/food_category_page.dart';
import 'package:wasfat_akl/pages/more_category_page.dart';
import 'package:wasfat_akl/pages/privacy_page.dart';
import 'package:wasfat_akl/pages/sign_in_page.dart';
import 'package:wasfat_akl/providers/auth_provider.dart';
import 'package:wasfat_akl/providers/dish_actions_provider.dart';
import 'package:wasfat_akl/providers/dish_likes_provider.dart';
import 'package:wasfat_akl/providers/food_category_provider.dart';
import 'package:wasfat_akl/providers/shared_preferences_provider.dart';
import 'package:wasfat_akl/providers/slider_indicator_provider.dart';

import 'one_dish_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final foodProvider = context.watch<FoodCategoryProvider>();
    final shared = context.watch<SharedPreferencesProvider>();
    final auth = context.watch<Auth>();
    final size = MediaQuery.of(context).size;
    getIt<InternetHelper>().checkConnectionAndFirstTimeToApp(context);
    return Scaffold(
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              // height: size.height * 0.6,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text(auth.wasfatUser?.name ?? ''),
                      accountEmail: Text(auth.wasfatUser?.email ?? ''),
                      currentAccountPicture: CircleAvatar(
                        backgroundColor: Colors.teal[800],
                        backgroundImage: auth.wasfatUser?.photoURL != null
                            ? CachedNetworkImageProvider(
                                auth.wasfatUser.photoURL,
                              )
                            : null,
                        child: auth.wasfatUser?.photoURL == null
                            ? const Icon(
                                Icons.account_circle,
                                color: Colors.white,
                                size: 50,
                              )
                            : null,
                      ),
                      decoration: BoxDecoration(color: Colors.amber[800]),
                    ),
                    if (!auth.isLoggedIn)
                      GFListTile(
                        title: const Text('تسجيل الدخول'),
                        avatar: const Icon(
                          Icons.account_circle,
                          color: Colors.blue,
                        ),
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const SignInPage(),
                        )),
                      ),
                    GFListTile(
                      title: const Text('الاطباق المفضلة'),
                      avatar: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const FavouriteListPage(),
                      )),
                    ),
                    GFListTile(
                      title: const Text("مشاركة التطبيق"),
                      avatar: const Icon(
                        Icons.share,
                        color: Colors.blue,
                      ),
                      onTap: () async => await Share.share(
                          "https://play.google.com/store/apps/details?id=ok2code.wasafatakl.wasfat_akl"),
                    ),
                    GFListTile(
                      title: const Text('Privacy Policy'),
                      avatar: const Icon(
                        Icons.info_outline,
                        color: Colors.blueGrey,
                      ),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const PrivacyPage())),
                    ),
                    if (auth.isLoggedIn)
                      GFListTile(
                        avatar: const Icon(Icons.power_settings_new),
                        title: const Text('تسجيل خروج',
                            textAlign: TextAlign.right),
                        onTap: () async =>
                            (auth.isLoggedIn) ? await auth.signOut() : null,
                      ),
                  ],
                ),
              ),
            ),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text.rich(TextSpan(children: [
                      const TextSpan(text: 'By: OK2CODE Company'),
                      const TextSpan(text: '\n'),
                      TextSpan(
                          text:
                              'App version: ${snapshot.hasData ? snapshot.data.version : 'loading...'}'),
                      const TextSpan(text: '\n'),
                      const TextSpan(text: 'Mobile: (+20) 1025788855'),
                    ]))),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('وصفات'),
        elevation: 0,
      ),
      body: LiquidPullToRefresh(
        onRefresh: () async {
          foodProvider
            ..getFoodCategory()
            ..getDishesRecentlyAdded();
        },
        backgroundColor: Colors.white,
        color: Colors.amber[700],
        child: ListView(
          children: [
            const DividerWidget("أطباق جديدة", 18.0, 0.0),
            Container(
                child: ChangeNotifierProvider(
              create: (_) => SliderIndicatorProvider(),
              builder: (context, _) {
                final slider = Provider.of<SliderIndicatorProvider>(context);
                return Column(
                  children: [
                    if (foodProvider.dishesRecentlyAdded.isEmpty)
                      Container(
                        height: size.height * 0.25,
                        width: size.width * 0.8,
                        child: const Center(
                          child: const SpinKitThreeBounce(
                            size: 30,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    if (foodProvider.dishesRecentlyAdded.isNotEmpty)
                      CarouselSlider.builder(
                        options: CarouselOptions(
                          enlargeCenterPage: true,
                          autoPlay: true,
                          onPageChanged: (index, reason) =>
                              slider.current = index,
                        ),
                        itemCount: foodProvider.dishesRecentlyAdded.length,
                        itemBuilder: (context, index) => InkWell(
                          child: OneCardWidget(
                            name: foodProvider.dishesRecentlyAdded[index].name,
                            imageUrl: foodProvider
                                .dishesRecentlyAdded[index].dishImages.first,
                            size: Size(size.width * 0.8, size.height * 0.25),
                            textColor: Colors.white,
                          ),
                          onTap: () {
                            context.read<DishProvider>().dishRating = 0.0;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                  create: (_) => getIt<DishLikesProvider>()
                                    ..listenDishLikes(foodProvider
                                        .dishesRecentlyAdded[index].id),
                                  child: OneDishPage(
                                    mDish:
                                        foodProvider.dishesRecentlyAdded[index],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          foodProvider.dishesRecentlyAdded.map<Widget>((_) {
                        final index =
                            foodProvider.dishesRecentlyAdded.indexOf(_);
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: EdgeInsets.only(
                              top: 2.0, bottom: 10.0, left: 2.0, right: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: slider.current == index
                                ? Colors.amber[700]
                                : Colors.black54,
                          ),
                        );
                      }).toList(),
                    )
                  ],
                );
              },
            )),
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
                                  color: Colors.amber[800],
                                  // border: Border.all(
                                  //     color: Colors.amber[700], width: 2),
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
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => FoodCategoryPage(
                                        foodCategoryId: foodProvider
                                            .topCategories[index].id,
                                      )));
                            },
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
              Container(
                height: size.height * 0.2,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: shared.favouriteDishes.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        context.read<DishProvider>().dishRating = 0.0;
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                              create: (_) => getIt<DishLikesProvider>()
                                ..listenDishLikes(
                                    shared.favouriteDishes[index].id),
                              child: OneDishPage(
                                mDish: shared.favouriteDishes[index],
                              ),
                            ),
                          ),
                        );
                      },
                      onLongPress: () async {
                        await showDialog<bool>(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => confirmationDialog(
                            '.قائمه الأطباق المفضله',
                            '.هل تريد ازاله هذا الطبق من القائمه',
                            true,
                            context,
                          ),
                        ).then((value) async {
                          if (value)
                            await shared.removeFavouriteDish(
                                shared.favouriteDishes[index]);
                        });
                      },
                      child: OneCardWidget(
                        name: shared.favouriteDishes[index].name,
                        imageUrl:
                            shared.favouriteDishes[index].dishImages.first,
                        size: Size(size.width * 0.5, size.height * 0.2),
                        textColor: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            if (shared.lastVisitedDishes.isNotEmpty)
              const DividerWidget("شاهدتُ من قبل", 0, 0.0),
            if (shared.lastVisitedDishes.isNotEmpty)
              Container(
                height: size.height * 0.2,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: shared.lastVisitedDishes.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      context.read<DishProvider>().dishRating = 0.0;
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (_) => getIt<DishLikesProvider>()
                            ..listenDishLikes(
                                shared.lastVisitedDishes[index].id),
                          child: OneDishPage(
                            mDish: shared.lastVisitedDishes[index],
                          ),
                        ),
                      ));
                    },
                    onLongPress: () async {
                      await showDialog<bool>(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => confirmationDialog(
                          'قائمه شاهدت من قبل',
                          'هل تريد ازاله هذا الطبق من القائمه',
                          true,
                          context,
                        ),
                      ).then((value) async {
                        if (value)
                          await shared.removeLastVisitedDish(
                              shared.lastVisitedDishes[index]);
                      });
                    },
                    child: OneCardWidget(
                      name: shared.lastVisitedDishes[index].name,
                      imageUrl:
                          shared.lastVisitedDishes[index].dishImages.first,
                      size: Size(size.width * 0.5, size.height * 0.2),
                      textColor: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
