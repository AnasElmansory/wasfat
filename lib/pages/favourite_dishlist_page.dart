import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/providers/dishes_preferences.dart';
import 'package:wasfat_akl/widgets/home_widgets/fav_list.dart';

class FavouriteListPage extends StatelessWidget {
  const FavouriteListPage();

  @override
  Widget build(BuildContext context) {
    print('build FavouriteListPage');
    final shared = context.watch<DishesPreferencesProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('الاطباق المفضلة'),
      ),
      body: (shared.favouriteDishes.isEmpty)
          ? const Center(child: const Text("لا توجد اطباق مفضله"))
          : const FavList(),
    );
  }
}
