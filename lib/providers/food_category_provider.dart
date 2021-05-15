import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasfat_akl/firebase/categories_service.dart';
import 'package:wasfat_akl/models/food_category.dart';
import 'package:wasfat_akl/providers/dishes_provider.dart';

class FoodCategoryProvider extends ChangeNotifier {
  final CategoriesService _categoryService;
  FoodCategoryProvider(this._categoryService);

  List<T> _shuffle<T>(List<T> items) {
    final random = Random();
    for (int i = items.length - 1; i > 0; i--) {
      int n = random.nextInt(i + 1);
      final temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }

  List<FoodCategory> _categories = [];
  List<FoodCategory> get categories => this._categories;
  List<FoodCategory> _topCategories = [];
  List<FoodCategory> get topCategories => this._topCategories;

  FoodCategory? getCategory(String categoryId) {
    final dishesProvider = Get.context!.watch<DishesProvider>();
    final findCategory =
        this._categories.where((category) => category.id == categoryId);
    if (findCategory.isNotEmpty) {
      final category = findCategory.single;
      return category.copyWith(dishes: dishesProvider.dishes[category.id]);
    } else
      return null;
  }

  Future<void> getFoodCategories() async {
    final result = await _categoryService.getCategories();
    final topCategories =
        result.take(4).map((category) => category.id).toList();
    await _setTopCategories(topCategories);
    final shuffledCategories = _shuffle<FoodCategory>(result);
    this._topCategories = shuffledCategories.take(3).toList();
    this._categories = shuffledCategories;
    notifyListeners();
  }

  Future<void> _setTopCategories(List<String> topCategories) async {
    final shared = await SharedPreferences.getInstance();
    await shared.setStringList('TopCategories', topCategories);
  }
}
