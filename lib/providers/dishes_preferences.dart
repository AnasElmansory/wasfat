import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasfat_akl/models/dish.dart';

class DishesPreferencesProvider extends ChangeNotifier {
  final favKey = GlobalKey<AnimatedListState>();
  final lastVisitedKey = GlobalKey<AnimatedListState>();
  final _emptyList = const <Dish>[];

  List<Dish> lastVisitedDishes = <Dish>[];
  List<Dish> favouriteDishes = <Dish>[];

  Future<void> getFavouriteDishes() async {
    final shared = await SharedPreferences.getInstance();
    if (shared.containsKey('favouriteDishes')) {
      favouriteDishes = shared
              .getStringList('favouriteDishes')
              ?.map<Dish>((dish) => Dish.fromJson(dish))
              .toList() ??
          _emptyList;
      notifyListeners();
    }
  }

  Future<void> addFavouriteDish(Dish favouriteDish) async {
    final shared = await SharedPreferences.getInstance();
    if (!favouriteDishes.contains(favouriteDish.id)) {
      favouriteDishes.add(favouriteDish);
      await shared.setStringList('favouriteDishes',
          favouriteDishes.map((dish) => dish.toJson()).toList());
      notifyListeners();
    }
  }

  Future<void> removeFavouriteDish(Dish favouriteDish) async {
    final shared = await SharedPreferences.getInstance();
    if (shared.containsKey('favouriteDishes')) {
      favouriteDishes.removeWhere((dish) => favouriteDish.id == dish.id);
      await shared.setStringList('favouriteDishes',
          favouriteDishes.map((dish) => dish.toJson()).toList());
      notifyListeners();
    }
  }

  Future<void> getLastVisitedDishes() async {
    final shared = await SharedPreferences.getInstance();
    if (shared.containsKey('visitedDishes')) {
      lastVisitedDishes = shared
              .getStringList('visitedDishes')
              ?.map<Dish>((dish) => Dish.fromJson(dish))
              .toList() ??
          _emptyList;
      notifyListeners();
    }
  }

  Future<void> setLastVisitedDish(Dish visitedDish) async {
    final shared = await SharedPreferences.getInstance();
    if (!lastVisitedDishes.contains(visitedDish)) {
      lastVisitedDishes.add(visitedDish);
      await shared.setStringList('visitedDishes',
          lastVisitedDishes.map((dish) => dish.toJson()).toList());
      notifyListeners();
    }
  }

  Future<void> removeLastVisitedDish(Dish visitedDishes) async {
    final shared = await SharedPreferences.getInstance();
    if (shared.containsKey('visitedDishes')) {
      lastVisitedDishes.removeWhere((dish) => visitedDishes.id == dish.id);
      await shared.setStringList('visitedDishes',
          lastVisitedDishes.map((dish) => dish.toJson()).toList());
      notifyListeners();
    }
  }

  Future<void> clearFavouriteDishList() async {
    final shared = await SharedPreferences.getInstance();
    if (shared.containsKey('favouriteDishes')) {
      final isCleared = await shared.remove('favouriteDishes');
      if (isCleared) favouriteDishes.clear();
      notifyListeners();
    }
  }

  Future<void> clearLastVisitedDishList() async {
    final shared = await SharedPreferences.getInstance();
    if (shared.containsKey('visitedDishes')) {
      final isCleared = await shared.remove('visitedDishes');
      if (isCleared) lastVisitedDishes.clear();
      notifyListeners();
    }
  }
}
