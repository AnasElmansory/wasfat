import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/get_it.dart';
import 'package:wasfat_akl/providers/ad_provider.dart';
import 'package:wasfat_akl/providers/auth_provider.dart';
import 'package:wasfat_akl/providers/dish_comments_provider.dart';
import 'package:wasfat_akl/providers/dishes_provider.dart';
import 'package:wasfat_akl/providers/expand_comment_provider.dart';
import 'package:wasfat_akl/providers/food_category_provider.dart';
import 'package:wasfat_akl/providers/dishes_preferences.dart';

import 'pages/home_page.dart';

class App extends StatelessWidget {
  const App();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<Auth>()..getUserData()),
        ChangeNotifierProvider(create: (_) => ExpandCommentProvider()),
        ChangeNotifierProvider(
            create: (_) => getIt<FoodCategoryProvider>()..getFoodCategories()),
        ChangeNotifierProvider(
            create: (_) => getIt<DishesProvider>()..getDishesRecentlyAdded()),
        ChangeNotifierProvider(create: (_) => getIt<DishCommentProvider>()),
        ChangeNotifierProvider(
          create: (_) => getIt<DishesPreferencesProvider>()
            ..getFavouriteDishes()
            ..getLastVisitedDishes(),
        ),
      ],
      child: ChangeNotifierProvider(
        create: (_) => getIt<AdmobProvider>(),
        builder: (context, _) {
          final adProvider = context.watch<AdmobProvider>();
          print('counter: ${adProvider.interstitialCounter}');
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                fontFamily: 'Cairo',
                appBarTheme: AppBarTheme(
                  centerTitle: true,
                  color: Colors.amber[700],
                  brightness: Brightness.dark,
                )),
            color: Colors.amber[900],
            title: 'وصفات',
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
