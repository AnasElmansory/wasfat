import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/providers/food_category_provider.dart';
import 'package:wasfat_akl/utils/navigation.dart';
import 'package:wasfat_akl/widgets/ads/banner_wrap_list.dart';
import 'package:wasfat_akl/widgets/category_widgets/category_grid_tile.dart';

class MoreCategoryPage extends StatelessWidget {
  const MoreCategoryPage();
  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<FoodCategoryProvider>();
    final size = context.mediaQuerySize;
    final categorySize = Size.square(size.width * .5);
    return Scaffold(
      appBar: AppBar(title: const Text('كل الأقسام')),
      body: BannerWrapList(
        listType: ListType.ListBuilder,
        listBuilder: _moreCategorylistBuilder(categoryProvider, categorySize),
      ),
    );
  }
}

Widget _moreCategorylistBuilder(
  FoodCategoryProvider categoryProvider,
  Size categorySize,
) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: categoryProvider.categories.length,
      itemBuilder: (context, index) {
        final category = categoryProvider.categories[index];
        return InkWell(
          onTap: () async => await navigateToCategoryPage(category.id),
          child: CategoryGridTile(
            category: category,
            size: categorySize,
          ),
        );
      },
    ),
  );
}
