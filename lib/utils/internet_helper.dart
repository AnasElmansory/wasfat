import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasfat_akl/providers/dishes_provider.dart';

import 'package:wasfat_akl/providers/food_category_provider.dart';
import 'package:wasfat_akl/utils/navigation.dart';

Future<GetOptions> internetValidation() async {
  GetOptions options;
  if (await isConnected())
    options = const GetOptions(source: Source.serverAndCache);
  else
    options = const GetOptions(source: Source.cache);
  return options;
}

void checkConnectionAndFirstTimeToApp(BuildContext context) {
  final categoryProvider = context.watch<FoodCategoryProvider>();
  final dishesProvider = context.watch<DishesProvider>();

  WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
    final shared = await SharedPreferences.getInstance();
    final isFirstTimeInApp = shared.getBool('isFirstTime') ?? false;
    if (!isFirstTimeInApp) return await navigateToTermsAndConditions();
    if (!await isConnected() && categoryProvider.categories.isEmpty)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        action: SnackBarAction(
            label: 'حاول مره أخرى',
            onPressed: () async {
              await categoryProvider.getFoodCategories();
              await dishesProvider.getDishesRecentlyAdded();
            }),
        content: const Text('تأكد من اتصالك باللانترنت'),
      ));
  });
}

Future<bool> isConnected() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}
