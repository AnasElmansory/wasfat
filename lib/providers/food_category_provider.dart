import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wasfat_akl/helper/internet_helper.dart';
import 'package:wasfat_akl/models/dish.dart';
import 'package:wasfat_akl/models/food_category.dart';

class FoodCategoryProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  final InternetHelper _helper;

  FoodCategoryProvider(this._firestore, this._helper);
  var foodCategories = Map<String, FoodCategory>();
  var topCategories = <FoodCategory>[];
  var dishesRecentlyAdded = <Dish>[];

  List<T> shuffle<T>(List<T> items) {
    var random = Random();

    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }

  Future<void> getDishesByCategory(String categoryId) async {
    final query = await _firestore
        .collection('dishes')
        .where('categoryId', arrayContains: categoryId)
        .get(await _helper.internetValidation());
    final categoryDishes =
        query.docs.map<Dish>((dish) => Dish.fromMap(dish.data())).toList();
    final shuffledCategoryDishes = shuffle<Dish>(categoryDishes);
    foodCategories.update(
        categoryId,
        (foodCategory) =>
            foodCategory.copyWith(dishes: shuffledCategoryDishes));

    notifyListeners();
  }

  Future<void> getFoodCategory() async {
    final query = await _firestore
        .collection('food_category')
        .orderBy('priority')
        .get(await _helper.internetValidation());
    if (query.docs.isNotEmpty)
      foodCategories.addEntries(query.docs.map((foodCategory) =>
          MapEntry<String, FoodCategory>(foodCategory.data()['id'],
              FoodCategory.fromMap(foodCategory.data()))));

    topCategories = query.docs
        .map((foodCategory) => FoodCategory.fromMap(foodCategory.data()))
        .toList()
          ..shuffle();
    notifyListeners();
  }

  Future<void> getDishesRecentlyAdded() async {
    final query = await _firestore
        .collection('dishes')
        .orderBy('addDate', descending: true)
        .limit(5)
        .get(await _helper.internetValidation());
    dishesRecentlyAdded =
        query.docs.map<Dish>((dish) => Dish.fromMap(dish.data())).toList();
    notifyListeners();
  }
}
