import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasfat_akl/firebase/dishes_service.dart';
import 'package:wasfat_akl/models/dish.dart';

class DishesProvider extends ChangeNotifier {
  final DishesService _dishesService;

  DishesProvider(this._dishesService);
  final dishes = Map<String, List<Dish>>();
  final _controller = PagingController<int, Dish>(firstPageKey: 1);
  PagingController<int, Dish> get controller => this._controller;
  StreamSubscription<List<String>>? _likesSubscription;

  List<Dish> _recentlyAddedDishes = [];
  List<Dish> get recentlyAddedDishes => this._recentlyAddedDishes;
  set recentlyAddedDishes(List<Dish> value) {
    this._recentlyAddedDishes = value;
    notifyListeners();
  }

  List<Dish> _searchDishes = [];
  List<Dish> get searchDishes => this._searchDishes;
  set searchDishes(List<Dish> value) {
    this._searchDishes = value;
    notifyListeners();
  }

  List<String> _oneDishLikes = [];
  List<String> get oneDishLikes => this._oneDishLikes;
  set oneDishLikes(List<String> value) {
    this._oneDishLikes = value;
    notifyListeners();
  }

  Future<List<Dish>> getDishesByCategory(
      String categoryId, int pageToken) async {
    final result = await _dishesService.getDishesByCategory(
      categoryId,
      pageToken,
    );
    dishes[categoryId] = result;
    notifyListeners();
    return result;
  }

  Future<void> getDishesRecentlyAdded() async {
    final shared = await SharedPreferences.getInstance();
    final categoriesId =
        shared.getStringList('TopCategories') ?? const <String>[];
    final result = await _dishesService.getDishesRecentlyAdded(categoriesId);
    recentlyAddedDishes = result;
  }

  Future<void> listenDishLikes(String dishId) async {
    await _likesSubscription?.cancel();
    _likesSubscription = null;
    _likesSubscription = _dishesService
        .listenDishLikes(dishId)
        .listen((likes) => oneDishLikes = likes);
  }

  Future<void> likeDish(String dishId) async {
    await _dishesService.likeDish(dishId);
  }

  Future<void> unlikeDish(String dishId) async {
    await _dishesService.unlikeDish(dishId);
  }

  Future<List<Dish>> searchDish(String query) async {
    final dishes = await _dishesService.searchDish(query);
    searchDishes = dishes;
    return dishes;
  }

  Future<void> handleDishesPagination(String categoryId) async {
    try {
      this._controller.addPageRequestListener((pageKey) async {
        final hasDishes = dishes[categoryId]?.isNotEmpty ?? true;
        final pageToken = hasDishes ? pageKey : 0;

        final result = await getDishesByCategory(categoryId, pageToken);
        print('result: $result');
        final isLastPage = result.length < 10;
        if (isLastPage)
          this._controller.appendLastPage(result);
        else
          this._controller.appendPage(
                result,
                result.last.addDate.millisecondsSinceEpoch,
              );
      });
    } catch (error) {
      await Fluttertoast.showToast(msg: '$error');
      this._controller.error = error;
    }
  }

  @override
  void dispose() {
    this._controller.dispose();
    _likesSubscription?.cancel();
    super.dispose();
  }
}
