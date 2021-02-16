import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasfat_akl/models/dish.dart';

class SharedPreferencesProvider extends ChangeNotifier {
  List<Dish> lastVisitedDishes = <Dish>[];
  List<Dish> favouriteDishes = <Dish>[];

  static SharedPreferences _prefs;

  Future<SharedPreferencesProvider> get sharedInstance async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();

    return this;
  }

  Future<bool> isfirstTimeInApp() async {
    if (_prefs == null) await sharedInstance;
    return _prefs.getBool('isFirstTime') ?? false;
  }

  Future<bool> acceptedTermsAndConditions() async =>
      await _prefs.setBool('isFirstTime', true);

  Future<void> getLastVisitedDishes() async {
    if (_prefs == null) await sharedInstance;

    if (_prefs.containsKey('visitedDishes') != null &&
        _prefs.getStringList('visitedDishes') != null) {
      lastVisitedDishes = _prefs
          .getStringList('visitedDishes')
          .map<Dish>((dish) => Dish.fromJson(dish))
          .toList();
      notifyListeners();
    }
  }

  Future<void> setLastVisitedDishes(Dish visitedDish) async {
    List tempDishIdList = <String>[];

    tempDishIdList = lastVisitedDishes.map((dish) => dish.id).toList();
    if (!tempDishIdList.contains(visitedDish.id)) {
      lastVisitedDishes.add(visitedDish);

      await _prefs.setStringList('visitedDishes',
          lastVisitedDishes.map((dish) => dish.toJson()).toList());
      notifyListeners();
    }
  }

  Future<void> getFavouriteDishes() async {
    if (_prefs == null) await sharedInstance;
    if (_prefs.containsKey('favouriteDishes') != null &&
        _prefs.getStringList('favouriteDishes') != null) {
      favouriteDishes = _prefs
          .getStringList('favouriteDishes')
          .map<Dish>((dish) => Dish.fromJson(dish))
          .toList();
      notifyListeners();
    }
  }

  Future<void> addFavouriteDish(Dish favouriteDish) async {
    List tempDishIdList = <String>[];
    tempDishIdList = favouriteDishes.map((dish) => dish.id).toList();
    if (!tempDishIdList.contains(favouriteDish.id)) {
      favouriteDishes.add(favouriteDish);
      notifyListeners();
      await _prefs.setStringList('favouriteDishes',
          favouriteDishes.map((dish) => dish.toJson()).toList());
    }
  }

  Future<void> removeFavouriteDish(Dish favouriteDishes) async {
    List tempDishList = <String>[];
    if (_prefs.containsKey('favouriteDishes') != null &&
        _prefs.getStringList('favouriteDishes') != null) {
      tempDishList = _prefs.getStringList('favouriteDishes').toList();
      final jsonDish = favouriteDishes.toJson();
      final isRemoved = tempDishList.remove(jsonDish);
      if (isRemoved)
        await _prefs.setStringList('favouriteDishes', tempDishList);
      getFavouriteDishes();
    }
  }

  Future<void> removeLastVisitedDish(Dish visitedDishes) async {
    List tempDishList = <String>[];
    if (_prefs.containsKey('visitedDishes') != null &&
        _prefs.getStringList('visitedDishes') != null) {
      tempDishList = _prefs.getStringList('visitedDishes').toList();
      final jsonDish = visitedDishes.toJson();
      final isRemoved = tempDishList.remove(jsonDish);
      if (isRemoved) await _prefs.setStringList('visitedDishes', tempDishList);
      getLastVisitedDishes();
    }
  }

  Future<void> clearFavouriteDishList() async {
    if (_prefs.containsKey('favouriteDishes') != null &&
        _prefs.getStringList('favouriteDishes') != null)
      await _prefs.remove('favouriteDishes').then((done) {
        if (done) favouriteDishes.clear();
        notifyListeners();
      });
  }

  Future<void> clearLastVisitedDishList() async {
    if (_prefs.containsKey('visitedDishes') != null &&
        _prefs.getStringList('visitedDishes') != null)
      await _prefs.remove('visitedDishes').then((done) {
        if (done) lastVisitedDishes.clear();
        notifyListeners();
      });
  }
}
