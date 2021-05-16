import 'dart:async';
import 'dart:collection';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasfat_akl/firebase/dishes_service.dart';
import 'package:wasfat_akl/models/dish.dart';
import 'package:wasfat_akl/providers/auth_provider.dart';
import 'package:wasfat_akl/utils/navigation.dart';

class DishesProvider extends ChangeNotifier {
  final DishesService _dishesService;

  DishesProvider(this._dishesService);
  final dishes = Map<String, List<Dish>>();
  HashMap<String, PagingController<int, Dish>> _controllers = HashMap();

  ScrollController? _scrollController;
  ScrollController? get scrollController => this._scrollController;

  void disposeScrollController() {
    this._scrollController?.dispose();
  }

  void handlefavouriteFabButton(AnimationController animationController) {
    this._scrollController?.dispose();
    this._scrollController = ScrollController();
    this._scrollController!.addListener(() {
      switch (this._scrollController!.position.userScrollDirection) {
        case ScrollDirection.forward:
          animationController.forward();
          break;
        case ScrollDirection.reverse:
          animationController.reverse();
          break;
        case ScrollDirection.idle:
          break;
      }
    });
  }

  PagingController<int, Dish> getPagingController(String categoryId) {
    final controller = _controllers.putIfAbsent(
        categoryId, () => PagingController<int, Dish>(firstPageKey: 0));
    return controller;
  }

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

  HashMap<String, List<String>> _dishesLikes = HashMap();
  HashMap<String, List<String>> get dishesLikes => this._dishesLikes;

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

  Future<void> listenDishLikes(String dishId) async {
    await _likesSubscription?.cancel();
    _likesSubscription = null;
    _likesSubscription = _dishesService.listenDishLikes(dishId).listen((likes) {
      dishesLikes[dishId] = likes;
      notifyListeners();
    });
  }

  Future<void> isAuthenticated() async {
    final auth = Get.context!.read<Auth>();
    if (!await auth.isLoggedIn()) return await navigateToSignPageUntil();
  }

  Future<void> likeDish(String dishId) async {
    await isAuthenticated();
    await _dishesService.likeDish(dishId);
  }

  Future<void> unlikeDish(String dishId) async {
    await isAuthenticated();
    await _dishesService.unlikeDish(dishId);
  }

  Future<List<Dish>> searchDish(String query) async {
    final dishes = await _dishesService.searchDish(query);
    searchDishes = dishes;
    return dishes;
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
    print('dishesProviderDisposed');
    this._scrollController?.dispose();
    this._controllers.values.forEach((controller) => controller.dispose());
    _likesSubscription?.cancel();
    super.dispose();
  }
}
