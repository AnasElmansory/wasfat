import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:wasfat_akl/get_it.dart';
import 'package:wasfat_akl/pages/terms_condition_page.dart';
import 'package:wasfat_akl/providers/food_category_provider.dart';
import 'package:wasfat_akl/providers/shared_preferences_provider.dart';
import 'package:provider/provider.dart';

class InternetHelper {
  final DataConnectionChecker _checker;

  InternetHelper(this._checker);
  Future<bool> get isConnected async => await _checker.hasConnection;

  Future<GetOptions> internetValidation() async {
    GetOptions options;
    if (await isConnected)
      options = const GetOptions(source: Source.serverAndCache);
    else
      options = const GetOptions(source: Source.cache);
    return options;
  }

  void checkConnectionAndFirstTimeToApp(BuildContext context) {
    final foodProvider = context.watch<FoodCategoryProvider>();
    final shared = context.watch<SharedPreferencesProvider>();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!await shared.isfirstTimeInApp())
        return Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => TermsAndConditionPage()));
      if (!await getIt<InternetHelper>().isConnected &&
          foodProvider.foodCategories.isEmpty)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          action: SnackBarAction(
              label: 'حاول مره أخرى',
              onPressed: () async {
                foodProvider
                  ..getFoodCategory()
                  ..getDishesRecentlyAdded();
              }),
          content: const Text('تأكد من اتصالك باللانترنت'),
        ));
    });
  }
}
