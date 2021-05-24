import 'dart:async';
import 'dart:collection';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasfat_akl/firebase/dishes_service.dart';
import 'package:wasfat_akl/models/dish.dart';

class DishesProvider extends ChangeNotifier {
  final DishesService _dishesService;

  DishesProvider(this._dishesService);
  final dishes = Map<String, List<Dish>>();
  HashMap<String, PagingController<int, Dish>> _controllers = HashMap();

  PagingController<int, Dish> getPagingController(String categoryId) {
    final controller = _controllers.putIfAbsent(
        categoryId, () => PagingController<int, Dish>(firstPageKey: 0));
    return controller;
  }

  List<Dish> _recentlyAddedDishes = [];
  List<Dish> get recentlyAddedDishes => this._recentlyAddedDishes;
  set recentlyAddedDishes(List<Dish> value) {
    this._recentlyAddedDishes = value;
    notifyListeners();
  }

  Future<List<Dish>> getDishesByCategory(
    String categoryId,
    int pageToken,
  ) async {
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

  Future<void> handleDishesPagination(String categoryId) async {
    final controller = getPagingController(categoryId);
    try {
      controller.addPageRequestListener((pageKey) async {
        final hasDishes = dishes[categoryId]?.isNotEmpty ?? false;
        final pageToken = hasDishes ? pageKey : 0;

        final result = await getDishesByCategory(categoryId, pageToken);

        final isLastPage = result.length < 10;
        if (isLastPage)
          controller.appendLastPage(result);
        else
          controller.appendPage(
            result,
            result.last.addDate.millisecondsSinceEpoch,
          );
      });
    } catch (error) {
      await Fluttertoast.showToast(msg: '$error');
      controller.error = error;
    }
  }

  @override
  void dispose() {
    this._controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }
}
