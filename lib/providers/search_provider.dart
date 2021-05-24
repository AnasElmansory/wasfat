import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/firebase/dishes_service.dart';
import 'package:wasfat_akl/models/dish.dart';
import 'package:wasfat_akl/models/food_category.dart';
import 'package:wasfat_akl/widgets/dish_widgets/dish_tile.dart';
import 'package:wasfat_akl/widgets/home_widgets/search_drawer.dart';

class DishSearchDelegate extends SearchDelegate<Dish> {
  final List<FoodCategory> categories;

  DishSearchDelegate(this.categories);

  @override
  void showResults(BuildContext context) async {
    final searchProvider = context.read<SearchProvider>();
    await searchProvider.search(query);
    super.showResults(context);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.filter_alt),
        onPressed: () async {
          await Get.dialog(const SearchFilterDialog());
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchProvider = context.watch<SearchProvider>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
        itemCount: searchProvider.searchResult.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final dish = searchProvider.searchResult[index];
          return DishTile(dish: dish);
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Text('');
  }
}

class SearchProvider extends ChangeNotifier {
  final DishesService _dishesService;
  List<FoodCategory> _searchCategories = [];

  SearchProvider(this._dishesService);

  List<Dish> _searchResult = [];
  List<Dish> get searchResult => this._searchResult;
  set searchResult(List<Dish> value) {
    this._searchResult = value;
    notifyListeners();
  }

  List<FoodCategory> get searchCategories => this._searchCategories;

  bool isSelected(FoodCategory category) {
    return this._searchCategories.contains(category);
  }

  void filterCategory(FoodCategory category) {
    if (isSelected(category))
      this._searchCategories.remove(category);
    else
      this._searchCategories.add(category);
    notifyListeners();
  }

  Future<void> search(String query) async {
    this._searchResult.clear();
    final categoriesId =
        this._searchCategories.map<String>((category) => category.id).toList();
    final dishes =
        await _dishesService.searchDish(query, categoriesId: categoriesId);
    searchResult = dishes;
  }
}
