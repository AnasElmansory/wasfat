import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:wasfat_akl/models/dish.dart';
import 'package:wasfat_akl/models/food_category.dart';
import 'package:wasfat_akl/pages/one_dish_page.dart';
import 'package:provider/provider.dart';

class SearchProvider extends ChangeNotifier {
  final duration = const Duration(milliseconds: 800);
  final FirebaseFirestore _firestore;
  Timer _searchOnStopTyping;
  List<Dish> _results = <Dish>[];
  List<Dish> get results => _results;

  List<FoodCategory> _categories;
  List<FoodCategory> get categories => this._categories;
  set categories(List<FoodCategory> value) {
    this._categories = value;
    notifyListeners();
  }

  String _filter = '';
  String get filter => this._filter;
  set filter(String value) {
    this._filter = value;
    notifyListeners();
  }

  bool _isSearching;
  bool get isSearching => this._isSearching;
  set isSearching(bool value) {
    this._isSearching = value;
    notifyListeners();
  }

  SearchProvider(this._firestore);

  @override
  void dispose() {
    _searchOnStopTyping?.cancel();
    super.dispose();
  }

  // void _searchHandler(String value) {
  //   if (_searchOnStopTyping != null) {
  //     _searchOnStopTyping.cancel(); // clear timer
  //     notifyListeners();
  //   }
  //   _searchOnStopTyping = Timer(duration, () async => await _doSearch(value));
  //   notifyListeners();
  // }

  Future<void> _doSearch(String query) async {
    isSearching = true;
    final searchQuery = await filterQuery(query).get();

    if (searchQuery?.docs?.isNotEmpty ?? false)
      _results = searchQuery.docs?.mapToDishes;
    else
      _results.clear();
    filter = '';
    isSearching = false;
    notifyListeners();
  }

  Query filterQuery(String query) {
    final dishQuery = _firestore.collection('dishes');
    if (filter == "الأكثر اعجابا")
      return _firestore
          .collection('dishes')
          .orderBy('name')
          .startAt([query]).endAt([query + '\uf8ff']).orderBy('likesCount');
    else
      return dishQuery
          .orderBy('name')
          .startAt([query]).endAt([query + "\uf8ff"]);
  }

  Widget buildFilterButton(BuildContext context) {
    final filterList = ["اكثر اعجاب", 'بدون فلتر'];
    return Container(
      height: (filterList.length * (kToolbarHeight + 8)),
      child: ListView.separated(
        itemCount: filterList.length,
        separatorBuilder: (context, index) =>
            const Divider(endIndent: 25, indent: 10),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: GFListTile(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(0),
            title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                filterList[index],
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
              ),
            ),
            selected: (filter == filterList[index]),
            onTap: () {
              filter = filterList[index];
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }
}

extension DishList on List<QueryDocumentSnapshot> {
  List<Dish> get mapToDishes =>
      this.map<Dish>((dish) => Dish.fromMap(dish.data())).toList();
}

class FireSearch extends SearchDelegate {
  FireSearch() : super(searchFieldLabel: 'ابحث عن وصفه');

  @override
  void showResults(BuildContext context) async {
    final search = context.read<SearchProvider>();
    await search._doSearch(query);
    super.showResults(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    final search = context.watch<SearchProvider>();
    return <Widget>[
      IconButton(
        icon: search.filter.isNotEmpty && search.filter != 'بدون فلتر'
            ? const Icon(Icons.filter_alt)
            : const Icon(Icons.filter_alt_outlined),
        onPressed: () async => await showDialog(
          context: context,
          builder: (context) =>
              Dialog(child: search.buildFilterButton(context)),
        ),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) => IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop());

  @override
  Widget buildResults(BuildContext context) {
    final search = context.watch<SearchProvider>();
    final size = MediaQuery.of(context).size;
    final statusBar = MediaQuery.of(context).padding.top;
    print(search.isSearching);
    if (search.isSearching)
      return const Center(
        child: const SpinKitThreeBounce(
          size: 30,
          color: const Color(0xFFFFA800),
        ),
      );
    if (search._results.isEmpty)
      return const Center(
        child: const Text(
          'لا توجد نتائج',
          textDirection: TextDirection.rtl,
        ),
      );
    return Container(
      height: size.height - (kToolbarHeight + statusBar),
      child: ListView.builder(
        itemCount: search._results.length,
        itemBuilder: (context, index) {
          return GFListTile(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
              title: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  search._results[index].name,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              subtitle: Text(
                search._results[index].subtitle,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
              ),
              icon: Container(
                  height: size.height * 0.2,
                  width: size.width * 0.4,
                  child: CachedNetworkImage(
                    imageUrl: search._results[index].dishImages.first,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const ImageIcon(
                      const AssetImage('assets/transparent_logo.ico'),
                      color: const Color(0xFFF5F5F5),
                      size: 30,
                    ),
                  )),
              onTap: () async => await Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => OneDishPage(dish: search._results[index]),
                    ),
                  ));
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) => const Text('');
}
