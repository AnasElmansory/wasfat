import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/get_it.dart';
import 'package:wasfat_akl/providers/auth_provider.dart';
import 'package:wasfat_akl/providers/dish_actions_provider.dart';
import 'package:wasfat_akl/providers/dish_likes_provider.dart';
import 'package:wasfat_akl/providers/food_category_provider.dart';
import 'package:wasfat_akl/providers/shared_preferences_provider.dart';
import 'pages/home_page.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print(data);
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print(notification);
  }
  // Or do other work.
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // _navigateToItemDetail(message);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<Auth>()..getUserData()),
        ChangeNotifierProvider(create: (_) => getIt<DishProvider>()),
        ChangeNotifierProvider(
            create: (_) => getIt<FoodCategoryProvider>()
              ..getFoodCategory()
              ..getDishesRecentlyAdded()),
        ChangeNotifierProvider(
          create: (_) => getIt<SharedPreferencesProvider>()
            ..sharedInstance
            ..getFavouriteDishes()
            ..getLastVisitedDishes(),
        ),
      ],
      child: MaterialApp(
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
        home: HomePage(),
      ),
    );
  }
}
